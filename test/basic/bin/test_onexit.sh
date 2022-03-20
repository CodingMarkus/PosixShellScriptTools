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
# On Exit

# Must accept exactly one argument
set +e
( onexit_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( onexit_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( onexit_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not contain  $RS_CHAR_PSST
set +e
( onexit_psst "$ $RS_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Code gets execute on exit
[ "$( onexit_psst 'printf "test_success"' )" = "test_success" ] \
	|| test_fail_psst $LINENO


# Multiple evaluations are possible
multi=$(
	onexit_psst 'printf "test1"'
	onexit_psst 'printf "test2"'
)
[ "$multi" = "test2test1" ] || test_fail_psst $LINENO



# =============================================================================
# On Exit Remvoe

# Must accept exactly one argument
set +e
( onexit_remove_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( onexit_remove_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( onexit_remove_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Removed code is not executed
multi=$(
	onexit_psst 'printf "test1"'
	onexit_psst 'printf "test2"'
	onexit_remove_psst 'printf "test2"'
)
[ "$multi" = "test1" ] || test_fail_psst $LINENO

multi=$(
	onexit_psst 'printf "test1"'
	onexit_psst 'printf "test2"'
	onexit_remove_psst 'printf "test1"'
)
[ "$multi" = "test2" ] || test_fail_psst $LINENO
