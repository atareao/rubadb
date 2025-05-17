#!/usr/bin/env sh
# -*- coding: utf-8 -*-

# Copyright (c) 2023 Lorenzo Carbonell <a.k.a. atareao>

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# init local backup
for file in $(find /app/.config/rustic -type f -name "*.toml"); do
    echo "=== Check ${file} ==="
    rustic -P $(basename "$file" | sed 's/\.toml$//') snapshots
    if [ $? -ne 0 ]; then
        echo "=== ${file} not initialized ==="
        rustic -P $(basename "$file" | sed 's/\.toml$//') init
    fi
done

# Exit if any command fails
set -o errexit
set -o nounset

# init crond
LOGLEVEL=$(echo ${LOGLEVEL:-DEBUG} | tr '[:lower:]' '[:upper:]')

case "$LOGLEVEL" in
    EMERG) LEVEL_VALUE=0;;
    ALERT) LEVEL_VALUE=1;;
    CRIT) LEVEL_VALUE=2;;
    ERR) LEVEL_VALUE=3;;
    WARNING) LEVEL_VALUE=4;;
    NOTICE) LEVEL_VALUE=5;;
    INFO) LEVEL_VALUE=6;;
    DEBUG) LEVEL_VALUE=7;;
    *) LEVEL_VALUE=7;;
esac

echo "=== Generate crontab.txt ==="
echo "$HOME"
SCHEDULE="${SCHEDULE:-0 2 * * *}"
echo "${SCHEDULE} /bin/sh /backup.sh >> /proc/1/fd/1" > /app/app

echo "Set log level to '${LOGLEVEL}' => '${LEVEL_VALUE}'"
echo "Starting crond... $(date)"
crond -c /app -f -l "${LEVEL_VALUE}"
