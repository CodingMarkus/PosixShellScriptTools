#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]
then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================

# Must accept exactly one argument
set +e
( abspath_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( abspath_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( abspath_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Must fail for non-existing file
! abspath_psst "cmdBase/../data/abspath/__not_existing__" \
	|| test_fail_psst $LINENO

# Returned path must be absolute
relpath="$cmdBase/../data/abspath/abspath.txt"
abspath=$( abspath_psst "$relpath" )
case "$abspath" in
	/*) ;;
	*) test_fail_psst $LINENO
esac

# Returned path must refer to the same file
test "$relpath" -ef "$abspath" || test_fail_psst $LINENO
