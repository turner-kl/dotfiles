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

USAGE_CACHE="${TMPDIR:-/tmp}/claude-usage-cache.json"
CACHE_TTL=60

five_hour=""
weekly=""
now_epoch=$(date +%s)
cache_age=$((now_epoch + 1))
if [ -f "$USAGE_CACHE" ]; then
  cache_mtime=$(stat -f %m "$USAGE_CACHE" 2>/dev/null)
  [ -n "$cache_mtime" ] && cache_age=$((now_epoch - cache_mtime))
fi

if [ "$cache_age" -ge "$CACHE_TTL" ]; then
  creds=$(security find-generic-password -s "Claude Code-credentials" -w 2>/dev/null)
  token=$(echo "$creds" | grep -o '"accessToken":"[^"]*"' | head -1 | sed 's/"accessToken":"//;s/"$//')
  if [ -n "$token" ]; then
    fresh=$(curl -s --max-time 1 "https://api.anthropic.com/api/oauth/usage" \
      -H "Authorization: Bearer $token" \
      -H "anthropic-beta: oauth-2025-04-20" 2>/dev/null)
    if [ -n "$fresh" ] && echo "$fresh" | grep -q '"five_hour"'; then
      echo "$fresh" > "$USAGE_CACHE"
    fi
  fi
fi

api_usage=$(cat "$USAGE_CACHE" 2>/dev/null)
if [ -n "$api_usage" ]; then
  IFS=$'\t' read -r fh_util fh_reset sd_util sd_reset <<< "$(echo "$api_usage" | jq -r '[
    (.five_hour.utilization // empty | tostring),
    (.five_hour.resets_at // empty),
    (.seven_day.utilization // empty | tostring),
    (.seven_day.resets_at // empty)
  ] | @tsv' 2>/dev/null)"
  five_hour=$(format_rate "5h" "$fh_util" "$fh_reset" "$now_epoch")
  weekly=$(format_rate "7d" "$sd_util" "$sd_reset" "$now_epoch")
fi

# --- Output ---
printf "%b\n" "${header} | ${MODEL}"

line2="Ctx: ${ctx_display}"
[ -n "$five_hour" ] && line2="$line2 | $five_hour"
[ -n "$weekly" ] && line2="$line2 | $weekly"
printf "%b" "$line2"
