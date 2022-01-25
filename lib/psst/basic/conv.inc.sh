#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_conv.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _conv.inc.sh_"


# shellcheck source=globals.inc.sh
. "$INCLUDE_PSST/basic/globals.inc.sh"


##
# SUBPROCESS
# 	chr_psst <charCode>
#
# SUMMARY
# 	Returns character whose character code is `charCode`.
#	E.g `65` becomes `A`, `97` becomes `a` and `32` becomes space.
#
# PARAMETERS
# 	charCode: Character code of desired character.
#
# RETURNS
# 	0: Character code was valid.
# 	1: Character code was no integer number.
# 	2: Character code was out of valid range (0-255).
#   3: Character code is newline (`\n``), which cannot be captured.
#
# OUTPUT
# 	stdout: The characters whose code is `charCode`.
#
# SAMPLE
# 	digit9=$( chr_psst 57 )
#
chr_psst()
(
	charCode=$1

	func_psst="chr_psst"
	assert_argc_psst "$func_psst" 1 $#
	assert_hasarg_psst "$func_psst" "charCode" "$charCode"

	case $charCode in
    	*[!0123456789]*) return 1 ;;
		"10") return 3
	esac

	{ [ "$charCode" -lt 0 ] || [ "$charCode" -gt 255 ]; } && return 2

	pattern=$( printf "%03o" "$charCode" )
	# shellcheck disable=SC2059
	printf "\\${pattern}"
)


##
# SUBPROCESS
# 	ord_psst <char>
#
# SUMMARY
# 	Returns character code of character.
#	E.g `A` becomes `65`, `a` becomes `97`, and space becomes `32`.
#
# PARAMETERS
# 	char: Character whose code shall be returned.
#
# RETURNS
# 	0: Argument was a valid character.
#   1: Argument contained zero characters.
# 	2: Argument contained more than one character.
#
# OUTPUT
# 	stdout: The character code of `char`.
#
# SAMPLE
# 	charCode57=$( chr_psst "9" )
#
ord_psst()
(
	char=$1

	func_psst="ord_psst"
	assert_argc_psst "$func_psst" 1 $#

	[ -n "$char" ] || return 1
	[ ${#char} -eq 1 ] || return 2

	LC_CTYPE=C printf "%d" "'$char"
)
