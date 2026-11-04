#!/bin/bash

INPUT=$(cat)
COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command')

SPEC="/project/.project/spec.yaml"
if [ ! -f "$SPEC" ]; then
  exit 0
fi

# Extract secret variable names from spec.yaml
SECRETS=$(python3 -c "
import yaml, sys
try:
    spec = yaml.safe_load(open('$SPEC'))
    secrets = spec.get('execution', {}).get('secrets', [])
    for s in secrets:
        print(s['variable'])
except Exception:
    sys.exit(0)
")

if [ -z "$SECRETS" ]; then
  exit 0
fi

# Block env-dumping commands when secrets exist
if echo "$COMMAND" | grep -qxE '\s*(env|printenv|set|declare -p|export -p)\s*'; then
  echo "Blocked: command dumps all environment variables" >&2
  exit 2
fi

if echo "$COMMAND" | grep -qE 'cat\s+/proc/self/environ'; then
  echo "Blocked: reading /proc/self/environ exposes secrets" >&2
  exit 2
fi

# Block commands that reference any secret by name
while IFS= read -r secret; do
  if echo "$COMMAND" | grep -qF "$secret"; then
    echo "Blocked: command references secret variable '$secret'" >&2
    exit 2
  fi
done <<< "$SECRETS"

exit 0

