# Docker Health Dashboard

[![CI](https://github.com/DevXanderCode/docker-health-dashboard/actions/workflows/ci.yml/badge.svg)](https://github.com/DevXanderCode/docker-health-dashboard/actions/workflows/ci.yml)

A lightweight terminal dashboard for monitoring Docker container health and host resources. `dhealth` makes it easy to inspect container status, CPU/memory usage, network and block I/O, and uptime at a glance.

![dhealth demo](docs/assets/demo.gif)

## Key Features

- Real-time Docker container health insights
- Color-coded CPU, memory, and disk thresholds
- Status-aware container rendering with healthy/unhealthy indicators
- Optional watch mode for continuous refresh
- Host-level summary with memory, load average, and root disk usage
- Single-file Bash implementation for fast setup and portability

## Why Use This Project

This dashboard is ideal for developers and operators who need an unobtrusive terminal view of Docker workload health without installing a full monitoring stack. It ships as a single executable Bash script and is designed for quick deployment in Linux-based Docker hosts.

## Requirements

- Docker CLI installed and configured
- Docker daemon accessible to the current user
- Bash shell (`bash`)
- `awk`
- `tput`
- `free` (Linux hosts) or compatible alternative

> Note: The script currently uses `free -m` for host memory metrics. On macOS, install `free` via Homebrew (`brew install inetutils`) or run the dashboard from a Linux-based environment.

## Installation

### Option 1: Install script (recommended for servers/VPS)

Downloads the latest release, verifies its SHA-256 checksum, and installs
`dhealth` onto your `PATH` (no `sudo` required):

```bash
curl -fsSL https://raw.githubusercontent.com/DevXanderCode/docker-health-dashboard/main/install.sh | bash
```

Pin a specific version instead of the latest release:

```bash
DHEALTH_VERSION=v1.0.0 curl -fsSL https://raw.githubusercontent.com/DevXanderCode/docker-health-dashboard/main/install.sh | bash
```

Then run it from anywhere:

```bash
dhealth
```

### Option 2: Homebrew (macOS/Linuxbrew)

```bash
brew tap DevXanderCode/dhealth
brew install dhealth
```

### Option 3: Manual

Clone this repository or copy the `dhealth` script into your project
directory, then make it executable:

```bash
chmod +x ./dhealth
```

## Usage

Run the dashboard once:

```bash
./dhealth
```

Start live watch mode with automatic refresh every 5 seconds:

```bash
./dhealth -w
```

Change the refresh interval:

```bash
./dhealth -w -i 10
```

Show help:

```bash
./dhealth -h
```

Show version:

```bash
./dhealth -v
```

## Configuration

The dashboard uses built-in threshold values for color coding:

- CPU warning: `50%`
- CPU critical: `80%`
- Memory warning: `60%`
- Memory critical: `85%`
- Root disk warning: `70%`
- Root disk critical: `90%`

If you want to adjust these values, update the constants at the top of `dhealth`:

```bash
CPU_WARN=50
CPU_CRIT=80
MEM_WARN=60
MEM_CRIT=85
DISK_WARN=70
DISK_CRIT=90
```

## Contribution Guidelines

Contributions are welcome and appreciated. Please follow these guidelines to keep the project professional, maintainable, and easy to collaborate on.

### How to Contribute

1. Fork the repository.
2. Create a topic branch with a descriptive name, for example:
   - `feature/improve-watch-mode`
   - `fix/status-color-handling`
3. Make focused, incremental changes.
4. Submit a pull request with a clear summary of the work and any validation steps.

### Issue Reporting

When opening an issue, include:

- A concise title and description
- Steps to reproduce the problem
- The command you ran
- Host environment details (OS, Docker version, Bash version)
- Expected vs actual behavior
- Any error messages or terminal output

### Pull Request Expectations

- Keep each pull request small and focused
- Include a clear description of why the change is needed
- Reference related issues when applicable
- Run manual validation for the feature or fix
- Update documentation if behavior or user-facing options change

### Coding Standards

- Preserve the existing Bash style and script structure
- Use `set -euo pipefail` and robust input validation
- Prefer explicit error handling and fail-fast behavior
- Keep output readable for terminal use
- Limit dependencies to the required runtime tools

### Testing and Validation

This project has an automated test suite (ShellCheck for linting, [Bats](https://github.com/bats-core/bats-core) for unit/integration tests) that runs in CI on every push. Run it locally before submitting changes:

```bash
brew install shellcheck bats-core   # macOS; on Ubuntu: apt-get install shellcheck bats
shellcheck dhealth                  # lint
bats tests/                         # run the test suite
```

See [CONTRIBUTING.md](CONTRIBUTING.md#testing-and-validation) for how the tests are organized and how to add your own. Also validate live rendering manually:

- Running `./dhealth` in snapshot mode
- Running `./dhealth -w -i 5` in watch mode
- Verifying container rows and host metrics render correctly
- Confirming color thresholds behave as expected

### Additional Notes

- If you add new features, update this README so users can discover them easily.
- Maintain a professional commit history with descriptive messages.
- Use native shell utilities where possible and avoid introducing unnecessary external dependencies.

## Project Maintenance

This repository is kept minimal and functional. Future enhancements may include:

- macOS native compatibility fixes
- Config file support for custom thresholds
- Additional container metrics such as restart count or health check details

Done: automated tests (Bats) and ShellCheck linting now run in CI.

---

Thank you for using Docker Health Dashboard. Contributions and improvements are always welcome.
