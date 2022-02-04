#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:print:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:print:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=global.inc.sh
. "$INCLUDE_PSST/basic/global.inc.sh"



##
# SUBPROCESS
#	perror_psst [<arg>] [<arg>] [<arg>] ...
#
# SUMMARY
#	Print argument to stdout followed by a line break. If multiple arguments
#	are given, their values are concatenated first. Print empty line to
#	stdout if no argument is given. Will try to break lines on word boundaries.
#
# PARAMETERS
#	[arg]*: String value to print.
#
# OUTPUT
#	stdout: Formatted text that honors terminal width.
#
# SAMPLE
#	print_psst "Hello World!"
#	print_psst
#	print_psst "This is a very long line that we break into" \
#		" two arguments, yet it will be printed like a single string."
#
print_psst()
(
	IFS=
	string="$*"

	lines=$( printf '%s\n' "$string" \
		| fold -w "$TERM_WIDTH_PSST" -s \
		| sed "s/ $//"
	)
	printf "%s\n" "$lines"
)


##
# SUBPROCESS
#	print_i_psst <indent> [<arg>] [<arg>] [<arg>] ...
#
# SUMMARY
#   Like print_psst() but the first argument is the number of indent spaces.
#
# SEE
#	print_psst()
#
# PARAMETERS
#	indent: Number of spaces in front of every new line.
#	[arg]*: String value to print.
#
# OUTPUT
#	stdout: Formatted text width indention that honors terminal width.
#
# SAMPLE
#	print_i_psst 4 "Hello Indention!"
#
print_i_psst()
(
	func='print_i_psst'
	assert_minargc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'indent' "$1"

	indent="$1"
	shift

	IFS=
	string="$*"

	cols=$(( TERM_WIDTH_PSST - indent ))
	lines=$( printf '%s\n' "$string" \
		| fold -w "$cols" -s \
		| sed "s/ $//"
	)

	IFS="$NL_CHAR_PSST"
	for line in $lines
	do
		line=${line% }
		printf '%*s%s\n' "$indent" '' "$line"
	done
)