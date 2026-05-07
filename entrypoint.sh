#!/bin/bash
set -e

# Start Xvfb (virtual framebuffer) for headless browser support
export DISPLAY=:99
Xvfb :99 -screen 0 1920x1080x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!

# Wait for Xvfb to be ready
sleep 1

# Generate xauth cookie for the display
xauth generate :99 . trusted 2>/dev/null || true

# Login with license key if provided via environment variable
if [ -n "$ENOWXAI_LICENSE_KEY" ]; then
  echo "Logging in with provided license key..."
  /root/.local/bin/enowxai login "$ENOWXAI_LICENSE_KEY"
fi

# Cleanup on exit
cleanup() {
  kill $XVFB_PID 2>/dev/null || true
}
trap cleanup EXIT

# Start the daemon
exec /root/.local/bin/enowxai "$@"
