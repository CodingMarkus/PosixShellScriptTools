#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]; then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# =============================================================================

(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=30

	# shellcheck source=../../lib/psst/basic.inc
	. "$INCLUDE_PSST/basic.inc"

	# Must respect columns setting
	[ "$TERMINAL_WIDTH_PSST" = "30" ] || exit 100
)

(
	# shellcheck source=../../lib/psst/basic.inc
	. "$INCLUDE_PSST/basic.inc"

	# Must respect columns setting, must try to get real terminal width
	[ "$TERMINAL_WIDTH_PSST" = "$( tput cols )" ] || exit 101
)

(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=15

	# shellcheck source=../../lib/psst/basic.inc
	. "$INCLUDE_PSST/basic.inc"

	tmpDir="/tmp"
	tempdir_psst "tmpDir"

	printDst="$tmpDir/print_psst"
	print_psst "This is a very long test sentence, that should be split" \
		" at most every 15 characters but when possible only in between" \
		" words and terminate with a newline character." > "$printDst"

	# Test formatting is correct
	cmp -s "$printDst" "$cmdBase/../data/print/print.txt" || exit 102
)

(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=20

	# shellcheck source=../../lib/psst/basic.inc
	. "$INCLUDE_PSST/basic.inc"

	tmpDir="/tmp"
	tempdir_psst "tmpDir"

	printDst="$tmpDir/print_psst"
	print_i_psst 5 "This is a very long test sentence, that should be"    \
		" indented by 5 spaces and split at most every 20 characters but" \
		" when possible only in between words and terminate with a"       \
		" newline character." > "$printDst"

	# Test formatting is correct
	cmp -s "$printDst" "$cmdBase/../data/print/print_indent.txt" || exit 103
)