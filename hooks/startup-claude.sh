#!/bin/bash

# Check if Claude is in a project container
if [ ! -f /project/.project/spec.yaml ]; then
   echo "Not in a Workbench project container; Ignore Workbench skills"
   exit 0
fi

# Create CLAUDE.md if it doesn't exist
mkdir -p /project/.claude
if [ ! -f /project/CLAUDE.md ]; then
cat << 'EOF' > /project/CLAUDE.md

# Context for this project

## This is an AI Workbench Project

- This is a container
- There are relevant skills in `~/.claude/skills/ai-workbench-container`
- The project repository is at `/project`

EOF

fi

# Output project context
cat << 'EOF'
==============Claude Settings Information===============
This is an AI Workbench Project container.
The project Git repository is located at `/project`.
The project structure can be found in `/project/.project/spec.yaml`.
Use the Workbench skills in `~/.claude/skills/ai-workbench-container`
EOF

echo -e "This is the project spec.yaml file.\n"
cat /project/.project/spec.yaml

echo "These are the settings from ~/.claude/settings.json."
cat ~/.claude/settings.json

# Report GPU availability
if command -v nvidia-smi &>/dev/null && nvidia-smi &> /dev/null; then
   echo -e "\nThere are GPUs available in this container.\n"
   nvidia-smi --query-gpu=index,name,memory.total --format=csv,noheader
fi

