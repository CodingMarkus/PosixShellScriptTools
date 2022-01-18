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

# Push must accept exactly two arguments
set +e
( stack_push_psst 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_push_psst 1 2 3 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Stack name must not be empty, value can be empty
set +e
( stack_push_psst "test" "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_push_psst "" "test" 2>/dev/null ) || test_fail_psst $LINENO
set -e


# Pop must accept exactly two arguments
set +e
( stack_pop_psst 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst 1 2 3 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Neither one may be empty
set +e
( stack_pop_psst "test" "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst "" "test" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test push creates and pops destroys
! stack_exists_psst "stack" || test_fail_psst $LINENO

stack_push_psst "1" "stack" || test_fail_psst $LINENO
stack_exists_psst "stack" || test_fail_psst $LINENO

stack_pop_psst "stack" unused || test_fail_psst $LINENO
! stack_exists_psst "stack" ||  test_fail_psst $LINENO


# Test only destroyed if empty
! stack_exists_psst "stack" ||  test_fail_psst $LINENO

stack_push_psst "1" "stack" || test_fail_psst $LINENO
stack_push_psst "2" "stack" || test_fail_psst $LINENO
stack_exists_psst "stack" || test_fail_psst $LINENO

stack_pop_psst "stack" unused || test_fail_psst $LINENO
stack_exists_psst "stack"  test_fail_psst $LINENO

stack_pop_psst "stack" unused || test_fail_psst $LINENO
! stack_exists_psst "stack" || test_fail_psst $LINENO


# Test push, pop
test1Res=
stack_push_psst "a" "test1" || test_fail_psst $LINENO
stack_pop_psst test1 test1Res || test_fail_psst $LINENO
test "$test1Res" = "a" || test_fail_psst $LINENO


# Test push, push, pop, pop
test2Res=
stack_push_psst "a" test2 || test_fail_psst $LINENO
stack_push_psst "b" test2 || test_fail_psst $LINENO

stack_pop_psst test2 test2Res || test_fail_psst $LINENO
test "$test2Res" = "b" || test_fail_psst $LINENO

stack_pop_psst test2 test2Res || test_fail_psst $LINENO
test "$test2Res" = "a" || test_fail_psst $LINENO


# Test push, push, pop, push, pop, pop
test3Res=
stack_push_psst "a" test3 || test_fail_psst $LINENO
stack_push_psst "b" test3 || test_fail_psst $LINENO

stack_pop_psst test3 test3Res || test_fail_psst $LINENO
test "$test3Res" = "b" || test_fail_psst $LINENO

stack_push_psst "c" test3 || test_fail_psst $LINENO

stack_pop_psst test3 test3Res || test_fail_psst $LINENO
test "$test3Res" = "c" || test_fail_psst $LINENO

stack_pop_psst test3 test3Res || test_fail_psst $LINENO
test "$test3Res" = "a" || test_fail_psst $LINENO


# Cannot pop from non-existing stack
test4Res=
! stack_pop_psst test4 test4Res ||  test_fail_psst $LINENO
test -z "$test4Res" || test_fail_psst $LINENO