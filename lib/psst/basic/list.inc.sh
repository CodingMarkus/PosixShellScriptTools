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



##
# SUBPROCESS
#	list_append_psst <list> <newValue> [<del>]
#
# SUMMARY
#	Appends a new value to the end of an existing list, using `del` as a
#	delimiter between list items and to terminate the list.
#
# PARAMETERS
#	list: A list or an empty string to create a new list.
#	newValue: Value to append to the list.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The modified `list with `newValue` appended.
#
# NOTE
#	If `newValue` contains the delimiter character, it is considered to consist
#   out of multiple values, separted by the delimiter, and all of these values
#	are appended.
#
# SAMPLE
#	newList=$( list_append_psst '' "$someValue" "$GS_CHAR_PSST" )
#
#	modifiedList=$( list_append_psst "$someList" "$someValue" )
#
list_append_psst()
(
	func='list_append_psst'
	assert_minargc_psst "$func" 2 $#

	list=$1
	newValue=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#del} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must be single character'

	! [ "$del" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must not be newline'

	case $list in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	printf '%s%s%s' "$list" "$newValue" "$del"
)



##
# SUBPROCESS
#	list_prepend_psst <list> <newValue> [<del>]
#
# SUMMARY
#	Prepends a new value to the end of an existing list, using `del` as a
#	delimiter between list items and to terminate the list.
#
# PARAMETERS
#	list: A list or an empty string to create a new list.
#	newValue: Value to prepend to the list.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The modified `list with `newValue` prepended.
#
# NOTE
#	If `newValue` contains the delimiter character, it is considered to consist
#   out of multiple values, separted by the delimiter, and all of these values
#	are prepended.
#
# SAMPLE
#	newList=$( list_prepend_psst '' "$someValue" "$GS_CHAR_PSST" )
#
#	modifiedList=$( list_prepend_psst "$someList" "$someValue" )
#
list_prepend_psst()
(
	func='list_prepend_psst'
	assert_minargc_psst "$func" 2 $#

	list=$1
	newValue=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#del} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must be single character'

	! [ "$del" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must not be newline'

	case $list in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list" is not a valid list'
	esac

	printf '%s%s%s' "$newValue" "$del" "$list"
)



##
# SUBPROCESS
#	list_append_list_psst <list1> <list2> [<del>]
#
# SUMMARY
#	Appends values of `list2` to `list1`, using `del` as a
#	delimiter between list items and to terminate the list.
#
# PARAMETERS
#	list1: A list or an empty string to create a new list.
#	list2: Another list or empty string to append.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The resulting list of the append operation.
#
# SAMPLE
#	newList=$( list_append_list_psst "$list1" "$list2" "$GS_CHAR_PSST" )
#
list_append_list_psst()
(
	func="list_append_list_psst"
	assert_minargc_psst "$func" 2 $#

	list1=$1
	list2=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#del} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must be single character'

	! [ "$del" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must not be newline'

	case $list1 in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list1" is not a valid list'
	esac

	case $list2 in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list2" is not a valid list'
	esac


	printf '%s%s' "$list1" "$list2"
)



##
# SUBPROCESS
#	list_prepend_list_psst <list1> <list2> [<del>]
#
# SUMMARY
#	Prepends values of `list2` to `list1`, using `del` as a
#	delimiter between list items and to terminate the list.
#
# PARAMETERS
#	list1: A list or an empty string to create a new list.
#	list2: Another list or empty string to append.
#	[del]: Delimiter character; NOT newline! Defaults to $RS_CHAR_PSST.
#
# OUTPUT
#	stdout: The resulting list of the prepend operation.
#
# SAMPLE
#	newList=$( list_prepend_list_psst "$list1" "$list2" "$GS_CHAR_PSST" )
#

list_prepend_list_psst()
(
	func='list_prepend_list_psst'
	assert_minargc_psst "$func" 2 $#

	list1=$1
	list2=$2
	del=${3-$RS_CHAR_PSST}

	[ ${#del} -eq 1 ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must be single character'

	! [ "$del" = "$NL_CHAR_PSST" ] \
		|| assert_func_fail_psst "$func" \
			'List delimiter must not be newline'

	case $list1 in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list1" is not a valid list'
	esac

	case $list2 in
		'' | *"$del") ;;
		*) assert_func_fail_psst "$func" \
			'Argument "list2" is not a valid list'
	esac


	printf '%s%s' "$list2" "$list1"
)
