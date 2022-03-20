#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
    *:onexit:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:onexit:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=esc.inc.sh
. "$INCLUDE_PSST/basic/esc.inc.sh"

# shellcheck source=ifs.inc.sh
. "$INCLUDE_PSST/basic/ifs.inc.sh"

# shellcheck source=list.inc.sh
. "$INCLUDE_PSST/basic/list.inc.sh"


##
# VARIABLE
#	__OnExit_PSST
#
# SUMMARY
#	List storing commands to be excuted on exit.
#
__OnExit_PSST=''


##
# VARIABLE
#	__OnExitSet_PSST
#
# SUMMARY
#	Whether on exit trap has been set already
#
__OnExitSet_PSST=0


##
# FUNCTION
#	onexit_psst <codeToEval>
#
# SUMMARY
#	Register code to be executed when process or subprocess exists.
#
# PARAMETERS
#	codeToEval: String to be passed to `eval`.
#
# SAMPLE
#	onexit_psst "rm -rf /tmp/someTempFile.tmp"
#
# NOTE
#	`codeToEval` must not contain the character `$RS_CHAR_PSST`.
onexit_psst()
{
    # We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst 'onexit_psst' 1 $#
	assert_hasarg_psst 'onexit_psst' 'codeToEval' "$1"

	# shellcheck disable=SC2016
	case $1 in
		*$RS_CHAR_PSST*) assert_func_fail_psst "onexit_psst" \
			'Argument "codeToEval" must not contain $RS_CHAR_PSST'
	esac

    #codeToEval=$1

    if [ $__OnExitSet_PSST -eq 0 ]
    then
    	_oldtraps_onexit_psst=$( trap )
        _oldexit_onexit_psst=$(
            echo "$_oldtraps_onexit_psst" \
            | grep "EXIT$" \
            | sed -E 's/^trap -- (.*) EXIT$/\1/'
        )

        if [ -n "$_oldexit_onexit_psst" ]
        then
           _oldexit_onexit_psst=$( esc_squotes_psst "$_oldexit_onexit_psst" )
            # shellcheck disable=SC2064
            trap "eval '$_oldexit_onexit_psst' ; __onexit_run_psst" EXIT
        else
            # shellcheck disable=SC2064
            trap '__onexit_run_psst' EXIT
        fi

        __OnExitSet_PSST=1

        unset _oldtraps_onexit_psst
        unset _oldexit_onexit_psst
    fi

    __OnExit_PSST="$1$RS_CHAR_PSST$__OnExit_PSST"
}



##
# FUNCTION
#	onexit_remove_psst <codeNotToEval>
#
# SUMMARY
#	Remove code to be executed when process or subprocess exists.
#
# PARAMETERS
#	codeNotToEval: Code to be removed from the onexit list.
#
# SAMPLE
#   # Temp file has already been deleted
#	onexit_remove_psst "rm -rf /tmp/someTempFile.tmp"
#
onexit_remove_psst()
{
    # We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	assert_argc_psst 'onexit_remove_psst' 1 $#
	assert_hasarg_psst 'onexit_remove_psst' 'codeNotToEval' "$1"

    #codeNotToEval=$1
    __OnExit_PSST=$( list_remove_value_psst "$__OnExit_PSST" "$1" )
}



##
# FUNCTION
#	__onexit_run_psst
#
# SUMMARY
#	Performs all registered on exit handlers.
#
__onexit_run_psst()
{
	# In case of an error, just keep going!
	set +e

    # We cannot use a subshell for this function as we need to register the
	# variables in the main shell. Thus we need to be careful to not conflict
	# when defining local variables.

	ifs_set_psst "$RS_CHAR_PSST"
	for _eval_onexit_psst in $__OnExit_PSST
	do
		eval "$_eval_onexit_psst"
	done

	__OnExit_PSST=''
	__OnExitSet_PSST=0
	unset _eval_onexit_psst

	set -e
}