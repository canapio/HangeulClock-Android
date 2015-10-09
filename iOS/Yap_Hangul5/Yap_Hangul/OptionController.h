//
//  OptionController.h
//  Yap_Hangul2
//
//  Created by Canapio(Crossys) on 2014. 9. 25..
//
//

#import <Foundation/Foundation.h>

@class MainViewController;
@interface OptionController : NSObject


+(OptionController * )shared ;


@property (nonatomic, retain) MainViewController *mainViewController;



@property (nonatomic) BOOL secondOff;
@property (nonatomic) BOOL dateOff;
@property (nonatomic) BOOL ampmOff;
@end
