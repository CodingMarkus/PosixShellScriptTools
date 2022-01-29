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
# Test chr

# Must except exactly one argument
set +e
( conv_chr_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( conv_chr_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( onexit_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Argument must be integer number
conv_chr_psst "abc" >/dev/null || {
	[ $? = 1 ] || test_fail_psst $LINENO
}

# Argument must be in valid range
conv_chr_psst "350"  >/dev/null || {
	[ $? = 2 ] || test_fail_psst $LINENO
}


# Test some conversions
[ "$( conv_chr_psst 65 )" = "A" ] || test_fail_psst $LINENO
[ "$( conv_chr_psst 97 )" = "a" ] || test_fail_psst $LINENO
[ "$( conv_chr_psst 32 )" = " " ] || test_fail_psst $LINENO

[ "$( conv_chr_psst 10 )" = "" ] || test_fail_psst $LINENO
if conv_chr_psst "10"  >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 3 ] || test_fail_psst $LINENO
fi


# =============================================================================
# Test ord

# Must except exactly one argument
set +e
( conv_ord_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( conv_ord_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
if conv_ord_psst ""
then
	test_fail_psst $LINENO
else
	[ $? = 1 ] || test_fail_psst $LINENO
fi

# Argument must be single character

if conv_ord_psst "12"
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

# Test some conversions
[ "$( conv_ord_psst A )" = 65 ] || test_fail_psst $LINENO
[ "$( conv_ord_psst a )" = 97 ] || test_fail_psst $LINENO
[ "$( conv_ord_psst " " )" = 32 ] || test_fail_psst $LINENO
[ "$( conv_ord_psst "$NL_CHAR_PSST" )" = 10 ] || test_fail_psst $LINENO
