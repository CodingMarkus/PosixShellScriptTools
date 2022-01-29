#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

if [ -z "$INCLUDE_PSST" ]
then
	cmdBase=$( dirname "$0" )
	INCLUDE_PSST="$cmdBase/../../../lib/psst"
fi

# shellcheck source=../../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================
# esc_for_sq

# Must accept exactly one argument
set +e
( esc_for_sq_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( esc_for_sq_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test the encoding
[ "$( esc_for_sq_psst "" )" = ""  ] || test_fail_psst $LINENO
[ "$( esc_for_sq_psst "abc" )" = "abc"  ] || test_fail_psst $LINENO
[ "$( esc_for_sq_psst "ab'cd" )" = "ab'\\''cd"  ] || test_fail_psst $LINENO
[ "$( esc_for_sq_psst "'a'b" )" = "'\\''a'\\''b"  ] || test_fail_psst $LINENO