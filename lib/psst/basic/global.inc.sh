#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_global.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _global.inc.sh_"


##
# function
#	global_update_term_width_psst
#
# SUMMARY
#	Update the cached terminal width.
#
global_update_term_width_psst()
{
	if [ -n "${COLUMNS-}" ]
	then
		TERM_WIDTH_PSST="$COLUMNS"
	elif tput cols >/dev/null 2>&1
	then
		# shellcheck disable=SC2034
		TERM_WIDTH_PSST=$( tput cols )
	fi
}


##
# VARIABLE
#	TERM_WIDTH_PSST
#
# SUMMARY
#	Cached terminal width.
#	It's cached as it's unlikely to change while a script is executing.
#   Falls back to 80 in case real width cannot be determined.
#
# shellcheck disable=SC2034
TERM_WIDTH_PSST=80
global_update_term_width_psst