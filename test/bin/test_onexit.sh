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
( onexit_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( onexit_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( onexit_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Code gets execute on exit
[ "$( onexit_psst "echo test_success" )" = "test_success" ] \
	|| test_fail_psst $LINENO


# Multiple evaluations are possible
multi=$(
	onexit_psst "printf \"test1\""
	onexit_psst "printf \"test2\""
)
{ [ "$multi" = "test1test2" ] || [ "$multi" = "test2test1" ]; } \
	|| test_fail_psst $LINENO
