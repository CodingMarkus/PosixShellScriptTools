#!/usr/bin/env sh

# Double include protection
case "${INCLUDE_SEEN_PSST-}" in
	*_const_*) return
esac
INCLUDE_SEEN_PSST="${INCLUDE_SEEN_PSST-}_const_"


##
# CONSTANT
#	NL_CHAR_PSST
#
# SUMMARY
#	Newline (`\n`) character as string.
#
NL_CHAR_PSST=$( printf "\n_" )
NL_CHAR_PSST=${NL_CHAR_PSST%_}
# shellcheck disable=SC2034
readonly NL_CHAR_PSST


##
# CONSTANT
#	FS_CHAR_PSST
#
# SUMMARY
#	FS (file separator) character (28/0x1c) as string.
#
# shellcheck disable=SC2034
FS_CHAR_PSST=$( printf "\34" )
# shellcheck disable=SC2034
readonly FS_CHAR_PSST


##
# CONSTANT
#	GS_CHAR_PSST
#
# SUMMARY
#	GS (group separator) character (29/0x1D) as string.
#
# shellcheck disable=SC2034
GS_CHAR_PSST=$( printf "\35" )
# shellcheck disable=SC2034
readonly GS_CHAR_PSST


##
# CONSTANT
#	RS_CHAR_PSST
#
# SUMMARY
#	RS (record separator) character (30/0x1E) as string.
#
# shellcheck disable=SC2034
RS_CHAR_PSST=$( printf "\36" )
# shellcheck disable=SC2034
readonly RS_CHAR_PSST


##
# CONSTANT
#	US_CHAR_PSST
#
# SUMMARY
#	US (unit separator) character (31/0x1F) as string.
#
# shellcheck disable=SC2034
US_CHAR_PSST=$( printf "\37" )
# shellcheck disable=SC2034
readonly US_CHAR_PSST
