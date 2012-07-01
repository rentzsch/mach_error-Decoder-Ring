#import <Cocoa/Cocoa.h>

@interface AppController : NSObject {
	NSString *mach_errorString;
	NSString *system;
	NSString *subsystem;
	NSString *code;
	
	NSDictionary	*systemLookup;
	NSDictionary	*subsystemLookup;
	NSDictionary	*codeLookup;
}

@end
