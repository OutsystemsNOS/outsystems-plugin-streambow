//
//  AppDelegate+Streambow.m
//  StreambowSDK
//
//  Created by Andre Grillo on 10/12/2021.
//

#import "AppDelegate+Streambow.h"
#import "OutSystems-Swift.h"

@implementation AppDelegate (Streambow)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self swizzleFromMethod:@selector(application:didFinishLaunchingWithOptions:)
                       toMethod:@selector(streambow_application:didFinishLaunchingWithOptions:)];

    });
}

+ (void)swizzleFromMethod:(SEL )originalSelector toMethod:(SEL)swizzledSelector {
    Class class = [self class];
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));

    if (didAddMethod) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

- (BOOL)streambow_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self streambow_application:application didFinishLaunchingWithOptions:launchOptions];//original call
    
    Main *sdk = [[Main alloc] init];
    [sdk initializer];
    NSLog(@"\n>>> StreambowSDK initialized <<<\n");
    return YES;
}
@end

