//
//  MainViewController.m
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 10..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//


#import "UIView+EasingFunctions.h"
#import "easing.h"

#import "RoationController.h"


#import "MainViewController.h"

#import "TimeEngine.h"
#import "HangulConverter.h"


#import "FWLabelView.h"
#import "AMLabelView.h"
#import "UIEffectLabel.h"


#import "MainTouchView.h"
#import "MenuView.h"


#define ROTATION_DELAY_TIME .3f

#define TAG_ACTION_MOVETO 112

@interface MainViewController () <TimeChangeDelegate, RotateDelegate> {
    //    UIEffectLabel *effectLabel;
    //    FWLabelView *yeardateLabelView;
    CGSize winSize ;
    
    // 회전하지 않는 배경 노드
    UIImageView *bgImageView_p;
    UIImageView *bgImageView_l;
    
    
    // 회전하는 배경 노드
    UIView *rotateView;
    float defaultAngle;
    
    // rotateView위에 올라가있는 레이블 (:UIView)
    FWLabelView *yeardateLabelView;
    //    AMLabelView *yeardateLabelView;
    
    AMLabelView *hourLabelView;
    AMLabelView *minuteLabelView;
    AMLabelView *secondLabelView;  /**/
    //    EffectLabel *dateEffectLabel;  /**/
    AMLabelView *ampmLabelView;
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    UIEffectLabel *ampmEffectLabel;
    UIEffectLabel *weekDayEffectLabel;
    
    //    EffectLabel *dayEffectLabel;
    UIEffectLabel *monthEffectLabel;
    UIEffectLabel *yearEffectLabel;
    
    BOOL nowRotateAnimate;
    
    BOOL timeLabelInit;
    
    
    
    
    
    
    
    
    
    HangulConverter *converter ;
    
    
    MainTouchView *mainTouchView;
    MenuView *menuView;
}


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    // Do any additional setup after loading the view, typically from a nib.
    
    //    [self performSelector:@selector(makeLabel) withObject:nil afterDelay:1.f];
    
    timeLabelInit = NO;
    nowRotateAnimate = NO;
    
    converter = [[HangulConverter alloc] init];
    //        NSLog(@"초중종성 : [%@]", [converter linearHangul:@"아"]);
    [TimeEngine shared].changeType = tType_second;
    [TimeEngine shared].afterInterval = .1f;
    [TimeEngine shared].delegate = self;
    [[TimeEngine shared] MAKE_TIMER];
    
    
    
    winSize = CGSizeMake((self.view.frame.size.width>self.view.frame.size.height)?self.view.frame.size.width:self.view.frame.size.height, (self.view.frame.size.height<self.view.frame.size.width)?self.view.frame.size.height:self.view.frame.size.width);
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (!(orientation==UIInterfaceOrientationLandscapeLeft ||
        orientation==UIInterfaceOrientationLandscapeRight)) {
        winSize = CGSizeMake(winSize.height, winSize.width);
    }
//    winSize = self.view.frame.size;//[CCDirector sharedDirector].winSize;
    //    [RoationController shared].rootOrientation = [[UIDevice currentDevice] orientation];
    //    defaultAngle = [[RoationController shared] degreeWithOrientation:[[UIDevice currentDevice] orientation]]*90;
    
    NSString *bgImageName_p = nil;
    NSString *bgImageName_l = nil;
    if (ISIPAD) {
        bgImageName_p = @"LaunchImage-700-Portrait~ipad";
        bgImageName_l = @"LaunchImage-700-Landscape~ipad";
    } else {
        bgImageName_p = @"LaunchImage-800-667h@2x.png";
        bgImageName_l = @"LaunchImage-Landscape";
    }
    
    self.view.backgroundColor = [UIColor blackColor];
    UIImage *bgImage_p = [UIImage imageNamed:bgImageName_p];
    bgImageView_p = [[UIImageView alloc] initWithImage:bgImage_p];
    bgImageView_p.frame = CGRectMake(0, 0, winSize.width, winSize.width*(bgImage_p.size.height/bgImage_p.size.width));
    [self.view addSubview:bgImageView_p];
    UIImage *bgImage_l = [UIImage imageNamed:bgImageName_l];
    bgImageView_l = [[UIImageView alloc] initWithImage:bgImage_l];
    bgImageView_l.frame = CGRectMake(0, 0, winSize.width*(bgImage_l.size.width/bgImage_l.size.height), winSize.width);
    [self.view addSubview:bgImageView_l];
    if (([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationLandscapeRight)||
        ([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationLandscapeLeft))bgImageView_l.alpha = 1;
    else bgImageView_l.alpha = 0;

    rotateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:rotateView];
    rotateView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:1.f green:.7f blue:.7f alpha:1.f];
    
    
    
    
    mainTouchView = [[MainTouchView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    mainTouchView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mainTouchView];
    mainTouchView.mainViewController = self;
    mainTouchView.winSize = winSize;
    
    [OptionController shared].mainViewController = self;
    //        NSLog(@"%@", [UIFont fontNamesForFamilyName:FONT_NORMAL]);
    NSLog(@"view did load");
    
    
    
    //    [[RoationController shared].delegateArray addObject:self];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#define BOTTOM_LABEL_Y ((ISIPAD)?(56.f):((winSize.width>winSize.height)?(16.f):(56.f)))
#define BOTTOM_LABEL_X ((ISIPAD)?(44.f):((winSize.width>winSize.height)?(10.f):(14.f)))
#define BOGGOM_LABEL_GAP_Y 17.f
#define BOTTOM_LABEL_GAP2_Y 36.f
- (CGPoint) getYearLabelPoint {
    return CGPointMake(winSize.width-BOTTOM_LABEL_X-[yearEffectLabel getWidth], winSize.height-BOTTOM_LABEL_Y);
}
- (CGPoint) getMonthLabelPointWithYearLabelPoint:(CGPoint)yearLabelPoint {
    return CGPointMake(winSize.width-BOTTOM_LABEL_X-[monthEffectLabel getWidth],yearLabelPoint.y-BOGGOM_LABEL_GAP_Y);
}
//- (CGPoint) getDayLabelPointWithYearLabelPoint:(CGPoint)monthLabelPoint {
//    return CGPointMake(winSize.width/2.f-BOTTOM_LABEL_X-[dayEffectLabel getWidth], monthLabelPoint.y+BOGGOM_LABEL_GAP_Y);
//}
- (CGPoint) getWeekLabelPointWithMonthDayLabelPoint:(CGPoint)dayLabelPoint {
    return CGPointMake(winSize.width-BOTTOM_LABEL_X-[weekDayEffectLabel getWidth], dayLabelPoint.y-BOTTOM_LABEL_GAP2_Y);
}
- (CGPoint) getAMPMLabelPointWithWeekLabelPoint:(CGPoint)weekLabelPoint {
    return CGPointMake(winSize.width-BOTTOM_LABEL_X-[ampmEffectLabel getWidth], weekLabelPoint.y-BOGGOM_LABEL_GAP_Y);
}

#pragma mark - 터치
-(void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [touchController ccTouchesBegan:touches withEvent:event];
}
-(void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [touchController ccTouchesMoved:touches withEvent:event];
}
-(void) ccTouchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [touchController ccTouchesCancelled:touches withEvent:event];
}
-(void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    //    [OptionController shared].mainLayer = self;
    //    [touchController ccTouchesEnded:touches withEvent:event];
    
}



#define TOP_YEAR_GAP ((ISIPAD)?(40.f):(20.f))
#define TOP_YEAR_FONTSIZE ((ISIPAD)?(17):(15))
#define YEAR_POS_Y ((ISIPAD)?(26.f):(18.f))

#define HOUR_FONTSIZE ((ISIPAD)?(205):(86))
#define MINUTE_FONTSIZE ((ISIPAD)?(129):(61))
#define SECOND_FONTSIZE ((ISIPAD)?(30):(20))
#define AMPM_FONTSIZE ((ISIPAD)?(75):(30))

#define SCREENRATE ((ISIPAD)?(1):([[RoationController shared] bigHeight]/568.f))

#define MINUTE_PORTRAIT_EXTRA_GAP ((ISIPAD)?(17):(-2))
#define SECOND_PORTRAIT_EXTRA_GAP ((ISIPAD)?(17):(3))

#define PORTRAIT_STANDARD_X_GAP 10.f
#define SECOND_PORTRAIT_STANDARD_Y_GAP ((ISIPAD)?(4.f):(2.f))
#define LANDSCAPE_STANDARD_X_GAP 64.f
#define LANDSCAPE_STANDARD_MIN_X_GAP ((ISIPAD)?(198.f):(200.f))
#define SECOND_LANDSCAPE_X ((ISIPAD)?(0.f):(3.f))
#define LANDSCAPE_STANDARD_MIN_Y_GAP ((ISIPAD)?(7.f):(3.f))

#define AMPM_EXTRAGAP_Y_RATE .133333f



#pragma mark - Time Engine Delegate
- (void) timeWillChange:(NSDate *)date changeType:(enum TimeChangeType)type afterInterval:(float)afterT {
    
}
- (void) timeChanged:(NSDate *)date changeType:(enum TimeChangeType)type {
    if (![OptionController shared].dateOff) {
        if (!yeardateLabelView) {
            float width = (![[RoationController shared] isLandscape])?(winSize.width):(winSize.height);
            yeardateLabelView = [[FWLabelView alloc] initWithFontName:FONT_NORMAL
                                                             fontSize:TOP_YEAR_FONTSIZE
                                                                width:width-TOP_YEAR_GAP*2.f];
            yeardateLabelView.frame = CGRectMake(TOP_YEAR_GAP, YEAR_POS_Y,
                                                 yeardateLabelView.frame.size.width,
                                                 yeardateLabelView.frame.size.height);
            [rotateView addSubview:yeardateLabelView];
        }
        
        
        if (type&tType_day || type&tType_month || type&tType_year) {
            NSString *yearString = [NSString stringWithFormat:@"%@년", [converter hangulWithTime:date.year timeType:tcType_minute]];
            NSString *monthString = [NSString stringWithFormat:@"%@월", [converter hangulWithTime:date.month timeType:tcType_month]];
            NSString *dayString = [NSString stringWithFormat:@"%@일", [converter hangulWithTime:date.day timeType:tcType_minute]];
            NSString *weekString = [converter weekHanhulWithIndex:date.weekday];
            
            [yeardateLabelView changeTextArray:@[yearString, monthString, dayString, weekString]];
        }
    }
    
    
    
    float hourLabelX = 0.f;
    float hourLabelW = 0.f;
    float hourLabelY = 0.f;
    {
        
        if (![[RoationController shared] isLandscape]) {
            
            if (!hourLabelView) {
                hourLabelView = [[AMLabelView alloc] initWithFontName:FONT_EXTRABOLD fontSize:HOUR_FONTSIZE*SCREENRATE];
                NSString *hourText = nil;
                if (![OptionController shared].ampmOff) {
                    if (date.hour%12==0) {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]];
                    } else {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]];
                    }
                } else {
                    hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%24 timeType:tcType_hour]];
                }
                
                hourLabelW = [hourLabelView changeText:hourText];
                hourLabelX = winSize.width-PORTRAIT_STANDARD_X_GAP-hourLabelW;
                CGPoint targetPoint = CGPointMake(hourLabelX ,
                                                  (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
                hourLabelY = targetPoint.y+hourLabelView.frame.size.height/2.f;
                hourLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y, hourLabelView.frame.size.width, hourLabelView.frame.size.height);
                [rotateView addSubview:hourLabelView];
            } else {
                if (type&tType_hour) {
                    NSString *hourText = nil;
                    if (![OptionController shared].ampmOff) {
                        if (date.hour%12==0) {
                            hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]];
                        } else {
                            hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]];
                        }
                    } else {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%24 timeType:tcType_hour]];
                    }
                    
                    hourLabelW = [hourLabelView changeText:hourText];
                    hourLabelX = winSize.width-PORTRAIT_STANDARD_X_GAP-hourLabelW;
                    CGPoint targetPoint = CGPointMake(hourLabelX , (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
                    hourLabelY = targetPoint.y+hourLabelView.frame.size.height/2.f;
                    
                    [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                        [hourLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                        hourLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                         hourLabelView.frame.size.width,
                                                         hourLabelView.frame.size.height);
                    } completion:^(BOOL finished) {
                        [hourLabelView removeEasingFunctionForKeyPath:@"center"];
                    }];
                } else {
                    hourLabelX = hourLabelView.frame.origin.x;
                    hourLabelY = hourLabelView.frame.origin.y+hourLabelView.frame.size.height/2.f;
                    hourLabelW = hourLabelView.frame.size.width;
                }
                
            }
            
            
            
            if (![OptionController shared].ampmOff) {
                if (!ampmLabelView) {
                    float ampmW = 0.f;
                    ampmLabelView = [[AMLabelView alloc] initWithFontName:FONT_BOLD fontSize:AMPM_FONTSIZE*SCREENRATE];
                    [rotateView addSubview:ampmLabelView];
                    if (date.hour<12) {
                        ampmW = [ampmLabelView changeText:@"오전"];
                    } else {
                        ampmW = [ampmLabelView changeText:@"오후"];
                    }
                    CGPoint targetPoint = CGPointMake(hourLabelX-ampmLabelView.frame.size.width+0.f,
                                                      hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
                    ampmLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                     ampmLabelView.frame.size.width, ampmLabelView.frame.size.height);
                    NSLog(@"ampmLabelView.frame:%@", NSStringFromCGRect(ampmLabelView.frame));
                } else {
                    if (type&tType_hour) {
                        if (date.hour<12) {
                            [ampmLabelView changeText:@"오전"];
                        } else {
                            [ampmLabelView changeText:@"오후"];
                        }
                        
                        CGPoint targetPoint = CGPointMake(hourLabelX-ampmLabelView.frame.size.width+0.f,
                                                          hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
                        [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                            [ampmLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                            ampmLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                             ampmLabelView.frame.size.width,
                                                             ampmLabelView.frame.size.height);
                        } completion:^(BOOL finished) {
                            [ampmLabelView removeEasingFunctionForKeyPath:@"center"];
                        }];
                    } else {
                        
                    }
                }
            }
            
            
        } else {
            
            
            BOOL hourInit = NO;
            if (!hourLabelView) {
                hourInit=  YES;
                hourLabelView = [[AMLabelView alloc] initWithFontName:FONT_EXTRABOLD fontSize:HOUR_FONTSIZE*SCREENRATE];
                NSString *hourText = nil;
                if (![OptionController shared].ampmOff) {
                    if (date.hour%12==0) {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]];
                    } else {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]];
                    }
                } else {
                    hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%24 timeType:tcType_hour]];
                }
                
                hourLabelW = [hourLabelView changeText:hourText];
                
                CGPoint targetPoint = CGPointMake(0.f,
                                                  (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
                hourLabelY = targetPoint.y+hourLabelView.frame.size.height/2.f;
                hourLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                 hourLabelView.frame.size.width,
                                                 hourLabelView.frame.size.height);
                [rotateView addSubview:hourLabelView];
            } else {
                NSString *hourText = nil;
                if (![OptionController shared].ampmOff) {
                    if (date.hour%12==0) {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]];
                    } else {
                        hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]];
                    }
                } else {
                    hourText = [NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%24 timeType:tcType_hour]];
                }
                hourLabelW = [hourLabelView changeText:hourText];
                hourLabelY = hourLabelView.frame.origin.y+hourLabelView.frame.size.height/2.f;
            }
            float ampmW = 0.f;
            float ampmX = LANDSCAPE_STANDARD_X_GAP;
            
            if (![OptionController shared].ampmOff) {
                if (!ampmLabelView) {
                    ampmLabelView = [[AMLabelView alloc] initWithFontName:FONT_BOLD fontSize:AMPM_FONTSIZE*SCREENRATE];
                    [rotateView addSubview:ampmLabelView];
                    if (date.hour<12) {
                        ampmW = [ampmLabelView changeText:@"오전"];
                    } else {
                        ampmW = [ampmLabelView changeText:@"오후"];
                    }
                    CGPoint targetPoint = CGPointMake(ampmX,
                                                      hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
                    ampmLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                     ampmLabelView.frame.size.width, ampmLabelView.frame.size.height);
                } else {
                    if (type&tType_hour) {
                        if (date.hour<12) {
                            ampmW = [ampmLabelView changeText:@"오전"];
                        } else {
                            ampmW = [ampmLabelView changeText:@"오후"];
                        }
                        CGPoint targetPoint = CGPointMake(ampmX,
                                                          hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
                        [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                            [ampmLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                            ampmLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                             ampmLabelView.frame.size.width,
                                                             ampmLabelView.frame.size.height);
                        } completion:^(BOOL finished) {
                            [ampmLabelView removeEasingFunctionForKeyPath:@"center"];
                        }];
                    } else {
                        ampmW = ampmLabelView.frame.size.width;
                    }
                }
            }
            
            
            
            if (hourInit) {
                CGPoint targetPoint = CGPointMake(ampmX+ampmW-0.f, (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
                hourLabelY = targetPoint.y+hourLabelView.frame.size.height/2.f;
                //                hourLabelView.position = targetPoint;
                hourLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                 hourLabelView.frame.size.width, hourLabelView.frame.size.height);
            } else {
                CGPoint targetPoint = CGPointMake(ampmX+ampmW-0.f, (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
                hourLabelY = targetPoint.y+hourLabelView.frame.size.height/2.f;
                [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                    [hourLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                    hourLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                     hourLabelView.frame.size.width, hourLabelView.frame.size.height);
                } completion:^(BOOL finished) {
                    [hourLabelView removeEasingFunctionForKeyPath:@"center"];
                }];
            }
            
            
        }
        
    }
    
    
    
    
    //winSize.width-PORTRAIT_STANDARD_X_GAP-secondW-SECOND_PORTRAIT_EXTRA_GAP,
    {
        
        // Minute & Second
        float minuteW = 0.f;
        float secondW = 0.f;
        float minuteY = 0.f;
        
        
        if (![[RoationController shared] isLandscape]) {
            if (!minuteLabelView) {
                minuteLabelView = [[AMLabelView alloc] initWithFontName:FONT_LIGHT fontSize:MINUTE_FONTSIZE*SCREENRATE];
                [rotateView addSubview:minuteLabelView];
                minuteW = [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
                CGPoint targetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-minuteW -MINUTE_PORTRAIT_EXTRA_GAP,
                                                  hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.07f);
                minuteY = targetPoint.y+minuteLabelView.frame.size.height/2.f;
                //                minuteLabelView.position = targetPoint;
                minuteLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                   minuteLabelView.frame.size.width, minuteLabelView.frame.size.height);
            } else {
                if (type&tType_minute) {
                    minuteW = [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
                    CGPoint targetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-minuteW -MINUTE_PORTRAIT_EXTRA_GAP,
                                                      hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.07f);
                    minuteY = targetPoint.y+minuteLabelView.frame.size.height/2.f;
                    //                    CCActionInterval *eMoveTo = EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:targetPoint]);
                    //                    eMoveTo.tag = TAG_ACTION_MOVETO;
                    //                    if ([minuteLabelView numberOfRunningActions]) [minuteLabelView stopActionByTag:TAG_ACTION_MOVETO];
                    //                    [minuteLabelView runAction:eMoveTo];
                    [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                        [minuteLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                        minuteLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                           minuteLabelView.frame.size.width,
                                                           minuteLabelView.frame.size.height);
                    } completion:^(BOOL finished) {
                        [minuteLabelView removeEasingFunctionForKeyPath:@"center"];
                    }];
                } else {
                    minuteY = minuteLabelView.frame.origin.y+minuteLabelView.frame.size.height/2.f;
                }
            }
            
            
            
            if (![OptionController shared].secondOff) {
                if (!secondLabelView) {
                    secondLabelView = [[AMLabelView alloc] initWithFontName:FONT_NORMAL fontSize:SECOND_FONTSIZE*SCREENRATE];
                    [secondLabelView setLabelCount:4];
                    [rotateView addSubview:secondLabelView];
                    
                    secondW = [secondLabelView changeText:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
                    CGPoint targetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-secondW-SECOND_PORTRAIT_EXTRA_GAP,
                                                      minuteY+(secondLabelView.frame.size.height)-SECOND_PORTRAIT_STANDARD_Y_GAP);
                    secondLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                       secondLabelView.frame.size.width,
                                                       secondLabelView.frame.size.height);
                } else {
                    if (type&tType_second) {
                        secondW = [secondLabelView changeText:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
                        CGPoint targetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-secondW-SECOND_PORTRAIT_EXTRA_GAP,
                                                          minuteY+(secondLabelView.frame.size.height)-SECOND_PORTRAIT_STANDARD_Y_GAP);
                        //                        CCActionInterval *eMoveTo = EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:targetPoint]);
                        //                        eMoveTo.tag = TAG_ACTION_MOVETO;
                        //                        if ([secondLabelView numberOfRunningActions]) [secondLabelView stopActionByTag:TAG_ACTION_MOVETO];
                        //                        [secondLabelView runAction:eMoveTo];
                        [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                            [secondLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                            secondLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                               secondLabelView.frame.size.width,
                                                               secondLabelView.frame.size.height);
                        } completion:^(BOOL finished) {
                            [secondLabelView removeEasingFunctionForKeyPath:@"center"];
                        }];
                    }
                }
                
            }
        } else {
            if (!minuteLabelView) {
                minuteLabelView = [[AMLabelView alloc] initWithFontName:FONT_LIGHT fontSize:MINUTE_FONTSIZE*SCREENRATE];
                [rotateView addSubview:minuteLabelView];
                minuteW = [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
                CGPoint targetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP-minuteW ,
                                                  hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.37f);
                minuteY = targetPoint.y+minuteLabelView.frame.size.height/2.f;
                //                minuteLabelView.position = targetPoint;
                minuteLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                   minuteLabelView.frame.size.width,
                                                   minuteLabelView.frame.size.height);
            } else {
                if (type&tType_minute) {
                    minuteW = [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
                    CGPoint targetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP-minuteW ,
                                                      hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.37f);
                    minuteY = targetPoint.y+minuteLabelView.frame.size.height/2.f;
                    //                    CCActionInterval *eMoveTo = EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:targetPoint]);
                    //                    eMoveTo.tag = TAG_ACTION_MOVETO;
                    //                    if ([minuteLabelView numberOfRunningActions]) [minuteLabelView stopActionByTag:TAG_ACTION_MOVETO];
                    //                    [minuteLabelView runAction:eMoveTo];
                    [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                        [minuteLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                        minuteLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                           minuteLabelView.frame.size.width,
                                                           minuteLabelView.frame.size.height);
                    } completion:^(BOOL finished) {
                        [minuteLabelView removeEasingFunctionForKeyPath:@"center"];
                    }];
                } else {
                    minuteY = minuteLabelView.frame.origin.y+minuteLabelView.frame.size.height/2.f;
                }
            }
            
            
            
            if (![OptionController shared].secondOff) {
                if (!secondLabelView) {
                    secondLabelView = [[AMLabelView alloc] initWithFontName:FONT_NORMAL fontSize:SECOND_FONTSIZE*SCREENRATE];
                    [secondLabelView setLabelCount:4];
                    [rotateView addSubview:secondLabelView];
                    
                    secondW = [secondLabelView changeText:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
                    CGPoint targetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP+SECOND_LANDSCAPE_X,
                                                      minuteY-(secondLabelView.frame.size.height/2.f)-LANDSCAPE_STANDARD_MIN_Y_GAP);
                    //                    secondLabelView.position = targetPoint;
                    secondLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                       secondLabelView.frame.size.width,
                                                       secondLabelView.frame.size.height);
                } else {
                    if (type&tType_second) {
                        secondW = [secondLabelView changeText:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
                        CGPoint targetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP+SECOND_LANDSCAPE_X,
                                                          minuteY-(secondLabelView.frame.size.height/2.f)-LANDSCAPE_STANDARD_MIN_Y_GAP);
                        //                        CCActionInterval *eMoveTo = EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:targetPoint]);
                        //                        eMoveTo.tag = TAG_ACTION_MOVETO;
                        //                        if ([secondLabelView numberOfRunningActions]) [secondLabelView stopActionByTag:TAG_ACTION_MOVETO];
                        //                        [secondLabelView runAction:eMoveTo];
                        [UIView animateWithDuration:ANI_TEXT_DELAY animations:^{
                            [secondLabelView setEasingFunction:ExponentialEaseOut forKeyPath:@"center"];
                            secondLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                                               secondLabelView.frame.size.width,
                                                               secondLabelView.frame.size.height);
                        } completion:^(BOOL finished) {
                            [secondLabelView removeEasingFunctionForKeyPath:@"center"];
                        }];
                    }
                }
                
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    if (![RoationController shared].delegate) [RoationController shared].delegate = self;
    
    if (!timeLabelInit) {
        timeLabelInit = YES;
        
        /*
         //
         //
         // 시간 세팅
         hourLabelView = [[AMLabelView alloc] initWithFontName:FONT_EXTRABOLD fontSize:200];
         if (date.hour%12==0) {
         [hourLabelView changeText:[NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]]];
         } else {
         [hourLabelView changeText:[NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]]];
         }
         CGPoint hTargetPoint = [self getHourPoint];
         hourLabelView.position = hTargetPoint;
         [rotateView addSubview:hourLabelView];
         
         minuteLabelView = [[AMLabelView alloc] initWithFontName:@FONT_LIGHT fontSize:80];
         [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
         
         CGPoint mTargetPoint = [self getMinutPointWithHourPoint:hTargetPoint];
         minuteLabelView.position = mTargetPoint;
         [rotateView addSubview:minuteLabelView];
         
         secondLabelView = [[AMLabelView alloc] initWithFontName:FONT_NORMAL fontSize:18];
         [secondLabelView changeText:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
         [secondLabelView setLabelCount:4];
         CGPoint sTargetPoint = [self getSecondPointWithHourPoint:hTargetPoint minutePoint:mTargetPoint];
         secondLabelView.position = sTargetPoint;
         [rotateView addSubview:secondLabelView];
         */
        
        
        
        
        CGPoint targetPoint;
        NSString *yearText = [NSString stringWithFormat:@"%@년", [converter hangulWithTime:date.year timeType:tcType_minute]] ;
        yearEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:yearText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getYearLabelPoint];
        yearEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                           yearEffectLabel.frame.size.width,
                                           yearEffectLabel.frame.size.height);
        [rotateView addSubview:yearEffectLabel];
        
        
        NSString *monthdayText = [NSString stringWithFormat:@"%@월%@일", [converter hangulWithTime:date.month timeType:tcType_month], [converter hangulWithTime:date.day timeType:tcType_minute]] ;
        monthEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:monthdayText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getMonthLabelPointWithYearLabelPoint:yearEffectLabel.frame.origin];
        monthEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                            monthEffectLabel.frame.size.width,
                                            monthEffectLabel.frame.size.height);
        [rotateView addSubview:monthEffectLabel];
        
        
        NSString *weekText = [converter weekHanhulWithIndex:date.weekday];
        weekDayEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:weekText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getWeekLabelPointWithMonthDayLabelPoint:monthEffectLabel.frame.origin];
        weekDayEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                              weekDayEffectLabel.frame.size.width,
                                              weekDayEffectLabel.frame.size.height);
        [rotateView addSubview:weekDayEffectLabel];
        
        
        NSString *ampmText = @"오전";
        if (date.hour>=12) ampmText = @"오후";
        ampmEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:ampmText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getAMPMLabelPointWithWeekLabelPoint:weekDayEffectLabel.frame.origin];
        ampmEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                           ampmLabelView.frame.size.width,
                                           ampmLabelView.frame.size.height);
        [rotateView addSubview:ampmEffectLabel];
        
        
        
        
        return;
    }
    
    CGPoint targetPoint;
    if (type&tType_year) {
        if (yearEffectLabel) {
            [yearEffectLabel removeAnimateWithIsSearch:YES];
        }
        NSString *yearText = [NSString stringWithFormat:@"%@년", [converter hangulWithTime:date.year timeType:tcType_minute]] ;
        yearEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:yearText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getYearLabelPoint];
        yearEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                           yearEffectLabel.frame.size.width,
                                           yearEffectLabel.frame.size.height);
        [rotateView addSubview:yearEffectLabel];
    }
    if (type&tType_month) {
        if (monthEffectLabel) {
            [monthEffectLabel removeAnimateWithIsSearch:YES];
        }
        NSString *monthdayText = [NSString stringWithFormat:@"%@월%@일", [converter hangulWithTime:date.month timeType:tcType_month], [converter hangulWithTime:date.day timeType:tcType_minute]] ;
        monthEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:monthdayText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getMonthLabelPointWithYearLabelPoint:yearEffectLabel.frame.origin];
        monthEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                            monthEffectLabel.frame.size.width,
                                            monthEffectLabel.frame.size.height);
        [rotateView addSubview:monthEffectLabel];
    }
    if (type&tType_day) {
        if (weekDayEffectLabel) {
            [weekDayEffectLabel removeAnimateWithIsSearch:YES];
        }
        NSString *weekText = [converter weekHanhulWithIndex:date.weekday];
        weekDayEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:weekText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
        targetPoint = [self getWeekLabelPointWithMonthDayLabelPoint:monthEffectLabel.frame.origin];
        weekDayEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                              weekDayEffectLabel.frame.size.width,
                                              weekDayEffectLabel.frame.size.height);
        [rotateView addSubview:weekDayEffectLabel];
    }
    if (type&tType_hour) {
        if (date.hour==0 || date.hour==12) {
            if (ampmEffectLabel) {
                [ampmEffectLabel removeAnimateWithIsSearch:YES];
            }
            NSString *ampmText = @"오전";
            if (date.hour>=12) ampmText = @"오후";
            ampmEffectLabel = [[UIEffectLabel alloc] initWithString:[converter linearHangul:ampmText] fontName:FONT_NORMAL fontSize:12.f init:NO Opacity:MAX_OPACITY];
            targetPoint = [self getAMPMLabelPointWithWeekLabelPoint:weekDayEffectLabel.frame.origin];
            ampmEffectLabel.frame = CGRectMake(targetPoint.x, targetPoint.y,
                                               ampmEffectLabel.frame.size.width,
                                               ampmEffectLabel.frame.size.height);
            [rotateView addSubview:ampmEffectLabel];
        }
    }
    
    
    
    /*if (type&tType_hour) {
     if (date.hour%12==0) {
     [hourLabelView changeText:[NSString stringWithFormat:@"%@시", [converter hangulWithTime:12 timeType:tcType_hour]]];
     } else {
     [hourLabelView changeText:[NSString stringWithFormat:@"%@시", [converter hangulWithTime:date.hour%12 timeType:tcType_hour]]];
     }
     hTargetPoint = [self getHourPoint];
     }
     if (type&tType_minute) {
     NSLog(@"1minuteLabelView.contentsize:%@", NSStringFromCGSize(minuteLabelView.contentSize));
     [minuteLabelView changeText:[NSString stringWithFormat:@"%@분", [converter hangulWithTime:date.minute timeType:tcType_minute]]];
     NSLog(@"2minuteLabelView.contentsize:%@", NSStringFromCGSize(minuteLabelView.contentSize));
     if (!nowRotateAnimate) {
     mTargetPoint = [self getMinutPointWithHourPoint:hTargetPoint];
     [minuteLabelView runAction:EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:mTargetPoint])];
     }
     
     }
     if (type&tType_second) {
     [secondLabelView changeTextWithOutAnimation:[NSString stringWithFormat:@"%@초", [converter hangulWithTime:date.second timeType:tcType_minute]]];
     if (!nowRotateAnimate) {
     sTargetPoint = [self getSecondPointWithHourPoint:hTargetPoint minutePoint:mTargetPoint];
     [secondLabelView runAction:EASEOUT_ACTION([CCMoveTo actionWithDuration:ANI_TEXT_DELAY position:sTargetPoint])];
     }
     }*/
    
}



#pragma mark - 화면 회전
- (BOOL)shouldAutorotate {
    //    NSLog(@"%zd-self.view.frame:%@", [[UIApplication sharedApplication] statusBarOrientation], NSStringFromCGRect(self.view.frame));
    winSize = CGSizeMake((self.view.frame.size.width>self.view.frame.size.height)?self.view.frame.size.width:self.view.frame.size.height, (self.view.frame.size.height<self.view.frame.size.width)?self.view.frame.size.height:self.view.frame.size.width);
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (!(orientation==UIInterfaceOrientationLandscapeLeft ||
          orientation==UIInterfaceOrientationLandscapeRight)) {
        winSize = CGSizeMake(winSize.height, winSize.width);
    }
    mainTouchView.winSize = winSize;
    
    [RoationController shared].statusBarOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    
    return YES;
}
#pragma mark - 실제 화면 회전시
- (void) realRotateScreen {
    winSize = CGSizeMake((self.view.frame.size.width>self.view.frame.size.height)?self.view.frame.size.width:self.view.frame.size.height, (self.view.frame.size.height<self.view.frame.size.width)?self.view.frame.size.height:self.view.frame.size.width);
    if (![RoationController shared].isLandscape) {
        winSize = CGSizeMake(winSize.height, winSize.width);
    }
    mainTouchView.winSize = winSize;
    
    
    bgImageView_p.alpha = 1;
    [UIView animateWithDuration:ROTATION_DELAY_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        bgImageView_p.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        bgImageView_l.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        if ([RoationController shared].isLandscape) {
            //            bgImageView_p.alpha = 0;
            bgImageView_l.alpha = 1;
        } else {
            //            bgImageView_p.alpha = 1;
            bgImageView_l.alpha = 0;
        }
    } completion:nil];
    
    
    
    
    if (![OptionController shared].dateOff) {
        if (yeardateLabelView) {
            //            CCMoveTo *moveTo = [CCMoveTo actionWithDuration:ROTATION_DELAY_TIME position:CGPointMake(TOP_YEAR_GAP, YEAR_POS_Y)];
            //            CCActionInterval *eMoveTo = ROTATE_EASE(moveTo);
            //            eMoveTo.tag = TAG_ACTION_MOVETO;
            //            if ([yeardateLabelView numberOfRunningActions]) [yeardateLabelView stopActionByTag:TAG_ACTION_MOVETO];
            //            [yeardateLabelView runAction:eMoveTo];
            [UIView animateWithDuration:ROTATION_DELAY_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                yeardateLabelView.frame = CGRectMake(TOP_YEAR_GAP, YEAR_POS_Y,
                                                     yeardateLabelView.frame.size.width,
                                                     yeardateLabelView.frame.size.height);
            } completion:^(BOOL finished) {
                
            }];
        }
    }
    
    
    CGPoint hourTargetPoint ;
    CGPoint ampmTargetPoint ;
    CGPoint minutTargetPoint ;
    CGPoint secondTargetPoint ;
    if (![RoationController shared].isLandscape) {
        float hourLabelW = hourLabelView.frame.size.width;
        float hourLabelX = winSize.width-PORTRAIT_STANDARD_X_GAP-hourLabelW;
        
        hourTargetPoint = CGPointMake(hourLabelX,
                                      (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
        float hourLabelY = hourTargetPoint.y+hourLabelView.frame.size.height/2.f;
        ampmTargetPoint = CGPointMake(hourLabelX-ampmLabelView.frame.size.width+0.f,
                                      hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
        
        float minuteW = minuteLabelView.frame.size.width;
        minutTargetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-minuteW-MINUTE_PORTRAIT_EXTRA_GAP,
                                       hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.37f);
        float minuteY = minutTargetPoint.y+minuteLabelView.frame.size.height/2.f;
        
        float secondW = secondLabelView.frame.size.width;
        secondTargetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-secondW-SECOND_PORTRAIT_EXTRA_GAP,
                                        minuteY+(secondLabelView.frame.size.height/2.f)-SECOND_PORTRAIT_STANDARD_Y_GAP);
    } else {
        
        float hourLabelY = (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f+hourLabelView.frame.size.height/2.f;
        float ampmX = LANDSCAPE_STANDARD_X_GAP;
        float ampmW = ampmLabelView.frame.size.width;
        
        hourTargetPoint = CGPointMake(ampmX+ampmW-0.f,
                                      (YEAR_POS_Y*2)+(hourLabelView.frame.size.height/2.f)*1.37f);
        ampmTargetPoint = CGPointMake(ampmX,
                                      hourLabelY-ampmLabelView.frame.size.height/2.f-ampmLabelView.frame.size.height*AMPM_EXTRAGAP_Y_RATE);
        
        float minuteW = minuteLabelView.frame.size.width;
        minutTargetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP-minuteW,
                                       hourLabelY+(minuteLabelView.frame.size.height/2.f)*1.37f);
        float minuteY = minutTargetPoint.y+minuteLabelView.frame.size.height/2.f;
        
        secondTargetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP+SECOND_LANDSCAPE_X,
                                        minuteY-(secondLabelView.frame.size.height/2.f)+7.f);
    }
    
//    minuteY+(secondLabelView.frame.size.height)-4.f
    
    
    [UIView animateWithDuration:ROTATION_DELAY_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        //        [self rotationMoveToAnimtionWithView:hourLabelView point:hourTargetPoint];
        //        [self rotationMoveToAnimtionWithView:minuteLabelView point:minutTargetPoint];
        hourLabelView.frame = CGRectMake(hourTargetPoint.x, hourTargetPoint.y, hourLabelView.frame.size.width, hourLabelView.frame.size.height);
        minuteLabelView.frame = CGRectMake(minutTargetPoint.x, minutTargetPoint.y, minuteLabelView.frame.size.width, minuteLabelView.frame.size.height);
        if (![OptionController shared].ampmOff) {
            //            [self rotationMoveToAnimtionWithView:ampmLabelView point:ampmTargetPoint];
            ampmLabelView.frame = CGRectMake(ampmTargetPoint.x, ampmTargetPoint.y, ampmLabelView.frame.size.width, ampmLabelView.frame.size.height);
        }
        if (![OptionController shared].secondOff) {
            //            [self rotationMoveToAnimtionWithView:secondLabelView point:secondTargetPoint];
            secondLabelView.frame = CGRectMake(secondTargetPoint.x, secondTargetPoint.y, secondLabelView.frame.size.width, secondLabelView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        
    }];
    
    
    
    CGPoint yep = [self getYearLabelPoint];
    CGPoint mep = [self getMonthLabelPointWithYearLabelPoint:yep];
    CGPoint wep = [self getWeekLabelPointWithMonthDayLabelPoint:mep];
    CGPoint aep = [self getAMPMLabelPointWithWeekLabelPoint:wep];
    
    
    [UIView animateWithDuration:ROTATION_DELAY_TIME delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
        yearEffectLabel.frame = CGRectMake(yep.x, yep.y, yearEffectLabel.frame.size.width, yearEffectLabel.frame.size.height);
        monthEffectLabel.frame = CGRectMake(mep.x, mep.y, monthEffectLabel.frame.size.width, monthEffectLabel.frame.size.height);
        weekDayEffectLabel.frame = CGRectMake(wep.x, wep.y, weekDayEffectLabel.frame.size.width, weekDayEffectLabel.frame.size.height);
        ampmEffectLabel.frame = CGRectMake(aep.x, aep.y, ampmEffectLabel.frame.size.width, ampmEffectLabel.frame.size.height);
    } completion:^(BOOL finished) {
        
    }];
    
    if (menuView) {[menuView rotateWithWinSize:winSize];}
}


- (void) makeMenuView {
    if (!menuView) {
        menuView = [[MenuView alloc] initWithFrame:CGRectMake(0, 0, winSize.width, winSize.height)];
        menuView.alpha = 0;
        menuView.menuOn = NO;
        menuView.mainViewController = self;
        [self.view addSubview:menuView];
        mainTouchView.menuView = menuView;
        NSLog(@"menuView:%@", menuView);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
    
    
}






#pragma mark - 옵션으로부터 이벤트
- (void)setSecondOff:(BOOL)secondOff {
    if (secondOff) {
        if (secondLabelView) {
            AMLabelView *tmepLabelView = secondLabelView;
            secondLabelView = nil;
            [tmepLabelView removeAnimationWithBlock:^{
                [tmepLabelView removeFromSuperview];
            }];
        }
    } else {
        if (!secondLabelView) {
            secondLabelView = [[AMLabelView alloc] initWithFontName:FONT_NORMAL fontSize:SECOND_FONTSIZE*SCREENRATE];
            [secondLabelView setLabelCount:4];
            [rotateView addSubview:secondLabelView];
            
            
            CGPoint targetPoint ;
            float secondW = [secondLabelView changeText:@"초"];
            if (winSize.width<winSize.height) {
                targetPoint = CGPointMake(winSize.width-PORTRAIT_STANDARD_X_GAP-secondW-SECOND_PORTRAIT_EXTRA_GAP,
                                          minuteLabelView.frame.origin.y+minuteLabelView.frame.size.height/2.f+(secondLabelView.frame.size.height)-4.f);
                
            } else {
                targetPoint = CGPointMake(winSize.width-LANDSCAPE_STANDARD_MIN_X_GAP+SECOND_LANDSCAPE_X,
                                          minuteLabelView.frame.origin.y+minuteLabelView.frame.size.height/2.f-(secondLabelView.frame.size.height/2.f)-LANDSCAPE_STANDARD_MIN_Y_GAP);
            }
            secondLabelView.frame = CGRectMake(targetPoint.x, targetPoint.y, secondW, secondLabelView.frame.size.height);
        }
    }
}
- (void)setDateOff:(BOOL)dateOff {
    if (dateOff) {
        if (yeardateLabelView) {
            if (secondLabelView) {
                FWLabelView *tmepLabelView = yeardateLabelView;
                yeardateLabelView = nil;
                [tmepLabelView removeAnimationWithBlock:^{
                    [tmepLabelView removeFromSuperview];
                }];
            }
        }
    } else {
        if (!yeardateLabelView) {
            float width = (winSize.height<winSize.width)?(winSize.height):(winSize.width);
            yeardateLabelView = [[FWLabelView alloc] initWithFontName:FONT_NORMAL
                                                             fontSize:TOP_YEAR_FONTSIZE*SCREENRATE
                                                                width:width-TOP_YEAR_GAP*2.f];
            yeardateLabelView.frame = CGRectMake(TOP_YEAR_GAP, YEAR_POS_Y,
                                                 yeardateLabelView.frame.size.width,
                                                 yeardateLabelView.frame.size.height);
            [rotateView addSubview:yeardateLabelView];
        }
        NSDate *date = [NSDate date];
        NSString *yearString = [NSString stringWithFormat:@"%@년", [converter hangulWithTime:date.year timeType:tcType_minute]];
        NSString *monthString = [NSString stringWithFormat:@"%@월", [converter hangulWithTime:date.month timeType:tcType_month]];
        NSString *dayString = [NSString stringWithFormat:@"%@일", [converter hangulWithTime:date.day timeType:tcType_minute]];
        NSString *weekString = [converter weekHanhulWithIndex:date.weekday];
        [yeardateLabelView changeTextArray:@[yearString, monthString, dayString, weekString]];
    }
}
- (void)setAmpmOff:(BOOL)ampmOff {
    
    
    // 지울건 지우고
    
    if (ampmOff) {
        if (ampmLabelView) {
            AMLabelView *tmepLabelView = ampmLabelView;
            ampmLabelView = nil;
            [tmepLabelView removeAnimationWithBlock:^{
                [tmepLabelView removeFromSuperview];
            }];
        }
    } else {
        
    }
    
    enum TimeChangeType type = tType_hour;
    NSDate *date = [NSDate date];
    [self timeChanged:date changeType:type];
}
@end
