#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:perror:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:perror:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo 'INCLUDE_PSST not set!' >&2 ; exit 1 ; }


# shellcheck source=print.inc.sh
. "$INCLUDE_PSST/basic/print.inc.sh"


##
# SUBPROCESS
#	perror_psst [<arg>] [<arg>] [<arg>] ...
#
# SUMMARY
#	Print argument to stderr followed by a line break. If multiple arguments
#	are given, their values are concatenated first. Print empty line to
#	stderr if no argument is given. Will try to break lines on word boundaries.
#
# PARAMETERS
#	[arg]*: String value to print.
#
# OUTPUT
#	stderr: Formatted text that honors terminal width.
#
# SAMPLE
#	perror_psst "Syntax error!"
#	perror_psst
#	perror_psst "Argument 3 has bad syntax. Please read the documentation" \
#		" found at http://...link..."
#
perror_psst()
(
	print_psst "$@" >&2
)


##
# SUBPROCESS
#	perror_i_psst <indent> [<arg>] [<arg>] [<arg>] ...
#
# SUMMARY
#   Like perror_psst() but the first argument is the number of indent spaces.
#
# SEE
#	perror_psst()
#
# PARAMETERS
#	indent: Number of spaces in front of every new line.
#	[arg]*: String value to print.
#
# OUTPUT
#	stderr: Formatted text width indention that honors terminal width.
#
# SAMPLE
#	perror_i_psst 4 "Syntax error!"
#
perror_i_psst()
(
	print_i_psst "$@" >&2
)