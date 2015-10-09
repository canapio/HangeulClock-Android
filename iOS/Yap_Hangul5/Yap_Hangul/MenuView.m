//
//  MenuView.m
//  Yap_Hangul5
//
//  Created by doyoung gwak on 2014. 10. 13..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import "MenuView.h"

#import "MainViewController.h"
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>

#import "MenuSettingView.h"
#import "UIEffectLabel.h"
#import "MenuButtonView.h"




#define MENU_FONTSIZE ((ISIPAD)?32.f:28.f)

#define MENU_BUTTON_EXTRA_GAP ((ISIPAD)?30.f:16.f)

@interface MenuView () <MenuButtonDelegate, MFMailComposeViewControllerDelegate, SKStoreProductViewControllerDelegate> {
    
    MenuSettingView *menuSettingView;
    CAGradientLayer *gradient;
    
    UIEffectLabel *settingLabel;
    UIEffectLabel *rateLabel;
    UIEffectLabel *feedLabel;
    
    MenuButtonView *settingMenuButton;
    MenuButtonView *rateMenuButton;
    MenuButtonView *feedMenuButton;
    
    
}

@end

@implementation MenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        gradient = [CAGradientLayer layer];
        gradient.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        gradient.startPoint = CGPointMake(1.0, 0.5);
        gradient.endPoint = CGPointMake(0.0, 0.5);
        gradient.colors = [NSArray arrayWithObjects:
                           (id)[[UIColor colorWithWhite:0.f alpha:.68f] CGColor],
                           (id)[[UIColor colorWithWhite:0.f alpha:.95f] CGColor], nil];
        [self.layer insertSublayer:gradient atIndex:0];
        
        settingMenuButton = nil;
    }
    return self;
}

- (void) menuOnEvent {
    self.menuOn = YES;
    
    [self makeEffectLabelAndButton];
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 1.f;
    } completion:^(BOOL finished) {
//        self.userInteractionEnabled = YES;
    }];
}
- (void) menuOffEvent {
    self.menuOn = NO;
    [self removeEffectLabel];
    self.userInteractionEnabled = NO;
    [UIView animateWithDuration:.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
//        self.userInteractionEnabled = YES;
    }];
}

- (void) makeEffectLabelAndButton {
    [self removeEffectLabel];
    
    
    
    settingLabel = [[UIEffectLabel alloc] initWithString:@"설정하기"
                                             fontName:FONT_NORMAL
                                             fontSize:MENU_FONTSIZE
                                                 init:NO
                                              Opacity:1.f];
    [self addSubview:settingLabel];
    rateLabel = [[UIEffectLabel alloc] initWithString:@"평가하기"
                                             fontName:FONT_NORMAL
                                             fontSize:MENU_FONTSIZE
                                                 init:NO
                                              Opacity:1.f];
    [self addSubview:rateLabel];
    feedLabel = [[UIEffectLabel alloc] initWithString:@"건의하기"
                                             fontName:FONT_NORMAL
                                             fontSize:MENU_FONTSIZE
                                                 init:NO
                                              Opacity:1.f];
    [self addSubview:feedLabel];
    
    
    
    if (!settingMenuButton) {
        settingMenuButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:settingMenuButton];
        rateMenuButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:rateMenuButton];
        feedMenuButton = [[MenuButtonView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:feedMenuButton];
        
        settingMenuButton.delegate = self;
        rateMenuButton.delegate = self;
        feedMenuButton.delegate = self;
    }
    
    [self repositionWithWinSize:self.frame.size animate:NO];
}
- (void) removeEffectLabel {
    if (settingLabel) {
        [settingLabel removeAnimateWithIsSearch:NO];
    }
    if (rateLabel) {
        [rateLabel removeAnimateWithIsSearch:NO];
    }
    if (feedLabel) {
        [feedLabel removeAnimateWithIsSearch:NO];
    }
}
- (void) repositionWithWinSize:(CGSize)winSize animate:(BOOL)animate {
    
    CGRect feedLabelRect = CGRectZero;
    CGRect rateLabelRect = CGRectZero;
    CGRect settingLabelRect = CGRectZero;
    
    CGRect feedButtonRect = CGRectZero;
    CGRect rateButtonRect = CGRectZero;
    CGRect settingButtonRect = CGRectZero;
    
    if (ISIPAD) {
        feedLabelRect = CGRectMake(80.f, winSize.height-113.f, [feedLabel getWidth], feedLabel.frame.size.height);
        rateLabelRect = CGRectMake(80.f, feedLabelRect.origin.y-101.f, [rateLabel getWidth], rateLabel.frame.size.height);
        settingLabelRect = CGRectMake(80.f, rateLabelRect.origin.y-101.f, [settingLabel getWidth], settingLabel.frame.size.height);
        
        feedButtonRect = CGRectMake(feedLabelRect.origin.x-MENU_BUTTON_EXTRA_GAP,
                                    feedLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-feedLabelRect.size.height/2.f,
                                    feedLabelRect.size.width+MENU_BUTTON_EXTRA_GAP*2,
                                    feedLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
        rateButtonRect = CGRectMake(rateLabelRect.origin.x-MENU_BUTTON_EXTRA_GAP,
                                    rateLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-rateLabelRect.size.height/2.f,
                                    rateLabelRect.size.width+MENU_BUTTON_EXTRA_GAP*2,
                                    rateLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
        settingButtonRect = CGRectMake(settingLabelRect.origin.x-MENU_BUTTON_EXTRA_GAP,
                                       settingLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-settingLabelRect.size.height/2.f,
                                       settingLabelRect.size.width+MENU_BUTTON_EXTRA_GAP*2,
                                       settingLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
    } else {
        if (winSize.width<winSize.height) {
            settingLabelRect = CGRectMake(winSize.width/2.f-[feedLabel getWidth]/2.f, 113.f, [feedLabel getWidth], feedLabel.frame.size.height);
            rateLabelRect = CGRectMake(winSize.width/2.f-[rateLabel getWidth]/2.f, settingLabelRect.origin.y+80.f, [rateLabel getWidth], rateLabel.frame.size.height);
            feedLabelRect = CGRectMake(winSize.width/2.f-[settingLabel getWidth]/2.f, rateLabelRect.origin.y+80.f, [settingLabel getWidth], settingLabel.frame.size.height);
        } else {
            rateLabelRect = CGRectMake(winSize.width/2.f-[rateLabel getWidth]/2.f, winSize.height/2.f, [rateLabel getWidth], rateLabel.frame.size.height);
            settingLabelRect = CGRectMake(winSize.width/2.f-[feedLabel getWidth]/2.f, rateLabelRect.origin.y-80.f, [feedLabel getWidth], feedLabel.frame.size.height);
            
            feedLabelRect = CGRectMake(winSize.width/2.f-[settingLabel getWidth]/2.f, rateLabelRect.origin.y+80.f, [settingLabel getWidth], settingLabel.frame.size.height);
        }
        
        
        feedButtonRect = CGRectMake(-100,
                                    feedLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-feedLabelRect.size.height/2.f,
                                    winSize.width+100*2,
                                    feedLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
        rateButtonRect = CGRectMake(-100,
                                    rateLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-rateLabelRect.size.height/2.f,
                                    winSize.width+100*2,
                                    rateLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
        settingButtonRect = CGRectMake(-100,
                                       settingLabelRect.origin.y-MENU_BUTTON_EXTRA_GAP-settingLabelRect.size.height/2.f,
                                       winSize.width+100*2,
                                       settingLabelRect.size.height+MENU_BUTTON_EXTRA_GAP*2);
    }
    
    
    
    if (animate) {
        [UIView animateWithDuration:.3f animations:^{
            feedLabel.frame = feedLabelRect;
            rateLabel.frame = rateLabelRect;
            settingLabel.frame = settingLabelRect;
            
            feedMenuButton.frame = feedButtonRect;
            rateMenuButton.frame = rateButtonRect;
            settingMenuButton.frame = settingButtonRect;
        }];
    } else {
        feedLabel.frame = feedLabelRect;
        rateLabel.frame = rateLabelRect;
        settingLabel.frame = settingLabelRect;

        feedMenuButton.frame = feedButtonRect;
        rateMenuButton.frame = rateButtonRect;
        settingMenuButton.frame = settingButtonRect;
    }
    
    [feedMenuButton.superview bringSubviewToFront:feedMenuButton];
    [rateMenuButton.superview bringSubviewToFront:rateMenuButton];
    [settingMenuButton.superview bringSubviewToFront:settingMenuButton];
    
    
    if (menuSettingView) {
        [menuSettingView rotateWithWinSize:winSize settingLabelFrame:settingLabel.frame];
    }
}

- (void) rotateWithWinSize:(CGSize)winSize {
    // Main View Controller로부터 화면 회전이 들어올 때
    
    [UIView animateWithDuration:.3f animations:^{
        self.frame = CGRectMake(0, 0, winSize.width, winSize.height);
        gradient.frame = CGRectMake(0, 0, winSize.width, winSize.height);
    }];
    
    [self repositionWithWinSize:winSize animate:YES];
}





#pragma mark - 터치

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    NSLog(@"touchesEnded: menu view");
    if (menuSettingView.menuSettingOn) return;
    
    if (self.menuOn) {
        [self menuOffEvent];
    }
}


#pragma mark - menu button delegate
- (void) clickMenu:(UIView *)v {
    if (menuSettingView.menuSettingOn) return;
    if (v==settingMenuButton) {
        [self clickSetting];
//        NSLog(@"클릭 settingMenuButton");
    } else if (v==rateMenuButton) {
//        NSLog(@"클릭 rateMenuButton");
        [self clickRate];
    } else if (v==feedMenuButton) {
//        NSLog(@"클릭 feedMenuButton");
        [self clickFeedback];
    } else {
        
    }
}

- (void) clickSetting {
    if (!menuSettingView) {
        [self makeMenuSettingView];
    }
    if (!menuSettingView.menuSettingOn) {
        [menuSettingView menuSettingOnEventWithWinSize:self.frame.size settingLabelFrame:settingLabel.frame];
    }
}
- (void) makeMenuSettingView {
    menuSettingView = [[MenuSettingView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:menuSettingView];
    menuSettingView.alpha = 0;
}

- (void) clickRate {
    if(NSClassFromString(@"SKStoreProductViewController")) { // iOS6 이상인지 체크
        // 로딩창 띄우기
//        [[LoadingController shared] showLoadingWithTitle:nil];
        
        SKStoreProductViewController *storeController = [[SKStoreProductViewController alloc] init] ;
        storeController.delegate = self; // productViewControllerDidFinish
        
        NSDictionary *productParameters = @{ SKStoreProductParameterITunesItemIdentifier : APPSTORE_ID};
        
        
        [storeController loadProductWithParameters:productParameters completionBlock:^(BOOL result, NSError *error) {
            if (result) {
                [self.mainViewController presentViewController:storeController animated:YES completion:^{
//                    [[LoadingController shared] hideLoading];
                }];
                
            } else {
//                [[LoadingController shared] hideLoading];
//                [[[UIAlertView alloc] initWithTitle:@"연결 실패"
//                                             message:@"앱을 불러올 수 없습니다."
//                                            delegate:nil
//                                   cancelButtonTitle:@"확인"
//                                   otherButtonTitles: nil] show];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
            }
        }];
    } else { // iOS6 이하일 때
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
    }
}
- (void) clickFeedback {
    if ([MFMailComposeViewController canSendMail]) {
        // 로딩창 띄우기
//        [[LoadingController shared] showLoadingWithTitle:nil];
        
        
        NSString *appName = @"한글시계 App";
        NSString *versionNumber = [[[NSBundle bundleForClass:[self class]] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *phoneModel = [[UIDevice currentDevice] model];
        NSString* iOSVersion = [[UIDevice currentDevice] systemVersion];
        NSString *bodyMessage = [NSString stringWithFormat:@"\n\n\n\napp name : %@\napp version : %@\nDevice : %@\niOS Version : %@", appName, versionNumber, phoneModel, iOSVersion];
        
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init] ;
        mailViewController.mailComposeDelegate = self;
        [mailViewController setToRecipients:[NSArray arrayWithObject:DEV_MAIL]];
        [mailViewController setSubject:@"개발자에게 하고싶은 말이 있어요"];
        [mailViewController setMessageBody:bodyMessage isHTML:NO];
        
        
        
        //        [[CCDirector sharedDirector] presentModalViewController:mailViewController animated:YES];
        [self.mainViewController presentViewController:mailViewController animated:YES completion:^{
//            [[LoadingController shared] hideLoading];
        }];
        
        
    } else {
        NSLog(@"Device is unable to send email in its current state.");
    }
}

#pragma mark - 메일 닫기 Delegate
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    [controller dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 스토어 닫기 Delegate
- (void) productViewControllerDidFinish:(SKStoreProductViewController *)viewController {
    [viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
