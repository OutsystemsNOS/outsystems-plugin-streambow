//
//  SSBatteryInfo.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//
//

#import <Foundation/Foundation.h>

@interface SSBatteryInfo : NSObject

// Battery Information

// Battery Level
+ (float)batteryLevel;

// Charging?
+ (BOOL)charging;

// Fully Charged?
+ (BOOL)fullyCharged;

@end
