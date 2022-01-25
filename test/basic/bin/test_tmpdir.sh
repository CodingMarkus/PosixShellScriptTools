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

# Must accept exactly one argument
set +e
( tempdir_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( tempdir_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( tempdir_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

tmpDir=$(
	tmpDir="/tmp"
	tempdir_psst "tmpDir"

	# Must not be empty
	[ -n "$tmpDir" ] || test_fail_psst $LINENO

	# Must have been altered
	[ "$tmpDir" != "/tmp" ] || test_fail_psst $LINENO

	# Must be an existing directory
	[ -d "$tmpDir" ] || test_fail_psst $LINENO

	printf "%s\n" "$tmpDir"
)

# Must still not be empty
[ -n "$tmpDir" ] || test_fail_psst $LINENO

# Directory must not exist any longer
[ ! -d "$tmpDir" ]  || test_fail_psst $LINENO