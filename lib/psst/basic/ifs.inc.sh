#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:ifs:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:ifs:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=stack.inc.sh
. "$INCLUDE_PSST/basic/stack.inc.sh"



##
# FUNCTION
#	ifs_set_psst [<newValue>]
#
# SUMMARY
#	Save the current IFS value to a stack and replace it with a new value. New
#	value can be
#
# PARAMETERS
#	[newValue]: The new desired value for $IFS.
#
# RETURNS
#	0: Success.
#	2: Current $IFS value could not be saved.
#
# SAMPLE
#	ifs_set_psst "$US_CHAR_PSST"
#
ifs_set_psst()
{
	#newIFSValue=$1

	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst 'ifs_set_psst' 1 $#

	stack_push_psst 'ifsStack_psst' "$IFS" || return 2
	IFS=$1

	unset newIFSValue_psst
}



##
# FUNCTION
#	ifs_restore_psst
#
# SUMMARY
#	Restore the last saved IFS value or set IFS to default if no value has been
#	saved at all or all saved values have already been restored.
#
# SAMPLE
#	ifs_restore_psst
#
ifs_restore_psst()
{
	# We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst 'ifs_restore_psst' 0 $#
	unset _func_psst

	if ! stack_pop_psst 'ifsStack_psst' IFS
	then
		unset IFS
	fi
}
