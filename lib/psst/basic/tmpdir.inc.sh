#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_tempdir.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _tempdir.inc_"


# shellcheck source=../basic/onexit.inc.sh
. "$INCLUDE_PSST/basic/onexit.inc.sh"


##
# FUNCTION
# 	tmpdir_psst <resultVarName>
#
# SUMMARY
# 	Create a temporary directoy that cleans automatically on script exit.
# 	Argument is the name of a variable that shall contain the path to the
# 	created temporary directoy on return.
#
# PARAMETERS
# 	resultVarName: Name of variable the result is written to.
#
# SAMPLE
# 	tmpDir="/tmp"
#	tmpdir_psst tmpDir
#
tmpdir_psst()
{
	_resultName_psst="$1"

	# We cannot use a sub shell for this function as we need to register the
	# trap in the main shell, otherwise it would execute when the sub shell
	# exits. Thus we need to be careful to not conflict when defining local
	# variables and clean up on return.

	_func_psst="tmpdir_psst"
	assert_argc_psst "$_func_psst" 1 $#
	assert_hasarg_psst "$_func_psst" "resultVarName" "$1"
	unset _func_psst

	# Also the caller cannot call this function in sub shell either for exactly
	# the same reason. Thus the result is provided through a variable and the
	# caller passes the desired name as input parameter.

	_tmpDir_psst=$( mktemp -d )

	# shellcheck disable=2064 # Expand $tmpDir now, not on script exit
	onexit_psst "rm -rf \"$_tmpDir_psst\""

	eval "$_resultName_psst=\"\$_tmpDir_psst\""

	# Clean up to not leave any traces of this function call
	unset _tmpDir_psst
	unset _resultName_psst
}