#import "AppController.h"
#include <stdlib.h>
#import <IOKit/IOReturn.h>
#import <Kernel/libkern/OSReturn.h>
#import <DiskArbitration/DADissenter.h>
#import <IOBluetooth/IOBluetoothTypes.h>
#if 1
	#define sub_iokit_hidsystem                     err_sub(14)
#else
	#import <IOKit/hidsystem/IOHIDSystem.h>
#endif
#if 1
	#define sub_iokit_pccard	err_sub(21)
#else
	#import <IOKit/pccard/IOPCCardBridge.h>
#endif

#define MAKE_OBJECT_AND_SYSTEM_KEY(VALUE)		@#VALUE, [NSNumber numberWithInt:err_get_system(VALUE)]
#define MAKE_OBJECT_AND_SUBSYSTEM_KEY(VALUE)	@#VALUE, [NSNumber numberWithInt:err_get_sub(VALUE)]

#define sub_unix_err	err_sub(3)	//	Derived from unix_err().

@implementation AppController

- (id)init {
	self = [super init];
	if (self) {
		mach_errorString = [[NSString alloc] init];
		system = [[NSString alloc] init];
		subsystem = [[NSString alloc] init];
		code = [[NSString alloc] init];
		
		systemLookup = [[NSDictionary alloc] initWithObjectsAndKeys:
			MAKE_OBJECT_AND_SYSTEM_KEY(err_kern),		//	0  0x0
			MAKE_OBJECT_AND_SYSTEM_KEY(err_us),			//	1  0x1
			MAKE_OBJECT_AND_SYSTEM_KEY(err_server),		//  2  0x2
			MAKE_OBJECT_AND_SYSTEM_KEY(err_ipc),		//  3  0x3
			MAKE_OBJECT_AND_SYSTEM_KEY(err_mach_ipc),	//	4  0x4
			MAKE_OBJECT_AND_SYSTEM_KEY(err_dipc),		//  7  0x7
			MAKE_OBJECT_AND_SYSTEM_KEY(sys_libkern),	//  55 0x37
			MAKE_OBJECT_AND_SYSTEM_KEY(sys_iokit),		//  56 0x38
			MAKE_OBJECT_AND_SYSTEM_KEY(err_local),		//	62 0x3e
			MAKE_OBJECT_AND_SYSTEM_KEY(err_ipc_compat),	//	63 0x3f
			nil];
		
		subsystemLookup = [[NSDictionary alloc] initWithObjectsAndKeys:
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_common),	  		//	0
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_usb),		  		//	1
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_firewire),	  		//	2
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_unix_err),		  		//	3
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_block_storage),		//	4
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_graphics),	 		//	5
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_networking), 		//	6
			
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_bluetooth),			//	8
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_pmu),	   			//	9
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_acpi),	   			//	10
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_smbus),	   			//	11
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_ahci),	   			//	12
			
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_hidsystem),			//	14
			
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_pccard),			//	21
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_vendor_specific),	//	-2
			MAKE_OBJECT_AND_SUBSYSTEM_KEY(sub_iokit_reserved),			//	-1
			nil];
			
	}
	return self;
}

- (void)setMach_errorString:(NSString*)mach_errorString_ {
	if (mach_errorString != mach_errorString_) {
		[mach_errorString release];
		mach_errorString = [mach_errorString_ retain];
		
		//--
		
		if (mach_errorString) {
			mach_error_t err = strtol([mach_errorString UTF8String], NULL, 0);
			
			int systemCode = err_get_system(err);
			NSString *systemName = [systemLookup objectForKey:[NSNumber numberWithInt:systemCode]];
			[self setValue:[NSString stringWithFormat:@"%03d 0x%02x %@", systemCode, systemCode, systemName ? systemName : @"unknown system"]
					forKey:@"system"];
			
			int subsystemCode = err_get_sub(err);
			NSString *subsystemName = [subsystemLookup objectForKey:[NSNumber numberWithInt:subsystemCode]];
			[self setValue:[NSString stringWithFormat:@"%03d 0x%02x %@", subsystemCode, subsystemCode, subsystemName ? subsystemName : @"unknown subsystem"]
					forKey:@"subsystem"];
			
			int codeCode = err_get_code(err);
			[self setValue:[NSString stringWithFormat:@"%03d 0x%02x", codeCode, codeCode]
					forKey:@"code"];
		}
	}
}

- (void)applicationDidFinishLaunching:(NSNotification*)notification_ {
	// Do me.
}

@end
