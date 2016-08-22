#!/bin/sh

echo .byte \"Built $(date '+%F %R') \($(git rev-parse --short HEAD | tr a-z A-Z)\)\"