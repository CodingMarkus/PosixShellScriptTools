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
# test_is_int_psst

# set_ifs must accept exactly one argument
set +e
( test_is_int_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( test_is_int_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Test some values
test_is_int_psst '' && test_fail_psst $LINENO
test_is_int_psst 'abc' && test_fail_psst $LINENO
test_is_int_psst '-' && test_fail_psst $LINENO
test_is_int_psst '1234-567890' && test_fail_psst $LINENO
test_is_int_psst '1234567890' || test_fail_psst $LINENO
test_is_int_psst '-1234567890' || test_fail_psst $LINENO


# =============================================================================
# test_is_uint_psst

# set_ifs must accept exactly one argument
set +e
( test_is_uint_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( test_is_uint_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Test some values
test_is_uint_psst '' && test_fail_psst $LINENO
test_is_uint_psst 'abc' && test_fail_psst $LINENO
test_is_uint_psst '-1234567890' && test_fail_psst $LINENO
test_is_uint_psst '1234567890' || test_fail_psst $LINENO
