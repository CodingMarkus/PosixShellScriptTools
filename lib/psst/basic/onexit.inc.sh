#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_onexit.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _onexit.inc.sh_"


# shellcheck source=stack.inc.sh
. "$INCLUDE_PSST/basic/stack.inc.sh"


##
# FUNCTION
# 	onexit_psst <codeToEval>
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
onexit_psst()
{
    # We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

    if ! stack_exists_psst "onExitStack_psst"
    then
    	_oldtraps_psst=$(trap)
        _oldexit_psst=$(echo "$_oldtraps_psst" \
            | grep "EXIT$" \
            | sed -E 's/^trap -- (.*) EXIT$/\1/')
        if [ -n "$_oldexit_psst" ]
            then
            # shellcheck disable=SC2064
            trap "eval $_oldexit_psst ; __onexit_run_psst" EXIT
        else
            # shellcheck disable=SC2064
            trap "__onexit_run_psst" EXIT
        fi
    fi

    stack_push_psst "$1" "onExitStack_psst"
}


##
# FUNCTION
# 	__onexit_run_psst
#
# SUMMARY
# 	Performs all registered on exit handlers.
#
__onexit_run_psst()
{

    # We cannot use a sub shell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

    _evalMe_psst=
    while stack_pop_psst "onExitStack_psst" _evalMe_psst
    do
        eval "$_evalMe_psst"
    done
}