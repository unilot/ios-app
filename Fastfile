# More documentation about how to customize your build
# can be found here:
# https://docs.fastlane.tools
fastlane_version "2.68.0"

# This value helps us track success metrics for Fastfiles
# we automatically generate. Feel free to remove this line
# once you get things running smoothly!
generated_fastfile_id "b9fc5460-f06f-44a9-b899-ce7b54f7a0e1"

default_platform :ios

# Fastfile actions accept additional configuration, but
# don't worry, fastlane will prompt you for required
# info which you can add here later
lane :beta do
  # increment_build_number

  # build your iOS app
  build_app(
    # scheme: "YourScheme",
    export_method: "ad-hoc"
  )

  # upload to Beta by Crashlytics
  crashlytics(
    # keys for organization: Arseniy’s Projects
    api_token: "51cd3268f4d24ff7e7d42163352dfd7dea40cdcd",
    build_secret: "57d5cbe9f8687d8d99033d26983d9ec871a13c4a1f7515caa22cadf44cdefab5"
  )
end
