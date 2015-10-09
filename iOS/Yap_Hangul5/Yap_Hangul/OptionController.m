//
//  OptionController.m
//  Yap_Hangul2
//
//  Created by Canapio(Crossys) on 2014. 9. 25..
//
//

#import "OptionController.h"
#import "MainViewController.h"


#define SECOND_KEY @"second off"
#define DATE_KEY @"date off"
#define AMPM_KEY @"ampm off"

@implementation OptionController
+ (OptionController *)shared {
    static OptionController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[OptionController alloc] init];
        // Do any other initialisation stuff here
    });
    return sharedInstance;
}
- (id)init
{
    if (self = [super init]) {
        self.secondOff = [[NSUserDefaults standardUserDefaults] boolForKey:SECOND_KEY];
        self.dateOff = [[NSUserDefaults standardUserDefaults] boolForKey:DATE_KEY];
        self.ampmOff = [[NSUserDefaults standardUserDefaults] boolForKey:AMPM_KEY];
    }
    return self;
}

- (void)setSecondOff:(BOOL)secondOff {
    _secondOff = secondOff;
    [[NSUserDefaults standardUserDefaults] setBool:_secondOff forKey:SECOND_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if (self.mainViewController) {
        [self.mainViewController setSecondOff:secondOff];
    }
}
- (void)setDateOff:(BOOL)dateOff {
    _dateOff = dateOff;
    [[NSUserDefaults standardUserDefaults] setBool:_dateOff forKey:DATE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.mainViewController) {
        [self.mainViewController setDateOff:dateOff];
    }
}
- (void)setAmpmOff:(BOOL)ampmOff {
    _ampmOff = ampmOff;
    [[NSUserDefaults standardUserDefaults] setBool:_ampmOff forKey:AMPM_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.mainViewController) {
        [self.mainViewController setAmpmOff:ampmOff];
    }
}
















@end
