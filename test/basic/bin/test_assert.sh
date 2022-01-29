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

# Assert fail must always fail
set +e
( assert_fail_psst "test" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# assert_argc must only fail if argument number is wrong
set +e
( assert_argc_psst "test" 3 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( assert_argc_psst "test" 2 3 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( assert_argc_psst "test" 3 3 2>/dev/null ) || test_fail_psst $LINENO
set -e

# assert_minargc must only fail if argument number is too low
set +e
( assert_minargc_psst "test" 3 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( assert_minargc_psst "test" 2 3 2>/dev/null ) || test_fail_psst $LINENO

( assert_minargc_psst "test" 3 3 2>/dev/null ) || test_fail_psst $LINENO
set -e

# assert_maxargc must only fail if argument number is too high
set +e
( assert_maxargc_psst "test" 3 2 2>/dev/null ) || test_fail_psst $LINENO

( assert_maxargc_psst "test" 2 3 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( assert_maxargc_psst "test" 3 3 2>/dev/null ) || test_fail_psst $LINENO
set -e

#  assert_hasarg must fail only if arg is empty
set +e
( assert_hasarg_psst "test" "arg" "x" 2>/dev/null ) || test_fail_psst $LINENO

( assert_hasarg_psst "test" "arg" "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( arg="x" ; assert_hasarg_psst "test" "arg" 2>/dev/null ) \
	|| test_fail_psst $LINENO

# shellcheck disable=SC2034 # arg is used indirectly by name
( arg="" ; assert_hasarg_psst "test" "arg" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e
