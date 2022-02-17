#!/usr/bin/env bash
# HOW TO USE
# Save code to file
# Run as "SCRIPT_FILE_NAME SCSS_DIRECTORY"
# e.g "./find_unused_scss_variables.sh ./scss"
 
VAR_NAME_CHARS='A-Za-z0-9_-'

find "$1" -type f -name "*.scss" -exec grep -o "\$[$VAR_NAME_CHARS]*" {} ';' | sort | uniq -u
