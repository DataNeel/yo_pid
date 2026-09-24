---
name: local-dev
description: How to run and verify the yo_pid bash CLI locally (no build, no services)
---

# Local Dev — yo_pid

Durable record of Autobuild onboarding local-dev verification, 2026-09-24.

## Stack

Standalone bash CLI. Nothing to install, no services, no database, no env vars required for local behavior.

## Environment

- Requires: `bash` (uses arrays), `curl`, `ps` — all preinstalled on the sandbox (bash 5.2.37, curl 8.14.1)
- `yo_pid.sh` is already executable; if not, `chmod +x yo_pid.sh`
- A real Yo notification requires replacing the `{{api key}}` placeholder in `yo_pid.sh` with a Yo API token (README documents this). Not needed for local verification — TODO(confirm) whether the token should become an env var.

## Commands

```bash
./yo_pid.sh -c '{COMMAND}' -u {YO_NAME}   # run command, Yo on completion
./yo_pid.sh -p {PID} -u {YO_NAME}         # monitor PID until activity stops
```

## Verification Steps

1. `./yo_pid.sh` → expect "Not enough options provided" usage message, exit 1
2. `./yo_pid.sh -c 'echo hello' -u TestUser` → command output printed, Yo API call attempted (curl DNS error expected in sandbox)
3. PID mode: `sleep 120 & ./yo_pid.sh -p $! -u TestUser` → polls for ~30s, then attempts the Yo call

## Gotchas

- PID mode always sleeps at least 30 seconds before it can conclude the process is idle — do not treat the delay as a hang
- The script's exit status is the final `curl` status, not the `-c` command's status (curl exit 6 = DNS failure for api.justyo.co, expected in sandbox)
- `api.justyo.co` does not resolve (third-party Yo service); outbound network itself is fine. Local behavior is fully verifiable; notification delivery is not.
