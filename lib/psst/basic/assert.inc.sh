#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:assert:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:assert:"


##
# FUNCTION
#	assert_fail_psst <msg>
#
# SUMMARY
#	Prints `msg` to stderr and terminates current process with error 127,
#	which is the highest possible error as values 128 and up are reserved
#	for signals and lower values are used by functions as failure indicators.
#
# PARAMETERS
#	msg: Message to print to stderr.
#
# SAMPLE
#	[ "$index" -gt 0 ] || assert_fail_psst "Index must be > 0"
#
assert_fail_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	assert_argc_psst "assert_fail_psst" 1 $#
	assert_hasarg_psst "assert_argc_psst" "msg" "$1"

	printf "Assertion fail: %s!\n" "$1" >&2
	exit 127
}


##
# FUNCTION
#	assert_argc_psst <func> <expected> <actual>
#
# SUMMARY
#	Prints an error to stderr if `actual` is not equal `expected`` and
#	terminates current process with error 127, which is the highest possible
#	error as values 128 and up are reserved for signals and lower values are
#	used by functions as failure indicators.
#
# PARAMETERS
#	func: Name of the function.
#	expected: Number of aguments expected.
#	actual: Number of actual aguments.
#
# SAMPLE
#	assert_argc_psst "myfunc" 3 $#
#
assert_argc_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	if [ $# -ne 3 ]
	then
		printf "%s: Function \"%s\" expects %s arguments, got %s!\n" \
			"Assertion fail" assert_argc_psst 3 $# >&2
		exit 127
	fi

	assert_hasarg_psst "assert_argc_psst" "func" "$1"
	assert_hasarg_psst "assert_argc_psst" "expected" "$2"
	assert_hasarg_psst "assert_argc_psst" "actual" "$3"

	if [ "$2" -ne "$3" ]
	then
		printf "%s: Function \"%s\" expects %s arguments, got %s!\n" \
			"Assertion fail" "$@" >&2
		exit 127
	fi
}


##
# FUNCTION
#	assert_minargc_psst <func> <min> <actual>
#
# SUMMARY
#	Prints an error to stderr if `actual` is smaller than `min` and terminates
#	current process with error 127, which is the highest possible error as
#	values 128 and up are reserved for signals and lower values are used by
#   functions as failure indicators.

# PARAMETERS
#	func: Name of the function.
#	min: Minimum number of aguments expected.
#	actual: Number of actual aguments.
#
# SAMPLE
#	assert_minargc_psst "myfunc" 3 $#
#
assert_minargc_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	assert_argc_psst "assert_minargc_psst" 3 $#
	assert_hasarg_psst "assert_minargc_psst" "func" "$1"
	assert_hasarg_psst "assert_minargc_psst" "min" "$2"
	assert_hasarg_psst "assert_minargc_psst" "actual" "$3"

	if [ "$2" -gt "$3" ]
	then
		printf "%s: Function \"%s\" expects at least %s arguments, got %s!\n" \
			"Assertion fail" "$@" >&2
		exit 127
	fi
}


##
# FUNCTION
#	assert_maxargc_psst <func> <max> <actual>
#
# SUMMARY
#	Prints an error to stderr if `actual` is bigger than `max` and terminates
#	current process with error 127, which is the highest possible error as
#	values 128 and up are reserved for signals and lower values are used by
#   functions as failure indicators.

# PARAMETERS
#	func: Name of the function.
#	max: Maximum number of aguments expected.
#	actual: Number of actual aguments.
#
# SAMPLE
#	assert_maxargc_psst "myfunc" 3 $#
#
assert_maxargc_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	assert_argc_psst "assert_maxargc_psst" 3 $#
	assert_hasarg_psst "assert_maxargc_psst" "func" "$1"
	assert_hasarg_psst "assert_maxargc_psst" "max" "$2"
	assert_hasarg_psst "assert_maxargc_psst" "actual" "$3"

	if [ "$2" -lt "$3" ]
	then
		printf "%s: Function \"%s\" expects at most %s arguments, got %s!\n" \
			"Assertion fail" "$@" >&2
		exit 127
	fi
}


##
# FUNCTION
#	assert_hasarg_psst <func> <arg> [<value>]
#
# SUMMARY
#	Prints an error to stderr if `value` is empty and terminates current
#	process with error 127, which is the highest possible error as values 128
#	and up are reserved for signals and lower values are used by functions as
#	failure indicators. If `value` is not given, expands `arg` instead.
#
# PARAMETERS
#	func: Name of the function.
#	arg: Name of the argument.
#
# SAMPLE
#	assert_hasarg_psst "myfunc" "myarg"
#	assert_hasarg_psst "myfunc" "myarg" "$1"
#
assert_hasarg_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	if [ $# -lt 2 ]
	then
		printf "%s: Function \"%s\" expects at least %s arguments, got %s!\n" \
			"Assertion fail" assert_argc_psst 2 $# >&2
		exit 127
	fi

	if [ $# -gt 3 ]
	then
		printf "%s: Function \"%s\" expects at most %s arguments, got %s!\n" \
			"Assertion fail" assert_argc_psst 3 $# >&2
		exit 127
	fi

	if { [ $# = 3 ] && [ -z "$3" ] ; } \
		|| { [ $# = 2 ] && [ -z "$( eval "printf '%s' \"\${$2-}\"" )" ] ; }
	then
		printf "%s: %s of %s must not be empty!\n" \
			"Assertion fail" "Argument \"$2\"" "function \"$1\"" >&2
		exit 127
	fi
	return
}



##
# FUNCTION
#	assert_func_fail_psst <func> <msg>
#
# SUMMARY
#	Prints `msg` to stderr and terminates current process with error 127,
#	which is the highest possible error as values 128 and up are reserved
#	for signals and lower values are used by functions as failure indicators.
#
# PARAMETERS
#	msg: Message to print to stderr.
#
# SAMPLE
#	[ "$index" -gt 0 ] || assert_func_fail_psst "$func" "Index must be > 0"
#
assert_func_fail_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	#func=$1
	#msg=$2
	assert_fail_psst "Assertion in \"$1\" failed: $2"
}
