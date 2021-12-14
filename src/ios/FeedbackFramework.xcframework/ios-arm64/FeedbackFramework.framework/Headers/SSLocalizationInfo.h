//
//  SSLocalizationInfo.h
//  SystemServicesDemo
//
//  Created by Pedro Santos on 18/9/18.
//

#import <Foundation/Foundation.h>

@interface SSLocalizationInfo : NSObject

// Localization Information

// Country
+ (nullable NSString *)country;

// Language
+ (nullable NSString *)language;

// TimeZone
+ (nullable NSString *)timeZone;

// Currency Symbol
+ (nullable NSString *)currency;

@end
