#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:list:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:list:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=const.inc.sh
. "$INCLUDE_PSST/basic/const.inc.sh"

# shellcheck source=test.inc.sh
. "$INCLUDE_PSST/basic/test.inc.sh"


##
# SUBMODULE
#	List
#
# SUMMARY
#	Lists are strings of values and delimiters. E.g. a list with the values
#	`a`` to `f`` and the delimiter `|` would look as follows:
#
#		a|b|c|d|e|f|
#
#	It's important to note that a list is always terminated by a delimiter.
#	There are two reasons for that:
#u
#		* That way it is possible to distinguish an empty list "" from a list
#		  containing a single empty value "|".
#
#		* When piping lists through shell commands, trailing line breaks would
#		  otherwise be lost on capture if they aren't followed by one more
#		  non-line break character.
#
#	As of the second reason, it's obvious that a line break must not be used
#	as a delimiter for lists, just like NUL cannot be used for that purpose as
#	NUL terminates strings in the shell; any other character can be used.
#	Unless explicitely specified, list functions assume that the delimiter
#	is `$RS_CHAR_PSST``.
#
#	There are no functions to append or prepend values to lists, as that can
#	easily be done as follows:
#
#		newList1="$newValue$sep$oldList"
#		newList2="$oldList$newValue$sep"
#
#	With $sep representing the separator character.
#
#	These is also no function to iterate over a list as this can simply be done
#	using the following piece of code:
#
#		ifs_set_psst "$sep"
#		for listValue in $list
#		do
#			# Do something with $listValue
#		done
#		ifs_restore_psst
#
# NOTE
#	Most list functions have an O(n) complexity, so lists are not the best way
#	to store data in all cases and while they can be used as a replacement for
#	missing arrays in standard POSIX shells, they are a rather poor replacement
#	performance-wise.



##
# SUBPROCESS
#	list_convert_psst <list> <oldDel> <newDel>
#
# SUMMARY
#	Replaces the current delimeter of a list with a different one and returns
#	the modified list.
#
# PARAMETERS
#	list: The list to repalce
#	oldDel: The old delimiter.
#	newDel: The new delimiter.
#
# OUTPUT
#	stdout: The modified list after replacing the delimiter
#
# SAMPLE
#	newList=$( list_convert_psst "$list" ":" ","
#
list_convert_psst()
(
	func='list_convert_psst'
	assert_argc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'oldDel' "$2"
	assert_hasarg_psst "$func" 'newDel' "$3"

	list=$1
	oldDel=$2
	newDel=$3

	[ ${#list} -eq 0 ] && return 0

	[ ${#oldDel} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'Old list delimiter must be single character'

	! [ "$oldDel" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'Old list delimiter must not be newline'

	[ ${#newDel} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'New list delimiter must be single character'

	! [ "$newDel" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'New list delimiter must not be newline'


	case $list in
		*"$oldDel") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$oldDel'"; FS = "" }
		{ printf "%s%s", $0, "'"$newDel"'" }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_count_psst <list> [<del>]
#
# SUMMARY
#	Returns the number of values of a list.
#
# PARAMETERS
#	list: The list to count items of.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The number of items.
#
# SAMPLE
#	count=$( list_count_psst "$list" )
#
list_count_psst()
(
	func='list_count_psst'
	assert_minargc_psst "$func" 1 $#
	assert_maxargc_psst "$func" 2 $#

	list=$1
	del=${2-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && { printf "0" ; return 0 ; }

	if [ $# -eq 2 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		END { printf NR }
	'
	printf '%s' "$list" | awk "$awkProg"
)


##
# SUBPROCESS
#	list_first_psst <list> [<del>]
#
# SUMMARY
#	Returns the first value of a list.
#
# PARAMETERS
#	list: The list to get the first item from.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: List is empty.
#
# OUTPUT
#	stdout: The first value.
#
# SAMPLE
#	first=$( list_first_psst "$list")
#
list_first_psst()
(
	func='list_first_psst'
	assert_minargc_psst "$func" 1 $#
	assert_maxargc_psst "$func" 2 $#

	list=$1
	del=${2-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 2 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	awkProg='
		BEGIN { RS="'$del'"; FS="" }
		{ printf; exit }
	'

	printf '%s' "$list" | awk "$awkProg"
)


##
# SUBPROCESS
#	list_last_psst <list> [<del>]
#
# SUMMARY
#	Returns the last value of a list.
#
# PARAMETERS
#	list: The list to get the last value from.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: List is empty.
#
# OUTPUT
#	stdout: The last value.
#
# SAMPLE
#	last=$( list_last_psst "$list")
#
list_last_psst()
(
	func='list_last_psst'
	assert_minargc_psst "$func" 1 $#
	assert_maxargc_psst "$func" 2 $#

	list=$1
	del=${2-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 2 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	[ ${#list} -eq 0 ] && return 2

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		END { printf "%s", $0 }
	'

	printf '%s' "$list" | awk "$awkProg"
)


##
# SUBPROCESS
#	list_get_psst <list> <index> [<del>]
#
# SUMMARY
#	Returns the value at a given index from a list.
#
# PARAMETERS
#	list: The list to get an value from.
#	index: The index of the value to get.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: Index out of bounds.
#
# OUTPUT
#	stdout: The requested value.
#
# SAMPLE
#	value=$( list_get_psst "$list" 5 )
#
list_get_psst()
(
	func='list_get_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'index' "$2"

	list=$1
	index=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	test_is_uint_psst "$index" || assert_func_fail_psst "$func" \
		'Index must be an unsigned integer value'

	index=$(( index + 1 ))
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		NR == '$index' { printf }
		END { if (NR < '$index') exit 2 }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_remove_first_psst <list> [<del>]
#
# SUMMARY
#	Removes the first value of a list and returns the result.
#
# PARAMETERS
#	list: The list to remove the first value from.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: List is empty.
#
# OUTPUT
#	stdout: The modified list without the first value.
#
# SAMPLE
#	list=$( list_remove_first_psst "$list")
#
list_remove_first_psst()
(
	func='list_remove_first_psst'
	assert_minargc_psst "$func" 1 $#
	assert_maxargc_psst "$func" 2 $#

	list=$1
	del=${2-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 2 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		NR != 1 { printf "%s%s", $0, RS }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_remove_last_psst <list> [<del>]
#
# SUMMARY
#	Removes the last value of a list and returns the result.
#
# PARAMETERS
#	list: The list to remove the last value from.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: List is empty.
#
# OUTPUT
#	stdout: The modified list without the last value.
#
# SAMPLE
#	last=$( list_remove_last_psst "$list")
#
list_remove_last_psst()
(
	func='list_remove_last_psst'
	assert_minargc_psst "$func" 1 $#
	assert_maxargc_psst "$func" 2 $#

	list=$1
	del=${2-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 2 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		prev != "" { printf "%s%s", prev, RS }
		{ prev = current; current = $0 }
		END { if (prev != "") printf "%s%s", prev, RS }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_remove_psst <list> <index> [<del>]
#
# SUMMARY
#	Removes a value by index and returns the modified list.
#
# PARAMETERS
#	list: The list to remove the value from.
#	index: The index of the value to remove.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: Index out of bounds.
#
# OUTPUT
#	stdout: The modified list after removing the value.
#
# SAMPLE
#	list=$( list_get_psst "$list" 5 )
#
list_remove_psst()
(
	func='list_get_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'index' "$2"

	list=$1
	index=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	test_is_uint_psst "$index" || assert_func_fail_psst "$func" \
		'Index must be an unsigned integer value'

	index=$(( index + 1 ))
	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		NR != '$index' { printf "%s%s", $0, RS }
		END { if (NR < '$index') exit 2 }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_remove_value_psst <list> <value> [<del>]
#
# SUMMARY
#	Removes a given value of the list and returns the modified list. If the
#	value is found multiple times on the list, only the first occourance
#	is removed.
#
# PARAMETERS
#	list: The list to remove the value from.
#	value: The value to remove.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: Value not found in list.
#
# OUTPUT
#	stdout: The modified list after removing the value.
#
# SAMPLE
#	list=$( list_remove_value_psst "$list" "some_value" )
#
list_remove_value_psst()
(
	func='list_remove_value_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'value' "$2"

	list=$1
	value=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		found || $0 != "'"$value"'" { printf "%s%s", $0, RS }
		!found && $0 == "'"$value"'" { found = 1 }
		END { if (!found) exit 2 }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_remove_all_values_psst <list> <value> [<del>]
#
# SUMMARY
#	Removes a given value of the list and returns the modified list. If the
#	value is found multiple times on the list, all appearances are removed.
#
# PARAMETERS
#	list: The list to remove the value from.
#	value: The value to remove.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# RETURNS
#	0: No error.
#	2: Value not found in list.
#
# OUTPUT
#	stdout: The modified list after removing the value.
#
# SAMPLE
#	list=$( list_remove_all_values_psst "$list" "some_value" )
#
list_remove_all_values_psst()
(
	func='list_remove_all_values_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'value' "$2"

	list=$1
	value=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		$0 != "'"$value"'" { printf "%s%s", $0, RS }
		$0 == "'"$value"'" { found = 1 }
		END { if (!found) exit 2 }
	'

	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_select_psst <list> <filter> [<del>]
#
# SUMMARY
#	Creates a new list containing only values matching a given regex filters
#	and returns it. The regex uses extended regex syntax and must start and
#	end with a slash (/.../).
#
# PARAMETERS
#	list: The list to filter.
#	filter: The regex filter to apply.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The filtered list.
#
# SAMPLE
#	filtered=$( list_select_psst "$list" '^a|b' )
#
list_select_psst()
(
	func='list_select_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'filter' "$2"

	list=$1
	filter=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	case $filter in
		/*/) ;;
		*) assert_func_fail_psst "$func" \
			'Argument "filter" is not a valid regex'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		$0 ~ '"$filter"' { printf "%s%s", $0,  RS }
	'
	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_filter_psst <list> <filter> [<del>]
#
# SUMMARY
#	Creates a new list without the values matching a given regex filters
#	and returns it. The regex uses extended regex syntax and must start and
#	end with a slash (/.../).
#
# PARAMETERS
#	list: The list to filter.
#	filter: The regex filter to apply.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The filtered list.
#
# SAMPLE
#	filtered=$( list_filter_psst "$list" '^a|b' )
#
list_filter_psst()
(
	func='list_filter_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'filter' "$2"

	list=$1
	filter=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return 2

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	case $filter in
		/*/) ;;
		*) assert_func_fail_psst "$func" \
			'Argument "filter" is not a valid regex'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		$0 !~ '"$filter"' { printf "%s%s", $0,  RS }
	'
	printf '%s' "$list" | awk "$awkProg"
)



##
# SUBPROCESS
#	list_find_psst <list> <filter> [<del>]
#
# SUMMARY
#	Finds the first value that matches a given regex and returns it. The regex
#	uses extended regex syntax and must start and end with a slash (/.../).
#
# PARAMETERS
#	list: The list to filter.
#	filter: The regex filter to apply.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The filtered list.
#
# SAMPLE
#	match=$( list_find_psst "$list" '^a|b' )
#
list_find_psst()
(
	func='list_find_psst'
	assert_minargc_psst "$func" 2 $#
	assert_maxargc_psst "$func" 3 $#
	assert_hasarg_psst "$func" 'filter' "$2"

	list=$1
	filter=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#list} -eq 0 ] && return

	if [ $# -eq 3 ]
	then
		[ ${#del} -eq 1 ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must be single character'

		! [ "$del" = "$NL_CHAR_PSST" ] \
			|| assert_func_fail_psst "$func" \
				'List delimiter must not be newline'
	fi

	case $list in
		*"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	case $filter in
		/*/) ;;
		*) assert_func_fail_psst "$func" \
			'Argument "filter" is not a valid regex'
	esac

	# shellcheck disable=SC2016
	awkProg='
		BEGIN { RS = "'$del'"; FS = "" }
		$0 ~ '"$filter"' { printf; exit }
	'
	printf '%s' "$list" | awk "$awkProg"
)
