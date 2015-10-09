//
//  RoationController.m
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 12..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "RoationController.h"

@interface RoationController () {
    BOOL isInit;
}

@end

@implementation RoationController

+ (RoationController *)shared {
    static RoationController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[RoationController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}


- (void)setStatusBarOrientation:(UIInterfaceOrientation)statusBarOrientation {
    if (statusBarOrientation!=_statusBarOrientation || !isInit) {
        isInit = YES;
        
//        NSLog(@"%zd->%zd", _statusBarOrientation, statusBarOrientation);
//        NSLog(@"UIInterfaceOrientationUnknown:%zd", UIInterfaceOrientationUnknown);
//        NSLog(@"UIInterfaceOrientationPortrait:%zd", UIInterfaceOrientationPortrait);
//        NSLog(@"UIInterfaceOrientationPortraitUpsideDown:%zd", UIInterfaceOrientationPortraitUpsideDown);
//        NSLog(@"UIInterfaceOrientationLandscapeLeft:%zd", UIInterfaceOrientationLandscapeLeft);
//        NSLog(@"UIInterfaceOrientationLandscapeRight:%zd", UIInterfaceOrientationLandscapeRight);
        _statusBarOrientation = statusBarOrientation;
        
        [self.delegate realRotateScreen];
    }
}
- (BOOL) isLandscape {
    return (self.statusBarOrientation == UIInterfaceOrientationLandscapeLeft||
            self.statusBarOrientation == UIInterfaceOrientationLandscapeRight);
}
- (CGFloat) bigHeight {
    CGSize winSize = [[UIScreen mainScreen] bounds].size;
    return (winSize.width<winSize.height)?winSize.height:winSize.width;
}
@end
