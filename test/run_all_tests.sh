#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e
# Exit at once if an unset variable is attempted to be expanded
set -u

cmdBase=$( dirname "$0" )

for test in                        \
	"$cmdBase/basic/bin/"test_*.sh \
	"$cmdBase/file/bin/"test_*.sh
do
	if ! ( cd "$( dirname "$test" )" ; eval "./$( basename "$test" )" )
	then
		echo "$test failed with exit code: $?" >&2
		exit 1
	fi
done