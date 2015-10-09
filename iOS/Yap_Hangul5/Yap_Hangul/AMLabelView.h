//
//  AMLabelView.h
//  Yap_Hangul
//
//  Created by doyoung gwak on 2014. 10. 11..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <UIKit/UIKit.h>


#define ANI_TEXT_DELAY .7f
#define ANI_TEXT_INTERVAL .13f

@interface AMLabelView : UIView


/** creates a UILabel with a font name and font size in points*/
- (id) initWithFontName:(NSString*)name fontSize:(CGFloat)size ;
- (id) initWithFontName:(NSString*)name fontSize:(CGFloat)size extraGap:(CGFloat)gap ;


- (void) setLabelCount:(int)lc ;


- (float) changeText:(NSString *)text ;
- (float) changeTextWithOutAnimation:(NSString *)text ;


- (void) removeAnimationWithBlock:(void(^)())block ;


/** Font name used in the label */
@property (nonatomic, retain) NSString* fontName;
/** Font size of the label */
@property (nonatomic) float fontSize;

@property (nonatomic) float labelGap;



@property (nonatomic) BOOL isHidden;



@end
