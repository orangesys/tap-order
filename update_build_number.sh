buildNumber=10#$(date +"%j%H%M")
buildNumber=$((buildNumber))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${TARGET_BUILD_DIR}/TapOrder.app/AppClips/TapOrderClip.app/Info.plist"
