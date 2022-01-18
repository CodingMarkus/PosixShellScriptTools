#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_test.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _test.inc.sh_"


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# FUNCTION
# 	test_fail_psst <lineno> [<filename>]
#
# SUMMARY
#	Prints line number (and file name if available) of failed test to
#	stderr by calling `assert_fail_psst`.`
#
# PARAMETERS
# 	lineno: Line number of failed test.
# 	[filename]: Name of file of failed test.
#
# SAMPLE
# 	func_that_must_not_fail || test_fail_psst $LINENO
#	func_that_must_not_fail2 || test_fail_psst $LINENO "file name"
#
test_fail_psst()
{
	# We cannot use a sub shell for this function as we need to exit the main
	# shell in case an assertion is thrown. Thus we need to be careful to not
	# conflict when defining local variables.

	assert_fail_psst "Test ${2:+"in $2 "}at line $1 failed"
}
