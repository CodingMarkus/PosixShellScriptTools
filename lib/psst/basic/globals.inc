#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_globals.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _globals.inc_"


##
# CONSTANT
# 	NEWLINE_CHAR_PSST
#
# SUMMARY
# 	Newline (`\n`) character as string.
#
NEWLINE_CHAR_PSST=$( printf "\n_" )
NEWLINE_CHAR_PSST=${NEWLINE_CHAR_PSST%_}


##
# CONSTANT
# 	NUL_CHAR_PSST
#
# SUMMARY
# 	NUL character as string.
#
# shellcheck disable=SC2034
NUL_CHAR_PSST=$( printf "\0" )


##
# CONSTANT
# 	TERMINAL_WIDTH_PSST
#
# SUMMARY
# 	Cached terminal width.
#	It's cached as it's unlikely to change while a script is executing.
#   Falls back to 80 in case real width cannot be determined.
#
TERMINAL_WIDTH_PSST=80
if [ -n "$COLUMNS" ]
then
	TERMINAL_WIDTH_PSST="$COLUMNS"
elif tput cols >/dev/null 2>&1
then
	# shellcheck disable=SC2034
	TERMINAL_WIDTH_PSST=$( tput cols )
fi
