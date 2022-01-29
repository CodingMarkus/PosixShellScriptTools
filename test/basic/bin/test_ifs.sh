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

# set_ifs must accept exactly one argument
set +e
( ifs_set_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( ifs_set_psst 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# ifs_restore must accept exactly no argument
set +e
( ifs_restore_psst 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e



# Test push, pop
oldIFS="$IFS"

ifs_set_psst "a" || test_fail_psst $LINENO
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" = "$oldIFS" || test_fail_psst $LINENO


# Test push, push, pop, pop
oldIFS="$IFS"

ifs_set_psst "a" || test_fail_psst $LINENO
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_set_psst "b" || test_fail_psst $LINENO
test "$IFS" == "b" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" = "$oldIFS" || test_fail_psst $LINENO


# Test push, push, pop, push, pop, pop
oldIFS="$IFS"

ifs_set_psst "a" || test_fail_psst $LINENO
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_set_psst "b" || test_fail_psst $LINENO
test "$IFS" == "b" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_set_psst "c" || test_fail_psst $LINENO
test "$IFS" == "c" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" == "a" || test_fail_psst $LINENO

ifs_restore_psst
test "$IFS" = "$oldIFS" || test_fail_psst $LINENO