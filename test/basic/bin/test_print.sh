#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e
# Exit at once if an unset variable is attempted to be expanded
set -u

if [ -z "${INCLUDE_PSST-}" ]
then
	cmdBase=$( dirname "$0" )
	INCLUDE_PSST="$cmdBase/../../../lib/psst"
fi


# =============================================================================

(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=30

	# shellcheck source=../../../lib/psst/basic.inc.sh
	. "$INCLUDE_PSST/basic.inc.sh"

	# print_i must accept at least one argument
	set +e
	( print_i_psst 2>/dev/null )
	[ $? = 127 ] || test_fail_psst $LINENO
	set -e

	# Argument must not be empty
	set +e
	( print_i_psst '' 2>/dev/null )
	[ $? = 127 ] || test_fail_psst $LINENO
	set -e
)


# Must respect columns setting
(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=30

	# shellcheck source=../../../lib/psst/basic.inc.sh
	. "$INCLUDE_PSST/basic.inc.sh"

	[ "$TERM_WIDTH_PSST" = "30" ] || test_fail_psst $LINENO
)


# Must try to get real terminal width
if tput cols >/dev/null 2>&1
then
	(
		# shellcheck source=../../../lib/psst/basic.inc.sh
		. "$INCLUDE_PSST/basic.inc.sh"

		[ "$TERM_WIDTH_PSST" = "$( tput cols )" ] || test_fail_psst $LINENO
	)
fi


# Test print formatting is correct
(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=15

	# shellcheck source=../../../lib/psst/basic.inc.sh
	. "$INCLUDE_PSST/basic.inc.sh"

	tmpDir="/tmp"
	tmpdir_psst tmpDir

	printDst="$tmpDir/print_psst"
	print_psst "This is a very long test sentence, that should be split" \
		" at most every 15 characters but when possible only in between" \
		" words and terminate with a newline character." > "$printDst"

	cmp -s "$printDst" "../data/print/print.txt" \
		|| test_fail_psst $LINENO
)


# Test print_i formatting is correct
(
	# shellcheck disable=SC2030 disable=SC2031
	export COLUMNS=20

	# shellcheck source=../../../lib/psst/basic.inc.sh
	. "$INCLUDE_PSST/basic.inc.sh"

	tmpDir="/tmp"
	tmpdir_psst tmpDir

	printDst="$tmpDir/print_psst"
	print_i_psst 5 "This is a very long test sentence, that should be"    \
		" indented by 5 spaces and split at most every 20 characters but" \
		" when possible only in between words and terminate with a"       \
		" newline character." > "$printDst"

	cmp -s "$printDst" "../data/print/print_indent.txt" \
		|| test_fail_psst $LINENO
)