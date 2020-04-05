#import "AudioeventsPlugin.h"
#if __has_include(<audioevents/audioevents-Swift.h>)
#import <audioevents/audioevents-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "audioevents-Swift.h"
#endif

@implementation AudioeventsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAudioeventsPlugin registerWithRegistrar:registrar];
}
@end
