//
//  RoationController.h
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 12..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol RotateDelegate <NSObject>

@required
- (void) realRotateScreen ;
@end

@interface RoationController : NSObject

+ (RoationController *)shared ;
@property(nonatomic) UIInterfaceOrientation statusBarOrientation;
- (BOOL) isLandscape;
- (CGFloat) bigHeight ;

@property (nonatomic, retain) id <RotateDelegate> delegate;
@end
