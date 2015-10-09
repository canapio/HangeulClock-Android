//
//  MenuView.h
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 13..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MainViewController;
@interface MenuView : UIView


@property (nonatomic, retain) MainViewController *mainViewController;

@property (nonatomic) BOOL menuOn;
- (void) menuOnEvent ;
- (void) menuOffEvent ;

- (void) rotateWithWinSize:(CGSize)winSize ;
@end
