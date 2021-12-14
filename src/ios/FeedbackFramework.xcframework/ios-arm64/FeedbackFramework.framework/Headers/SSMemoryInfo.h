//
//  SSMemoryInfo.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//

#import <Foundation/Foundation.h>

@interface SSMemoryInfo : NSObject

// Memory Information

// Total Memory
+ (double)totalMemory;

// Free Memory
+ (double)freeMemory:(BOOL)inPercent;

// Used Memory
+ (double)usedMemory:(BOOL)inPercent;

// Active Memory
+ (double)activeMemory:(BOOL)inPercent;

// Inactive Memory
+ (double)inactiveMemory:(BOOL)inPercent;

// Wired Memory
+ (double)wiredMemory:(BOOL)inPercent;

// Purgable Memory
+ (double)purgableMemory:(BOOL)inPercent;

@end
