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

# --- Rate Limit ---
calc_remaining() {
  local ra=$1 now=$2
  if [ -n "$ra" ] && [ "$ra" != "null" ]; then
    local dt=$(echo "$ra" | sed 's/\.[0-9]*+.*//')
    local ep=$(TZ=UTC date -j -f "%Y-%m-%dT%H:%M:%S" "$dt" +%s 2>/dev/null)
    if [ -n "$ep" ] && [ "$ep" -gt "$now" ]; then
      local sec=$((ep - now))
      echo "$((sec / 3600))h$(((sec % 3600) / 60))m"
    fi
  fi
}

format_rate() {
  local label=$1 util=$2 reset=$3 now=$4
  if [ -n "$util" ] && [ "$util" != "null" ]; then
    local pct=$(printf "%.0f" "$util")
    local result="${label}: $(colorize "$pct")"
    local rem=$(calc_remaining "$reset" "$now")
    [ -n "$rem" ] && result="${result}(${rem})"
    echo "$result"
  fi
}

five_hour=""
weekly=""
creds=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
if [ -n "$creds" ]; then
  # jq fails when macOS `security -w` truncates long credentials (>2KB),
  # so extract the token with grep instead
  token=$(echo "$creds" | grep -o '"accessToken":"[^"]*"' | head -1 | sed 's/"accessToken":"//;s/"$//')
  if [ -n "$token" ]; then
    api_usage=$(curl -s --max-time 1 "https://api.anthropic.com/api/oauth/usage" \
      -H "Authorization: Bearer $token" \
      -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)
    now_epoch=$(date +%s)

    five_hour=$(format_rate "5h" \
      "$(echo "$api_usage" | jq -r '.five_hour.utilization // empty' 2>/dev/null)" \
      "$(echo "$api_usage" | jq -r '.five_hour.resets_at // empty' 2>/dev/null)" \
      "$now_epoch")
    weekly=$(format_rate "7d" \
      "$(echo "$api_usage" | jq -r '.seven_day.utilization // empty' 2>/dev/null)" \
      "$(echo "$api_usage" | jq -r '.seven_day.resets_at // empty' 2>/dev/null)" \
      "$now_epoch")
  fi
fi

# --- Output ---
printf "%b\n" "${header} | ${MODEL}"

line2="Ctx: ${ctx_display}"
[ -n "$five_hour" ] && line2="$line2 | $five_hour"
[ -n "$weekly" ] && line2="$line2 | $weekly"
printf "%b" "$line2"
