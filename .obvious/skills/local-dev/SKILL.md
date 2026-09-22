---
name: local-dev
description: How to run and verify DataNeel/yo_pid locally (bash CLI, no services)
---

# local-dev — DataNeel/yo_pid

Durable record of the LOCAL-DEV onboarding run (2026-09-22). `dev_stack_healthy: true`.

## What this repo is

Single-file bash CLI (`yo_pid.sh`): run a command or monitor a PID, then send a "Yo"
notification through the Yo API (`http://api.justyo.co/yo/`). Exit status of the wrapped
command picks a happy or sad GIF link appended to the notification.

## Environment

| Requirement | Verified version in sandbox |
|---|---|
| bash | GNU bash 5.2.37(1) |
| curl | 8.14.1 |
| ps | procps-ng 4.0.4 |

No dependencies to install, no services to start, no migrations, no seeds, no lock
files, no server/port. The "dev stack" is the shell toolchain above.

## Verified commands

```bash
bash -n yo_pid.sh                              # syntax check (doubles as lint here)
./yo_pid.sh -c 'echo hello' -u {YO_NAME}       # command mode (primary flow)
./yo_pid.sh -p {PID} -u {YO_NAME}              # PID-monitor mode (primary flow)
```

Typecheck/tests: N/A — no type system, no test framework.

## Evidence captured (2026-09-22)

1. `bash -n yo_pid.sh` → exit 0 (SYNTAX OK).
2. No args → exit 1 with usage text. `-c`+`-p` both → exit 1 with error. Missing `-u` → exit 1. Argument validation correct.
3. Command mode happy path: `./yo_pid.sh -c 'echo hello-from-yo-pid' -u TESTUSER` — command output rendered; `bash -x` trace shows `EXIT_STATUS=0`, `rando=2`, `random_gif='&link=http://i.imgur.com/1rvPf.gif'` (happy array), curl payload `api_token={{api key}}&username=TESTUSER&link=…`.
4. Command mode sad path: `-c 'false'` → `EXIT_STATUS=1`, sad GIF path taken.
5. PID mode: monitored `sleep 100` PID → stable time/pmem → loop exited after one 30s cycle (~30s total), Yo send attempted.

## Gotchas for future workers

- **Yo API is dead.** `api.justyo.co` does not resolve (service defunct). The final
  `curl` exits 6 during any local run. This is expected and external — not a local
  stack failure. Do not "fix" it locally.
- **Token is an in-source placeholder** (`{{api key}}` inside `yo_pid.sh`), not an env
  var. Replacing it means editing the script; no secret is configured for this repo.
  TODO(confirm) with the owner if a live Yo token exists.
- **PID mode always costs ≥30s** — the poll loop sleeps 30s between `ps` samples.
  Budget for that in verification scripts.
- **Script exit status == curl's exit status** (last command). A local run that does
  everything right still exits 6 while the API is unreachable.
- **shellcheck is not installed** and there is no route to install it in the sandbox;
  use `bash -n` as the syntax gate.

## Snapshot

- Snapshot ID: `mv2h8ctqqjtpucc383e4:default`
- Sandbox: `i6eiwoyj4znnlyiqk5iqm`
- Captured: 2026-09-22T19:34:21.121Z
