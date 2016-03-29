#!/bin/sh

echo .byte \"BUILT $(date '+%F %R') \[$(git rev-parse --short HEAD | tr a-z A-Z)\]\",\$ff
