#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]; then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================


# Test push creates and pops destroys
! stack_exists_psst "stack" || testfail_psst $LINENO

stack_push_psst "1" "stack" || testfail_psst $LINENO
stack_exists_psst "stack" || testfail_psst $LINENO

stack_pop_psst "stack" unused || testfail_psst $LINENO
! stack_exists_psst "stack" ||  testfail_psst $LINENO


# Test only destroyed if empty
! stack_exists_psst "stack" ||  testfail_psst $LINENO

stack_push_psst "1" "stack" || testfail_psst $LINENO
stack_push_psst "2" "stack" || testfail_psst $LINENO
stack_exists_psst "stack" || testfail_psst $LINENO

stack_pop_psst "stack" unused || testfail_psst $LINENO
stack_exists_psst "stack"  testfail_psst $LINENO

stack_pop_psst "stack" unused || testfail_psst $LINENO
! stack_exists_psst "stack" || testfail_psst $LINENO


# Test push, pop
test1Res=
stack_push_psst "a" "test1" || testfail_psst $LINENO
stack_pop_psst test1 test1Res || testfail_psst $LINENO
test "$test1Res" = "a" || testfail_psst $LINENO


# Test push, push, pop, pop
test2Res=
stack_push_psst "a" test2 || testfail_psst $LINENO
stack_push_psst "b" test2 || testfail_psst $LINENO

stack_pop_psst test2 test2Res || testfail_psst $LINENO
test "$test2Res" = "b" || testfail_psst $LINENO

stack_pop_psst test2 test2Res || testfail_psst $LINENO
test "$test2Res" = "a" || testfail_psst $LINENO


# Test push, push, pop, push, pop, pop
test3Res=
stack_push_psst "a" test3 || testfail_psst $LINENO
stack_push_psst "b" test3 || testfail_psst $LINENO

stack_pop_psst test3 test3Res || testfail_psst $LINENO
test "$test3Res" = "b" || testfail_psst $LINENO

stack_push_psst "c" test3 || testfail_psst $LINENO

stack_pop_psst test3 test3Res || testfail_psst $LINENO
test "$test3Res" = "c" || testfail_psst $LINENO

stack_pop_psst test3 test3Res || testfail_psst $LINENO
test "$test3Res" = "a" || testfail_psst $LINENO


# Cannot pop from non-existing stack
test4Res=
! stack_pop_psst test4 test4Res ||  testfail_psst $LINENO
test -z "$test4Res" || testfail_psst $LINENO