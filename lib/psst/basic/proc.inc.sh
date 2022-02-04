#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_proc.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _proc.inc.sh_"

# shellcheck source=assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=chkcmd.inc.sh
. "$INCLUDE_PSST/basic/chkcmd.inc.sh"

# shellcheck source=chkcmd.inc.sh
. "$INCLUDE_PSST/basic/esc.inc.sh"

# shellcheck source=onexit.inc.sh
. "$INCLUDE_PSST/basic/onexit.inc.sh"


##
# FUNCTION
#	proc_start_psst <resultVarName> <mode> <cmd> [<arg>] [<arg>] [<arg>] ...
#
# SUMMARY
#	Start a background process and return a process handle that can be
#	used to communicate with or terminate it again. The process handle
#	format must be considered private.
#
#	The `mode` argument defines what shall happen to stdin, stdout, and
#	stderr. `mode` must be a 3-character string. The first character maps to
#	stdin, the second one to stdout, and the third one to stderr. If the
#	charater is a dot (`.`), the background process inherits the stream of
#	the current process. If the character is a lowercase X (`x`), the stream
#	of the background process maps to `/dev/null`. If the character is a
#	lowercase O (`o`), the stream is captured. E.g. the mode "ox." means:
#	capture stdin, redirect stdout to /dev/null, and inherit stderr.
#
# PARAMETERS
#	resultVarName: Name of the var the process handle is written to.
#	mode: Which streams to inherit, capture, or terminate.
#	cmd: The command to execute for the process.
#	[arg]*: Any number of arguments to pass along to the command.
#
# RETURNS
#	0: Process was sucessfully launched.
#	1: `cmd` cannot not be called.
#
# SAMPLE
#	proc_start_psst shHandle ox. sh
#
# NOTE
#	In case the process handle is not stopped prior to the script
#	terminating, it is automatically stopped on script termination.
#
proc_start_psst()
{
	# We cannot use a subshell for this function as we need to auto-close
	# process handles on exit and therefor we require an at-exit handler in
	# this shell.

	assert_minargc_psst 'proc_start_psst' 3 $#
	assert_hasarg_psst 'proc_start_psst' 'resultVarName' "$1"
	assert_hasarg_psst 'proc_start_psst' 'mode' "$2"
	assert_hasarg_psst 'proc_start_psst' 'cmd' "$3"

	# resultVarName=$1
	# mode=$4
	# cmd=$3

	# shellcheck  disable=SC2016
	[ ${#2} -eq 3 ] || assert_func_fail_psst 'proc_start_psst' \
		'`mode` must be 3 characters long'

	case $2 in
		*[!.ox]*)
			# shellcheck  disable=SC2016
			assert_func_fail_psst 'proc_start_psst' \
				'"mode" may only contain ".", "o", and "x"'
	esac

	chkcmd_psst "$3" || return 1

	_tmpdir_proc_psst=$( mktemp -d )
	chmod 0700 "$_tmpdir_proc_psst"

	_resultVarName_proc_psst="$1"
	_mode_proc_psst="$2"
	_evalCMD_proc_psst="'$3'"
	printf "%s" "$3"  >"$_tmpdir_proc_psst/cmd"
	shift 3

	for _arg_psst in "$@"
	do
		_evalCMD_proc_psst="$_evalCMD_proc_psst '$( esc_for_sq_psst "$_arg_psst" )'"
	done
	unset _arg_psst

	printf "%s" "$_evalCMD_proc_psst"  >"$_tmpdir_proc_psst/eval"

	_stdin_proc_psst=
	case $_mode_proc_psst in
		x??) _stdin_proc_psst="</dev/null" ;;
		o??) mkfifo -m 0600 "$_tmpdir_proc_psst/stdin"
			_stdin_proc_psst="<$_tmpdir_proc_psst/stdin"
	esac

	_stdout_proc_psst=
	case $_mode_proc_psst in
		?x?) _stdout_proc_psst=">/dev/null" ;;
		?o?) mkfifo -m 0600 "$_tmpdir_proc_psst/stdout"
			_stdout_proc_psst=">$_tmpdir_proc_psst/stdout"
	esac

	_stderr_proc_psst=
	case $_mode_proc_psst in
		??x) _stderr_proc_psst="2>/dev/null" ;;
		??o) mkfifo -m 0600 "$_tmpdir_proc_psst/stderr"
			_stderr_proc_psst="2>$_tmpdir_proc_psst/stderr"
	esac

	_evalCMD_proc_psst="$_evalCMD_proc_psst $_stdin_proc_psst"
	_evalCMD_proc_psst="$_evalCMD_proc_psst $_stdout_proc_psst"
	_evalCMD_proc_psst="$_evalCMD_proc_psst $_stderr_proc_psst"
	unset _stdin_proc_psst
	unset _stdout_proc_psst
	unset _stderr_proc_psst
	unset _mode_proc_psst

	_result_proc_psst=0
	if eval "$_evalCMD_proc_psst &"
	then
		printf "%s" $! >"$_tmpdir_proc_psst/pid"

		_onExit_psst="[ -d \"$_tmpdir_proc_psst\" ]"
		_onExit_psst="$_onExit_psst && proc_stop_psst '$_tmpdir_proc_psst'"
		# onexit_psst "$_onExit_psst"
		eval "$_resultVarName_proc_psst=$_tmpdir_proc_psst"
	else
		_result_proc_psst=1
		rm -rf "$_tmpdir_proc_psst"
	fi

	unset _tmpdir_proc_psst
	unset _resultVarName_proc_psst
	unset _evalCMD_proc_psst

	if [ $_result_proc_psst -eq 1 ]
	then
		unset _result_proc_psst
		return 1
	fi

	unset _result_proc_psst
	return 0
}



##
# SUBPROCESS
#	proc_get_pid_psst <procHandle>
#
# SUMMARY
#   Returns the PID of a running or deceased background process.
#
# PARAMETERS
#	procHandle: The handle of the background process.
#
# OUTPUT
#	stdout: PID of the process.
#
# SAMPLE
#	pid=$( proc_get_pid_psst "$handle" )
#
proc_get_pid_psst()
(
	func='proc_get_pid_psst'
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'procHandle' "$1"

	procHandle=$1

	pidFile="$procHandle/pid"
	[ -f "$pidFile" ] || assert_fail_psst "Invalid process handle: $procHandle"

	cat "$pidFile"
)



##
# SUBPROCESS
#	proc_is_alive_psst <procHandle>
#
# SUMMARY
#   Returns the PID of a running or deceased background process.
#
# PARAMETERS
#	procHandle: The handle of the background process.
#
# RETURNS
#	0: Process is alive.
#	1: Process is not alive anymore.
#
# SAMPLE
#	pid=$( proc_get_pid_psst "$hadnle" )
#
proc_is_alive_psst()
(
	func='proc_get_pid_psst'
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'procHandle' "$1"

	procHandle=$1

	pidFile="$procHandle/pid"
	[ -f "$pidFile" ] || assert_fail_psst "Invalid process handle: $procHandle"

	pid=$( cat "$pidFile" )
	kill -0 "$pid" 2>/dev/null || return 1
	return 0
)



##
# FUNCTION
#	proc_stop_psst <procHandle>
#
# SUMMARY
#   Terminates a given background process gracefully by sending it the TERM
#	signal. After calling `proc_stop_psst` on a `procHandle`, the handle
#	becomes invalid.
#
# PARAMETERS
#	procHandle: The handle of the background process.
#
# RETURNS
#	0: Process was sucessfully stopped.
#	1: Process has already stopped on its own.
#
# SAMPLE
#	proc_stop_psst "$procHandle"
#
proc_stop_psst()
{
	# We cannot use a subshell for this function as we need to wait within
	# the main process to avoid an error output on main shell termination as
	# the main shell will wait for the process if we haven't done so already
	# within that very same shell.

	# procHandle=$1

	func='proc_get_pid_psst'
	assert_argc_psst "$func" 1 $#
	assert_hasarg_psst "$func" 'procHandle' "$1"

	_pidFile_proc_psst="$1/pid"
	[ -f "$_pidFile_proc_psst" ] \
		|| assert_fail_psst "Invalid process handle: $1"

	_pid_proc_psst=$( cat "$_pidFile_proc_psst" )
	unset _pidFile_proc_psst
	rm -rf "$1"

	result=0
	kill -15 "$_pid_proc_psst" 2>/dev/null || result=1
	[ $result = 0 ] && wait "$_pid_proc_psst" 2>/dev/null

	unset _pid_proc_psst

	return $result
}
