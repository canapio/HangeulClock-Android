//
//  MenuButtonView.m
//  Yap_Hangul
//
//  Created by Canapio(Crossys) on 2014. 10. 14..
//  Copyright (c) 2014년 canapio. All rights reserved.
//

#import "MenuButtonView.h"
#define TOUCH_AREA_GAP 12.f

@interface MenuButtonView () {
    UIView *bgColorview ;
}

@property (nonatomic) BOOL touchIn;
@end

@implementation MenuButtonView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        bgColorview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        bgColorview.backgroundColor = [UIColor whiteColor];
        [self addSubview:bgColorview];
        bgColorview.alpha = 0;
        
        
//        self.backgroundColor = [UIColor colorWithRed:1.f green:.5f blue:.4f alpha:.7f];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    bgColorview.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.touchAble = YES;
    self.touchIn = YES;
    [self touchOnAnimation];
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchLocation = [[touches anyObject] locationInView:self];
    if (self.touchIn) {
        // 나가는 경우 찾기
        if (!CGRectContainsPoint(CGRectMake(-TOUCH_AREA_GAP,
                                            -TOUCH_AREA_GAP,
                                            self.frame.size.width+TOUCH_AREA_GAP*2,
                                            self.frame.size.height+TOUCH_AREA_GAP*2), touchLocation)) {
            self.touchIn = NO;
            [self touchOffAnimation];
        }
    } else {
        // 들어가는 경우 찾기
        if (CGRectContainsPoint(CGRectMake(-TOUCH_AREA_GAP,
                                           -TOUCH_AREA_GAP,
                                           self.frame.size.width+TOUCH_AREA_GAP*2,
                                           self.frame.size.height+TOUCH_AREA_GAP*2), touchLocation)) {
            self.touchIn = YES;
            [self touchOnAnimation];
        }
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchIn) {
        [self touchOffAnimation];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.touchIn) {
        [self touchOffAnimation];
    }
    
    if (self.touchIn && self.touchAble) {
        [self.delegate clickMenu:self];
    }
    
    self.touchIn = NO;
}

- (void) touchOnAnimation {
    [UIView animateWithDuration:.15f animations:^{
        bgColorview.alpha = .22f;
    }];
}
- (void) touchOffAnimation {
    [UIView animateWithDuration:.24f animations:^{
        bgColorview.alpha = 0.f;
    }];
}

@end
