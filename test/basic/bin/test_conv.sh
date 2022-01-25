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
# Test chr

# Must except exactly one argument
set +e
( chr_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( chr_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( onexit_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Argument must be integer number
chr_psst "abc" >/dev/null || {
	[ $? = 1 ] || test_fail_psst $LINENO
}

# Argument must be in valid range
chr_psst "350"  >/dev/null || {
	[ $? = 2 ] || test_fail_psst $LINENO
}

# Test some conversions
[ "$( chr_psst 65 )" = "A" ] || test_fail_psst $LINENO
[ "$( chr_psst 97 )" = "a" ] || test_fail_psst $LINENO
[ "$( chr_psst 32 )" = " " ] || test_fail_psst $LINENO

[ "$( chr_psst 10 )" = "" ] || test_fail_psst $LINENO
chr_psst "10"  >/dev/null || {
	[ $? = 3 ] || test_fail_psst $LINENO
}


# =============================================================================
# Test ord

# Must except exactly one argument
set +e
( ord_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( ord_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
ord_psst "" || {
	[ $? = 1 ] || test_fail_psst $LINENO
}

# Argument must be single character
ord_psst "12" || {
	[ $? = 2 ] || test_fail_psst $LINENO
}


# Test some conversions
[ "$( ord_psst A )" = 65 ] || test_fail_psst $LINENO
[ "$( ord_psst a )" = 97 ] || test_fail_psst $LINENO
[ "$( ord_psst " " )" = 32 ] || test_fail_psst $LINENO
[ "$( ord_psst "$NL_CHAR_PSST" )" = 10 ] || test_fail_psst $LINENO
