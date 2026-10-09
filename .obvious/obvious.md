# Obvious repo guidance

<!-- obvious-install: skill=autobuild-setup, skill-version=1.0.3, template-version=1 -->

This repo uses `.obvious/` for reviewed Autobuild guidance.

Before editing, suggest the smallest relevant set of `.obvious` files for the task. Match candidate files by reading their frontmatter.

## Codebase Map

See `.obvious/codebase-map.md` for the full directory guide.

Summary: single-file bash CLI repo (`yo_pid.sh` + `README.md`). No subdirectories, no packages, no services, no CI workflows.

## Repo Guidance for Autobuild

No agent guidance files (AGENTS.md, CLAUDE.md, CONTRIBUTING.md, .cursorrules, .windsurfrules) were found in this repo.

**Stack:** Bash CLI script only. No package manager, no build step, no test framework, no services.

**Key details for agents:**
- `yo_pid.sh` uses `getopts` for CLI argument parsing (`-c` command mode, `-p` PID-monitor mode, `-u` required Yo username)
- It sends a notification via `curl` to `http://api.justyo.co/yo/` — the Yo API is defunct (DNS does not resolve) and the token placeholder `{{api key}}` must be replaced by the user before use
- Exit status of the wrapped command selects a happy (exit 0) or sad (non-zero) GIF for the notification
- PID mode polls `ps -p $PID -o time,pmem,sgi_p` every 30 s until the reading stops changing
- `-c` and `-p` are mutually exclusive; `-u` is required; invalid invocations exit 1 with usage text

## Commands

| Purpose | Command |
|---|---|
| Syntax check | `bash -n yo_pid.sh` |
| Run a command, Yo on completion | `./yo_pid.sh -c '{COMMAND}' -u {YO_NAME}` |
| Monitor a PID, Yo when idle | `./yo_pid.sh -p {PID} -u {YO_NAME}` |

## Local Verification

**dev_stack_healthy: true** (verified 2026-10-09, onboarding thread th_aigNyrHE)

The dev stack is the script itself plus bash/curl/ps coreutils — no install step, no services, no ports. All documented CLI flows were exercised end-to-end:

- Argument validation (no args, invalid option, missing `-u`, `-c`+`-p` conflict) → usage errors, exit 1 ✓
- Command mode, success path: command executed, exit 0 → happy-gif path → delivery attempted ✓
- Command mode, sad path: `sh -c "exit 3"` → script survives, sad-gif path → delivery attempted ✓
- PID monitor mode: polls a live PID, terminates ~30 s after process stability ✓
- Delivery step fails with `curl: (6) Could not resolve host: api.justyo.co` — the Yo SaaS is defunct and the key is user-supplied; delivery is a third-party notification, not part of the local stack

### Verified Commands

- **Typecheck:** N/A — bash script, no type system
- **Lint:** N/A — no linter configured; `bash -n yo_pid.sh` passes
- **Test:** N/A — no test framework

### Scoped Workflow

No scoped verification commands available. To manually test the script:

1. Replace `{{api key}}` in `yo_pid.sh` with a real Yo API token (note: the service is currently defunct)
2. Run `./yo_pid.sh -c 'echo hello' -u {YO_USERNAME}` to test command mode
3. Run `./yo_pid.sh -p {PID} -u {YO_USERNAME}` to test PID monitoring mode

## Sandbox Snapshot

- **Snapshot ID:** `dmxogqq1ua46hyv6cn9f:default`
- **Sandbox:** `i86wwul0jf8qx1tbrqgsq`
- **Captured:** 2026-10-09T16:22:44.721Z
- **Dev stack healthy:** true

## Bibliography

Product Atlas nodes for this repo were already seeded from a prior scan. The following nodes exist under the `yo-pid` product:

- `yo-pid` (product) — Yo Process Is Done
  - `command-completion-notification` (feature) — Run a command and send Yo on completion
  - `mood-based-result-gif` (feature) — Happy/sad GIF attached based on exit status
  - `process-activity-monitoring` (feature) — Monitor PID until CPU/memory/processor stop changing
  - `yo-messaging-delivery` (integration) — Yo API delivery via curl

**Bibliography depth:** seed-level (4 child nodes + 1 product node). For comprehensive Product Atlas coverage, load the `product-atlas-collection` skill.

## Security Scan

> **Note:** security_scan_not_triggered — `trigger_security_onboarding` tool is not available in this environment. Trigger manually if required.

## Component Manifest

> **Skipped:** `component-manifest-generator` skill does not apply — no `package.json` at repo root. This repo is a bash script, not a JS/TS project.

## Runbooks

Populated by autobuild-runbooks skill when requested. See `.obvious/runbooks/` after that skill runs.
