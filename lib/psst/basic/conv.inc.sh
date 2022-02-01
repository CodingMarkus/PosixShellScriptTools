#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_conv.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _conv.inc.sh_"


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
#	0: Character code was valid.
#	1: Character code was no integer number.
#	2: Character code was out of valid range (0-255).
#   3: Character code is newline (`\n``), which cannot be captured.
#
# OUTPUT
#	stdout: The character whose code is `charCode`.
#
# SAMPLE
#	digit9=$( chr_psst 57 )
#
conv_chr_psst()
(
	func="chr_psst"
	assert_minargc_psst "$func" 1 $#
	assert_hasarg_psst "$func" "charCode" "$1"

	while [ -n "${1-}" ]
	do
		charCode=$1
		test_is_int_psst "$charCode" || return 1
		{ [ "$charCode" -lt 0 ] || [ "$charCode" -gt 255 ]; } && return 2
		[ "$charCode" != "10" ] || return 3

		printf "%b" "$( printf '\%o' "$charCode" )"
		shift
	done
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
	func="ord_psst"
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" "chars" "$1"

	chars=$1
	[ ${#chars} -eq 1 ] && { LC_CTYPE=C printf "%d" "'$chars"; return 0; }

	printf "%s" "$chars" | (
		sep=
		while read -r _unused_ octalValue <<EOF
$( dd bs=1 count=1 2>/dev/null | od -b )
EOF
		do
			[ -n "$octalValue" ] || return 0
			LC_CTYPE=C printf "%s%d" "$sep" "0$octalValue"
			sep=" "
		done
	)

)
