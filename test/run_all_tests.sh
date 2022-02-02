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
	(
		error=0
		cd "$( dirname "$test" )"
		"./$( basename "$test" )" || error=$?
		if [ $error -ne 0 ]
		then
			echo "$test failed with exit code: $error" >&2
			exit 1
		fi
	)
done