#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if [[ -z "${CHROME_EXECUTABLE:-}" ]] && [[ -x /usr/bin/google-chrome-stable ]]; then
  export CHROME_EXECUTABLE=/usr/bin/google-chrome-stable
elif [[ -z "${CHROME_EXECUTABLE:-}" ]] && command -v chromium >/dev/null; then
  export CHROME_EXECUTABLE="$(command -v chromium)"
fi

run_flutter() {
  if command -v flutter >/dev/null 2>&1; then
    flutter "$@"
    return
  fi
  if command -v mise >/dev/null 2>&1 && [[ -f mise.toml ]]; then
    mise exec -- flutter "$@"
    return
  fi
  cat <<'EOF' >&2
flutter: command not found

  mise install
  ./scripts/run-web.sh
EOF
  exit 127
}

WEB_HOST="${WEB_HOST:-localhost}"
WEB_PORT="${WEB_PORT:-8080}"
MODE="${1:-server}"

run_flutter pub get

case "$MODE" in
  chrome)
    shift
    run_flutter run -d chrome "$@"
    ;;
  server|*)
    echo "Open http://${WEB_HOST}:${WEB_PORT} in any browser (use a wide / landscape window)."
    run_flutter run -d web-server \
      --web-hostname="$WEB_HOST" \
      --web-port="$WEB_PORT" \
      "${@:2}"
    ;;
esac