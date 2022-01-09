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

set_ifs_psst "a"
test "$IFS" == "a" || exit 100

restore_ifs_psst
test "$IFS" = "$oldIFS" || exit 101


# Test push, push, pop, pop
oldIFS="$IFS"

set_ifs_psst "a"
test "$IFS" == "a" || exit 102

set_ifs_psst "b"
test "$IFS" == "b" || exit 103

restore_ifs_psst
test "$IFS" == "a" || exit 104

restore_ifs_psst
test "$IFS" = "$oldIFS" || exit 105


# Test push, push, pop, push, pop, pop
oldIFS="$IFS"

set_ifs_psst "a"
test "$IFS" == "a" || exit 106

set_ifs_psst "b"
test "$IFS" == "b" || exit 107

restore_ifs_psst
test "$IFS" == "a" || exit 108

set_ifs_psst "c"
test "$IFS" == "c" || exit 109

restore_ifs_psst
test "$IFS" == "a" || exit 110

restore_ifs_psst
test "$IFS" = "$oldIFS" || exit 111