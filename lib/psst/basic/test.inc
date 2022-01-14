#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_test.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _test.inc_"


# shellcheck source=assert.inc
. "$INCLUDE_PSST/basic/assert.inc"


##
# FUNCTION
# 	testfail_psst <lineno>
#
# SUMMARY
#	Prints line number of failed test to stderr by calling `assertfail_psst`.`
#
# PARAMETERS
# 	lineno: Line number of failed test
#
# SAMPLE
# 	func_that_must_not_fail || testfail_psst $LINENO
#
testfail_psst()
{
	assertfail_psst "Test at line $1 failed!"
}
