//
//  SSUUID.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//

#import <Foundation/Foundation.h>

@interface SSUUID : NSObject

// CFUUID - Random Unique Identifier that changes every time
+ (nullable NSString *)cfuuid;

@end
