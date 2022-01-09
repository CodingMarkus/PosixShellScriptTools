#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]; then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc
. "$INCLUDE_PSST/basic.inc"

# =============================================================================

# Test push, pop
test1Res=
stack_push_psst "a" test1

stack_pop_psst test1 test1Res
test "$test1Res" = "a" || exit 100


# Test push, push, pop, pop
test2Res=
stack_push_psst "a" test2
stack_push_psst "b" test2

stack_pop_psst test2 test2Res
test "$test2Res" = "b" || exit 101

stack_pop_psst test2 test2Res
test "$test2Res" = "a" || exit 102


# Test push, push, pop, push, pop, pop
test3Res=
stack_push_psst "a" test3
stack_push_psst "b" test3

stack_pop_psst test3 test3Res
test "$test3Res" = "b" || exit 103

stack_push_psst "c" test3

stack_pop_psst test3 test3Res
test "$test3Res" = "c" || exit 104

stack_pop_psst test3 test3Res
test "$test3Res" = "a" || exit 105


# Cannot pop from non-existing stack
test4Res=
stack_pop_psst test4 test4Res && exit 106
test -z "$test4Res" || exit 107