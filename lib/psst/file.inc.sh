#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*:file:*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}:file:"

# Ensure INCLUDE_PSST is set
[ -n "${INCLUDE_PSST-}" ] || { echo "INCLUDE_PSST not set!" >&2 ; exit 1 ; }



# shellcheck source=basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"



# shellcheck source=file/abspath.inc.sh
. "$INCLUDE_PSST/file/abspath.inc.sh"

# shellcheck source=file/glob.inc.sh
. "$INCLUDE_PSST/file/glob.inc.sh"
