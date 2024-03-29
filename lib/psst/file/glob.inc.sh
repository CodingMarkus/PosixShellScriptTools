#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:glob:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:glob:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=../basic/assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=../basic/global.inc.sh
. "$INCLUDE_PSST/basic/global.inc.sh"

# shellcheck source=../basic/ifs.inc.sh
. "$INCLUDE_PSST/basic/ifs.inc.sh"



##
# SUBPROCESS
#	glob_psst <filter>  [<filter>]  [<filter>] ...
#
# SUMMARY
#	Perform file globbing.
#
# PARAMETERS
#	filter: Globbing pattern.
#
# OUTPUT
#	stdout: Globbed files separated by RS (`$RS_CHAR_PSST`).
#
# SAMPLE
#	globbed=$( glob_psst "$somePath/*.txt" "/tmp/*.tmp" )
#
glob_psst()
(
	func="glob_psst"
	assert_minargc_psst "$func" 1 $#
	assert_hasarg_psst "$func" "filter" "$1"

	IFS=
	separator=
	# shellcheck disable=SC2048 # We need globbing here!
	for f in $*
	do
		if [ -e "$f" ]
		then
			printf "%s%s" "$separator" "$f"
			separator=$RS_CHAR_PSST
		fi
	done
)



##
# SUBPROCESS
#	glob_max_psst <limit> <filter>  [<filter>]  [<filter>] ...
#
# SUMMARY
#	Perform file globbing with an upper limit.
#
# PARAMETERS
#	limit: Maximum number of returned files.
#	filter: Globbing pattern.
#
# OUTPUT
#	stdout: Globbed files separated by RS (`$RS_CHAR_PSST`).
#
# SAMPLE
#	globbed=$( glob_psst 5 "$somePath/*.txt" "/tmp/*.tmp" )
#
glob_max_psst()
(
	func="glob_psst"
	assert_minargc_psst "$func" 2 $#
	assert_hasarg_psst "$func" "limit" "$1"
	assert_hasarg_psst "$func" "filter" "$2"

	limit="$1"

	shift
	IFS=
	count=0
	separator=
	# shellcheck disable=SC2048 # We need globbing here!
	for f in $*
	do
		if [ -e "$f" ]
		then
			printf "%s%s" "$separator" "$f"
			separator=$RS_CHAR_PSST
			count=$(( count + 1 ))
			if [ $count -ge "$limit" ]
			then
				return 0
			fi
		fi
	done
)
