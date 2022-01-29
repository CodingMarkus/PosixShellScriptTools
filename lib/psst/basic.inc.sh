#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_basic.inc.sh_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-} _basic.inc.sh_"


# Ensure INCLUDE_PSST is set
if [ -z "${INCLUDE_PSST-}" ]
then
	echo "INCLUDE_PSST not set!" >&2
	exit 1
fi


# shellcheck source=basic/assert.inc.sh
. "$INCLUDE_PSST/basic/assert.inc.sh"

# shellcheck source=basic/chkcmd.inc.sh
. "$INCLUDE_PSST/basic/chkcmd.inc.sh"

# shellcheck source=basic/esc.inc.sh
. "$INCLUDE_PSST/basic/esc.inc.sh"

# shellcheck source=basic/conv.inc.sh
. "$INCLUDE_PSST/basic/conv.inc.sh"

# shellcheck source=basic/ifs.inc.sh
. "$INCLUDE_PSST/basic/ifs.inc.sh"

# shellcheck source=basic/onexit.inc.sh
. "$INCLUDE_PSST/basic/onexit.inc.sh"

# shellcheck source=basic/perror.inc.sh
. "$INCLUDE_PSST/basic/perror.inc.sh"

# shellcheck source=basic/print.inc.sh
. "$INCLUDE_PSST/basic/print.inc.sh"

# shellcheck source=basic/stack.inc.sh
. "$INCLUDE_PSST/basic/stack.inc.sh"

# shellcheck source=basic/tmpdir.inc.sh
. "$INCLUDE_PSST/basic/tmpdir.inc.sh"

# shellcheck source=basic/test.inc.sh
. "$INCLUDE_PSST/basic/test.inc.sh"