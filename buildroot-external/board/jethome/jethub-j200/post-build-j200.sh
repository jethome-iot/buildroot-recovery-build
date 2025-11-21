#!/bin/bash
# jethub_j200 specific post-build steps to reduce image size

# Remove kernel modules to save space
if [ -d "${TARGET_DIR}/lib/modules" ]; then
    echo "Removing kernel modules to reduce image size..."
    rm -rf "${TARGET_DIR}/lib/modules"
fi

# Remove Python3 ensurepip (pip installer)
if [ -d "${TARGET_DIR}/usr/lib/python3.12/ensurepip" ]; then
    echo "Removing Python3 ensurepip to reduce image size..."
    rm -rf "${TARGET_DIR}/usr/lib/python3.12/ensurepip"
fi

# Remove Python3 unittest module to save space
if [ -d "${TARGET_DIR}/usr/lib/python3.12/unittest" ]; then
    echo "Removing Python3 unittest to reduce image size..."
    rm -rf "${TARGET_DIR}/usr/lib/python3.12/unittest"
fi

