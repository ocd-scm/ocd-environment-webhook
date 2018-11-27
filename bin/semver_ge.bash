#!/bin/bash
# tests whether $1 >= $2 on the first two numbers only
function semver_ge {
    product_version1=$1
    semver1=( ${product_version1//./ } )
    
    product_version2=$2
    semver2=( ${product_version2//./ } )

    major1="${semver1[0]}"
    major2="${semver2[0]}"

    if [ "${major1}" -lt "${major2}" ]; then
        echo "${major1} < ${major2}"
        return 1
    else
        minor1="${semver1[1]}"
        minor2="${semver2[1]}"
        if [ "${minor1}" -lt "${minor2}" ]; then
            echo "${minor1} < ${minor2}"
            return 2
        else
            return 0
        fi
    fi
}

semver_ge $1 $2