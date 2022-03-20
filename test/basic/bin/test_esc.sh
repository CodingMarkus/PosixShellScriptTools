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
# esc_squotes

# Must accept exactly one argument
set +e
( esc_squotes_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( esc_squotes_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test the encoding
[ "$( esc_squotes_psst '' )" = ''  ] || test_fail_psst $LINENO
[ "$( esc_squotes_psst "abc" )" = "abc"  ] || test_fail_psst $LINENO
[ "$( esc_squotes_psst "ab'cd" )" = "ab'\\''cd"  ] || test_fail_psst $LINENO
[ "$( esc_squotes_psst "'a'b" )" = "'\\''a'\\''b"  ] || test_fail_psst $LINENO



# =============================================================================
# esc_cstring_psst

# Must accept exactly one argument
set +e
( esc_cstring_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( esc_cstring_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test the encoding
[ "$( esc_cstring_psst '' )" = ''  ] || test_fail_psst $LINENO
[ "$( esc_cstring_psst 'abc' )" = 'abc'  ] || test_fail_psst $LINENO
[ "$( esc_cstring_psst 'a"b' )" = 'a\"b'  ] || test_fail_psst $LINENO
[ "$( esc_cstring_psst 'a\b' )" = 'a\\b'  ] || test_fail_psst $LINENO

[ "$( esc_cstring_psst "a${NL_CHAR_PSST}b" )" = 'a\nb'  ] \
	|| test_fail_psst $LINENO



# =============================================================================
# esc_printf_psst

# Must accept exactly one argument
set +e
( esc_printf_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( esc_printf_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test the encoding
[ "$( esc_printf_psst '' )" = ''  ] || test_fail_psst $LINENO
[ "$( esc_printf_psst 'abc' )" = 'abc'  ] || test_fail_psst $LINENO
[ "$( esc_printf_psst 'a"b' )" = 'a\"b'  ] || test_fail_psst $LINENO
[ "$( esc_printf_psst 'a\b' )" = 'a\\b'  ] || test_fail_psst $LINENO
[ "$( esc_printf_psst 'a%b' )" = 'a%%b'  ] || test_fail_psst $LINENO

[ "$( esc_printf_psst "a${NL_CHAR_PSST}b" )" = 'a\nb'  ] \
	|| test_fail_psst $LINENO