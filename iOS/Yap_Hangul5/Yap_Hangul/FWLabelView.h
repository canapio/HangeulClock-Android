//
//  FWLabelView.h
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 11..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWLabelView : UIView

- (id) initWithFontName:(NSString *)fn fontSize:(CGFloat)fs width:(CGFloat)w ;

- (void) changeTextArray:(NSArray *)textArray;
- (float) changeText:(NSString *)text ;
- (float) changeText:(NSString *)text width:(CGFloat)w ;

- (void) removeAnimationWithBlock:(void(^)())block ;


@property (nonatomic, retain) NSString *fontName;
@property (nonatomic) CGFloat fontSize;
@property (nonatomic) CGFloat width;

@end
