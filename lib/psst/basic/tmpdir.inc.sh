#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:tempdir:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:tempdir:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo "INCLUDE_PSST not set!" >&2 ; exit 1 ; }


# shellcheck source=../basic/onexit.inc.sh
. "$INCLUDE_PSST/basic/onexit.inc.sh"



##
# FUNCTION
#	tmpdir_psst <resultVarName>
#
# SUMMARY
#	Create a temporary directory that cleans automatically on script exit.
#	Argument is the name of a variable that shall contain the path to the
#	created temporary directoy on return.
#
# PARAMETERS
#	resultVarName: Name of variable the result is written to.
#
# SAMPLE
#	tmpDir="/tmp"
#	tmpdir_psst tmpDir
#
tmpdir_psst()
{
	# We cannot use a subshell for this function as we need to register the
	# trap in the main shell, otherwise it would execute when the subshell
	# exits. Thus we need to be careful to not conflict when defining local
	# variables and clean up on return.
	#
	# Also the caller cannot call this function in subshell either for exactly
	# the same reason. Thus the result is provided through a variable and the
	# caller passes the desired name as input parameter.

	assert_argc_psst "tmpdir_psst" 1 $#
	assert_hasarg_psst "tmpdir_psst" "resultVarName" "$1"

	#resultName=$1

	_tmpDir_psst=$( mktemp -d )

	# shellcheck disable=2064 # Expand $tmpDir now, not on script exit
	onexit_psst "rm -rf \"$_tmpDir_psst\""

	eval "$1=$_tmpDir_psst"

	unset _tmpDir_psst
}
