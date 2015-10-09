//
//  MenuButtonView.h
//  Yap_Hangul
//
//  Created by Canapio(Crossys) on 2014. 10. 14..
//  Copyright (c) 2014년 canapio. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MenuButtonDelegate <NSObject>
@required
- (void) clickMenu:(UIView *)v ;
@end

@interface MenuButtonView : UIView

@property (nonatomic) BOOL touchAble;
@property (nonatomic, retain) id <MenuButtonDelegate> delegate;
@end
