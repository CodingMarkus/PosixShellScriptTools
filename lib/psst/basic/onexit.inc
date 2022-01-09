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
	oldtraps=$(trap)
    oldexit=$(echo "$oldtraps" \
        | grep "EXIT$" \
        | sed -E 's/^trap -- (.*) EXIT$/\1/')
    if [ -n "$oldexit" ]
    then
        # shellcheck disable=SC2064
        trap "eval $oldexit ; $1" EXIT
    else
        # shellcheck disable=SC2064
        trap "$1" EXIT
    fi
}