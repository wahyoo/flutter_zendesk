#import "ZendeskPlugin.h"
#if __has_include(<flutter_zendesk/flutter_zendesk-Swift.h>)
#import <flutter_zendesk/flutter_zendesk-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_zendesk-Swift.h"
#endif

@implementation ZendeskPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftZendeskPlugin registerWithRegistrar:registrar];
}
@end
