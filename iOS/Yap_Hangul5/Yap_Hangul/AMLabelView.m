//
//  AMLabelView.m
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 11..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "UIView+EasingFunctions.h"
#import "easing.h"

#import "AMLabelView.h"

#define NEW_STRING @"new string"
//#define OLD @"old"
#define NEW_LABEL @"new label"
#define OLD_LABEL @"old label"


#define ANI_DONTMOVE 1
#define ANI_FADEIN 2
#define ANI_FADEOUT 3


#define LABEL_WIDTHRATE .9f
#define LABEL_HEIGHTRATE 1.2f//1.2f

#define LABEL_OFFSET_Y (0.7f)

#define COLOR_BG_LABEL [UIColor clearColor]//[UIColor colorWithRed:.2f green:1.f blue:.2f alpha:.4f]
#define COLOR_BG_LABELBG [UIColor clearColor]//[UIColor colorWithRed:1.f green:.2f blue:.2f alpha:.4f]


@interface AMLabelView () {
    int labelCount ;
}

@property (nonatomic, retain) NSMutableArray *oldLabelArray;
@property (nonatomic, retain) NSMutableArray *waitingLabelArray;
@end

@implementation AMLabelView


- (void) setLabelCount:(int)lc {
    labelCount = lc;
}
- (id) initWithFontName:(NSString*)name fontSize:(CGFloat)size extraGap:(CGFloat)gap {
    if (self = [super init]) {
        labelCount = 0;
        self.fontSize = size;
        self.fontName = name;
        self.labelGap = gap;
        //        [self changeText:string];
        //
        //
        //
        //
        self.backgroundColor = COLOR_BG_LABELBG;
        self.clipsToBounds = NO;
    }
    return self;
}
- (id) initWithFontName:(NSString*)name fontSize:(CGFloat)size {
    return [self initWithFontName:name fontSize:size extraGap:0];
}



- (float) changeText:(NSString *)text {
    if (!self.waitingLabelArray) self.waitingLabelArray = [NSMutableArray array];
    if (!self.oldLabelArray) self.oldLabelArray = [NSMutableArray array];
    
    
    if (labelCount) {
        if (text.length<labelCount) {
            for (int i=0; i<labelCount-text.length+1; i++) {
                text = [NSString stringWithFormat:@" %@", text];
            }
        }
    }
    NSMutableArray *newStringArray = [NSMutableArray arrayWithCapacity:text.length];
    
    for (int i=0; i<text.length; i++) {
        [newStringArray addObject:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    int maxCount = (int)((self.oldLabelArray.count>newStringArray.count)?self.oldLabelArray.count:newStringArray.count);
    
    
    
    NSMutableArray *actionInfoArray = [NSMutableArray arrayWithCapacity:maxCount];
    for (int i=0; i<maxCount; i++) {
        NSMutableDictionary *actionInfo = [NSMutableDictionary dictionary];
        if (i<newStringArray.count) {
            actionInfo[NEW_STRING] = newStringArray[i];
        }
        if (i<self.oldLabelArray.count) {
            actionInfo[OLD_LABEL] = self.oldLabelArray[i];
        }
        [actionInfoArray addObject:actionInfo];
    }
    
    
    
    for (int i=(int)actionInfoArray.count-1; i>=0; i--) {
        NSMutableDictionary *actionInfo = actionInfoArray[i];
        
        if (actionInfo[OLD_LABEL] && !actionInfo[NEW_STRING]) {
            // actionInfo[OLD_LABEL] 지우기 애니메이션
            // 다다음 for문에서 지울것임
        } else {
            if (actionInfo[NEW_STRING]) {
                NSString *newString = actionInfo[NEW_STRING];
                UILabel *willMoveOldLabel = nil;
                if (actionInfo[OLD_LABEL]) {    // 이전 레이블이 있다면
                    willMoveOldLabel = actionInfo[OLD_LABEL];
                    if ([willMoveOldLabel.text isEqualToString:newString]) {
                        // willMoveOldLabel 안움직임
                        actionInfo[NEW_LABEL] = willMoveOldLabel;
                        willMoveOldLabel.tag = ANI_DONTMOVE;
                        
                        [actionInfo removeObjectForKey:OLD_LABEL];
                    } else {
                        
                        
                        if (i==0) {
                            // newString을 그냥 내리기
                            // actionInfo[NEW_LABEL] =
                            UILabel *newLabel = [self getNewLabel];
                            newLabel.alpha = 0;
                            newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                        -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                        self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                            newLabel.text = newString;
                            actionInfo[NEW_LABEL] = newLabel;
                        } else {
                            NSMutableDictionary *beforeActionInfo = actionInfoArray[i-1];
                            //                            NSLog(@"beforeActionInfo:%@", beforeActionInfo);
                            if (!beforeActionInfo[OLD_LABEL]) {
                                // newString 만들어서 그냥 내리기
                                // actionInfo[NEW_LABEL] =
                                UILabel *newLabel = [self getNewLabel];
                                newLabel.alpha = 0;
                                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                            -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                            self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                newLabel.text = newString;
                                actionInfo[NEW_LABEL] = newLabel;
                            } else {
                                UILabel *beforeOldLabel = beforeActionInfo[OLD_LABEL];
                                if ([beforeOldLabel.text isEqualToString:newString]) {
                                    actionInfo[NEW_LABEL] = beforeOldLabel;
                                    [beforeActionInfo removeObjectForKey:OLD_LABEL];
                                    
                                    beforeOldLabel.tag = ANI_FADEIN;
                                } else {
                                    // newString을 그냥 내리기
                                    // actionInfo[NEW_LABEL] =
                                    UILabel *newLabel = [self getNewLabel];
                                    newLabel.alpha = 0;
                                    newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                                -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                                self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                    newLabel.text = newString;
                                    actionInfo[NEW_LABEL] = newLabel;
                                }
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                } else {    // 이전 레이블이 없다면
                    if (i==0) {
                        // newString을 그냥 내리기
                        // actionInfo[NEW_LABEL] =
                        UILabel *newLabel = [self getNewLabel];
                        newLabel.alpha = 0;
                        newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                    -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                    self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                        newLabel.text = newString;
                        actionInfo[NEW_LABEL] = newLabel;
                    } else {
                        NSMutableDictionary *beforeActionInfo = actionInfoArray[i-1];
                        //                        NSLog(@"beforeActionInfo:%@", beforeActionInfo);
                        if (!beforeActionInfo[OLD_LABEL]) {
                            // newString 만들어서 그냥 내리기
                            // actionInfo[NEW_LABEL] =
                            UILabel *newLabel = [self getNewLabel];
                            newLabel.alpha = 0;
                            newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                        -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                        self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                            newLabel.text = newString;
                            actionInfo[NEW_LABEL] = newLabel;
                        } else {
                            UILabel *beforeOldLabel = beforeActionInfo[OLD_LABEL];
                            if ([beforeOldLabel.text isEqualToString:newString]) {
                                actionInfo[NEW_LABEL] = beforeOldLabel;
                                [beforeActionInfo removeObjectForKey:OLD_LABEL];
                                
                                beforeOldLabel.tag = ANI_FADEIN;
                            } else {
                                // newString을 그냥 내리기
                                // actionInfo[NEW_LABEL] =
                                UILabel *newLabel = [self getNewLabel];
                                newLabel.alpha = 0;
                                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                            -self.fontSize*LABEL_HEIGHTRATE/2.f-self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                                            self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                newLabel.text = newString;
                                actionInfo[NEW_LABEL] = newLabel;
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    for (int i=0; i<actionInfoArray.count; i--) {
        UILabel *label = actionInfoArray[i][NEW_LABEL];
        if (actionInfoArray[i][NEW_STRING]) assert(label);
    }
    
    
    
    float width = -10.f;
    
    float startTime = 0.;
    float aniDelayTime = ANI_TEXT_DELAY;
    float aniIntervalGap = ANI_TEXT_INTERVAL;
    
    //    NSLog(@"0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0");
    [self.oldLabelArray removeAllObjects];
    for (int i=(int)actionInfoArray.count-1; i>=0; i--) {
        UILabel *newLabel = actionInfoArray[i][NEW_LABEL];
        UILabel *removeLabel = actionInfoArray[i][OLD_LABEL];
        
        
        //        NSLog(@"i=====:%i", i);
        if (newLabel) {
            //            NSLog(@"new string : %@", newLabel.text);
//            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:aniDelayTime position:CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0)];
//            CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:aniDelayTime opacity:255.f*1.f];
//            CCActionInterval *action = [CCSpawn actions:EASEOUT_ACTION(moveTo), EASEOUT_ACTION(fadeTo), nil];
//            [newLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:startTime], action, nil]];
            [UIView animateWithDuration:aniDelayTime*.5f delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                newLabel.alpha = 1.f;
            } completion:nil];
            [UIView animateWithDuration:aniDelayTime delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                [newLabel setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap), -newLabel.frame.size.height/2.f, newLabel.frame.size.width, newLabel.frame.size.height);
            } completion:^(BOOL finished) {
                [newLabel removeEasingFunctionForKeyPath:@"center"];
            }];
            
            [self.oldLabelArray insertObject:newLabel atIndex:0];
            
            
            if (width<0.f) width = (i+1)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap);
        }
        if (removeLabel) {
            //            NSLog(@"remove string : %@", removeLabel.text);
//            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:aniDelayTime position:CGPointMake((float)i)*(removeLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), -removeLabel.fontSize*LABEL_WIDTHRATE*.7f)];
//            CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:aniDelayTime opacity:0.f];
//            CCActionInterval *action = [CCSpawn actions:EASEOUT_ACTION(moveTo), EASEOUT_ACTION(fadeTo), nil];
//            [removeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:startTime], action, [CCCallBlock actionWithBlock:^{
//                [self removeToWaitingWithLabel:removeLabel];
//            }], nil]];
            [UIView animateWithDuration:aniDelayTime*.5f delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                removeLabel.alpha = 0;
            } completion:nil];
            [UIView animateWithDuration:aniDelayTime delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                [removeLabel setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                
                removeLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                               -newLabel.frame.size.height/2.f+self.fontSize*LABEL_WIDTHRATE*LABEL_OFFSET_Y,
                                               removeLabel.frame.size.width, removeLabel.frame.size.height);
            } completion:^(BOOL finished) {
                [removeLabel removeEasingFunctionForKeyPath:@"center"];
                [self removeToWaitingWithLabel:removeLabel];
            }];
        }
        
        
        startTime+=aniIntervalGap;
    }
    
    
    
//    if (0 && DEBUG) {
//        if (!debugLayer) {
//            debugLayer = [CCLayerColor layerWithColor:ccc4(255, 190, 190, .2f*255.f) width:width height:width/newStringArray.count];
//            debugLayer.position = CGPointMake0, -debugLayer.frame.size.height/2.f);
//            [self addSubview:debugLayer];
//        }
//        debugLayer.contentSize = CGSizeMake(width, debugLayer.frame.size.height);
//    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.fontSize/*width/newStringArray.count*/);
    if (width>0) return width-self.labelGap;
    else return width;
}
- (UILabel *) getNewLabel {
    UILabel *l = nil;
    if (self.waitingLabelArray.count) {
        l = self.waitingLabelArray[0];
        [self.waitingLabelArray removeObject:l];
    } else {
        //        NSLog(@"get new label !!!");
        l = [[UILabel alloc] initWithFrame:CGRectMake(0, -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                      self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE)];
        l.text = @"";
        l.textColor = [UIColor whiteColor];
        l.backgroundColor = [UIColor clearColor];
        l.alpha = 0.f;
        [self addSubview:l];
    }
    l.font = [UIFont fontWithName:self.fontName size:self.fontSize];
    
    l.opaque = NO;
    l.clipsToBounds = NO;
    l.layer.masksToBounds = YES;
    l.backgroundColor = COLOR_BG_LABEL;
    return l;
}
- (void) removeToWaitingWithLabel:(UILabel *)l {
    l.alpha = 0;
    [self.waitingLabelArray addObject:l];
}




#pragma mark - 애니메이션 없이 텍스트 바꾸기
- (float) changeTextWithOutAnimation:(NSString *)text {
    if (!self.waitingLabelArray) self.waitingLabelArray = [NSMutableArray array];
    if (!self.oldLabelArray) self.oldLabelArray = [NSMutableArray array];
    
    //    NSLog(@"labelCount:%i", labelCount);
    if (labelCount) {
        if (text.length<labelCount) {
            for (int i=0; i<labelCount-text.length+1; i++) {
                text = [NSString stringWithFormat:@" %@", text];
            }
        }
    }
    NSMutableArray *newStringArray = [NSMutableArray arrayWithCapacity:text.length];
    
    for (int i=0; i<text.length; i++) {
        [newStringArray addObject:[text substringWithRange:NSMakeRange(i, 1)]];
    }
    
    int maxCount = (int)((self.oldLabelArray.count>newStringArray.count)?self.oldLabelArray.count:newStringArray.count);
    
    
    
    NSMutableArray *actionInfoArray = [NSMutableArray arrayWithCapacity:maxCount];
    for (int i=0; i<maxCount; i++) {
        NSMutableDictionary *actionInfo = [NSMutableDictionary dictionary];
        if (i<newStringArray.count) {
            actionInfo[NEW_STRING] = newStringArray[i];
        }
        if (i<self.oldLabelArray.count) {
            actionInfo[OLD_LABEL] = self.oldLabelArray[i];
        }
        [actionInfoArray addObject:actionInfo];
    }
    
    
    
    for (int i=(int)actionInfoArray.count-1; i>=0; i--) {
        NSMutableDictionary *actionInfo = actionInfoArray[i];
        
        if (actionInfo[OLD_LABEL] && !actionInfo[NEW_STRING]) {
            // actionInfo[OLD_LABEL] 지우기 애니메이션
            // 다다음 for문에서 지울것임
        } else {
            if (actionInfo[NEW_STRING]) {
                NSString *newString = actionInfo[NEW_STRING];
                UILabel *willMoveOldLabel = nil;
                if (actionInfo[OLD_LABEL]) {    // 이전 레이블이 있다면
                    willMoveOldLabel = actionInfo[OLD_LABEL];
                    if ([willMoveOldLabel.text isEqualToString:newString]) {
                        // willMoveOldLabel 안움직임
                        actionInfo[NEW_LABEL] = willMoveOldLabel;
                        willMoveOldLabel.tag = ANI_DONTMOVE;
                        
                        [actionInfo removeObjectForKey:OLD_LABEL];
                    } else {
                        
                        
                        if (i==0) {
                            // newString을 그냥 내리기
                            // actionInfo[NEW_LABEL] =
                            UILabel *newLabel = [self getNewLabel];
                            newLabel.alpha = 0;
//                            newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                            newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                        -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                        self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                            newLabel.text = newString;
                            actionInfo[NEW_LABEL] = newLabel;
                        } else {
                            NSMutableDictionary *beforeActionInfo = actionInfoArray[i-1];
                            //                            NSLog(@"beforeActionInfo:%@", beforeActionInfo);
                            if (!beforeActionInfo[OLD_LABEL]) {
                                // newString 만들어서 그냥 내리기
                                // actionInfo[NEW_LABEL] =
                                UILabel *newLabel = [self getNewLabel];
                                newLabel.alpha = 0;
//                                newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                            -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                            self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                newLabel.text = newString;
                                actionInfo[NEW_LABEL] = newLabel;
                            } else {
                                UILabel *beforeOldLabel = beforeActionInfo[OLD_LABEL];
                                if ([beforeOldLabel.text isEqualToString:newString]) {
                                    actionInfo[NEW_LABEL] = beforeOldLabel;
                                    [beforeActionInfo removeObjectForKey:OLD_LABEL];
                                    
                                    beforeOldLabel.tag = ANI_FADEIN;
                                } else {
                                    // newString을 그냥 내리기
                                    // actionInfo[NEW_LABEL] =
                                    UILabel *newLabel = [self getNewLabel];
                                    newLabel.alpha = 0;
//                                    newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                                    newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                                -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                                self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                    newLabel.text = newString;
                                    actionInfo[NEW_LABEL] = newLabel;
                                }
                            }
                        }
                        
                        
                        
                        
                        
                        
                    }
                } else {    // 이전 레이블이 없다면
                    if (i==0) {
                        // newString을 그냥 내리기
                        // actionInfo[NEW_LABEL] =
                        UILabel *newLabel = [self getNewLabel];
                        newLabel.alpha = 0;
//                        newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                        newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                    -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                    self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                        newLabel.text = newString;
                        actionInfo[NEW_LABEL] = newLabel;
                    } else {
                        NSMutableDictionary *beforeActionInfo = actionInfoArray[i-1];
                        //                        NSLog(@"beforeActionInfo:%@", beforeActionInfo);
                        if (!beforeActionInfo[OLD_LABEL]) {
                            // newString 만들어서 그냥 내리기
                            // actionInfo[NEW_LABEL] =
                            UILabel *newLabel = [self getNewLabel];
                            newLabel.alpha = 0;
//                            newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                            newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                        -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                        self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                            newLabel.text = newString;
                            actionInfo[NEW_LABEL] = newLabel;
                        } else {
                            UILabel *beforeOldLabel = beforeActionInfo[OLD_LABEL];
                            if ([beforeOldLabel.text isEqualToString:newString]) {
                                actionInfo[NEW_LABEL] = beforeOldLabel;
                                [beforeActionInfo removeObjectForKey:OLD_LABEL];
                                
                                beforeOldLabel.tag = ANI_FADEIN;
                            } else {
                                // newString을 그냥 내리기
                                // actionInfo[NEW_LABEL] =
                                UILabel *newLabel = [self getNewLabel];
                                newLabel.alpha = 0;
//                                newLabel.position = CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0);
                                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                                            -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                                            self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
                                newLabel.text = newString;
                                actionInfo[NEW_LABEL] = newLabel;
                            }
                        }
                    }
                    
                }
            }
        }
    }
    
    
    
    for (int i=0; i<actionInfoArray.count; i--) {
        UILabel *label = actionInfoArray[i][NEW_LABEL];
        if (actionInfoArray[i][NEW_STRING]) assert(label);
    }
    
    
    
    float width = -10.f;
    
    float startTime = 0.;
    float aniDelayTime = .0f;
    //    float aniIntervalGap = .13f;
    
    //    NSLog(@"0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0-0");
    [self.oldLabelArray removeAllObjects];
    for (int i=(int)actionInfoArray.count-1; i>=0; i--) {
        UILabel *newLabel = actionInfoArray[i][NEW_LABEL];
        UILabel *removeLabel = actionInfoArray[i][OLD_LABEL];
        
        
        //        NSLog(@"i=====:%i", i);
        if (newLabel) {
            //            NSLog(@"new string : %@", newLabel.text);
            float o = 1.f;
            if (_isHidden) o=0.f;
//            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:aniDelayTime position:CGPointMake((float)i)*(newLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0)];
//            CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:aniDelayTime opacity:255.f*o];
//            CCActionInterval *action = [CCSpawn actions:EASEOUT_ACTION(moveTo), EASEOUT_ACTION(fadeTo), nil];
//            [newLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:startTime], action, nil]];
            
            [UIView animateWithDuration:aniDelayTime*.5f animations:^{
                newLabel.alpha = o;
            }];
            [UIView animateWithDuration:aniDelayTime delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                [newLabel setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                
                newLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                            -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                            self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
            } completion:^(BOOL finished) {
                [newLabel removeEasingFunctionForKeyPath:@"center"];
            }];
            
            [self.oldLabelArray insertObject:newLabel atIndex:0];
            
            
            if (width<0.f) width = (i+1)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap);
        }
        if (removeLabel) {
            //            NSLog(@"remove string : %@", removeLabel.text);
//            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:aniDelayTime position:CGPointMake((float)i)*(removeLabel.fontSize*LABEL_WIDTHRATE+self.labelGap), 0)];
//            CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:aniDelayTime*.5f opacity:0.f];
//            CCActionInterval *action = [CCSpawn actions:EASEOUT_ACTION(moveTo), EASEOUT_ACTION(fadeTo), nil];
//            [removeLabel runAction:[CCSequence actions:[CCDelayTime actionWithDuration:startTime], action, [CCCallBlock actionWithBlock:^{
//                [self removeToWaitingWithLabel:removeLabel];
//            }], nil]];
            
            [UIView animateWithDuration:aniDelayTime*.5f delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                newLabel.alpha = 0.f;
            } completion:nil];
            [UIView animateWithDuration:aniDelayTime delay:startTime options:UIViewAnimationOptionTransitionNone animations:^{
                [removeLabel setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                removeLabel.frame = CGRectMake(((float)i)*(self.fontSize*LABEL_WIDTHRATE+self.labelGap),
                                               -self.fontSize*LABEL_HEIGHTRATE/2.f,
                                               self.fontSize*LABEL_WIDTHRATE, self.fontSize*LABEL_HEIGHTRATE);
            } completion:^(BOOL finished) {
                [removeLabel removeEasingFunctionForKeyPath:@"center"];
                [self removeToWaitingWithLabel:removeLabel];
            }];
            
        }
        
        
        //        startTime+=aniIntervalGap;
    }
    
    
    
//    if (0 && DEBUG) {
//        if (!debugLayer) {
//            debugLayer = [CCLayerColor layerWithColor:ccc4(255, 190, 190, .2f*255.f) width:width height:width/newStringArray.count];
//            debugLayer.position = CGPointMake0, -debugLayer.frame.size.height/2.f);
//            [self addSubview:debugLayer];
//        }
//        debugLayer.contentSize = CGSizeMake(width, debugLayer.frame.size.height);
//    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, width/newStringArray.count);
    if (width>0) return width-self.labelGap;
    else return width;
    
}


- (void) setIsHidden:(BOOL)isHidden {
    _isHidden = isHidden;
    
    
    
}


- (void) removeAnimationWithBlock:(void(^)())block {
//    CCFadeTo *fadeTo = [CCFadeTo actionWithDuration:.3f opacity:0.f];
    [UIView animateWithDuration:.3f animations:^{
        for (UILabel *label in self.oldLabelArray) {
            label.alpha = 0.f;
        }
    } completion:^(BOOL finished) {
        if (block) block();
    }];
//    for (int i=0; i<self.oldLabelArray.count; i++) {
//        UILabel *label = self.oldLabelArray[i];
////        if ([label numberOfRunningActions]) [label stopAllActions];
//        if (i==0) {
//            [label runAction:[CCSequence actions:fadeTo, [CCCallBlock actionWithBlock:block], nil]];
//        } else {
//            [label runAction:fadeTo];
//        }
//    }
}


@end
