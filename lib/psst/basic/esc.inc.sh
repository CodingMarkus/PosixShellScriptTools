#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_esc.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _esc.inc.sh_"


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# SUBPROCESS
#	esc_for_sq_psst <value>
#
# SUMMARY
#	Escapes `value` so it can be safely used within single quotes. This
#	means it only escapes single quotes themselves as all other characters,
#	including backshlash, are safe to be used within single quotes. Basically
#	`abc'def'`` becomes `abc'\''def`.
#
#
# PARAMETERS
#	value: Value to be escaped for usage within single quotes.
#
# OUTPUT
#	stdout: The escaped value.
#
# SAMPLE
#	safeValue=$( esc_for_sq_psst "$value" )
#
esc_for_sq_psst()
(
	value=$1

	func="esc_for_sq_psst"
	assert_argc_psst "$func" 1 $#

	printf "%s" "$value" |  sed "s/'/'\\\''/g"
)