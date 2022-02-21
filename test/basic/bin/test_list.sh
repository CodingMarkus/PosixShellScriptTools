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
# list_convert_psst

# Must accept exactly 3 arguments
set +e
( list_convert_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_convert_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_convert_psst '' 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_convert_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Old delimiter must be single character and not newline
set +e
( list_convert_psst '123' 123 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_convert_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# New delimiter must be single character and not newline
set +e
( list_convert_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_convert_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_convert_psst 'test' 0 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test conversion
[ "$( list_convert_psst 'a|b|c|' '|' ',' )" = 'a,b,c,' ] \
	|| test_fail_psst $LINENO

[ "$( list_convert_psst 'a|' '|' ',' )" = 'a,' ] || test_fail_psst $LINENO
[ "$( list_convert_psst '' '|' ',' )" = '' ] || test_fail_psst $LINENO



# =============================================================================
# list_count_psst

# Must accept at least one arguments, at most two
set +e
( list_count_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_count_psst '' 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_count_psst '123' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_count_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_prepend_list_psst 'test' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test some counts
[ "$( list_count_psst '' '|' )" -eq 0 ] || test_fail_psst $LINENO
[ "$( list_count_psst 'a|' '|' )" -eq 1 ] || test_fail_psst $LINENO
[ "$( list_count_psst 'a|b|' '|' )" -eq 2 ] || test_fail_psst $LINENO
[ "$( list_count_psst 'a|b|c|' '|' )" -eq 3 ] || test_fail_psst $LINENO



# =============================================================================
# list_first_psst

# Must accept at least one argument, at most two
set +e
( list_first_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_first_psst '' 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_first_psst '123' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_first_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_first_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test getting value
[ "$( list_first_psst '' '|' )" = '' ] || test_fail_psst $LINENO
[ "$( list_first_psst 'a|' '|' )" = 'a' ] || test_fail_psst $LINENO
[ "$( list_first_psst 'a|b|c|' '|' )" = 'a' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_first_psst 'a|b|c|' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_first_psst '' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_last_psst

# Must accept at least one argument, at most two
set +e
( list_last_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_last_psst '' 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_last_psst '123' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_last_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_last_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Test getting value
[ "$( list_last_psst '' '|' )" = '' ] || test_fail_psst $LINENO
[ "$( list_last_psst 'a|' '|' )" = 'a' ] || test_fail_psst $LINENO
[ "$( list_last_psst 'a|b|c|' '|' )" = 'c' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_last_psst 'a|b|c|' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_last_psst '' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_get_psst

# Must accept at least two arguments, at most three
set +e
( list_get_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_get_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_get_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Index must be an integer and positive
set +e
( list_get_psst '|' 'abc' '|' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_get_psst '|' '-1' '|' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_get_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_get_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_get_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test retrieving some values
list='a|b|c|d|e|f|'
[ "$( list_get_psst "$list" 0 '|' )" = 'a' ] || test_fail_psst $LINENO
[ "$( list_get_psst "$list" 1 '|' )" = 'b' ] || test_fail_psst $LINENO
[ "$( list_get_psst "$list" 2 '|' )" = 'c' ] || test_fail_psst $LINENO
[ "$( list_get_psst "$list" 5 '|' )" = 'f' ] || test_fail_psst $LINENO
[ "$( list_get_psst "$list" 6 '|' )" = '' ] || test_fail_psst $LINENO
[ "$( list_get_psst "$list" 7 '|' )" = '' ] || test_fail_psst $LINENO
[ "$( list_get_psst "a|" 0 '|' )" = 'a' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_get_psst "$list" 0 '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if ! list_get_psst "$list" 5 '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_get_psst "$list" 6 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_get_psst "$list" 7 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_get_psst '' 0 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_remove_first_psst

# Must accept at least one argument, at most two
set +e
( list_remove_first_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_first_psst '1' 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_remove_first_psst '123' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_first_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_remove_first_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test removing items until list is empty
list='a|b|c|'
list="$( list_remove_first_psst "$list" '|' )"
[ "$list" = 'b|c|' ] || test_fail_psst $LINENO
list="$( list_remove_first_psst "$list" '|' )"
[ "$list" = 'c|' ] || test_fail_psst $LINENO
list="$( list_remove_first_psst "$list" '|' )"
[ "$list" = '' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_remove_first_psst 'a|b|c|' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_remove_first_psst '' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_remove_last_psst

# Must accept at least one argument, at most two
set +e
( list_remove_last_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_last_psst '1' 1 2  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_remove_last_psst '123' 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_last_psst "$NL_CHAR_PSST" "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_remove_last_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test removing items until list is empty
list='a|b|c|'
list="$( list_remove_last_psst "$list" '|' )"
[ "$list" = 'a|b|' ] || test_fail_psst $LINENO
list="$( list_remove_last_psst "$list" '|' )"
[ "$list" = 'a|' ] || test_fail_psst $LINENO
list="$( list_remove_last_psst "$list" '|' )"
[ "$list" = '' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_remove_last_psst 'a|b|c|' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_remove_last_psst '' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_remove_psst

# Must accept at least two arguments, at most three
set +e
( list_remove_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Index must be an integer and positive
set +e
( list_remove_psst '|' 'abc' '|' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_psst '|' '-1' '|' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_remove_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_remove_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test removing some values
list='a|b|c|d|'
[ "$( list_remove_psst "$list" 0 '|' )" = 'b|c|d|' ] || test_fail_psst $LINENO
[ "$( list_remove_psst "$list" 1 '|' )" = 'a|c|d|' ] || test_fail_psst $LINENO
[ "$( list_remove_psst "$list" 2 '|' )" = 'a|b|d|' ] || test_fail_psst $LINENO
[ "$( list_remove_psst "$list" 3 '|' )" = 'a|b|c|' ] || test_fail_psst $LINENO
[ "$( list_remove_psst "$list" 4 '|' )" = "$list" ] || test_fail_psst $LINENO
[ "$( list_remove_psst "$list" 5 '|' )" = "$list" ] || test_fail_psst $LINENO
[ "$( list_remove_psst "a|" 0 '|' )" = '' ] || test_fail_psst $LINENO


# Test correct return values
if ! list_remove_psst "$list" 0 '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if ! list_remove_psst "$list" 3 '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_remove_psst "$list" 4 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_remove_psst "$list" 5 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_remove_psst '' 0 '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_remove_value_psst

# Must accept at least two arguments, at most three
set +e
( list_remove_value_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_value_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_value_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_remove_value_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_value_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_remove_value_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test removing some values
list='a|b|c|'
[ "$( list_remove_value_psst "$list" 'a' '|' )" = 'b|c|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_value_psst "$list" 'b' '|' )" = 'a|c|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_value_psst "$list" 'c' '|' )" = 'a|b|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_value_psst "$list" 'd' '|' )" = "$list" ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_value_psst "a|" 'a' '|' )" = '' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_value_psst "a|b|a|" 'a' '|' )" = 'b|a|' ] \
	|| test_fail_psst $LINENO


# Test correct return values
if ! list_remove_value_psst "$list" 'a' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if ! list_remove_value_psst "$list" 'c' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_remove_value_psst "$list" 'd' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_remove_value_psst '' 'd' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_remove_all_values_psst

# Must accept at least two arguments, at most three
set +e
( list_remove_all_values_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_all_values_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_all_values_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_remove_all_values_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_remove_all_values_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_remove_all_values_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test removing some values
list='a|b|c|'

[ "$( list_remove_all_values_psst "$list" 'a' '|' )" = 'b|c|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_all_values_psst "$list" 'b' '|' )" = 'a|c|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_all_values_psst "$list" 'c' '|' )" = 'a|b|' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_all_values_psst "$list" 'd' '|' )" = "$list" ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_all_values_psst "a|" 'a' '|' )" = '' ] \
	|| test_fail_psst $LINENO

[ "$( list_remove_all_values_psst "a|b|a|" 'a' '|' )" = 'b|' ] \
	|| test_fail_psst $LINENO


# Test correct return values
if ! list_remove_all_values_psst "$list" 'a' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if ! list_remove_all_values_psst "$list" 'c' '|' >/dev/null
then
	test_fail_psst $LINENO
fi

if list_remove_all_values_psst "$list" 'd' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi

if list_remove_all_values_psst '' 'd' '|' >/dev/null
then
	test_fail_psst $LINENO
else
	[ $? = 2 ] || test_fail_psst $LINENO
fi



# =============================================================================
# list_select_psst

# Must accept at least two arguments, at most three
set +e
( list_select_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_select_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_select_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_select_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_select_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_select_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test some filtering
list='abc|bcd|cde|def|'

[ "$( list_select_psst "$list" '/c/' '|' )" = 'abc|bcd|cde|' ] \
	|| test_fail_psst $LINENO

[ "$( list_select_psst "$list" '/^(b|c)/' '|' )" = 'bcd|cde|' ] \
	|| test_fail_psst $LINENO

[ "$( list_select_psst '' '/a/' '|' )" = '' ] || test_fail_psst $LINENO



# =============================================================================
# list_filter_psst

# Must accept at least two arguments, at most three
set +e
( list_filter_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_filter_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_filter_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_filter_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_filter_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_filter_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test some filtering
list='abc|bcd|cde|def|'

[ "$( list_filter_psst "$list" '/c/' '|' )" = 'def|' ] \
	|| test_fail_psst $LINENO

[ "$( list_filter_psst "$list" '/^(b|c)/' '|' )" = 'abc|def|' ] \
	|| test_fail_psst $LINENO

[ "$( list_filter_psst '' '/a/' '|' )" = '' ] || test_fail_psst $LINENO



# =============================================================================
# list_find_psst

# Must accept at least two arguments, at most three
set +e
( list_find_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_find_psst '' 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_find_psst '' 1 2 3  2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Delimiter must be single character and not newline
set +e
( list_find_psst '123' 0 123 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( list_find_psst "$NL_CHAR_PSST" 0 "$NL_CHAR_PSST" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# List must be a valid list
set +e
( list_find_psst 'test' 0 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Test some searching
list='abc|bcd|cde|def|'

[ "$( list_find_psst "$list" '/c/' '|' )" = 'abc' ] \
	|| test_fail_psst $LINENO

[ "$( list_find_psst "$list" '/f$/' '|' )" = 'def' ] \
	|| test_fail_psst $LINENO

[ "$( list_find_psst '' '/a/' '|' )" = '' ] || test_fail_psst $LINENO