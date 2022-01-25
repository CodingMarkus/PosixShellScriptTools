#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_stack.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _stack.inc.sh_"


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
# RETURNS
#	0: Success.
#	1: Value could not be pushed to stack.
#
# SAMPLE
#	stack_push_psst "$value" "someStackName"
#
stack_push_psst()
{
	#newValue=$1
	#stackName=$2

	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_func_psst="stack_push_psst"
	assert_argc_psst "$_func_psst" 2 $#
	assert_hasarg_psst "$_func_psst" "stackName" "$2"
	unset _fun_psst


	# shellcheck disable=SC2034 # It is used but only indirect by eval
	_stackCountName_psst="${2}__stackCount_psst"

	eval "_stackCount_psst=\$$_stackCountName_psst"
	if [ -z "$_stackCount_psst" ]
	then
		_stackCount_psst=0
	fi

	_stackItemName_psst="${2}__$_stackCount_psst"
	_stackItemName_psst="${_stackItemName_psst}__stackItem_psst"
	_stackCount_psst=$(( _stackCount_psst + 1 ))

	eval "$_stackItemName_psst=\"\$1\""
	eval "$_stackCountName_psst=$_stackCount_psst"

	unset _stackName_psst
	unset _stackCountName_psst
	unset _stackCount_psst
	unset _stackItemName_psst
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
#	1: No stack with that name has been found.
#
# SAMPLE
#	if stack_pop_psst "someStackName" "myResultVar"
#	then
#		# Do something with $myResultVar
#	fi
#
stack_pop_psst()
{
	# stackName=$1
	# resultVarName=$2

	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_func_psst="stack_pop_psst"
	assert_argc_psst "$_func_psst" 2 $#
	assert_hasarg_psst "$_func_psst" "stackName" "$1"
	assert_hasarg_psst "$_func_psst" "resultVarName" "$2"
	unset _fun_psst

	# shellcheck disable=SC2034 # It is used but only indirect by eval
	_stackCountName_psst="${1}__stackCount_psst"
	eval "_stackCount_psst=\$$_stackCountName_psst"

	if [ -z "$_stackCount_psst" ]
	then
		# Clean up and report error
		unset _stackCountName_psst
		unset _stackCount_psst
		return 1
	fi

	_stackCount_psst=$(( _stackCount_psst - 1 ))

	_stackItemName_psst="${1}__$_stackCount_psst"
	_stackItemName_psst="${_stackItemName_psst}__stackItem_psst"

	eval "$2=\"\$$_stackItemName_psst\""
	unset "$_stackItemName_psst"

	if [ $_stackCount_psst -eq 0 ]
	then
		unset "$_stackCountName_psst"
	else
		eval "$_stackCountName_psst=$_stackCount_psst"
	fi

	unset _stackCountName_psst
	unset _stackCount_psst
	unset _stackItemName_psst
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
#	1: Stack does not exist.
#
# SAMPLE
#	if stack_exists_psst "someStackName"
#	then
#		# Do something with the stack
#	fi
#
stack_exists_psst()
{
	#stackName=$1

	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_stackCountName_psst="${1}__stackCount_psst"
	eval "_stackCount_psst=\$$_stackCountName_psst"
	unset _stackCountName_psst

	if [ -n "$_stackCount_psst" ]
	then
		unset _stackCount_psst
		return 0
	fi

	unset _stackCount_psst
	return 1
}
