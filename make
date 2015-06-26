#!/bin/bash

# build a whole Android application
# wrapper of android/ndk-build/ant/adb tools

if [[ $# -ne 1 ]]; then
    echo "Usage: ./make <id>"
else
    targetId=${1}
    curPath=`pwd`
    apkName=`basename ${curPath}`
    echo "1. generate build configuration files ..."
    android update project -n ${apkName} -p . -t ${targetId} 1> /dev/null
    echo "2. build NDK libraries ..."
    if [[ -d ./jni ]]; then
        ndk-build clean 1> /dev/null
        ndk-build 1> /dev/null
    fi
    echo "3. build APK ..."
    ant clean 1> /dev/null
    ant debug 1> /dev/null
    echo "4. install APK ..."
    echo "----------"
    adb devices | grep -w "device" 1> /dev/null
    if [[ $? -eq 0 ]]; then
        adb install -r bin/${apkName}-debug.apk
    else
        echo "Error: device NOT found!"
    fi
fi
