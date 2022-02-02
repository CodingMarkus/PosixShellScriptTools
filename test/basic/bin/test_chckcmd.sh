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

# cd should be found
chkcmd_psst "cd" || test_fail_psst $LINENO

# Should also work with multiple commands
chkcmd_psst "cd" "ls" || test_fail_psst $LINENO

# Fictional command should not be found
if chkcmd_psst "__this_is_not_a_command"
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

# Multiple fictional command should not be found
! chkcmd_psst "__this_is_not_a_command" "__this_either__" \
	|| test_fail_psst $LINENO

# Mixing should still fail
! chkcmd_psst "__this_is_not_a_command" "ls" || test_fail_psst $LINENO
! chkcmd_psst "cd" "__this_either__" || test_fail_psst $LINENO
