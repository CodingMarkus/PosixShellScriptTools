#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e
# Exit at once if an unset variable is attempted to be expanded
set -u

if [ -z "${INCLUDE_PSST-}" ]
then
	cmdBase=$( dirname "$0" )
	INCLUDE_PSST="$cmdBase/../../../lib/psst"
fi

# shellcheck source=../../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================
# stack_push_psst

# Push must accept exactly two arguments
set +e
( stack_push_psst 'stack' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_push_psst 'stack' 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Stack name must not be empty or start with a digit or have spaces.
# Value can be empty.
set +e
( stack_push_psst '' 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_push_psst '1stack' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_puth_psst 'stack name' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_push_psst 'stack' '' 2>/dev/null ) || test_fail_psst $LINENO
set -e


# =============================================================================
# stack_pop_psst

# Pop requires at least one argument and not more than two
set +e
( stack_pop_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst 'stack' 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Stack name must not be empty or start with a digit or have spaces.
# outVar name must not be empty.
set +e
( stack_pop_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst '1stack' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst 'stack name' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_pop_psst 'stack' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# =============================================================================
# stack_exists_psst

# Exists must accept exactly one argument
set +e
( stack_exists_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_exists_psst 'stack' 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Stack name must not be empty or start with a digit or have spaces
set +e
( stack_exists_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_exists_psst '1stack' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_exists_psst 'stack name' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# =============================================================================
# stack_count_psst

# Count must accept exactly one argument
set +e
( stack_count_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_count_psst 'stack' 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Stack name must not be empty or start with a digit or have spaces
set +e
( stack_count_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_count_psst '1stack' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( stack_count_psst 'stack name' '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# =============================================================================
# Combine operations

# Test push creates and pops destroys
(
	! stack_exists_psst 'stack' || test_fail_psst $LINENO
	# Verify that the gloabl namespace has not been polluted
	! ( set | grep '^_.*_psst' ) || test_fail_psst $LINENO

	stack_push_psst 'stack' 1 || test_fail_psst $LINENO
	stack_exists_psst 'stack' || test_fail_psst $LINENO
	# Verify that the gloabl namespace has not been polluted
	! ( set | grep "^_.*_psst" ) || test_fail_psst $LINENO

	stack_pop_psst 'stack' || test_fail_psst $LINENO
	! stack_exists_psst 'stack' ||  test_fail_psst $LINENO
	# Verify that the gloabl namespace has not been polluted
	! ( set | grep '^_.*_psst' ) || test_fail_psst $LINENO
)


# Test only destroyed if empty
(
	! stack_exists_psst 'stack' ||  test_fail_psst $LINENO

	stack_push_psst 'stack' 1 || test_fail_psst $LINENO
	stack_push_psst 'stack' 2 || test_fail_psst $LINENO
	stack_exists_psst 'stack' || test_fail_psst $LINENO

	stack_pop_psst 'stack' || test_fail_psst $LINENO
	stack_exists_psst 'stack' ||  test_fail_psst $LINENO

	stack_pop_psst 'stack' || test_fail_psst $LINENO
	! stack_exists_psst 'stack' || test_fail_psst $LINENO
)


# Test push, pop
(
	test1Res=
	stack_push_psst 'stack' 'a' || test_fail_psst $LINENO
	stack_pop_psst 'stack' test1Res || test_fail_psst $LINENO
	[ "$test1Res" = 'a' ] || test_fail_psst $LINENO


	# Test push, push, pop, pop
	test2Res=
	stack_push_psst 'stack' 'a' || test_fail_psst $LINENO
	stack_push_psst 'stack' 'b' || test_fail_psst $LINENO
		# Verify that the gloabl namespace has not been polluted
		! ( set | grep '^_.*_psst' ) || test_fail_psst $LINENO

	stack_pop_psst 'stack' test2Res || test_fail_psst $LINENO
	[ "$test2Res" = 'b' ] || test_fail_psst $LINENO
		# Verify that the gloabl namespace has not been polluted
		! ( set | grep '^_.*_psst' ) || test_fail_psst $LINENO

	stack_pop_psst 'stack' test2Res || test_fail_psst $LINENO
	[ "$test2Res" = 'a' ] || test_fail_psst $LINENO
)


# Test push, push, pop, push, pop, pop
(
	test3Res=
	stack_push_psst 'stack' 'a' || test_fail_psst $LINENO
	stack_push_psst 'stack' 'b' || test_fail_psst $LINENO

	stack_pop_psst 'stack' test3Res || test_fail_psst $LINENO
	[ "$test3Res" = 'b' ] || test_fail_psst $LINENO

	stack_push_psst 'stack' 'c' || test_fail_psst $LINENO

	stack_pop_psst 'stack' test3Res || test_fail_psst $LINENO
	[ "$test3Res" = 'c' ] || test_fail_psst $LINENO

	stack_pop_psst 'stack' test3Res || test_fail_psst $LINENO
	[ "$test3Res" = 'a' ] || test_fail_psst $LINENO
)


# Cannot pop from non-existing stack
test4Res=
! stack_pop_psst 'stack' test4Res ||  test_fail_psst $LINENO
[ -z "$test4Res" ] || test_fail_psst $LINENO

# Verify that the gloabl namespace has not been polluted
! ( set | grep '^_.*_psst' ) || test_fail_psst $LINENO



# Test stack count
(
	[ "$( stack_count_psst 'stack' )" -eq 0 ] || test_fail_psst $LINENO
	stack_push_psst 'stack' 'a' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 1 ] || test_fail_psst $LINENO
	stack_push_psst 'stack' 'b' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 2 ] || test_fail_psst $LINENO
	stack_push_psst 'stack' 'c' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 3 ] || test_fail_psst $LINENO
	stack_pop_psst 'stack' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 2 ] || test_fail_psst $LINENO
	stack_pop_psst 'stack' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 1 ] || test_fail_psst $LINENO
	stack_pop_psst 'stack' || test_fail_psst $LINENO
	[ "$( stack_count_psst 'stack' )" -eq 0 ] || test_fail_psst $LINENO
)
