#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]; then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc
. "$INCLUDE_PSST/basic.inc"

# =============================================================================

# Must fail for non-existing file
! abspath_psst "cmdBase/../data/abspath/__not_existing__" \
	|| testfail_psst $LINENO

# Returned path must be absolute
relpath="$cmdBase/../data/abspath/abspath.txt"
abspath=$( abspath_psst "$relpath" )
case "$abspath" in
	/*) ;;
	*) testfail_psst $LINENO
esac

# Returned path must refer to the same file
test "$relpath" -ef "$abspath" || testfail_psst $LINENO
