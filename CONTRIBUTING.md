# Contributing to Docker Health Dashboard

Thank you for your interest in improving Docker Health Dashboard. This document explains the contribution workflow, expectations, and quality standards for this project.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Branching and Pull Requests](#branching-and-pull-requests)
- [Issue Reporting](#issue-reporting)
- [Coding Standards](#coding-standards)
- [Testing and Validation](#testing-and-validation)
- [Documentation](#documentation)
- [Review Process](#review-process)
- [Thank You](#thank-you)

## Code of Conduct

This project follows a professional and respectful code of conduct. Be courteous, collaborative, and inclusive in all interactions. If you encounter behavior that does not align with these expectations, please raise it respectfully or contact the repository maintainer.

## How to Contribute

1. Fork the repository.
2. Create a branch from `main` with a descriptive name, such as:
   - `feature/add-config-support`
   - `fix/threshold-parsing`
   - `docs/update-readme`
3. Make focused, small changes that are easy to review.
4. Write a clear commit message describing the benefit and scope of your change.
5. Open a pull request with a concise summary, motivation, and validation steps.

## Branching and Pull Requests

- Create one pull request per logical change.
- Base your branch on the latest `main` branch.
- Rebase or merge from `main` before requesting review if there are conflicts.
- Use meaningful, action-oriented PR titles.
- Include links to any related issues.
- Describe what changed, why it changed, and how it was tested.

## Issue Reporting

When reporting an issue, include the following details:

- A short, clear title
- The exact command or action used
- Environment details (OS, Docker version, Bash version)
- Expected behavior versus actual behavior
- Full error messages or terminal output
- Steps to reproduce the problem

Good issue reports make it faster and easier to fix problems.

## Coding Standards

This project is implemented in Bash and aims for simplicity, robustness, and readability.

- Keep the existing coding style consistent.
- Use `set -euo pipefail` for fail-fast behavior.
- Validate input before use.
- Prefer explicit error messages and graceful exit codes.
- Keep functions short and focused.
- Avoid unnecessary external dependencies.
- Use shell-safe quoting and variable handling.

## Testing and Validation

This project has an automated test suite. **Run it before opening a pull request** — the same checks run in CI on every push.

### Tooling

Two tools are used. Install them once:

```bash
# macOS (Homebrew)
brew install shellcheck bats-core

# Debian/Ubuntu
sudo apt-get install -y shellcheck bats
```

- **[ShellCheck](https://www.shellcheck.net/)** — static analysis (linting). Finds bugs without running the script (unquoted variables, broken regexes, dead code). Configured by `.shellcheckrc`.
- **[Bats](https://github.com/bats-core/bats-core)** (Bash Automated Testing System) — runs the unit and integration tests in `tests/`.

### Running the checks

```bash
shellcheck dhealth        # lint — must report nothing (exit 0)
bats tests/               # run all tests
```

### How the tests are organized

| File | What it covers |
|------|----------------|
| `tests/unit_uptime.bats` | `extract_uptime` — parsing the uptime out of a docker status string |
| `tests/unit_validation.bats` | `validate_interval` — the `-i` refresh-interval rule |
| `tests/unit_colorize.bats` | `colorize_metric` / `colorize_status` — threshold and status colouring |
| `tests/integration.bats` | the whole script run end-to-end against a fake `docker` |
| `tests/mocks/` | stand-in `docker`/`free`/`df`/`tput` so tests need no real Docker host |
| `tests/helpers.bash` | shared setup (`load_dhealth`, mock `PATH`) |

The script is written to be **sourceable**: a guard at the bottom
(`if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then main "$@"; fi`) means tests can
`source ./dhealth` to load its functions without running the dashboard.

### Writing a test for a new function

1. Keep logic in a small, pure function (input via arguments, result via stdout/exit code).
2. Add a `@test` block. Use `run <fn> <args>`, then assert on `$status` and `$output`.
3. Make sure the test **fails when the code is wrong** — temporarily break the function and confirm the test goes red before trusting it.

### Manual validation

Automated tests don't cover live rendering against a real daemon, so also:

- Run `./dhealth` in snapshot mode.
- Run `./dhealth -w -i 5` in watch mode.
- Confirm container status, CPU/memory metrics, and host summary render without errors.
- Verify threshold coloring and formatting across different terminal widths.

## Documentation

If your change affects user-facing behavior, add or update documentation in `README.md` or this `CONTRIBUTING.md` file.

- Document new options or configuration changes.
- Clarify any environment requirements.
- Provide examples when applicable.

## Review Process

- Maintainers may request changes before merging.
- Address review comments promptly and respectfully.
- Keep follow-up commits focused on the requested improvements.
- Squash or tidy commits when appropriate prior to merge.

## Thank You

Thanks for helping make Docker Health Dashboard better. Your contributions are valuable and help keep the tool reliable, easy to use, and maintainable.
