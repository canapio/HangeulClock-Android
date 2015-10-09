//
//  HangulConverter.h
//  LabelTest
//
//  Created by Canapio on 2014. 9. 15..
//  Copyright (c) 2014년 Canapio. All rights reserved.
//

#import <Foundation/Foundation.h>

enum TimeConvertType {
    tcType_hour = 0,
    tcType_minute,
    tcType_month
};


@interface HangulConverter : NSObject


- (NSString *) hangulWithTime:(NSInteger)time timeType:(enum TimeConvertType)type ;


// 초성 중성 종성 나누기
- (NSString *) linearHangul:(NSString *)str ;


// 요일
// 1:일요일
// 7:토요일
- (NSString *) weekHanhulWithIndex:(NSUInteger)week ;

@end
