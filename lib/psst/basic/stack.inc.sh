#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_stack.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _stack.inc.sh_"


##
# FUNCTION
#	stack_push_psst <newValue> <stackName>
#
# SUMMARY
#	Pushes a value to a stack with a given name. If no stack of that name
#	exists, it is created. Stack names must follow the same rules as variables,
#	e.g. must not contain spaces.
#
# PARAMETERS
#	newValue: Value to push on stack.
#	stackName: Name of the stack (no spaces, only letters and underscore).
#
# SAMPLE
#	stack_push_psst "$value" "someStackName"
#
stack_push_psst()
{
	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst "stack_push_psst" 2 $#
	assert_hasarg_psst "stack_push_psst" "stackName" "$2"

	#newValue=$1
	#stackName=$2

	# shellcheck disable=SC2034 # It is used but only indirect by eval
	_countName_stack_psst="${2}__count_stack_psst"
	eval "_count_stack_psst=\${$_countName_stack_psst-0}"

	_itemName_stack_psst="${2}__${_count_stack_psst}_item_stack_psst"
	_count_stack_psst=$(( _count_stack_psst + 1 ))

	eval "$_itemName_stack_psst=\"\$1\""
	eval "$_countName_stack_psst=$_count_stack_psst"

	unset _stackName_psst
	unset _countName_stack_psst
	unset _count_stack_psst
	unset _itemName_stack_psst
}



##
# FUNCTION
#	stack_pop_psst <stackName> <resultVarName>
#
# SUMMARY
#	Pop a value from a stack with a given name to a variable with a given name.
#	If no stack of that name exists, function return indicates failure.
#	If the last element of stack was poped, the stack is deleted.
#
# PARAMETERS
#	stackName: Name of the stack (no spaces, only letters and underscore).
#	resultVarName: Name of variable to receive popped value.
#
# RETURNS
#	0: Success.
#	2: No stack with that name has been found.
#
# SAMPLE
#	if stack_pop_psst "someStackName" myResultVar
#	then
#		# Do something with $myResultVar
#	fi
#
stack_pop_psst()
{
	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst "stack_pop_psst" 2 $#
	assert_hasarg_psst "stack_pop_psst" "stackName" "$1"
	assert_hasarg_psst "stack_pop_psst" "resultVarName" "$2"

	# stackName=$1
	# resultVarName=$2

	# shellcheck disable=SC2034 # It is used but only indirect by eval
	_countName_stack_psst="${1}__count_stack_psst"
	eval "_count_stack_psst=\${$_countName_stack_psst-}"

	if [ -z "$_count_stack_psst" ]
	then
		# Clean up and report error
		unset _countName_stack_psst
		unset _count_stack_psst
		return 2
	fi

	_count_stack_psst=$(( _count_stack_psst - 1 ))
	_itemName_stack_psst="${1}__${_count_stack_psst}_item_stack_psst"

	eval "$2=\"\$$_itemName_stack_psst\""
	unset "$_itemName_stack_psst"

	if [ $_count_stack_psst -eq 0 ]
	then
		unset "$_countName_stack_psst"
	else
		eval "$_countName_stack_psst=$_count_stack_psst"
	fi

	unset _countName_stack_psst
	unset _count_stack_psst
	unset _itemName_stack_psst
}



##
# FUNCTION
#	stack_exists_psst <stackName>
#
# SUMMARY
#	Test if a stack with a given name exists.
#
# PARAMETERS
#	stackName: Name of the stack (no spaces, only letters and underscore).
#
# RETURNS
#	0: Stack does exist.
#	2: Stack does not exist.
#
# SAMPLE
#	if stack_exists_psst "someStackName"
#	then
#		# Do something with the stack
#	fi
#
stack_exists_psst()
{
	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_countName_stack_psst="${1}__count_stack_psst"
	eval "_count_stack_psst=\${$_countName_stack_psst-}"
	unset _countName_stack_psst

	#stackName=$1

	if [ -n "${_count_stack_psst-}" ]
	then
		unset _count_stack_psst
		return 0
	fi

	unset _count_stack_psst
	return 2
}
