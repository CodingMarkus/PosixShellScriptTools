#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_glob.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _glob.inc_"


# shellcheck source=globals.inc
. "$INCLUDE_PSST/basic/globals.inc"


# shellcheck source=ifs.inc
. "$INCLUDE_PSST/basic/ifs.inc"


##
# SUBPROCESS
# 	glob_psst <filter>  [<filter>]  [<filter>] ...
#
# SUMMARY
# 	Perform file globbing.
#
# PARAMETERS
# 	filter: Globbing pattern.
#
# OUTPUT
# 	stdout: Globbed files separated by NUL (`$NUL_CHAR_PSST`).
#
# SAMPLE
# 	globbed=$( glob_psst "$somePath/*.txt" "/tmp/*.tmp" )
#
glob_psst ( )
(
	filter="$1"

	IFS=""
	for f in "$@"
	do
		if [ -e "$f" ]
		then
			printf "%s%s" "$f" "$NUL_CHAR_PSST"
		fi
	done
)



##
# SUBPROCESS
# 	glob_max_psst <limit> <filter>  [<filter>]  [<filter>] ...
#
# SUMMARY
# 	Perform file globbing with an upper limit.
#
# PARAMETERS
#	limit: Maximum number of returned files.
# 	filter: Globbing pattern.
#
# OUTPUT
# 	stdout: Globbed files separated by NUL (`$NUL_CHAR_PSST`).
#
# SAMPLE
# 	globbed=$( glob_psst 5 "$somePath/*.txt" "/tmp/*.tmp" )
#
glob_max_psst ( )
(
	limit="$1"
	filter="$2"

	IFS=""
	count=0
	for f in $filter
	do
		if [ -e "$f" ]
		then
			printf "%s%s" "$f" "$NUL_CHAR_PSST"
			count=$(( count + 1 ))
			if [ $count -ge "$limit" ]
			then
				return 0
			fi
		fi
	done
)
