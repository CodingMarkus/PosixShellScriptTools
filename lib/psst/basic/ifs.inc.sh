#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_ifs.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _ifs.inc.sh_"


# shellcheck source=stack.inc.sh
. "$INCLUDE_PSST/basic/stack.inc.sh"

# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# FUNCTION
# 	set_ifs_psst <newValue>
#
# SUMMARY
# 	Save the current IFS value to a stack and replace it with a new value.
#
# PARAMETERS
# 	newValue: The new desired value for $IFS.
#
# RETURNS
# 	0: Success.
# 	1: Current $IFS value could not be saved.
#
# SAMPLE
# 	set_ifs_psst "$NUL_CHAR_PSST"
#
set_ifs_psst()
{
	_newIFSValue_psst="$1"

	# We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_func_psst="set_ifs_psst"
	assert_argc_psst "$_func_psst" 1 $#

	stack_push_psst "$IFS" "ifsStack_psst" || return 1
	IFS="$_newIFSValue_psst"

	unset newIFSValue_psst
}



##
# FUNCTION
# 	restore_ifs_psst
#
# SUMMARY
# 	Restore the last saved IFS value or set IFS to default if no value has been
# 	saved at all or all saved values have already been restored.
##
# SAMPLE
# 	restore_ifs_psst
#
restore_ifs_psst()
{
	# We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_func_psst="set_ifs_psst"
	assert_argc_psst "$_func_psst" 0 $#

	if ! stack_pop_psst "ifsStack_psst" IFS
	then
		unset IFS
	fi
}
