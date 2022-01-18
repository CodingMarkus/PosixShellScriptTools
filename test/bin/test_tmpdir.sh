#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]; then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================

tmpDir=$(
	tmpDir="/tmp"
	tempdir_psst "tmpDir"

	# Must not be empty
	[ -n "$tmpDir" ] || testfail_psst $LINENO

	# Must have been altered
	[ "$tmpDir" != "/tmp" ] || testfail_psst $LINENO

	# Must be an existing directory
	[ -d "$tmpDir" ] || testfail_psst $LINENO

	printf "%s\n" "$tmpDir"
)

# Must still not be empty
[ -n "$tmpDir" ] || testfail_psst $LINENO

# Directory must not exist any longer
[ ! -d "$tmpDir" ]  || testfail_psst $LINENO