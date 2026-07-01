#!/usr/bin/env bats
#
# Unit tests for extract_uptime() — the function behind the original "UPTIME
# always shows -" bug. These are the regression tests that would have caught it.

setup() {
    load helpers      # brings in load_dhealth, PATH mocks, etc.
    load_dhealth      # source the script so we can call its functions directly
}

@test "extract_uptime: plain uptime is returned as-is" {
    run extract_uptime "Up 3 hours"
    [ "$status" -eq 0 ]
    [ "$output" = "3 hours" ]
}

@test "extract_uptime: '(healthy)' suffix is stripped" {
    run extract_uptime "Up 5 weeks (healthy)"
    [ "$output" = "5 weeks" ]
}

# This is the exact case that was broken: the status carries an "(unhealthy)"
# health suffix and the uptime must still be extracted.
@test "extract_uptime: '(unhealthy)' suffix is stripped (bug regression)" {
    run extract_uptime "Up 12 days (unhealthy)"
    [ "$output" = "12 days" ]
}

@test "extract_uptime: docker's 'About an hour' wording" {
    run extract_uptime "Up About an hour"
    [ "$output" = "About an hour" ]
}

@test "extract_uptime: paused-but-up container still reports uptime" {
    run extract_uptime "Up 2 hours (Paused)"
    [ "$output" = "2 hours" ]
}

@test "extract_uptime: a stopped container returns a dash" {
    run extract_uptime "Exited (0) 2 days ago"
    [ "$output" = "-" ]
}

@test "extract_uptime: a never-started container returns a dash" {
    run extract_uptime "Created"
    [ "$output" = "-" ]
}
