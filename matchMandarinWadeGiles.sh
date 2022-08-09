#!/bin/bash

# TO RUN: ./matchMandarinWadeGilesBonus.sh

INPUT_FILE=inputFileOfNames # or "${1}"

# needs those 3 files given with those various prefixes
PREFIXES="$(echo $(cat prefix-file))"
SUFFIXES="$(echo $(cat suffix-file))"
STANDALONE_SUFFIXES="$(echo $(cat standaloneSuffix-file))"


PREFIXES_REGEX="($(echo $( echo "${PREFIXES}") | sed 's# #|#g' ))"
SUFFIXES_REGEX="($(echo $( echo "${SUFFIXES}") | sed 's# #|#g' ))"
STANDALONE_SUFFIXES_REGEX="($(echo $( echo "${STANDALONE_SUFFIXES}") | sed 's# #|#g' ))"

SYLLABLE="(${PREFIXES_REGEX}${SUFFIXES_REGEX}|${STANDALONE_SUFFIXES_REGEX})"
WG_REGEX="$(echo "(${SYLLABLE} ${SYLLABLE}([- ]${SYLLABLE})?)" | 
  sed "
    # Prefix (escape) all special regex chars '(|)?' with single backslash
    # This is required if WG_REGEX gets used as the regex for a downstream sed 
    # (or grep) command.  Note that the regex engine in awk does *not* need this.  
    # 2x backslashes for bash double-quoted string and 2x for sed s/// expr
    s#(#\\\\(#g ;
    s#|#\\\\|#g ;
    s#)#\\\\)#g ;
    s#?#\\\\?#g ;
	"
)"

# Notes on sed commands:
# Start by prefixing and postfixing each line with '__'
# (this is a hack to get around sed's lack of support for "negative lookahead").
# Replace all lines that start with __ and match the regex with MATCH_REGEX.
# Then replace all the lines that start with __ and have any number of non colons
# (these are lines that did not match the prior regex)
# Similarly the suffix of ':' is replaced with either MandarinWadeGiles or
# Other depending on whether the line ends in MandarinWadeGiles
# The last 4 substitute commands translate the 4 prefix/suffix combinations into
# language consistent with the questions in the assignment.

cat "${INPUT_FILE}" |
  sed '
    s#^#__# ;
    s#$#__# ;

    s#^__'"${WG_REGEX}"'[ ]*:#MATCH_REGEX:#I ;
    s#^__[^:]*:#NO_MATCH_REGEX:# ;
    s#:.* MandarinWadeGiles__$#:MandarinWadeGiles# ;
    s#:.*__#:Other# ;

    s#^MATCH_REGEX:MandarinWadeGiles#true-positive# ;
    s#^MATCH_REGEX:Other#false-positive# ;
    s#^NO_MATCH_REGEX:MandarinWadeGiles#false-negative# ;
    s#^NO_MATCH_REGEX:Other#true-negative# ;
   ' |
  sort | uniq -c
