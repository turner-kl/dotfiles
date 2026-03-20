#!/bin/bash
input=$(cat)

# --- Project & Branch ---
DIR=$(echo "$input" | jq -r '.workspace.current_dir')
PROJECT=$(basename "$DIR")
BRANCH=$(git -C "$DIR" branch --show-current 2>/dev/null)

if [ -n "$BRANCH" ]; then
  [ -n "$(git -C "$DIR" status --porcelain 2>/dev/null | head -1)" ] && DIRTY="*" || DIRTY=""
  header="${PROJECT}(${BRANCH}${DIRTY})"
else
  header="$PROJECT"
fi
MODEL=$(echo "$input" | jq -r '.model.display_name' | sed 's/Claude //')

# --- Color helpers ---
colorize() {
  local pct=$1
  if [ "$pct" -ge 80 ]; then
    printf '\033[31m✖ %s%%\033[0m' "$pct"
  elif [ "$pct" -ge 50 ]; then
    printf '\033[33m▲ %s%%\033[0m' "$pct"
  else
    printf '\033[32m● %s%%\033[0m' "$pct"
  fi
}

# --- Session: Context Window Usage ---
ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
ctx_display=$(colorize "$ctx_pct")

# --- Rate Limit (from stdin JSON since v2.1.80) ---
calc_remaining() {
  local ep=$1 now=$2
  if [ -n "$ep" ] && [ "$ep" != "null" ] && [ "$ep" -gt "$now" ] 2>/dev/null; then
    local sec=$((ep - now))
    echo "$((sec / 3600))h$(((sec % 3600) / 60))m"
  fi
}

format_rate() {
  local label=$1 pct_raw=$2 reset=$3 now=$4
  if [ -n "$pct_raw" ] && [ "$pct_raw" != "null" ]; then
    local pct=$(printf "%.0f" "$pct_raw")
    local result="${label}: $(colorize "$pct")"
    local rem=$(calc_remaining "$reset" "$now")
    [ -n "$rem" ] && result="${result}(${rem})"
    echo "$result"
  fi
}

now_epoch=$(date +%s)
IFS=$'\t' read -r fh_pct fh_reset sd_pct sd_reset <<< "$(echo "$input" | jq -r '[
  (.rate_limits.five_hour.used_percentage // empty | tostring),
  (.rate_limits.five_hour.resets_at // empty),
  (.rate_limits.seven_day.used_percentage // empty | tostring),
  (.rate_limits.seven_day.resets_at // empty)
] | @tsv' 2>/dev/null)"
five_hour=$(format_rate "5h" "$fh_pct" "$fh_reset" "$now_epoch")
weekly=$(format_rate "7d" "$sd_pct" "$sd_reset" "$now_epoch")

# --- Output ---
printf "%b\n" "${header} | ${MODEL}"

line2="Ctx: ${ctx_display}"
[ -n "$five_hour" ] && line2="$line2 | $five_hour"
[ -n "$weekly" ] && line2="$line2 | $weekly"
printf "%b" "$line2"
