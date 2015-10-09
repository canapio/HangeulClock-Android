//
//  MenuSettingView.h
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 13..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuSettingView : UIView

@property (nonatomic) BOOL menuSettingOn;
- (void) menuSettingOnEventWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame ;
- (void) menuSettingOffEvent ;

- (void) rotateWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame ;
- (void) repositionWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame animate:(BOOL)animate ;
@end
