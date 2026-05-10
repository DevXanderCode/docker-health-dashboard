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

Although there is no automated test suite at this time, please validate your changes manually:

- Run `./dhealth` in snapshot mode.
- Run `./dhealth -w -i 5` in watch mode.
- Confirm container status, CPU/memory metrics, and host summary render without errors.
- Verify threshold coloring and formatting across different terminal widths.
- Check that help and error messages remain accurate.

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
