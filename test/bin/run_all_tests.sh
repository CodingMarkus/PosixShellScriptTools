#!/usr/bin/env sh

# Exit at once if a command fails and the error isn't caught
set -e

cmdBase=$( dirname "$0" )

for test in "$cmdBase/"test_*.sh
do
	failure=0
	$test || failure=$?
	if [ "$failure" -ne 0 ]
	then
		echo "$test faild with exit code: $failure" >&2
		exit 1
	fi
done