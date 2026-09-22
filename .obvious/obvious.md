# Obvious repo guidance

<!-- obvious-install: skill=autobuild-setup, skill-version=1.0.3, template-version=1 -->

This repo uses `.obvious/` for reviewed Autobuild guidance.

Before editing, suggest the smallest relevant set of `.obvious` files for the task. Match candidate files by reading their frontmatter.

## Codebase Map

See `.obvious/codebase-map.md` for the full directory guide.

Summary: single-file bash script repo (`yo_pid.sh` + `README.md`). No subdirectories, no packages, no services, no CI workflows.

## Repo Guidance for Autobuild

No agent guidance files (AGENTS.md, CLAUDE.md, CONTRIBUTING.md, .cursorrules, .windsurfrules) were found in this repo.

**Stack:** Bash script only. No package manager, no build step, no test framework.

**Key details for agents:**
- The script uses `getopts` for CLI argument parsing (`-c`, `-u`, `-p`)
- It calls the Yo API at `http://api.justyo.co/yo/` via `curl`
- The API token placeholder `{{api key}}` in `yo_pid.sh` must be replaced with a real token before use
- Exit status determines whether a "happy" or "sad" GIF is attached to the Yo notification
- PID monitoring mode polls `ps` every 30 seconds until CPU time, memory, and processor stop changing

## Commands

| Task | Command |
|---|---|
| Syntax check (doubles as lint) | `bash -n yo_pid.sh` |
| Run a command, send Yo when done | `./yo_pid.sh -c '{COMMAND}' -u {YO_NAME}` |
| Monitor a PID, send Yo when idle | `./yo_pid.sh -p {PID} -u {YO_NAME}` |

No install step, no build step, no test suite, no server, no ports.

## Local Verification

### Local Verification Summary

- **Decision:** DONE — `dev_stack_healthy: true` (verified 2026-09-22 in sandbox)
- **Runtime:** GNU bash 5.2.37, curl 8.14.1, procps-ng ps 4.0.4 — all present
- **Lint:** `bash -n yo_pid.sh` → SYNTAX OK (shellcheck unavailable in sandbox; no install route)
- **Typecheck / tests:** N/A — bash script; no type system, no test framework

### Verified flows (evidence)

| Flow | Result |
|---|---|
| No args | exit 1 + usage text (correct) |
| `-c` and `-p` both given | exit 1 + "Command and PID both provided" (correct) |
| Missing `-u` | exit 1 + usage text (correct) |
| **Command mode, happy path:** `./yo_pid.sh -c 'echo hello-from-yo-pid' -u TESTUSER` | command output rendered; trace shows `EXIT_STATUS=0`, happy GIF selected (`random_gif='&link=http://i.imgur.com/1rvPf.gif'`), Yo payload built correctly |
| **Command mode, sad path:** `./yo_pid.sh -c 'false' -u TESTUSER` | `EXIT_STATUS=1` → sad GIF path taken |
| **PID mode:** `./yo_pid.sh -p {PID of sleep 100} -u TESTUSER` | poll loop exited after one stable 30s cycle, Yo send attempted (~30s total) |

### Known limitation (external service)

`api.justyo.co` no longer resolves in DNS — the Yo service is defunct. During local verification the final `curl` therefore exits 6 (could not resolve host). This is an external-service failure, not a local-stack failure: every local code path (argument parsing, command execution, exit-status capture, GIF selection, payload construction) was verified working. The script's token placeholder `{{api key}}` is kept as-is; replace it with a real token only if the Yo service is reachable: TODO(confirm)

## Sandbox Snapshot

- **Snapshot ID:** `mv2h8ctqqjtpucc383e4:default`
- **Sandbox:** `i6eiwoyj4znnlyiqk5iqm`
- **Captured:** 2026-09-22T19:34:21.121Z (ISO-8601, UTC)
- **Dev stack healthy:** true — bash CLI verified end-to-end (see Local Verification)

## Bibliography

Product Atlas nodes for this repo were already seeded from a prior scan. The following nodes exist under the `yo-pid` product:

- `yo-pid` (product) — Yo Process Is Done
  - `command-completion-notification` (feature) — Run a command and send Yo on completion
  - `mood-based-result-gif` (feature) — Happy/sad GIF attached based on exit status
  - `process-activity-monitoring` (feature) — Monitor PID until CPU/memory/processor stop changing
  - `yo-messaging-delivery` (integration) — Yo API delivery via curl

File source provenance (`yo_pid.sh`, `README.md`) was appended to the `yo-pid` product node during the install scan.

**Bibliography depth:** seed-level (4 child nodes + 1 product node). For comprehensive Product Atlas coverage, load the `product-atlas-collection` skill.

## Security Scan

> **Note:** security_scan_not_triggered — `trigger_security_onboarding` tool is not available in this environment. Trigger manually if required.

## Component Manifest

> **Skipped:** `component-manifest-generator` skill does not apply — no `package.json` at repo root. This repo is a bash script, not a JS/TS project.

## Runbooks

Populated by autobuild-runbooks skill when requested. See `.obvious/runbooks/` after that skill runs.
