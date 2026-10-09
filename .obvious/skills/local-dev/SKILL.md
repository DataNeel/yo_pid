---
name: local-dev
description: How to run and verify the yo_pid bash CLI locally — environment requirements, verified flows, and known limits
globs: ["yo_pid.sh"]
alwaysApply: false
---

# Local Dev — yo_pid

## What this repo is

Single-file bash CLI (`yo_pid.sh`). Two modes: wrap a command and get a Yo notification when it finishes (`-c`), or poll a running PID until its CPU time/memory/processor readings stop changing (`-p`). Both require `-u {YO_NAME}` and notify via `curl http://api.justyo.co/yo/`.

## Environment requirements

- `bash` (5.x), `curl`, `ps` — preinstalled on the sandbox; **nothing to install**
- No package manager, no build step, no test framework, no services, no `.env`, no ports
- Yo API key: user-supplied, lives in the `{{api key}}` placeholder inside `yo_pid.sh` (README setup step 3)

## Verified procedure (onboarding 2026-10-09, thread th_aigNyrHE)

1. `bash -n yo_pid.sh` → syntax gate
2. `./yo_pid.sh` → usage error, exit 1 (also test `-x foo`, missing `-u`, and `-c`+`-p` together — all exit 1)
3. `./yo_pid.sh -c 'echo hello' -u testuser` → command runs, exit 0 → happy-gif path → delivery attempted
4. `./yo_pid.sh -c 'sh -c "exit 3"' -u testuser` → script survives subcommand failure → sad-gif path → delivery attempted
5. Monitor mode: `sleep 300 & ./yo_pid.sh -p $! -u testuser &` → monitor active while PID is live, terminates ≈30 s after the reading stops changing

## Known limits

- The final delivery step always fails locally with `curl: (6) Could not resolve host: api.justyo.co` — the Yo service is defunct and the token is a placeholder. Treat everything before the `curl` as the verifiable surface.
- `eval "$COMMAND"` means `-c 'exit 3'` terminates the script shell itself (bypasses gif classification). Use `-c 'sh -c "exit 3"'` to exercise the sad path without killing the script.
- `shellcheck` is not installable on the sandbox (no root). `bash -n` is the syntax gate.

## Snapshot

Dev-stack-verified sandbox captured as `dmxogqq1ua46hyv6cn9f:default` at 2026-10-09T16:22:44.721Z (sandbox `i86wwul0jf8qx1tbrqgsq`).
