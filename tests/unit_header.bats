#!/usr/bin/env bats
#
# Unit tests for the dashboard title bar in print_header.
#
# Requirements:
#   - the "🐳 Docker Health Dashboard" title is centred, and
#   - the dashes fill the *entire* terminal width on both sides.
#
# The tricky part is the whale 🐳: it draws two columns but counts as a single
# character, so the visible width of any line containing it is ${#line} + 1.
#
# We make the width deterministic by overriding the script's terminal_width()
# function after sourcing — so these tests never depend on the real terminal
# (and don't care how terminal_width gets the size in production).

setup() {
    load helpers
    load_dhealth
    # Drive the header width from $FAKE_COLS (default 200) for every test.
    terminal_width() { echo "${FAKE_COLS:-200}"; }
}

# Render print_header at a given terminal width and return only the dashed
# title line (the one carrying the dashboard name).
title_line() {
    FAKE_COLS="$1"
    print_header | grep "Docker Health Dashboard"
}

@test "header: title line fills the full terminal width (even width)" {
    local line
    line=$(title_line 200)
    # The whale counts as 1 char but draws 2 columns, so display width = chars+1.
    [ "$(( ${#line} + 1 ))" -eq 200 ]
}

@test "header: title line fills the full terminal width (odd width)" {
    local line
    line=$(title_line 101)
    [ "$(( ${#line} + 1 ))" -eq 101 ]
}

@test "header: title is centred at an even width (left/right dashes equal)" {
    local line left right
    line=$(title_line 200)
    left="${line%% 🐳*}"          # the run of dashes before the title
    right="${line##*Dashboard }"  # the run of dashes after the title
    [ "${#left}" -eq "${#right}" ]
}

@test "header: odd leftover column goes right, dashes still reach the edge" {
    local line left right
    line=$(title_line 101)
    left="${line%% 🐳*}"
    right="${line##*Dashboard }"
    # Right side absorbs the single odd column so the line stays full width.
    [ "$(( ${#right} - ${#left} ))" -eq 1 ]
}
