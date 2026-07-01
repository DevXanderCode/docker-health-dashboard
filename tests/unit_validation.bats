#!/usr/bin/env bats
#
# Unit tests for validate_interval() — the rule for the -i refresh interval.
# Also a regression guard: the old check (^[1-9]+$) wrongly rejected 10, 20, …

setup() {
    load helpers
    load_dhealth
}

@test "validate_interval: accepts single-digit positives" {
    run validate_interval 1; [ "$status" -eq 0 ]
    run validate_interval 9; [ "$status" -eq 0 ]
}

# Regression: multi-digit values must be accepted (old regex rejected any
# number containing a 0, so 10 and 20 were wrongly refused).
@test "validate_interval: accepts multi-digit positives (bug regression)" {
    run validate_interval 10;  [ "$status" -eq 0 ]
    run validate_interval 20;  [ "$status" -eq 0 ]
    run validate_interval 100; [ "$status" -eq 0 ]
}

@test "validate_interval: rejects zero" {
    run validate_interval 0
    [ "$status" -ne 0 ]
}

@test "validate_interval: rejects negatives" {
    run validate_interval -5
    [ "$status" -ne 0 ]
}

@test "validate_interval: rejects non-numeric input" {
    run validate_interval abc
    [ "$status" -ne 0 ]
}

@test "validate_interval: rejects decimals" {
    run validate_interval 1.5
    [ "$status" -ne 0 ]
}

@test "validate_interval: rejects the empty string" {
    run validate_interval ""
    [ "$status" -ne 0 ]
}

@test "validate_interval: rejects a leading zero" {
    run validate_interval 01
    [ "$status" -ne 0 ]
}
