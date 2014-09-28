#!/bin/bash
# Copyright (C) 2014 The NamelessRom Project
# Copyright (C) 2014 Kilian von Pflugk
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
if [ -z $1 ]; then
  echo "Enter a device name!"
  exit 1
else
  device=$1
fi

rm .repo/local_manifests/roomservice.xml

# normal build process
. build/envsetup.sh
lunch nameless_${device}-userdebug true
brunch ${device}

# Delete device to prevent repo sync errors
rm -rf device/*
