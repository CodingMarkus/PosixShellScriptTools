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

# cd should be found
chkcmd_psst "cd" || exit 100

# Should also work with multiple commands
chkcmd_psst "cd" "ls" || exit 101

# Fictional command should not be found
! chkcmd_psst "__this_is_not_a_command" || exit 102

# Multiple fictional command should not be found
! chkcmd_psst "__this_is_not_a_command" "__this_either__" || exit 103

# Mixing should still fail
! chkcmd_psst "__this_is_not_a_command" "ls" || exit 104
! chkcmd_psst "cd" "__this_either__" || exit 105
