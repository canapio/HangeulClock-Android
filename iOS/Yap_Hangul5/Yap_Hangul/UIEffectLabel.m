//
//  UIEffectLabel.m
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 10..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "UIView+EasingFunctions.h"
#import "easing.h"


#import "UIEffectLabel.h"
#define CHANGE_ANIMATION_DELAY .8f
#define FRAME_HEIGHT_RATE 1.f//(1.5f)

@interface UIEffectLabel () {
    float width;
}

@property (nonatomic) CGFloat fontSize;
@end

@implementation UIEffectLabel

- (id) initWithString:(NSString*)str fontName:(NSString*)name fontSize:(CGFloat)size init:(BOOL)init Opacity:(CGFloat)o {
    return [self initWithString:str
                       fontName:name
                       fontSize:size
                     TotalDelay:2.f
                    RandomDelay:1.f
                          Delay:.3f
                        Opacity:o];
}
- (id) initSearchStringWithString:(NSString*)str fontName:(NSString*)name fontSize:(CGFloat)size Opacity:(CGFloat)o {
    return [self initWithString:str
                       fontName:name
                       fontSize:size
                     TotalDelay:.8f
                    RandomDelay:.6f
                          Delay:0.f
                        Opacity:o];
}
- (id) initWithString:(NSString*)str fontSize:(CGFloat)size TotalDelay:(CGFloat)td RandomDelay:(CGFloat)rd Delay:(CGFloat)dl Opacity:(CGFloat)o {
    return [self initWithString:str
                       fontName:[UIFont systemFontOfSize:size].fontName
                       fontSize:size
                     TotalDelay:td
                    RandomDelay:rd
                          Delay:dl
                        Opacity:o];
}
- (id) initWithString:(NSString*)str
             fontName:(NSString*)fontName
             fontSize:(CGFloat)size
           TotalDelay:(CGFloat)td
          RandomDelay:(CGFloat)rd
                Delay:(CGFloat)dl
              Opacity:(CGFloat)o {
    if (self = [super init]) {
        self.charLabelArray = [[NSMutableArray alloc] initWithCapacity:str.length];
        self.labelTitle = [NSString stringWithString:str];
        self.fontSize = size;
        // label 들 만들고
        float x = 0.f;
        
        for (int i=0; i<str.length; i++) {
            UILabel *l = [[UILabel alloc] init];
            l.font = [UIFont fontWithName:fontName size:size];
            l.text = [str substringWithRange:NSMakeRange(i, 1)];
            l.backgroundColor = [UIColor clearColor];
            l.textColor = [UIColor whiteColor];
            BOOL isUp = arc4random()%2;
            if (isUp) {
                l.frame = CGRectMake(x, -self.fontSize/2.f-10.f, self.fontSize, self.fontSize*FRAME_HEIGHT_RATE);
            } else {
                l.frame = CGRectMake(x, -self.fontSize/2.f+10.f, self.fontSize, self.fontSize*FRAME_HEIGHT_RATE);
            }
            
            l.alpha = 0;
            [self addSubview:l];
            
            [self.charLabelArray addObject:l];
        
            x += l.frame.size.width;

        }
        width = x;
        
        
        [self makeInitAnimationWithTotalDelay:td RadDelay:rd Delay:dl Opacity:o];
        
    }
    return self;
}

- (CGRect)frame {
    return CGRectMake([super frame].origin.x, [super frame].origin.y, [self getWidth], self.fontSize*FRAME_HEIGHT_RATE);
}


- (void) makeInitAnimationWithTotalDelay:(float)td RadDelay:(float)rd Delay:(float)dl Opacity:(float)o {
    
    
    if (self.charLabelArray) {
        static float ddd = 0.f;
        //        ddd += .3f;
//        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveActionWithLabelInfo:) object:nil];
        for (UILabel *l in self.charLabelArray) {
            BOOL isUp = arc4random()%2;
            if (isUp) l.frame = CGRectMake(l.frame.origin.x, -self.fontSize/2.f-10.f, l.frame.size.width, l.frame.size.height);
            else l.frame = CGRectMake(l.frame.origin.x, -self.fontSize/2.f+10.f, l.frame.size.width, l.frame.size.height);
            
            
            
            
            
            CGFloat totalDelay, radDelay, delay;
            totalDelay = td;
            if (rd>0.01f) radDelay = (float)(arc4random()%((int)(rd*100.f)))/100.f;
            else radDelay = 0.f;
            delay=dl;
            
            float afterDelay = (delay+radDelay+ddd)*CHANGE_ANIMATION_DELAY;

            float fadeDelay = ((totalDelay-radDelay)/1.2f)*CHANGE_ANIMATION_DELAY;
            float moveDelay = (totalDelay-radDelay)*CHANGE_ANIMATION_DELAY;

            [UIView animateWithDuration:moveDelay delay:afterDelay options:UIViewAnimationOptionTransitionNone animations:^{
                [l setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                l.frame = CGRectMake(l.frame.origin.x, -self.fontSize/2.f, l.frame.size.width, l.frame.size.height);
            } completion:^(BOOL finished) {
                [l removeEasingFunctionForKeyPath:@"center"];
            }];
            [UIView animateWithDuration:fadeDelay delay:afterDelay options:UIViewAnimationOptionTransitionNone animations:^{
                l.alpha = o;
            } completion:nil];

        }
    }
}
- (void) moveActionWithLabelInfo:(NSDictionary *)labelInfo {
    UILabel *l = labelInfo[@"label"];
    CGFloat moveDelay = [labelInfo[@"moveDelay"] floatValue];
    CGFloat fadeDelay = [labelInfo[@"fadeDelay"] floatValue];
    [UIView animateWithDuration:moveDelay animations:^{
        [l setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
        l.frame = CGRectMake(l.frame.origin.x, -self.fontSize/2.f, l.frame.size.width, l.frame.size.height);
    } completion:^(BOOL finished) {
        [l removeEasingFunctionForKeyPath:@"center"];
    }];
    [UIView animateWithDuration:fadeDelay animations:^{
        l.alpha = 1.f;
    }];
}




#pragma mark - REMOVE


- (void) removeAnimateWithIsSearch:(BOOL)isSearch {
    if (isSearch) {
        [self removeAnimateWithTotalDelay:.4f RaddomDelay:0.01f];
    }
    else {
        [self removeAnimateWithTotalDelay:.4f RaddomDelay:0.01f];
    }
}
- (void) removeAnimateWithTotalDelay:(CGFloat)td RaddomDelay:(CGFloat)rd {

    if (self.charLabelArray) {
        
        for (UILabel *l in self.charLabelArray) {
            BOOL isUp = arc4random()%2;
            
            CGFloat moveY = 10.f;
            if (!isUp) moveY = -moveY;
            
            if (l.frame.origin.y>0.01f-self.fontSize/2.f) moveY = fabsf(moveY);
            else if (l.frame.origin.y<-0.01f-self.fontSize/2.f) moveY = -fabsf(moveY);
            
            CGFloat radDelay;
            if (rd>.01f) radDelay = (float)(arc4random()%((int)rd*100))/100.f;
            else radDelay = 0.f;
            

            
            [l removeEasingFunctionForKeyPath:@"center"];
            if ([self.charLabelArray indexOfObject:l]==self.charLabelArray.count-1) {
                [UIView animateWithDuration:(td-radDelay)*CHANGE_ANIMATION_DELAY delay:radDelay options:UIViewAnimationOptionTransitionNone animations:^{
                    l.frame = CGRectMake(l.frame.origin.x, l.frame.origin.y+moveY, l.frame.size.width, l.frame.size.height);
                    l.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }
            else {
                [UIView animateWithDuration:(td-radDelay)*CHANGE_ANIMATION_DELAY delay:radDelay options:UIViewAnimationOptionTransitionNone animations:^{
                    l.frame = CGRectMake(l.frame.origin.x, l.frame.origin.y+moveY, l.frame.size.width, l.frame.size.height);
                    l.alpha = 0.f;
                } completion:nil];
            }
        }
    }
}
- (void) fadeOutAnimation:(CGFloat)dur {
    if (self.charLabelArray) {
        
        for (UILabel *l in self.charLabelArray) {
            
            [l removeEasingFunctionForKeyPath:@"center"];
            if ([self.charLabelArray indexOfObject:l]==self.charLabelArray.count-1) {
                [UIView animateWithDuration:dur*CHANGE_ANIMATION_DELAY animations:^{
                    l.alpha = 0.f;
                } completion:^(BOOL finished) {
                    [self removeFromSuperview];
                }];
            }
            else {
                [UIView animateWithDuration:dur*CHANGE_ANIMATION_DELAY animations:^{
                    l.alpha = 0.f;
                }];
            }
        }
    }
}


- (float) getWidth {
    if (self.charLabelArray.count==0) return 0.f;
    else if (self.charLabelArray.count>=1) {
        UILabel *l1 = self.charLabelArray[0];
        UILabel *l2 = [self.charLabelArray lastObject];
        return (l2.frame.origin.x+l2.frame.size.width-l1.frame.origin.x);
    }
    else {
        return 0.f;
    }
}

@end
