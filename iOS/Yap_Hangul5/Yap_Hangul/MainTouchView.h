//
//  MainTouchView.h
//  Yap_Hangul
//
//  Created by Canapio(Crossys) on 2014. 10. 13..
//  Copyright (c) 2014년 canapio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuView, MainViewController;
@interface MainTouchView : UIView


@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) MenuView *menuView;
@property (nonatomic) CGSize winSize;
@end
