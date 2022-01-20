#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_abspath.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _abspath.inc.sh_"


# shellcheck source=../basic/assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# SUBPROCESS
# 	abspath_psst <path>
#
# SUMMARY
# 	Converts relative path to absolute path.
#
# PARAMETERS
# 	path: Relative or absolute path.
#
# RETURNS
# 	0: Success.
# 	1: Path does not exists.
#
# OUTPUT
# 	stdout: Absolute path on success.
#
# SAMPLE
# 	absPath=$( abspath_psst "$relativePath" )
#
abspath_psst()
(
	path=$1

	func="abspath_psst"
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" "path" "$1"

	if [ ! -e "$path" ]; then
		return 1
	fi

	file=""
	dir="$path"
	if [ ! -d "$dir" ]; then
		file=$( basename "$dir" )
		dir=$( dirname "$dir" )
	fi

	case "$dir" in
		/*) ;;
		*) dir="$( pwd )/$dir"
	esac
	result=$( cd "$dir" && pwd )

	if [ -n "$file" ]; then
		case "$result" in
			*/) ;;
			*) result="$result/"
		esac
		result="$result$file"
	fi

	printf "%s\n" "$result"
)