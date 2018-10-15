#!/bin/sh

set -e

IFS=''

v4l2-compliance -s | while read line; do
    echo "$line" # to keep regular output
    echo "$line" | grep -qe "test .*: [OK|FAIL]" && {
        id=$(echo $line | sed s/'\ttest \(.*\): \(.*\)'/'\1'/ | sed s/' '/'-'/g | sed s/"[\(\)']"//g)
        res=$(echo $line | sed s/'\(.*\): \([OK|FAIL].*\)'/'\2'/ | sed s/'OK (Not Supported)'/skip/ | sed s/OK/pass/ | sed s/FAIL/fail/)
        lava-test-case "$id" --result "$res"
    }
done

exit 0
