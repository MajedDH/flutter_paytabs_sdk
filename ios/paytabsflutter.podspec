#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint paytabsflutter.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'paytabsflutter'
  s.version          = '0.0.1'
  s.summary          = 'Paytabs gateway sdk flutter wrapper'
  s.description      = <<-DESC
Paytabs gateway sdk flutter wrapper
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'
  s.preserve_paths = 'paytabs-iOS.framework'
  #s.xcconfig = { 'OTHER_LDFLAGS' => '-framework paytabs-iOS' }
  s.vendored_frameworks = 'paytabs-iOS.framework'
  s.resources  = "Resources.bundle"
  
  s.dependency 'BIObjCHelpers'
  s.dependency 'IQKeyboardManager', '~> 4.0.2'
  s.dependency 'AFNetworking'
  s.dependency 'Mantle'
  s.dependency 'Reachability'
  s.dependency 'Lockbox'
  s.dependency 'SBJson'
  s.dependency 'PINCache'
  s.dependency 'MBProgressHUD', '~> 1.1.0'
  s.dependency 'libPhoneNumber-iOS', '~> 0.8'
  s.xcconfig = { 'OTHER_LDFLAGS' => '-all_load -ObjC' }

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.0'
end
