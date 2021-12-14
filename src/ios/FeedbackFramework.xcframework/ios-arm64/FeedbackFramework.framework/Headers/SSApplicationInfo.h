//
//  SSApplicationInfo.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//
//

#import <Foundation/Foundation.h>

@interface SSApplicationInfo : NSObject

// Application Information

// Application Version
+ (nullable NSString *)applicationVersion;

// Clipboard Content
+ (nullable NSString *)clipboardContent;

// Application CPU Usage
+ (float)cpuUsage;

@end
