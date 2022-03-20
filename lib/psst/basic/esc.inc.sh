#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:esc:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:esc:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# SUBPROCESS
#	esc_squotes_psst <value>
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
#	safeValue=$( esc_squotes_psst "$value" )
#	execLater="someCommand '$safeValue'"
#	exec "$execLater"
#
esc_squotes_psst()
(
	func='esc_squotes_psst'
	assert_argc_psst "$func" 1 $#

	printf '%s' "$1" | sed "s/'/'\\\''/g"
)



##
# SUBPROCESS
#	esc_cstring_psst <value>
#
# SUMMARY
#	Escapes `value` so it can be safely used within a C-string. A C-string
#	allows all values except for double quote, backslash, and line break.
#
# PARAMETERS
#	value: Value to be escaped for usage within a C-string.
#
# OUTPUT
#	stdout: The escaped value.
#
# SAMPLE
#	safeValue=$( esc_cstring_psst "$value" )
#
#
esc_cstring_psst()
(
	func='esc_cstring_psst'
	assert_argc_psst "$func" 1 $#

	# shellcheck disable=SC2016
	awkProg='
		NR > 1 { printf "\\n" }
		{ printf "%s", $0 }
	'

	printf '%s' "$1" | sed 's/\(["\\]\)/\\\1/g' |  awk "$awkProg"
)



##
# SUBPROCESS
#	esc_printf_psst <value>
#
# SUMMARY
#	Escapes `value` so it can be safely used within a printf string. A printf
#	allows all values except for double quote, backslash, and line break.
#	Additionally % has a special meaing and must be escaped as %%.
#
# PARAMETERS
#	value: Value to be escaped for usage within a printf string
#
# OUTPUT
#	stdout: The escaped value.
#
# SAMPLE
#	safeValue=$( esc_cstring_psst "$value" )
#
#
esc_printf_psst()
(
	func='esc_printf_psst'
	assert_argc_psst "$func" 1 $#

	esc_cstring_psst "$1" | sed 's/%/%%/g'
)