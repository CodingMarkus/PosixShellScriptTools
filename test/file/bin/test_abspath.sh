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

# shellcheck source=../../../lib/psst/file.inc.sh
. "$INCLUDE_PSST/file.inc.sh"

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
! abspath_psst "../data/abspath/__not_existing__" \
	|| test_fail_psst $LINENO

# Returned path must be absolute
relpath="../data/abspath/abspath.txt"
abspath=$( abspath_psst "$relpath" )
case "$abspath" in
	/*) ;;
	*) test_fail_psst $LINENO
esac

# Returned path must refer to the same file
test "$relpath" -ef "$abspath" || test_fail_psst $LINENO
