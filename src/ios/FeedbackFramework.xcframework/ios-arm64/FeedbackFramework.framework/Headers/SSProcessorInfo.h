//
//  SSProcessorInfo.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//

#import <Foundation/Foundation.h>

@interface SSProcessorInfo : NSObject

// Processor Information

// Number of processors
+ (NSInteger)numberProcessors;

// Number of Active Processors
+ (NSInteger)numberActiveProcessors;

// Get Processor Usage Information (i.e. ["0.2216801", "0.1009614"])
+ (NSArray *)processorsUsage;

@end
