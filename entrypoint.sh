#!/bin/bash
set -e

# Login with license key if provided via environment variable
if [ -n "$ENOWXAI_LICENSE_KEY" ]; then
  echo "Logging in with provided license key..."
  /root/.local/bin/enowxai login "$ENOWXAI_LICENSE_KEY"
fi

# Start the daemon
exec /root/.local/bin/enowxai "$@"
