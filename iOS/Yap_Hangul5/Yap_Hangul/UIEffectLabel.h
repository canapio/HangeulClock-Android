//
//  UIEffectLabel.h
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 10..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <UIKit/UIKit.h>
#define MAX_OPACITY (.4f)


@interface UIEffectLabel : UIView

- (id) initWithString:(NSString*)str fontName:(NSString*)name fontSize:(CGFloat)size init:(BOOL)init Opacity:(CGFloat)o ;
- (id) initSearchStringWithString:(NSString*)str fontName:(NSString*)name fontSize:(CGFloat)size Opacity:(CGFloat)o ;
- (id) initWithString:(NSString*)str fontSize:(CGFloat)size TotalDelay:(CGFloat)td RandomDelay:(CGFloat)rd Delay:(CGFloat)dl Opacity:(CGFloat)o ;
- (id) initWithString:(NSString*)str fontName:(NSString*)fontName fontSize:(CGFloat)size TotalDelay:(CGFloat)td RandomDelay:(CGFloat)rd Delay:(CGFloat)dl Opacity:(CGFloat)o ;



- (void) removeAnimateWithTotalDelay:(CGFloat)td RaddomDelay:(CGFloat)rd ;
- (void) removeAnimateWithIsSearch:(BOOL)isSearch;
- (float) getWidth ;

@property (nonatomic, retain) NSMutableArray *charLabelArray;
@property (nonatomic, retain) NSString *labelTitle;

@end
