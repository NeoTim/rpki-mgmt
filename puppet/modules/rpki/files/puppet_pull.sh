#!/bin/sh
#
#Copyright 2014 Google Inc. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

TODAY=$(date +%y%m%d)
LOG="/tmp/rsync-pull.$TODAY.log"

date=$(/bin/date +%y%m%d_%H%M)
src=${1}
dest=${2}

if [ -z "$src" ]; then
    echo "$0: missing source"
    exit 1
fi
if [ -z "$dest" ]; then
    echo "$0: missing destination"
    exit 1
fi

if [ ! -d "$dest" ]; then
    echo "$0: destination directory does not exist"
    exit 1
fi

(( delay = %RANDOM % 60 ))
/usr/bin/rsync -av $src $dest/$date/ > $LOG 2>&1

# delete empty dirs
rmdir $dest/$date 2>/dev/null