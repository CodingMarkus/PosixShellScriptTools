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

# Test push, pop
oldIFS="$IFS"

set_ifs_psst "a" || testfail_psst $LINENO
test "$IFS" == "a" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" = "$oldIFS" || testfail_psst $LINENO


# Test push, push, pop, pop
oldIFS="$IFS"

set_ifs_psst "a" || testfail_psst $LINENO
test "$IFS" == "a" || testfail_psst $LINENO

set_ifs_psst "b" || testfail_psst $LINENO
test "$IFS" == "b" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" == "a" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" = "$oldIFS" || testfail_psst $LINENO


# Test push, push, pop, push, pop, pop
oldIFS="$IFS"

set_ifs_psst "a" || testfail_psst $LINENO
test "$IFS" == "a" || testfail_psst $LINENO

set_ifs_psst "b" || testfail_psst $LINENO
test "$IFS" == "b" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" == "a" || testfail_psst $LINENO

set_ifs_psst "c" || testfail_psst $LINENO
test "$IFS" == "c" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" == "a" || testfail_psst $LINENO

restore_ifs_psst
test "$IFS" = "$oldIFS" || testfail_psst $LINENO