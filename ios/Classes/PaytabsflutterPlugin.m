#import "PaytabsflutterPlugin.h"
#if __has_include(<paytabsflutter/paytabsflutter-Swift.h>)
#import <paytabsflutter/paytabsflutter-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "paytabsflutter-Swift.h"
#endif

@implementation PaytabsflutterPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftPaytabsflutterPlugin registerWithRegistrar:registrar];
}
@end
