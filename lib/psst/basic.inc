#!/usr/bin/env sh

# Double include protection
case "$INCLUDE_SEEN_PSST" in
	*_basic.inc_*)
		return
		;;
esac
INCLUDE_SEEN_PSST="$INCLUDE_SEEN_PSST _basic.inc_"

# Ensure INCLUDE_PSST is set
if [ -z "$INCLUDE_PSST" ]
then
	echo "INCLUDE_PSST not set!" >&2
	exit 1
fi


# shellcheck source=basic/abspath.inc
. "$INCLUDE_PSST/basic/abspath.inc"

# shellcheck source=basic/assert.inc
. "$INCLUDE_PSST/basic/assert.inc"

# shellcheck source=basic/chkcmd.inc
. "$INCLUDE_PSST/basic/chkcmd.inc"

# shellcheck source=basic/glob.inc
. "$INCLUDE_PSST/basic/glob.inc"

# shellcheck source=basic/ifs.inc
. "$INCLUDE_PSST/basic/ifs.inc"

# shellcheck source=basic/onexit.inc
. "$INCLUDE_PSST/basic/onexit.inc"

# shellcheck source=basic/perror.inc
. "$INCLUDE_PSST/basic/perror.inc"

# shellcheck source=basic/print.inc
. "$INCLUDE_PSST/basic/print.inc"

# shellcheck source=basic/stack.inc
. "$INCLUDE_PSST/basic/stack.inc"

# shellcheck source=basic/tempdir.inc
. "$INCLUDE_PSST/basic/tempdir.inc"

# shellcheck source=basic/test.inc
. "$INCLUDE_PSST/basic/test.inc"