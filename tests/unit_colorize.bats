#!/usr/bin/env bats
#
# Unit tests for the two colouring helpers.
#
# Trick: after sourcing dhealth we OVERRIDE the colour variables with obvious
# sentinels (<R>, <G>, …). That makes the tests deterministic regardless of the
# real terminal AND lets us assert *which* colour branch was taken — something
# we couldn't see if the codes were invisible escape sequences.

setup() {
    load helpers
    load_dhealth
    RED="<R>"; GREEN="<G>"; YELLOW="<Y>"; MAGENTA="<M>"
    BOLD="<B>"; DIM="<D>"; RESET="<0>"
}

# ---- colorize_metric: number vs. warn/crit thresholds ----------------------

@test "colorize_metric: above the critical threshold -> red + bold" {
    run colorize_metric 90 50 80
    [ "$status" -eq 0 ]
    [ "$output" = "<R><B>90<0>" ]
}

@test "colorize_metric: between warn and crit -> yellow" {
    run colorize_metric 70 50 80
    [ "$output" = "<Y>70<0>" ]
}

@test "colorize_metric: below the warning threshold -> green" {
    run colorize_metric 10 50 80
    [ "$output" = "<G>10<0>" ]
}

# The function floors decimals before comparing: 80.9 -> 80, which is NOT
# greater than the crit threshold of 80, so it stays in the warn (yellow) band
# while still displaying the original "80.9".
@test "colorize_metric: floors decimals before comparing thresholds" {
    run colorize_metric 80.9 50 80
    [ "$output" = "<Y>80.9<0>" ]
}

# ---- colorize_status: container status -> coloured label -------------------

@test "colorize_status: running -> green dot" {
    run colorize_status "running"
    [ "$output" = "<G><B>● running<0>" ]
}

@test "colorize_status: exited -> red cross" {
    run colorize_status "exited (0) 5 minutes ago"
    [ "$output" = "<R><B>✖ exited (0) 5 minutes ago<0>" ]
}

@test "colorize_status: a bare 'unhealthy' status -> red warning" {
    run colorize_status "unhealthy"
    [ "$output" = "<R><B>⚠ unhealthy<0>" ]
}

@test "colorize_status: an unknown status falls back to dim" {
    run colorize_status "some weird state"
    [ "$output" = "<D>some weird state<0>" ]
}
