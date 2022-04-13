alias plistbuddy=/usr/libexec/PlistBuddy
alias codesign=/usr/bin/codesign


#
# Bundle identifier
#

set_plist_bundle_identifier() {
  local bundle_identifier="$1"
  local plist_file="$2"

  plistbuddy \
    -c "set :CFBundleIdentifier $bundle_identifier" \
    "$plist_file"
}

set_appex_bundle_identifier() {
  local appex_target_name="$1"
  local bundle_identifier_suffix="$2"

  local bundle_identifier="$PRODUCT_BUNDLE_IDENTIFIER.$bundle_identifier_suffix"
  local plist_file="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/AppClips/$appex_target_name.app/Info.plist"

  set_plist_bundle_identifier "$bundle_identifier" "$plist_file"
}


#
# Bundle version
#

set_plist_bundle_version() {
  local bundle_version="$1"
  local plist_file="$2"

  plistbuddy \
    -c "set :CFBundleShortVersionString $bundle_version" \
    "$plist_file"
}

get_plsit_bundle_version() {
  local plist_file="$1"

  plistbuddy \
    -c "Print :CFBundleShortVersionString" \
    "$plist_file"
}

get_app_bundle_version() {
  local plist_file="$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"
  get_plsit_bundle_version "$plist_file"
}

set_appex_bundle_version() {
  local appex_target_name="$1"
  local bundle_version="$2"

  local plist_file="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/$BUNDLE_PLUGINS_FOLDER_PATH/$appex_target_name.appex/Info.plist"

  set_plist_bundle_version "$bundle_version" "$plist_file"
}


#
# Bundle build
#

set_plist_bundle_build() {
  local bundle_build="$1"
  local plist_file="$2"

  plistbuddy \
    -c "set :CFBundleVersion $bundle_build" \
    "$plist_file"
}

get_plist_bundle_build() {
  local plist_file="$1"

  plistbuddy \
    -c "Print :CFBundleVersion" \
    "$plist_file"
}

set_appex_bundle_build() {
  local appex_target_name="$1"
  local bundle_version="$2"

  local plist_file="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/$BUNDLE_PLUGINS_FOLDER_PATH/$appex_target_name.appex/Info.plist"

  set_plist_bundle_build "$bundle_version" "$plist_file"
}

get_app_bundle_build() {
  local plist_file="$BUILT_PRODUCTS_DIR/$INFOPLIST_PATH"
  get_plist_bundle_build "$plist_file"
}


#
# Code signing
#

prepare_entitlements_file() {
  local appex_target_name="$1"
  local bundle_identifier_suffix="$2"
  local output_file="$3"

  local original_entitlements="$CONFIGURATION_TEMP_DIR/$appex_target_name.build/$appex_target_name.appex.xcent"
  local bundle_identifier="$DEVELOPMENT_TEAM.$PRODUCT_BUNDLE_IDENTIFIER.$bundle_identifier_suffix"

  cp "$original_entitlements" "$output_file"

  if [[ $CONFIGURATION == "Release" ]]
  then
    plistbuddy \
      -c "set :application-identifier $bundle_identifier" \
      "$output_file"

    plistbuddy \
      -c "set :keychain-access-groups:0 $bundle_identifier" \
      "$output_file"
  fi
}

copy_provisioning_profile() {
  local appex_target_name="$1"
  local provision_source="$2"

  local provision_destination="$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/$BUNDLE_PLUGINS_FOLDER_PATH/$appex_target_name.appex/$EMBEDDED_PROFILE_NAME"

  cp "$provision_source" "$provision_destination"
}

resign_appex() {
  local appex_target_name="$1"
  local entitlements_file="$2"

  codesign \
    --force \
    --sign "$EXPANDED_CODE_SIGN_IDENTITY" \
    --entitlements "$entitlements_file" \
    --timestamp=none \
    "$BUILT_PRODUCTS_DIR/$FULL_PRODUCT_NAME/$BUNDLE_PLUGINS_FOLDER_PATH/$appex_target_name.appex"
}

#
#
#
#
#

set_appex_bundle_identifier \
  "TapOrderClip" \
  "Clip"

# set_appex_bundle_version \
#   "TapOrderClip" \
#   `get_app_bundle_version`

# set_appex_bundle_build \
#   "TapOrderClip" \
#   `get_app_bundle_build`

# # Be careful if using `keychain-access-groups` entitlement
# prepare_entitlements_file \
#   "TapOrderClip" \
#   "notification-service" \
#   "$DERIVED_SOURCES_DIR/NotificationService-Entitlements.plist"

# copy_provisioning_profile \
#   "TapOrderClip" \
#   "$SOURCE_ROOT/../.github/appstore/$TARGET_NAME/profiles/notification-service.mobileprovision"

# resign_appex \
#   "TapOrderClip" \
#   "$DERIVED_SOURCES_DIR/NotificationService-Entitlements.plist"