#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_stack.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _stack.inc_"


STACK_ITEM_SUFFIX_PSST="__stack_psst"
STACK_COUNTER_SUFFIX_PSST="__count_stack_psst"



##
# FUNCTION
# 	stack_push_psst <newValue> <stackName>
#
# SUMMARY
# 	Pushes a value to a stack with a given name. If no stack of that name
# 	exists, it is created. Stack names must follow the same rules as variables,
# 	e.g. must not contain spaces.
#
# PARAMETERS
# 	newValue: Value to push on stack.
#	stackName: Name of the stack.
#
# RETURNS
# 	0: Success.
# 	1: Value could not be pushed to stack.
#
# SAMPLE
# 	stack_push_psst "$value" "some stack name"
#
stack_push_psst ( )
{
	# shellcheck disable=SC2034 # It is used but only indirect by eval
	newValue_psst="$1"
	stackName_psst="$2"

	# We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	# shellcheck disable=SC2034 # It is used but only indirect by eval
	stackCountName_psst="$stackName_psst$STACK_COUNTER_SUFFIX_PSST"

	eval "stackCount_psst=\$$stackCountName_psst"
	if [ -z "$stackCount_psst" ]; then
		stackCount_psst=1
	else
		stackCount_psst=$(( stackCount_psst + 1 ))
	fi

	stackItemName_psst="${stackName_psst}_$stackCount_psst"
	stackItemName_psst="$stackItemName_psst$STACK_ITEM_SUFFIX_PSST"

	eval "$stackItemName_psst=\"\$newValue_psst\""
	eval "$stackCountName_psst=$stackCount_psst"

	unset newValue_psst
	unset stackName_psst
	unset stackCountName_psst
	unset stackCount_psst
	unset stackItemName_psst
}



##
# FUNCTION
# 	stack_pop_psst <stackName> <resultVarName>
#
# SUMMARY
# 	Pop a value from a stack with a given name to a variable with a given name.
# 	If no stack of that name exists, function return indicates failure.
# 	If the last element of stack was poped, the stack is deleted.
#
# PARAMETERS
#	stackName: Name of the stack.
#	resultVarName: Name of variable to receive popped value.
#
# RETURNS
# 	0: Success.
# 	1: No stack with that name has been found.
#
# SAMPLE
# 	if stack_pop_psst "some stack name" "myResultVar"
# 	then
# 		# Do something with $myResultVar
# 	fi
#
stack_pop_psst ( )
{
	# shellcheck disable=SC2034 # It is used but only indirect by eval
	stackName_psst="$1"
	resultVarName_psst="$2"

	# We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	# shellcheck disable=SC2034 # It is used but only indirect by eval
	stackCountName_psst="$stackName_psst$STACK_COUNTER_SUFFIX_PSST"

	eval "stackCount_psst=\$$stackCountName_psst"
	if [ -z "$stackCount_psst" ]; then
		# Clean up and report error
		unset stackName_psst
		unset resultVarName_psst
		unset stackCountName_psst
		unset stackCount_psst
		return 1
	fi

	stackItemName_psst="${stackName_psst}_$stackCount_psst"
	stackItemName_psst="$stackItemName_psst$STACK_ITEM_SUFFIX_PSST"

	eval "$resultVarName_psst=\"\$$stackItemName_psst\""

	unset "$stackItemName_psst"
	stackCount_psst=$(( stackCount_psst - 1 ))
	if [ $stackCount_psst -eq 0 ]; then
		unset "$stackCountName_psst"
	else
		eval "$stackCountName_psst=$stackCount_psst"
	fi

	unset stackName_psst
	unset resultVarName_psst
	unset stackCountName_psst
	unset stackCount_psst
}