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
# list_append

# Must accept at least two arguments
set +e
( list_append_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_append_psst 1  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_append_psst 123 123 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_append_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" "$NL_CHAR_PSST" \
	2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_append_psst test '' x 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test appending single items
list=
list=$( list_append_psst "$list" "a" "|" )
list=$( list_append_psst "$list" "b" "|" )
list=$( list_append_psst "$list" "c" "|" )
list=$( list_append_psst "$list" "d" "|" )
[ "$list" = "a|b|c|d|" ] || test_fail_psst $LINENO

# Test appending multiple items
list=
list=$( list_append_psst "$list" "a|b" "|" )
list=$( list_append_psst "$list" "c|d" "|" )
[ "$list" = "a|b|c|d|" ] || test_fail_psst $LINENO

# Test appending empty items
list=
list=$( list_append_psst "$list" '' "|" )
list=$( list_append_psst "$list" '' "|" )
[ "$list" = "||" ] || test_fail_psst $LINENO



# =============================================================================
# list_prepend

# Must accept at least two arguments
set +e
( list_prepend_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_prepend_psst 1  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_prepend_psst 123 123 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_prepend_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" "$NL_CHAR_PSST" \
	2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_append_psst test '' x 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test appending single items
list=
list=$( list_prepend_psst "$list" "a" "|" )
list=$( list_prepend_psst "$list" "b" "|" )
list=$( list_prepend_psst "$list" "c" "|" )
list=$( list_prepend_psst "$list" "d" "|" )
[ "$list" = "d|c|b|a|" ] || test_fail_psst $LINENO

# Test appending multiple items
list=
list=$( list_prepend_psst "$list" "a|b" "|" )
list=$( list_prepend_psst "$list" "c|d" "|" )
[ "$list" = "c|d|a|b|" ] || test_fail_psst $LINENO


# Test appending empty items
list=
list=$( list_prepend_psst "$list" '' "|" )
list=$( list_prepend_psst "$list" '' "|" )
[ "$list" = "||" ] || test_fail_psst $LINENO



# =============================================================================
# list_append_list

# Must accept at least two arguments
set +e
( list_append_list_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_append_list_psst 1  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_append_list_psst 123 123 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_append_list_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" "$NL_CHAR_PSST" \
	2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_append_list_psst test '' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_append_list_psst '' test 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test appending list to list
list1="a|b|"
list2="c|d|"
list=$( list_append_list_psst "$list1" "$list2" "|" )
[ "$list" = "a|b|c|d|" ] || test_fail_psst $LINENO

# Test appending empty list to empty list
list1=
list2=
list=$( list_append_list_psst "$list1" "$list2" "|" )
[ "$list" = '' ] || test_fail_psst $LINENO

# Test appending empty list to list
list1="a|b|"
list2=
list=$( list_append_list_psst "$list1" "$list2" "|" )
[ "$list" = "a|b|" ] || test_fail_psst $LINENO

# Test appending list to empty list
list1=
list2="a|b|"
list=$( list_append_list_psst "$list1" "$list2" "|" )
[ "$list" = "a|b|" ] || test_fail_psst $LINENO



# =============================================================================
# list_prepend_list_psst

# Must accept at least two arguments
set +e
( list_prepend_list_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_prepend_list_psst 1  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_prepend_list_psst 123 123 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_prepend_list_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" "$NL_CHAR_PSST" \
	2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_prepend_list_psst test '' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_prepend_list_psst '' test 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test prepending list to list
list1="a|b|"
list2="c|d|"
list=$( list_prepend_list_psst "$list1" "$list2" "|" )
[ "$list" = "c|d|a|b|" ] || test_fail_psst $LINENO

# Test prepending empty list to empty list
list1=
list2=
list=$( list_prepend_list_psst "$list1" "$list2" "|" )
[ "$list" = '' ] || test_fail_psst $LINENO

# Test prepending empty list to list
list1="a|b|"
list2=
list=$( list_prepend_list_psst "$list1" "$list2" "|" )
[ "$list" = "a|b|" ] || test_fail_psst $LINENO

# Test prepending list to empty list
list1=
list2="a|b|"
list=$( list_prepend_list_psst "$list1" "$list2" "|" )
[ "$list" = "a|b|" ] || test_fail_psst $LINENO