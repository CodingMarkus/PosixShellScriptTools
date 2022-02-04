#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:conv:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:conv:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=test.inc.sh
. "$INCLUDE_PSST/basic/test.inc.sh"



##
# SUBPROCESS
#	conv_chr_psst <charCode> [<charCode>] [<charCode>] ...
#
# SUMMARY
#	Returns character whose character code is `charCode`.
#	E.g `65` becomes `A`, `97` becomes `a` and `32` becomes space.
#
#	If multiple character codes are passed, the resulting characters are
#	returned as a concatinated string.
#
# PARAMETERS
#	charCode: Character code of desired character.
#
# RETURNS
#	0: Success.
#	2: Character code was no integer number.
#	3: Character code was out of valid range (0-255).
#   4: One or more trailing newline characters (\n) have been dropped.
#
# OUTPUT
#	stdout: The character whose code is `charCode`.
#
# NOTE
#	To prevent that trailing newlines are getting dropped, just append an extra
#	charcode and later on strip that char again as shown in the sample code.
#
# SAMPLE
#	digit9=$( chr_psst 57 )
#
#	# Prevent newlines from getting dropped
#	newline=$( chr_psst 10 95 )
#	newline=${newline%_} # strip "_" at end as 95 == "_"
#
conv_chr_psst()
(
	func='chr_psst'
	assert_minargc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'charCode' "$1"

	for char in "$@"
	do
		test_is_int_psst "$char" || return 2;
		{ [ "$char" -lt 0 ] || [ "$char" -gt 255 ]; } && return 3
	done

	if [ $# -eq 1 ]
	then
		printf "%b" "$( printf '\\0%o' "$char" )"
	else
		printf "%s" "$*" | xargs printf '\\\\0%o' | xargs printf "%b"
	fi

	[ "$char" -eq 10 ] && return 4
	return 0
)


##
# SUBPROCESS
#	conv_ord_psst <chars>
#
# SUMMARY
#	Returns character code of character.
#	E.g `A` becomes `65`, `a` becomes `97`, and space becomes `32`.
#
#	If multiple characters are passed, the resulting character codes are
#	returned as a concatinated string separated by space.
#
# PARAMETERS
#	char: Characters whose code shall be returned.
#
# OUTPUT
#	stdout: The character code of `char`.
#
# SAMPLE
#	charCode57=$( chr_psst "9" )
#
conv_ord_psst()
(
	func='ord_psst'
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'chars' "$1"

	chars=$1
	[ ${#chars} -eq 1 ] && { LC_CTYPE=C printf "%d" "'$chars"; return 0; }

	printf "%s" "$chars" \
		| od -t u1 \
		| awk '{for(i=2;i<=NF;i++){printf "%s%s",sep,$i;sep=" "}}'
)
