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

# shellcheck source=../../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================
# proc_start

# Must accept at least three arguments
set +e
( proc_start_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must not be empty
set +e
( proc_start_psst "" 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 "" 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 2 "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Mode must be 3 characters
set +e
( proc_start_psst 1 "12" 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 "1234" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Mode must only contain ".", "o", or "x"
set +e
( proc_start_psst 1 .oa 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 .ao 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_start_psst 1 a.o 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Fictional command should not be found cannot be started
! proc_start_psst procHandle ... "__this_is_not_a_command" \
	|| test_fail_psst $LINENO


#  Test if a process can be started at all
(
	tmpdir="/tmp"
	tmpdir_psst tmpdir
	tmpfile="$tmpdir/test"

	procHandle=
	proc_start_psst procHandle ... sh -c "echo test >$tmpfile" \
		|| test_fail_psst $LINENO

	pid=$( proc_get_pid_psst "$procHandle" )
	wait "$pid"

	[ -f "$tmpfile"  ] || test_fail_psst $LINENO
	[ "$( cat "$tmpfile" )" = "test" ]  || test_fail_psst $LINENO

	# Test if a self terminating process is recognized correctly

	if  proc_is_alive_psst "$procHandle"
	then
		test_fail_psst $LINENO
	else
		[ $? -eq 1 ] || test_fail_psst $LINENO
	fi

	if proc_stop_psst "$procHandle"
	then
		test_fail_psst $LINENO
	else
		[ $? -eq 1 ] || test_fail_psst $LINENO
	fi
)



# =============================================================================
# proc_stop

# Must accept exactly one argument
set +e
( proc_stop_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_stop_psst 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must not be empty
set +e
( proc_stop_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must be valid file descriptor
set +e
( proc_stop_psst "abcd" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


#  Test if a process can be stopped at all
(
	tmpdir="/tmp"
	tmpdir_psst tmpdir
	tmpfile="$tmpdir/test"

	procHandle=
	proc_start_psst procHandle ... sh -c "echo \$$ >$tmpfile ; sleep 60" \
		|| test_fail_psst $LINENO

	pid=$( proc_get_pid_psst "$procHandle" )

	proc_stop_psst "$procHandle" || test_fail_psst $LINENO

	! kill -9 "$pid" 2>/dev/null || test_fail_psst $LINENO
)



# =============================================================================
# proc_get_pid

# Must accept exactly one argument
set +e
( proc_get_pid_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_get_pid_psst 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must not be empty
set +e
( proc_get_pid_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must be valid file descriptor
set +e
( proc_get_pid_psst "abcd" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


#  Test if the correct PID is returned
(
	tmpdir="/tmp"
	tmpdir_psst tmpdir
	tmpfile="$tmpdir/test"

	procHandle=
	proc_start_psst procHandle ... sh -c "echo \$$ >'$tmpfile'" \
		|| test_fail_psst $LINENO

	pid=$( proc_get_pid_psst "$procHandle" )
	wait "$pid"

	[ "$pid" = "$( cat $tmpfile )" ] || test_fail_psst $LINENO

	if proc_stop_psst "$procHandle"
	then
		test_fail_psst $LINENO
	else
		[ $? -eq 1 ] || test_fail_psst $LINENO
	fi
)



# =============================================================================
# proc_is_alive_psst

# Must accept exactly one argument
set +e
( proc_is_alive_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( proc_is_alive_psst 1 2 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must not be empty
set +e
( proc_is_alive_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must be valid file descriptor
set +e
( proc_is_alive_psst "abcd" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

#  Test if correct status is returned
(
	procHandle=
	proc_start_psst procHandle ... sleep 60 || test_fail_psst $LINENO

	proc_is_alive_psst "$procHandle" || test_fail_psst $LINENO

	pid=$( proc_get_pid_psst "$procHandle" )
	kill -9 "$pid" || test_fail_psst $LINENO
	wait "$pid" 2>/dev/null || true

	# Test if a self terminating process is recognized correctly

	if  proc_is_alive_psst "$procHandle"
	then
		test_fail_psst $LINENO
	else
		[ $? -eq 1 ] || test_fail_psst $LINENO
	fi

	if proc_stop_psst "$procHandle"
	then
		test_fail_psst $LINENO
	else
		[ $? -eq 1 ] || test_fail_psst $LINENO
	fi
)
