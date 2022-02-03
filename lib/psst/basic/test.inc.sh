#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_test_*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}_test_"


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# FUNCTION
#	test_fail_psst <lineno> [<filename>]
#
# SUMMARY
#	Prints line number (and file name if available) of failed test to
#	stderr by calling `assert_fail_psst`.`
#
# PARAMETERS
#	lineno: Line number of failed test.
#	[filename]: Name of file of failed test.
#
# SAMPLE
#	func_that_must_not_fail || test_fail_psst $LINENO
#	func_that_must_not_fail2 || test_fail_psst $LINENO "file name"
#
test_fail_psst()
{
	# We cannot use a subshell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	assert_fail_psst "Test ${2:+"in $2 "}at line $1 failed"
}


##
# FUNCTION
#	test_is_int_psst <value>
#
# SUMMARY
#	Tests if a value is an integer number.
#
# PARAMETERS
#	value: The value to test for being an integer.
#
# RETURNS
#	0: Yes, it is an integer.
#	2: No, it isn't.
#
# SAMPLE
#	test_is_int_psst "abc" || echo "Not an int"
#	test_is_int_psst "123" && echo "It is an int"
#
test_is_int_psst()
{
	# value=$1

	# We could use a subshell here but that would only make this test rather
	# slow for no reason, so we go for speed.
	case $1 in
 	  	'' | *[!0-9]*) return 2
	esac
}
