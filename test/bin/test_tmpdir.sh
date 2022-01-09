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

tmpDir=$(
	tmpDir="/tmp"
	tempdir_psst "tmpDir"

	# Must not be empty
	[ -n "$tmpDir" ] || exit 100

	# Must have been altered
	[ "$tmpDir" != "/tmp" ] || exit 101

	# Must be an existing directory
	[ -d "$tmpDir" ] || exit 102

	printf "%s\n" "$tmpDir"
)

# Must still not be empty
[ -n "$tmpDir" ] || exit 103

# Directory must not exist any longer
[ ! -d "$tmpDir" ]  || exit 104