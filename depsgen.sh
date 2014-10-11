#!/bin/bash
VENDOR=lge
for DEVICE in d800 d801 d802 ls980 vs980
do
(cat << EOF) > $DEVICE.dependencies
[
    {
        "vendorhack":  "true",
        "remote":      "github",
        "repository":  "CyanogenMod/android_device_${VENDOR}_$DEVICE",
        "target_path": "device/$VENDOR/$DEVICE",
        "revision":    "cm-11.0"
    },
    {
        "remote":      "github",
        "repository":  "TheMuppets/proprietary_vendor_${VENDOR}",
        "target_path": "vendor/$VENDOR",
        "revision":    "cm-11.0"
    }
]
EOF
done
