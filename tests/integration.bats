#!/usr/bin/env bats
#
# Integration test: run the *whole* dhealth script end-to-end against the fake
# docker/free/df/tput on PATH, and assert on what it renders. This is the
# black-box counterpart to the unit tests — it proves the pieces work together.

setup() {
    load helpers   # puts tests/mocks first on PATH; defines $DHEALTH
}

@test "dhealth: runs end-to-end and exits 0" {
    run bash "$DHEALTH"
    [ "$status" -eq 0 ]
}

@test "dhealth: prints the dashboard title" {
    run bash "$DHEALTH"
    [[ "$output" == *"Docker Health Dashboard"* ]]
}

@test "dhealth: lists container names from docker ps" {
    run bash "$DHEALTH"
    [[ "$output" == *"prizaar_web"* ]]
    [[ "$output" == *"mysql_server"* ]]
}

# End-to-end regression for the original bug: the rendered row for a container
# whose status carries "(unhealthy)" must still show its uptime, not "-".
#
# NOTE: we can't just grep for "12 days" — that text also appears in the STATUS
# column ("Up 12 days (unhealthy)"), so it would pass even with the bug present.
# UPTIME is the LAST column, so we assert the prizaar_web row *ends with* the
# uptime. With the bug the row ends in "-", so this fails as it should.
@test "dhealth: renders uptime in the UPTIME column for an (unhealthy) container (bug regression)" {
    run bash "$DHEALTH"
    local row
    row=$(printf '%s\n' "$output" | grep "prizaar_web")
    [[ "$row" =~ 12\ days[[:space:]]*$ ]]
}

# Regression for column misalignment. Every container row is built entirely
# from fixed-width columns, so with colour off each rendered row must have the
# exact same display width. Before the fix the STATUS column overflowed by a
# different amount per row (statuses vary: "Up 12 days (unhealthy)" is longer
# than "Up 5 weeks (healthy)"), so rows had different lengths and every column
# to the right of STATUS drifted out of alignment.
@test "dhealth: all container rows render to the same width (columns stay aligned)" {
    run bash "$DHEALTH"
    [ "$status" -eq 0 ]

    local name row
    local -a widths=()
    for name in prizaar_web mysql_server old_job; do
        row=$(printf '%s\n' "$output" | grep -F "$name")
        widths+=( "${#row}" )
    done

    # All rows must match the first row's width.
    [ "${widths[1]}" -eq "${widths[0]}" ]
    [ "${widths[2]}" -eq "${widths[0]}" ]
}

@test "dhealth: counts running vs stopped correctly" {
    run bash "$DHEALTH"
    [[ "$output" == *"Total: 3"* ]]
    [[ "$output" == *"Running: 2"* ]]
    [[ "$output" == *"Stopped/Other: 1"* ]]
}

@test "dhealth: shows host memory from free" {
    run bash "$DHEALTH"
    [[ "$output" == *"3670MB / 7872MB"* ]]
}

@test "dhealth: rejects an invalid -i interval" {
    run bash "$DHEALTH" -w -i 0
    [ "$status" -ne 0 ]
    [[ "$output" == *"positive integer"* ]]
}
