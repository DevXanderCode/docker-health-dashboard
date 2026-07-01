# Shared setup for every test file. Pulled in with `load helpers` inside a
# bats `setup()` function (bats auto-appends the .bash extension).

# BATS_TEST_DIRNAME is set by bats to the directory holding the running .bats
# file — i.e. this tests/ directory.
TESTS_DIR="${BATS_TEST_DIRNAME}"

# Repository root is one level up; that is where the dhealth script lives.
REPO_ROOT="$(cd "${TESTS_DIR}/.." && pwd)"
DHEALTH="${REPO_ROOT}/dhealth"

# Prepend our mocks dir so fake docker/free/df/tput shadow the real binaries
# for the duration of the test. Each test process gets its own copy of PATH,
# so this never leaks outside the test run.
PATH="${TESTS_DIR}/mocks:${PATH}"

# Load the dhealth functions into the current shell *without* running the
# dashboard (the script's sourcing guard sees BASH_SOURCE != $0 and skips main).
# Call this from a test's setup() before exercising individual functions.
load_dhealth() {
    # shellcheck source=/dev/null
    source "${DHEALTH}"
}
