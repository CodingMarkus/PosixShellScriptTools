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

# cd should be found
chkcmd_psst "cd" || test_fail_psst $LINENO

# Should also work with multiple commands
chkcmd_psst "cd" "ls" || test_fail_psst $LINENO

# Fictional command should not be found
! chkcmd_psst "__this_is_not_a_command" || test_fail_psst $LINENO

# Multiple fictional command should not be found
! chkcmd_psst "__this_is_not_a_command" "__this_either__" \
	|| test_fail_psst $LINENO

# Mixing should still fail
! chkcmd_psst "__this_is_not_a_command" "ls" || test_fail_psst $LINENO
! chkcmd_psst "cd" "__this_either__" || test_fail_psst $LINENO
