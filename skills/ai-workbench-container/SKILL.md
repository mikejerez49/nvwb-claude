---
name: nvwb-project
description: Apply when working in a Linux environment that has a
  `/project/.project/spec.yaml` file. This skill enforces rules about
  AI Workbench project and container structure, environment configuration,
  and rebuild/restart requirements.
user-invocable: false
---

# NVIDIA AI Workbench — In-Container Project Awareness

## What NOT to Do

- Do NOT use `sudo`
- Do NOT install packages
- Do NOT edit `/project/.project/*` without consulting the user
- Do NOT run `nvwb` commands (Workbench CLI not available here)
- Do NOT print or log any secret environment variables listed in the
  `execution.secrets` section of `/project/.project/spec.yaml`

## What To Do

- Tell the user to rebuild the container after editing:
  `requirements.txt`, `apt.txt`, `postBuild.bash`, `preBuild.bash`
- Tell the user to restart the container after editing:
  `variables.env`, mount or app fields in `spec.yaml`
- Tell the user to restart the Compose application after editing:
  `compose.yaml` or `docker-compose.yml`
- For persistent storage, tell the user to add a mount
  (Claude cannot configure mounts from within the container)

