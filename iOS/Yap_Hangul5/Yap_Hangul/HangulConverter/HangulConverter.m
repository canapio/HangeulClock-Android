//
//  HangulConverter.m
//  LabelTest
//
//  Created by Canapio on 2014. 9. 15..
//  Copyright (c) 2014년 Canapio. All rights reserved.
//

#import "HangulConverter.h"

#define HANGUL_UNIT_10 @"십"
#define HANGUL_UNIT_100 @"백"
#define HANGUL_UNIT_1000 @"천"
//#define HANGUL_UNIT_10000 @"만"



@interface HangulConverter () {
    
}
@property (nonatomic, retain) NSArray *cho;
@property (nonatomic, retain) NSArray *jung;
@property (nonatomic, retain) NSArray *jong;
@end

@implementation HangulConverter





- (NSString *) hangulWithTime:(NSInteger)time timeType:(enum TimeConvertType)type {
    
    if (time<=0) return @"영";
    else {
        
        if (type==tcType_hour) {
            return [self houreStringWithUnit:time];
        } else if (type==tcType_minute || type==tcType_month) {
            NSMutableString *hangulStr = [[NSMutableString alloc] initWithString:@""];
            int unit = 0;
            while (time!=0) {
                if (time%10==0) {
                    
                } else {
                    if (unit==0) {}
                    else if (unit==1) [hangulStr insertString:HANGUL_UNIT_10 atIndex:0];
                    else if (unit==2) [hangulStr insertString:HANGUL_UNIT_100 atIndex:0];
                    else if (unit==3) [hangulStr insertString:HANGUL_UNIT_1000 atIndex:0];
                    else assert(0);
                    
                    if (time%10!=1 || unit==0) {
                        [hangulStr insertString:[self minuteStringWithOneUnit:time%10] atIndex:0];
                    }
                    
                }
                unit++;
                time/=10;
            }
            if (type==tcType_month) {
                if ([hangulStr isEqualToString:@"육"]) hangulStr = [[NSMutableString alloc] initWithString:@"유"];
                else if ([hangulStr isEqualToString:@"십"]) hangulStr = [[NSMutableString alloc] initWithString:@"시"];
            }
            
            return hangulStr;
            
        } else {
            return nil;
        }
    }
}



- (NSString *)minuteStringWithOneUnit:(NSInteger)time {
    if (time==0) return @"영";
    else if (time==1) return @"일";
    else if (time==2) return @"이";
    else if (time==3) return @"삼";
    else if (time==4) return @"사";
    else if (time==5) return @"오";
    else if (time==6) return @"육";
    else if (time==7) return @"칠";
    else if (time==8) return @"팔";
    else if (time==9) return @"구";
    
    return nil;
}
- (NSString *)houreStringWithUnit:(NSInteger)time {
    if (time==0) return @"영";
    else if (time==1) return @"한";
    else if (time==2) return @"두";
    else if (time==3) return @"세";
    else if (time==4) return @"네";
    else if (time==5) return @"다섯";
    else if (time==6) return @"여섯";
    else if (time==7) return @"일곱";
    else if (time==8) return @"여덟";
    else if (time==9) return @"아홉";
    else if (time==10) return @"열";
    else if (time==11) return @"열한";
    else if (time==12) return @"열두";
    else if (time==13) return @"열세";
    else if (time==14) return @"열네";
    else if (time==15) return @"열다섯";
    else if (time==16) return @"열여섯";
    else if (time==17) return @"열일곱";
    else if (time==18) return @"열여덟";
    else if (time==19) return @"열아홉";
    else if (time==20) return @"스무";
    else if (time==21) return @"스물한";
    else if (time==22) return @"스물두";
    else if (time==23) return @"스물세";
    else if (time==24) return @"스물네";
    else assert(0);
    
    return nil;
}



- (NSString *) linearHangul:(NSString *)str {
    if (!self.cho) self.cho = @[@"ㄱ",@"ㄲ",@"ㄴ",@"ㄷ",@"ㄸ",@"ㄹ",@"ㅁ",@"ㅂ",@"ㅃ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅉ",@"ㅊ",@"ㅋ",@"ㅌ",@"ㅍ",@"ㅎ"];
    if (!self.jung) self.jung = @[@"ㅏ",@"ㅐ",@"ㅑ",@"ㅒ",@"ㅓ",@"ㅔ",@"ㅕ",@"ㅖ",@"ㅗ",@"ㅘ",@"ㅙ",@"ㅚ",@"ㅛ",@"ㅜ",@"ㅝ",@"ㅞ",@"ㅟ",@"ㅠ",@"ㅡ",@"ㅢ",@"ㅣ"];
    if (!self.jong) self.jong = @[@"",@"ㄱ",@"ㄲ",@"ㄳ",@"ㄴ",@"ㄵ",@"ㄶ",@"ㄷ",@"ㄹ",@"ㄺ",@"ㄻ",@"ㄼ",@"ㄽ",@"ㄾ",@"ㄿ",@"ㅀ",@"ㅁ",@"ㅂ",@"ㅄ",@"ㅅ",@"ㅆ",@"ㅇ",@"ㅈ",@"ㅊ",@"ㅋ",@" ㅌ",@"ㅍ",@"ㅎ"];
    NSString *result = @"";
    for (int i=0;i<[str length];i++) {
        NSInteger code = [str characterAtIndex:i] - 44032;
        if (code > -1 && code < 11172) {
            NSInteger choIdx = code / 21 / 28;
            NSInteger jungIdx = code % (21 * 28) / 28;
            NSInteger jongIdx = code % 28;
            if ([[self.jung objectAtIndex:jungIdx] isEqualToString:@"ㅝ"]) {
                result = [NSString stringWithFormat:@"%@%@%@%@", result,
                          [self.cho objectAtIndex:choIdx],
                          @"ㅜㅓ",
                          [self.jong objectAtIndex:jongIdx]];
            } else if ([[self.jung objectAtIndex:jungIdx] isEqualToString:@"ㅘ"]) {
                result = [NSString stringWithFormat:@"%@%@%@%@", result,
                          [self.cho objectAtIndex:choIdx],
                          @"ㅗㅏ",
                          [self.jong objectAtIndex:jongIdx]];
            } else {
                result = [NSString stringWithFormat:@"%@%@%@%@", result,
                          [self.cho objectAtIndex:choIdx],
                          [self.jung objectAtIndex:jungIdx],
                          [self.jong objectAtIndex:jongIdx]];
            }
            
        }
    }
    return result;
}



- (NSString *) weekHanhulWithIndex:(NSUInteger)week {
    if (week==1) return @"일요일";
    else if (week==2) return @"월요일";
    else if (week==3) return @"화요일";
    else if (week==4) return @"수요일";
    else if (week==5) return @"목요일";
    else if (week==6) return @"금요일";
    else if (week==7) return @"토요일";
    else return @"월요일";
}

@end
