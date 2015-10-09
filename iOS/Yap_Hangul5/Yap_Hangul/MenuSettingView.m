//
//  MenuSettingView.m
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 13..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "MenuSettingView.h"



#define LABEL_SWITCH_WIDTH ((ISIPAD)?230.f:190.f)
#define LABEL_SWITCH_HEIGHT 44.f
#define LABEL_AND_SWITCH_GAP ((ISIPAD)?60.f:50.f)
#define LABEL_FONTSIZE ((ISIPAD)?26.f:22.f)
@interface MenuSettingView () {
    UIView *secView;
    UILabel *secLabel;
    UISwitch *secSwitch;
    
    UIView *dateView;
    UILabel *dateLabel;
    UISwitch *dateSwitch;
    
    UIView *ampmOffView;
    UILabel *ampmOffLabel;
    UISwitch *ampmOffSwitch;
}

@end



@implementation MenuSettingView
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        if (ISIPAD) {
            self.backgroundColor = [UIColor colorWithWhite:0.f alpha:.78f];
        } else {
            self.backgroundColor = [UIColor colorWithWhite:0.f alpha:.85f];
        }
        
    }
    return self;
}


- (void) menuSettingOnEventWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame {
    [self.superview bringSubviewToFront:self];
    if (self.menuSettingOn) return;
    
    [self makeLableAndSwitch];
    [self repositionWithWinSize:winSize settingLabelFrame:settingLabelFrame animate:NO];
    [self manuSettingOnAnimation];
    
    self.menuSettingOn = YES;
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 1;
    }];
    
    [self reloadSettingInfo];
}
- (void) menuSettingOffEvent {
    if (!self.menuSettingOn) return;
    
    [self manuSettingOffAnimation];
    
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.6f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.menuSettingOn = NO;
    }];
}
- (void) makeLableAndSwitch {
    if (secView) return;
    
    secView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    dateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    ampmOffView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:secView];
    [self addSubview:dateView];
    [self addSubview:ampmOffView];

    
    
    secLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    secLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
    secLabel.textColor = [UIColor whiteColor];
    secLabel.backgroundColor = [UIColor clearColor];
    secLabel.text = @"초(sec) 표시";
    [secView addSubview:secLabel];
    
    secSwitch = [[UISwitch alloc] init];
    [secView addSubview:secSwitch];
    [secSwitch addTarget:self action:@selector(changeSecondOn:) forControlEvents:UIControlEventValueChanged];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    dateLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
    dateLabel.textColor = [UIColor whiteColor];
    dateLabel.backgroundColor = [UIColor clearColor];
    dateLabel.text = @"날짜 표시";
    [dateView addSubview:dateLabel];
    
    dateSwitch = [[UISwitch alloc] init];
    [dateView addSubview:dateSwitch];
    [dateSwitch addTarget:self action:@selector(changeDateOn:) forControlEvents:UIControlEventValueChanged];
    
    ampmOffLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    ampmOffLabel.font = [UIFont systemFontOfSize:LABEL_FONTSIZE];
    ampmOffLabel.textColor = [UIColor whiteColor];
    ampmOffLabel.backgroundColor = [UIColor clearColor];
    ampmOffLabel.text = @"24시간제 사용";
    [ampmOffView addSubview:ampmOffLabel];
    
    ampmOffSwitch = [[UISwitch alloc] init];
    [ampmOffView addSubview:ampmOffSwitch];
    [ampmOffSwitch addTarget:self action:@selector(change24Off:) forControlEvents:UIControlEventValueChanged];
    
    
    
    
    
    CGRect labelRect;
    CGRect switchRect;
//    if (ISIPAD) {
//        
//        labelRect = CGRectMake(0, 0, LABEL_SWITCH_WIDTH-secSwitch.frame.size.width, LABEL_SWITCH_HEIGHT);
//        switchRect = CGRectMake(LABEL_SWITCH_WIDTH-secSwitch.frame.size.width, LABEL_SWITCH_HEIGHT/2.f-secSwitch.frame.size.height/2.f, secSwitch.frame.size.width, secSwitch.frame.size.height);
//    } else {
//        assert(0);
//    }
    labelRect = CGRectMake(0, 0, LABEL_SWITCH_WIDTH-secSwitch.frame.size.width, LABEL_SWITCH_HEIGHT);
    switchRect = CGRectMake(LABEL_SWITCH_WIDTH-secSwitch.frame.size.width, LABEL_SWITCH_HEIGHT/2.f-secSwitch.frame.size.height/2.f, secSwitch.frame.size.width, secSwitch.frame.size.height);
    
    
    secLabel.frame = labelRect;
    dateLabel.frame = labelRect;
    ampmOffLabel.frame = labelRect;
    
    secSwitch.frame = switchRect;
    dateSwitch.frame = switchRect;
    ampmOffSwitch.frame = switchRect;
    
    
    secView.alpha = 0;
    dateView.alpha = 0;
    ampmOffView.alpha = 0;
    
    
    
    
    
    
    
}
- (void) manuSettingOnAnimation {
    CGRect secViewRect = secView.frame;
    CGRect dateViewRect = dateView.frame;
    CGRect ampmOffViewRect = ampmOffView.frame;
    float moveGap = 10.f;
    secView.frame = CGRectMake(secViewRect.origin.x, secViewRect.origin.y+moveGap,
                               secViewRect.size.width, secViewRect.size.height);
    dateView.frame = CGRectMake(dateViewRect.origin.x, dateViewRect.origin.y+moveGap,
                                dateViewRect.size.width, dateViewRect.size.height);
    ampmOffView.frame = CGRectMake(ampmOffViewRect.origin.x, ampmOffViewRect.origin.y+moveGap,
                                   ampmOffViewRect.size.width, ampmOffViewRect.size.height);
    [UIView animateWithDuration:.3f delay:0.f options:UIViewAnimationOptionTransitionNone animations:^{
        secView.frame = secViewRect;
        secView.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:.3f delay:.1f options:UIViewAnimationOptionTransitionNone animations:^{
        dateView.frame = dateViewRect;
        dateView.alpha = 1;
    } completion:nil];
    [UIView animateWithDuration:.3f delay:.2f options:UIViewAnimationOptionTransitionNone animations:^{
        ampmOffView.frame = ampmOffViewRect;
        ampmOffView.alpha = 1;
    } completion:nil];
}
- (void) manuSettingOffAnimation {
    CGRect secViewRect = secView.frame;
    CGRect dateViewRect = dateView.frame;
    CGRect ampmOffViewRect = ampmOffView.frame;
    float moveGap = 10.f;
    
    [UIView animateWithDuration:.3f delay:.2f options:UIViewAnimationOptionTransitionNone animations:^{
        secView.frame = CGRectMake(secViewRect.origin.x, secViewRect.origin.y+moveGap,
                                   secViewRect.size.width, secViewRect.size.height);
        secView.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:.3f delay:.1f options:UIViewAnimationOptionTransitionNone animations:^{
        dateView.frame = CGRectMake(dateViewRect.origin.x, dateViewRect.origin.y+moveGap,
                                    dateViewRect.size.width, dateViewRect.size.height);
        dateView.alpha = 0;
    } completion:nil];
    [UIView animateWithDuration:.3f delay:.0f options:UIViewAnimationOptionTransitionNone animations:^{
        ampmOffView.frame = CGRectMake(ampmOffViewRect.origin.x, ampmOffViewRect.origin.y+moveGap,
                                       ampmOffViewRect.size.width, ampmOffViewRect.size.height);
        ampmOffView.alpha = 0;
    } completion:nil];
}

- (void) rotateWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame {
    [UIView animateWithDuration:.3f animations:^{
        self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    }];
    [self repositionWithWinSize:winSize settingLabelFrame:settingLabelFrame animate:YES];
}
- (void) repositionWithWinSize:(CGSize)winSize settingLabelFrame:(CGRect)settingLabelFrame animate:(BOOL)animate {
    
    CGRect secViewRect = CGRectZero;
    CGRect dateViewRect = CGRectZero;
    CGRect ampmOffViewRect = CGRectZero;
    if (ISIPAD) {
        secViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width+13.f,
                                 settingLabelFrame.origin.y-LABEL_SWITCH_HEIGHT/2.f,
                                 LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
        dateViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width+13.f,
                                  secViewRect.origin.y+LABEL_AND_SWITCH_GAP,
                                  LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
        ampmOffViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width+13.f,
                                     dateViewRect.origin.y+LABEL_AND_SWITCH_GAP,
                                     LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
    } else {
        secViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width/2.f-LABEL_SWITCH_WIDTH/2.f,
                                 settingLabelFrame.origin.y+settingLabelFrame.size.height-LABEL_SWITCH_HEIGHT/2.f,
                                 LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
        dateViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width/2.f-LABEL_SWITCH_WIDTH/2.f,
                                  secViewRect.origin.y+LABEL_AND_SWITCH_GAP,
                                  LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
        ampmOffViewRect = CGRectMake(settingLabelFrame.origin.x+settingLabelFrame.size.width/2.f-LABEL_SWITCH_WIDTH/2.f,
                                     dateViewRect.origin.y+LABEL_AND_SWITCH_GAP,
                                     LABEL_SWITCH_WIDTH, LABEL_SWITCH_HEIGHT);
    }
    
    if (animate) {
        [UIView animateWithDuration:.3f animations:^{

            secView.frame = secViewRect;
            dateView.frame = dateViewRect;
            ampmOffView.frame = ampmOffViewRect;
        }];
    } else {
        secView.frame = secViewRect;
        dateView.frame = dateViewRect;
        ampmOffView.frame = ampmOffViewRect;
//        NSLog(@"ampmOffView.frame:%@", NSStringFromCGRect(ampmOffViewRect));
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self menuSettingOffEvent];
}


#pragma mark - 스위치 정보 불러오기
- (void) reloadSettingInfo {
    if ([OptionController shared].secondOff) [secSwitch setOn:NO];
    else [secSwitch setOn:YES];
    
    if ([OptionController shared].dateOff) [dateSwitch setOn:NO];
    else [dateSwitch setOn:YES];
    
    if ([OptionController shared].ampmOff) [ampmOffSwitch setOn:YES];
    else [ampmOffSwitch setOn:NO];
}

#pragma mark - 스위치 누를시
- (void) changeSecondOn:(UISwitch *)sender {
    if (sender.on) {
        [OptionController shared].secondOff = NO;
    } else {
        [OptionController shared].secondOff = YES;
    }
}

- (void) changeDateOn:(UISwitch  *)sender {
    if (sender.on) {
        [OptionController shared].dateOff = NO;
    } else {
        [OptionController shared].dateOff = YES;
    }
}
- (void) change24Off:(UISwitch  *)sender {
    if (sender.on) {
        [OptionController shared].ampmOff = YES;
    } else {
        [OptionController shared].ampmOff = NO;
    }
}





@end