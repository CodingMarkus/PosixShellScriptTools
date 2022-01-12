#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_onexit.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _onexit.inc_"


##
# FUNCTION
# 	on_exit_psst <codeToEval>
#
# SUMMARY
# 	Register code to be executed when process or subprocess exists.
#
# PARAMETERS
# 	codeToEval: String to be passed to `eval`.
#
# SAMPLE
# 	on_exit_psst "rm -rf /tmp/someTempFile.tmp"
#
on_exit_psst ( )
{
    # We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	_oldtraps_psst=$(trap)
    _oldexit_psst=$(echo "$_oldtraps_psst" \
        | grep "EXIT$" \
        | sed -E 's/^trap -- (.*) EXIT$/\1/')
    if [ -n "$_oldexit_psst" ]
    then
        # shellcheck disable=SC2064
        trap "eval $_oldexit_psst ; $1" EXIT
    else
        # shellcheck disable=SC2064
        trap "$1" EXIT
    fi
}