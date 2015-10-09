//
//  FWLabelView.m
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 11..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//
#import "UIView+EasingFunctions.h"
#import "easing.h"

#import "FWLabelView.h"

#define FADETO_TAG 231
#define MOVETO_TAG 232

#define LABEL_WIDTHRATE .9f
#define LABEL_HEIGHTRATE 1.1f

@interface FWLabelView () {
    
}
@property (nonatomic, retain) NSMutableArray *originalTextLabelArray;

@property (nonatomic, retain) NSMutableArray *oldLabelArray;
@property (nonatomic, retain) NSMutableArray *waitingLabelArray;
@end


@implementation FWLabelView

- (id) initWithFontName:(NSString *)fn fontSize:(CGFloat)fs width:(CGFloat)w {
    if (self = [super initWithFrame:CGRectMake(0, 0, w, fs*LABEL_WIDTHRATE)]) {
        self.fontName = fn;
        self.fontSize = fs;
        self.width = w;
        
//        self.backgroundColor = [UIColor colorWithRed:1.f green:.2f blue:.2f alpha:.4f];
        if (!self.oldLabelArray) self.oldLabelArray = [NSMutableArray array];
        if (!self.waitingLabelArray) self.waitingLabelArray = [NSMutableArray array];
    }
    return self;
}


- (void) changeTextArray:(NSArray *)textArray {
    // textArray = @[@"이천십사년", @"구월", @"이십육일"];
    BOOL isInit = NO;
    if (!self.originalTextLabelArray) {
        self.originalTextLabelArray = [NSMutableArray array];
        isInit = YES;
    }
    NSMutableArray *willRemoveLabelArray = [NSMutableArray array];
    
    
    // 레이블 View위에 만들기
    // 레이블 array에 넣기
    
    // 레이블 View에서 지우기
    // 레이블 array에서 빼기
    // 레이블 지우기 애니메이션
    for (int i=0; i<self.originalTextLabelArray.count || i<textArray.count; i++) {
        
        NSMutableArray *labelArray = nil;
        NSString *willText = nil;
        if (i<self.originalTextLabelArray.count) labelArray = self.originalTextLabelArray[i];
        if (i<textArray.count) willText = textArray[i];
        if (willText && !willText.length) assert(0);
        
        
        
        
        if (labelArray && !willText) {
            // labelArray 다 지우기
            
            [willRemoveLabelArray addObjectsFromArray:labelArray];
            [self.originalTextLabelArray removeObject:labelArray];
            
        } else if (!labelArray && willText) {
            // 새로 labelArray 만들어서 self.originalTextLabelArray에 넣기
            
            labelArray = [NSMutableArray arrayWithCapacity:willText.length];
            for (int j=0; j<willText.length; j++) {
                NSString *oneText = [NSString stringWithFormat:@"%@", [willText substringWithRange:NSMakeRange(j, 1)]];
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -self.fontSize*LABEL_HEIGHTRATE/2.f, self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE)];
                label.text = oneText;
                label.font = [UIFont fontWithName:self.fontName size:self.fontSize];
                label.textColor = [UIColor whiteColor];
                label.alpha = 0.f;
                label.backgroundColor = [UIColor clearColor];
                [self addSubview:label];
                
//                [UILabel labelWithString:oneText fontName:self.fontName fontSize:self.fontSize];
//                label.alpha = 0.f;
//                [self addSubview:label];
                
                [labelArray addObject:label];
            }
            [self.originalTextLabelArray addObject:labelArray];
            
        } else if (labelArray && willText) {
            //            NSLog(@"-=-=-=-=-=-=-=-=-=-=-=-=-=-");
            //            NSLog(@"willText:%@", willText);
            for (UILabel *l in labelArray) NSLog(@"%@", l.text);
            
            // 비교 및 수정
            NSMutableArray *willLabelArray = [NSMutableArray array];
            NSUInteger maxCount = labelArray.count;//(labelArray.count>willText.length)?(labelArray.count):(willText.length);
            
            for (int j=0; j<maxCount; j++) {
                NSString *willOneText = nil;
                UILabel *oldLabel = nil;
                if (j<willText.length) willOneText = [willText substringWithRange:NSMakeRange(willText.length-j-1, 1)];
                if (j<labelArray.count) oldLabel = labelArray[labelArray.count-j-1];
                //                NSLog(@"비교 : [%@->%@]", oldLabel.text, willOneText);
                
                if (willOneText && oldLabel) {
                    if ([oldLabel.text isEqualToString:willOneText]) {
                        [willLabelArray insertObject:oldLabel atIndex:0];
                    } else {
                        [willRemoveLabelArray addObject:oldLabel];
//                        oldLabel = [UILabel labelWithString:willOneText fontName:self.fontName fontSize:self.fontSize];
//                        oldLabel.alpha = 0;
//                        oldLabel.position = CGPointZero;
//                        [self addSubview:oldLabel];
                        
                        oldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -self.fontSize*LABEL_HEIGHTRATE/2.f, self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE)];
                        oldLabel.text = willOneText;
                        oldLabel.font = [UIFont fontWithName:self.fontName size:self.fontSize];
                        oldLabel.textColor = [UIColor whiteColor];
                        oldLabel.backgroundColor = [UIColor clearColor];
                        oldLabel.alpha = 0;
                        [self addSubview:oldLabel];
                        [willLabelArray insertObject:oldLabel atIndex:0];
                    }
                } else if (willOneText && !oldLabel) {
//                    oldLabel = [UILabel labelWithString:willOneText fontName:self.fontName fontSize:self.fontSize];
//                    oldLabel.alpha = 0;
//                    oldLabel.position = CGPointZero;
//                    [self addSubview:oldLabel];
                    
                    oldLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -self.fontSize*LABEL_HEIGHTRATE/2.f, self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE)];
                    oldLabel.text = willOneText;
                    oldLabel.font = [UIFont fontWithName:self.fontName size:self.fontSize];
                    oldLabel.textColor = [UIColor whiteColor];
                    oldLabel.backgroundColor = [UIColor clearColor];
                    oldLabel.alpha = 0;
                    oldLabel.textColor = [UIColor whiteColor];
                    [self addSubview:oldLabel];
                    [willLabelArray insertObject:oldLabel atIndex:0];
                } else if (!willOneText && oldLabel) {
                    [willRemoveLabelArray addObject:oldLabel];
                } else {
                    //????
                    assert(0);
                }
                
            }
            self.originalTextLabelArray[i] = willLabelArray;
            
        } else {
            // 뭐야 이거?
            //
            NSLog(@"??뭐야 어쩌라는거야??");
            assert(0);
        }
    }
    
    
    
    
    
    //  extraGap 계산준비
    float extraGap = 0.f;
    float spaceGapRate = .5f;
    float targetWitdh = self.width;
    targetWitdh -= self.fontSize*LABEL_WIDTHRATE;
    //    targetWitdh -= (self.fontSize*.8f)*(self.originalTextLabelArray.count-1);
    
    float totalLableCount = 0.f;
    for (NSArray *labelArray in self.originalTextLabelArray) {
        totalLableCount += labelArray.count;
        totalLableCount += spaceGapRate;
    }
    totalLableCount--;
    extraGap = targetWitdh/(totalLableCount-spaceGapRate)-self.fontSize*LABEL_WIDTHRATE;
    
    
    
    
    
    float startDelay = .1f;
    float endDelay = 2.5f;
    float duration = 1.7f;
    NSMutableArray *delayArray = [NSMutableArray arrayWithCapacity:totalLableCount];
    for (int i=0; i<totalLableCount; i++) {
        [delayArray addObject:[NSNumber numberWithFloat:startDelay+((endDelay-startDelay)/(totalLableCount-1))*i]];
    }
    
    // extraGap를 이용한 MoveTo애니메이션 및 FadeTo애니메이션
    // 모든 label에 적용
    // MoveTo Action, FadeTo Action에 Tag달고 관리하기
    if (isInit) {
        float x = 0;//self.fontSize*LABEL_WIDTHRATE/2.f;
        for (NSArray *labelArray in self.originalTextLabelArray) {
            for (UILabel *label in labelArray) {
//                if ([label numberOfRunningActions]) {
//                    [label stopActionByTag:MOVETO_TAG];
//                    [label stopActionByTag:FADETO_TAG];
//                }
                
//                label.position = CGPointMakex, 0);
                label.frame = CGRectMake(x, -self.fontSize*LABEL_HEIGHTRATE/2.f, self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                // <#랜덤#>
//                CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:duration opacity:255.f];
//                fadeTo.tag = FADETO_TAG;
                if (delayArray.count==0) assert(0);
                int index = arc4random()%delayArray.count;
//                CCSequence *ft = [CCSequence actions:[CCDelayTime actionWithDuration:[delayArray[index] floatValue]], fadeTo, nil];
//                ft.tag = FADETO_TAG;
//                [label runAction:ft];
                [UIView animateWithDuration:duration delay:[delayArray[index] floatValue] options:UIViewAnimationOptionTransitionNone animations:^{
                    label.alpha = 1.f;
                } completion:nil];
                
                if (delayArray.count!=1) [delayArray removeObjectAtIndex:index];
                
                x+=self.fontSize*LABEL_WIDTHRATE;
                x+=extraGap;
            }
            x+=self.fontSize*LABEL_WIDTHRATE*spaceGapRate;
            x+=extraGap*spaceGapRate;
        }
        x+=self.fontSize*LABEL_WIDTHRATE/2.f;
    } else {
        //        if (1) {
        
        float x = 0;//self.fontSize*LABEL_WIDTHRATE/2.f;
        for (NSArray *labelArray in self.originalTextLabelArray) {
            for (UILabel *label in labelArray) {
//                if ([label numberOfRunningActions]) {
//                    [label stopActionByTag:MOVETO_TAG];
//                    [label stopActionByTag:FADETO_TAG];
//                }
                
                if (CGPointEqualToPoint(label.frame.origin, CGPointMake(0, -self.fontSize*LABEL_HEIGHTRATE/2.f))) {
//                    label.position = CGPointMakex, 0);
                    label.frame = CGRectMake(x, -self.frame.size.height/2.f, self.frame.size.width, self.frame.size.height);
                }
//                CCMoveTo *moveTo = [CCMoveTo actionWithDuration:duration position:CGPointMakex, 0)];
//                moveTo.tag = MOVETO_TAG;
//                // <#랜덤#>
//                CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:duration opacity:255.f];
//                fadeTo.tag = FADETO_TAG;
                if (delayArray.count==0) assert(0);
                int index = arc4random()%delayArray.count;
//
//                CCSpawn *ft = [CCSpawn actions:
//                               [CCEaseInOut actionWithAction:moveTo rate:3.f],
//                               [CCSequence actions:[CCDelayTime actionWithDuration:[delayArray[index] floatValue]], fadeTo, nil],
//                               nil];
                //                    CCSequence *ft = [CCSequence actions:[CCDelayTime actionWithDuration:[delayArray[index] floatValue]], [CCSpawn actions:fadeTo, moveTo, nil], nil];
//                ft.tag = FADETO_TAG;
//                if ([label numberOfRunningActions]) [label stopAllActions];
//                [label runAction:ft];
                [UIView animateWithDuration:duration animations:^{
                    [label setEasingFunction:ExponentialEaseInOut forKeyPath:@"center"];
                    label.frame = CGRectMake(x, -self.fontSize*LABEL_HEIGHTRATE/2.f, label.frame.size.width, label.frame.size.height);
                    
                } completion:^(BOOL finished) {
                    [label removeEasingFunctionForKeyPath:@"center"];
                }];
                [UIView animateWithDuration:duration delay:[delayArray[index] floatValue] options:UIViewAnimationOptionTransitionNone animations:^{
                    label.alpha = 1.f;
                } completion:nil];
                if (delayArray.count!=1) [delayArray removeObjectAtIndex:index];
                
                x+=self.fontSize*LABEL_WIDTHRATE;
                x+=extraGap;
            }
            x+=self.fontSize*LABEL_WIDTHRATE*spaceGapRate;
            x+=extraGap*spaceGapRate;
        }
        x+=self.fontSize*LABEL_WIDTHRATE/2.f;
        //        }
    }
    
    
    
    // Remove Labels
    for (UILabel *label in willRemoveLabelArray) {
//        if ([label numberOfRunningActions]) [label stopActionByTag:FADETO_TAG];
        // FadeTo -> 0.f;
        //
        //
        //
        // <#랜덤#>
//        CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:duration opacity:0.f];
//        [label runAction:[CCSequence actions:fadeTo, [CCCallBlock actionWithBlock:^{
//            // removeFromParanet
//            [label removeFromParentAndCleanup:YES];
//        }], nil]];
        
        [UIView animateWithDuration:duration animations:^{
            label.alpha = 0;
        } completion:^(BOOL finished) {
            [label removeFromSuperview];
        }];
        
    }
}



- (float) changeText:(NSString *)text {
    
    
    return 0.f;
}
- (float) changeText:(NSString *)text width:(CGFloat)w {
    
    return 0.f;
}






- (void) removeAnimationWithBlock:(void(^)())block {

    [UIView animateWithDuration:.3f animations:^{
        for (int i=0; i<self.originalTextLabelArray.count; i++) {
            for (UILabel *label in self.originalTextLabelArray[i]) {
                label.alpha = 0.f;
            }
        }
    } completion:^(BOOL finished) {
        if (block) block();
    }];
}


@end
