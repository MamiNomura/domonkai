#! /bin/bash
set -e

# Remove a potentially pre-existing server.pid for rails
rm -f /domonkai/tmp/pids/server.pid

# then exec container's main process
exec "$@"
