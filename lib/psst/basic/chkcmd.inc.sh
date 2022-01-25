#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_chkcmd.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _chkcmd.inc.sh_"


# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"


##
# SUBPROCESS
#	chkcmd_psst <cmd> [<cmd>] [<cmd>] ...
#
# SUMMARY
#	Check if a list of given commands can be safely called
#	from within a script.
#
# PARAMETERS
#	cmd: Command.
#
# RETURNS
#	0: All commands can be called.
#	1: At least one command cannot be called or was not found.
#
# SAMPLE
#	if cmdchck_psst cmd1 cmd2 cmd3
#	then
#		Perform actions with cmd1, cmd2, and cmd3
#	fi
#
chkcmd_psst()
(
	func="chkcmd_psst"
	assert_minargc_psst "$func" 1 $#
	assert_hasarg_psst "$func" "cmd" "$1"

	while [ -n "$1" ]; do
		if ! command -v "$1" >/dev/null; then
			return 1
		fi
		shift
	done
)