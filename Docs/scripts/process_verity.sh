#!/bin/bash

process_verity() {
    read header
    printf "#\n# $header\n#\n"

    local IFS=":"
    while read KEY VAL
    do
        printf "%s=%s\n" \
            "$(echo "$KEY" | tr '[:lower:]' '[:upper:]' | tr ' ' '_')" \
            "$(echo "$VAL" | tr -d ' \t')"
    done
}

cat $1 | process_verity
