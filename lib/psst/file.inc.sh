#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_file.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _file.inc.sh_"


# Ensure INCLUDE_PSST is set
if [ -z "${INCLUDE_PSST-}" ]
then
	echo "INCLUDE_PSST not set!" >&2
	exit 1
fi


# shellcheck source=basic.inc.sh
. "$INCLUDE_PSST/basic.inc.sh"


# shellcheck source=file/abspath.inc.sh
. "$INCLUDE_PSST/file/abspath.inc.sh"

# shellcheck source=file/glob.inc.sh
. "$INCLUDE_PSST/file/glob.inc.sh"
