#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_globals.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _globals.inc.sh_"


##
# CONSTANT
# 	NL_CHAR_PSST
#
# SUMMARY
# 	Newline (`\n`) character as string.
#
NL_CHAR_PSST=$( printf "\n_" )
NL_CHAR_PSST=${NL_CHAR_PSST%_}


##
# CONSTANT
# 	FS_CHAR_PSST
#
# SUMMARY
# 	FS (file separator) character (28/0x1D) as string.
#
# shellcheck disable=SC2034
FS_CHAR_PSST=$( printf "\34" )

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