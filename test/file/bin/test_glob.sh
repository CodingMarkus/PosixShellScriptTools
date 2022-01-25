#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

if [ -z "$INCLUDE_PSST" ]
then
	cmdBase=$( dirname "$0" )
	INCLUDE_PSST="$cmdBase/../../../lib/psst"
fi

# shellcheck source=../../../lib/psst/file.inc.sh
. "$INCLUDE_PSST/file.inc.sh"

# =============================================================================

# Glob must accept at least one argument
set +e
( glob_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Argument must not be empty
set +e
( glob_psst "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e


# Glob max must accept at least two arguments
set +e
( glob_max_psst 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( glob_max_psst 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# Arguments must not be empty
set +e
( glob_max_psst "" 1 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO

( glob_max_psst 1 "" 2>/dev/null )
[ $? = 127 ] || test_fail_psst $LINENO
set -e

# We need some temp storage location
tmpDir="/tmp"
tmpdir_psst "tmpDir" || test_fail_psst $LINENO

globDst="$tmpDir/glob_psst"


# Test globbing is correct
glob_psst "../data/glob/testdir/*" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob.txt" \
	|| test_fail_psst $LINENO


glob_psst "../data/glob/testdir/*.txt" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_txt.txt" \
	|| test_fail_psst $LINENO


glob_psst "../data/glob/testdir/*.space" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_space.txt" \
	|| test_fail_psst $LINENO


glob_psst "../data/glob/testdir/*.space" \
	"../data/glob/testdir/*.txt"         \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_txt_space.txt" \
	|| test_fail_psst $LINENO



# Test globbing max is correct
glob_max_psst 3 "../data/glob/testdir/*" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_3.txt" \
	|| test_fail_psst $LINENO


glob_max_psst 3 "../data/glob/testdir/*.txt" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_txt_3.txt" \
	|| test_fail_psst $LINENO


glob_max_psst 3 "../data/glob/testdir/*.space" \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_space_3.txt" \
	|| test_fail_psst $LINENO


glob_max_psst 3 "../data/glob/testdir/*.space" \
	"../data/glob/testdir/*.txt"               \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "../data/glob/glob_space_3.txt" \
	|| test_fail_psst $LINENO


glob_max_psst 3 "../data/glob/testdir/*.txt" \
	"../data/glob/testdir/*.space"           \
	| tr "$FS_CHAR_PSST" "$NL_CHAR_PSST" >"$globDst"

cmp -s "$globDst" "$cmdBase/../data/glob/glob_txt_3.txt" \
	|| test_fail_psst $LINENO
