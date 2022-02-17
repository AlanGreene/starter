#!/usr/bin/env bash
# HOW TO USE
# Save code to file
# Run as "SCRIPT_FILE_NAME LESS_DIRECTORY"
# e.g "./find_unused_less_variables.sh ./less"
 
VAR_NAME_CHARS='A-Za-z0-9_-'

find "$1" -type f -name "*.less" -exec grep -o "\@[$VAR_NAME_CHARS]*" {} ';' | sort | uniq -u
