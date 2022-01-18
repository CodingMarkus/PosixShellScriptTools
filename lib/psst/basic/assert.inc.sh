#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_assert.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _assert.inc.sh_"


##
# FUNCTION
# 	assertfail_psst <msg>
#
# SUMMARY
# 	Prints `msg` to stderr and terminates current process with error 127,
#	which is the highest possible error as values 128 and up are reserved
#	for signals and lower values are used by functions as failure indicators.
#
# PARAMETERS
# 	msg: Message to print to stderr
#
# SAMPLE
# 	test [ "$index" -gt 0 ] || assert_fail_psst "Index must be > 0"
#
assertfail_psst()
{
	printf "%s\n" "$1"
	exit 127
}
