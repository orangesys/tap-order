buildNumber=$(/usr/libexec/PlistBuddy -c "Print CFBundleVersion" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}")
buildNumber=$(cut -d'.' -f2 <<<$buildNumber)
buildNumber=$(date +"%y%m%d")"."$(($buildNumber + 1))
/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $buildNumber" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"