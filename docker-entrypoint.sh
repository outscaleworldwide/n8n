#!/bin/sh
# Launch task runner if enabled
if [ -f /etc/n8n-task-runners.json ]; then
  echo "Starting Task Runner..."
  task-runner-launcher &
fi

# Start n8n
exec n8n
