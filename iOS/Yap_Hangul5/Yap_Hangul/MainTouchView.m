//
//  MainTouchView.m
//  Yap_Hangul
//
//  Created by Canapio(Crossys) on 2014. 10. 13..
//  Copyright (c) 2014년 canapio. All rights reserved.
//

#import "MainTouchView.h"
#import "MainViewController.h"
#import "MenuView.h"


#define KEY_DARKNESS_ALPHA @"darkness alpha"

#define DIS(p1, p2) (pow(pow((p2.x-p1.x), 2.f)+pow((p2.y-p1.y), 2.f),.5f))

#define TAP_AREA_RADIUS 5.f

#define ALPHA_MAX .93f
#define ALPHA_MIN .0f

@interface MainTouchView () {
    
    
    
    UIView *darkView;
    
    CGPoint defaultPoint;
    
    BOOL nowSliding;
    BOOL nowWaitingForSliding;
    //    CGPoint slideDefaultPoint;
    //    float defaultBrightness;
    float beforeDarkness;
    CGPoint beforeSlidePoint;

    float screenDarkness;
}

@end

@implementation MainTouchView


- (instancetype)initWithFrame:(CGRect)frame {
    if (frame.size.width<frame.size.height) frame.size.width=frame.size.height;
    else frame.size.height=frame.size.width;
    if (self = [super initWithFrame:frame]) {
        NSString *dAlphaString = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_DARKNESS_ALPHA];
        if (!dAlphaString) {
            dAlphaString = @"0.";
            [[NSUserDefaults standardUserDefaults] setObject:dAlphaString forKey:KEY_DARKNESS_ALPHA];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        screenDarkness = [dAlphaString floatValue];
//        NSLog(@"screenDarkness:%f", screenDarkness);
        
        darkView = [[UIView alloc] initWithFrame:frame];
        darkView.backgroundColor = [UIColor blackColor];
        [self addSubview:darkView];
        
        darkView.alpha = screenDarkness;
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint location = [[touches anyObject] locationInView:self];
    defaultPoint = location;
    beforeDarkness = screenDarkness;
    nowSliding = NO;
    
    if (location.y>self.winSize.height-44) {
        nowWaitingForSliding = NO;
    } else {
        nowWaitingForSliding = YES;
    }
    
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (!nowWaitingForSliding) return;
    
    CGPoint location = [[touches anyObject] locationInView:self];
    if (nowSliding) {
        float b;// = defaultBrightness + ((location.y-slideDefaultPoint.y)/winSize.height)*3.f;
        CGPoint deltaP = CGPointMake(location.x-beforeSlidePoint.x, location.y-beforeSlidePoint.y);
        b = beforeDarkness + ((deltaP.y)/self.winSize.height)*3.f;
        if (b>ALPHA_MAX) b = ALPHA_MAX;
        else if (b<ALPHA_MIN) b = ALPHA_MIN;
        screenDarkness = b;
        darkView.alpha = screenDarkness;
    } else {
        if (DIS(location, defaultPoint)>TAP_AREA_RADIUS) {
            nowSliding = YES;
            beforeSlidePoint = location;
        }
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    
}
- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded: main touch view");
    
    if (nowSliding) {
        CGPoint location = [[touches anyObject] locationInView:self];

        float b;// = defaultBrightness + ((location.y-slideDefaultPoint.y)/winSize.height)*3.f;
        CGPoint deltaP = CGPointMake(location.x-beforeSlidePoint.x, location.y-beforeSlidePoint.y);
        b = beforeDarkness + ((deltaP.y)/self.winSize.height)*3.f;
        if (b>ALPHA_MAX) b = ALPHA_MAX;
        else if (b<ALPHA_MIN) b = ALPHA_MIN;
        screenDarkness = b;
        darkView.alpha = screenDarkness;

        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%f", screenDarkness] forKey:KEY_DARKNESS_ALPHA];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        if (!self.menuView) {
            [self.mainViewController makeMenuView];
        }
        if (!self.menuView.menuOn) {
            [self.menuView menuOnEvent];
        }
    }
    
    
}

@end
