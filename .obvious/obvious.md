# Obvious repo guidance

<!-- obvious-install: skill=autobuild-setup, skill-version=1.0.3, template-version=1 -->

This repo uses `.obvious/` for reviewed Autobuild guidance.

Before editing, suggest the smallest relevant set of `.obvious` files for the task. Match candidate files by reading their frontmatter.

## Codebase Map

This is a single-file bash script repo with no directories. The entire codebase is two files in the repo root:

| Path | Purpose |
|---|---|
| `yo_pid.sh` | Main bash script — runs a command or monitors a PID, then sends a Yo notification via the Yo API |
| `README.md` | Usage instructions and Yo API setup guide |

No subdirectories, no packages, no services, no CI workflows.

## Repo Guidance for Autobuild

No agent guidance files (AGENTS.md, CLAUDE.md, CONTRIBUTING.md, .cursorrules, .windsurfrules) were found in this repo.

**Stack:** Bash script only. No package manager, no build step, no test framework.

**Key details for agents:**
- The script uses `getopts` for CLI argument parsing (`-c`, `-u`, `-p`)
- It calls the Yo API at `http://api.justyo.co/yo/` via `curl`
- The API token placeholder `{{api key}}` in `yo_pid.sh` must be replaced with a real token before use
- Exit status determines whether a "happy" or "sad" GIF is attached to the Yo notification
- PID monitoring mode polls `ps` every 30 seconds until CPU time, memory, and processor stop changing

## Local Verification

> **SCAFFOLD branch:** This repo has no runnable application stack (no server, no build system, no test framework). Local dev verification was not applicable. The script is a standalone CLI tool that requires a Yo API key to function end-to-end.

### Verified Commands

- **Typecheck:** N/A — bash script, no type system
- **Lint:** N/A — no linter configured
- **Test:** N/A — no test framework

### Scoped Workflow

No scoped verification commands available. To manually test the script:

1. Replace `{{api key}}` in `yo_pid.sh` with a real Yo API token
2. Run `./yo_pid.sh -c 'echo hello' -u {YO_USERNAME}` to test command mode
3. Run `./yo_pid.sh -p {PID} -u {YO_USERNAME}` to test PID monitoring mode

## Sandbox Snapshot

- **Snapshot ID:** N/A
- **Captured:** N/A
- **Dev stack healthy:** N/A — no runnable stack (SCAFFOLD branch)

> **Note:** Snapshot skipped — repo has no runnable dev stack. This is a standalone bash script with no dependencies to install or services to start.

## Bibliography

Product Atlas nodes for this repo were already seeded from a prior scan. The following nodes exist under the `yo-pid` product:

- `yo-pid` (product) — Yo Process Is Done
  - `command-completion-notification` (feature) — Run a command and send Yo on completion
  - `mood-based-result-gif` (feature) — Happy/sad GIF attached based on exit status
  - `process-activity-monitoring` (feature) — Monitor PID until CPU/memory/processor stop changing
  - `yo-messaging-delivery` (integration) — Yo API delivery via curl

File source provenance (`yo_pid.sh`, `README.md`) was appended to the `yo-pid` product node during this install scan.

**Bibliography depth:** seed-level (4 child nodes + 1 product node). For comprehensive Product Atlas coverage, load the `product-atlas-collection` skill.

## Security Scan

> **Note:** security_scan_not_triggered — `trigger_security_onboarding` tool is not available in this environment. Trigger manually if required.

## Runbooks

Populated by autobuild-runbooks skill when requested. See `.obvious/runbooks/` after that skill runs.
