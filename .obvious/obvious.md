# Obvious repo guidance

<!-- obvious-install: skill=autobuild-setup, skill-version=1.0.3, template-version=1 -->

This repo uses `.obvious/` for reviewed Autobuild guidance.

Before editing, suggest the smallest relevant set of `.obvious` files for the task. Match candidate files by reading their frontmatter.

## Codebase Map

See `.obvious/codebase-map.md` for the full directory guide.

Summary: single-file bash script repo (`yo_pid.sh` + `README.md`). No subdirectories, no packages, no services, no CI workflows.

## Repo Guidance for Autobuild

No agent guidance files (AGENTS.md, CLAUDE.md, CONTRIBUTING.md, .cursorrules, .windsurfrules) were found in this repo.

**Stack:** Standalone Bash CLI script. Runtime requirements: bash (uses arrays), `curl`, `ps`. No package manager, no build step, no test framework, no CI.

**Key details for agents:**
- The script uses `getopts` for CLI argument parsing (`-c` command mode, `-p` PID mode, `-u` Yo username — required)
- It calls the Yo API at `http://api.justyo.co/yo/` via `curl` POST
- The API token placeholder `{{api key}}` in `yo_pid.sh` must be replaced with a real token before notifications work — TODO(confirm) whether this should become an env var
- Exit status of the `-c` command selects a "happy" (0) or "sad" (non-zero) GIF for the notification
- PID monitoring mode polls `ps -p PID -o time,pmem,sgi_p` every 30 seconds until output stops changing (minimum ~30s wait by design)
- The last statement is the `curl` call, so the script's exit status is curl's status, not the wrapped command's status

## Local Verification

Verified during Autobuild onboarding on 2026-09-24 (sandbox: bash 5.2.37, curl 8.14.1).

### Verified Commands

- **Typecheck:** N/A — bash script, no type system
- **Lint:** N/A — no linter configured; shellcheck could not be installed in the sandbox (explicit omission)
- **Test:** N/A — no test framework; functional verification performed instead (below)

### Functional Verification (primary flows)

- Usage paths 4/4 pass: no args, invalid option, missing `-u`, both `-c`+`-p` → correct usage messages, exit 1
- Command mode: `./yo_pid.sh -c 'echo hello from yo_pid && true' -u TestUser` → command executed, exit status captured, GIF path selected, Yo call attempted
- PID mode: monitored a live `sleep` process → polling loop detected stable CPU/mem/processor state in ~30s and proceeded to the Yo call

### Known Limitations

- `api.justyo.co` does not resolve from the sandbox (outbound network itself works — api.github.com returned 200). The Yo service is a third-party dependency and the repo ships an `{{api key}}` placeholder, so notification delivery is not verifiable locally. TODO(confirm) whether delivery should be mocked or the service replaced.

## Sandbox Snapshot

- **Snapshot ID:** `4nvmvertxwyi0nxs1efv:default`
- **Captured:** 2026-09-24T18:28:22.611Z
- **Dev stack healthy:** true (CLI stack: bash + curl; no services or databases required)

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
