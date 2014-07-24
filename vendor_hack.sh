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

###########################################
# Delete device/* when everything is done #
###########################################

source vendor/nameless/vendorhack/cm_vendor_setup.sh

DEVICE=$1
rm .repo/local_manifests/roomservice.xml

# Fetch device from CM
vendor/nameless/vendorhack/cm_roomservice.py ${DEVICE}

# Find CM.mk file for device
r2d2=$(ls device/*/${DEVICE}/cm.mk)

# Find the folder where the cm.mk is stored
c3po=$(dirname ${r2d2})
yoda=$(ls device/*/*/overlay/packages/apps/Torch/res/values/config.xml)
chewbacca=$(dirname ${yoda})

# Remove all CM Vendor config from cm.mk and save it to nameless_device.mk
sed '/vendor\/cm\/config/d' ${r2d2} >  ${c3po}/nameless_${DEVICE}.mk

# Add nameless config
echo 'include vendor/nameless/config/common.mk' >> ${c3po}/nameless_${DEVICE}.mk

# Add nameless apns
echo '$(call inherit-product, vendor/nameless/config/apns.mk)' >> ${c3po}/nameless_${DEVICE}.mk

# Add nameless Product name
echo "PRODUCT_NAME := nameless_${DEVICE}" >> ${c3po}/nameless_${DEVICE}.mk

# Remove existing AndroidProducts.mk
rm -rf ${c3po}/AndroidProducts.mk

# Write our own AndroidProducts.mk and add nameless_device.mk
echo "PRODUCT_MAKEFILES := "'$'"(LOCAL_DIR)/nameless_${DEVICE}.mk" >> ${c3po}/AndroidProducts.mk

# Search for CM's Torch config and extract LED Path
led=$(grep -oP '(?<=<string name="flashDevice">).*?(?=</string>)' ${yoda})
if [ -z "$led" ]; then
  echo ""
  echo -e "\033[31mDevice dont have a sys Torch overlay\033[0m"
  echo ""
else
  echo ""
  echo -e "\033[32mFound a sys Torch overlay!\033[0m"
  echo ""
  mkdir -p ${chewbacca}/../../../Flashlight/res/values/
  echo "<resources><string name="'"'"config_sysfs_torch"'"'">${led}</string></resources>" >> ${chewbacca}/../../../Flashlight/res/values/config.xml
fi
