#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:esc:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:esc:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo "INCLUDE_PSST not set!" >&2 ; exit 1 ; }


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
	func="esc_for_sq_psst"
	assert_argc_psst "$func" 1 $#

	value=$1

	printf "%s" "$value" |  sed "s/'/'\\\''/g"
)