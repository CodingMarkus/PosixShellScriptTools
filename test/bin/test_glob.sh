#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

if [ -z "$INCLUDE_PSST" ]
then
	INCLUDE_PSST="$cmdBase/../../lib/psst"
fi

# shellcheck source=../../lib/psst/basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"

# =============================================================================

#echo "$( glob_max_psst 5 "../data/glob/*.txt" )"

#echo "$( glob_max_psst 7 "../data/glob/* .space" )"

#echo "$( glob_r_psst "../data/glob/*.txt" )"
