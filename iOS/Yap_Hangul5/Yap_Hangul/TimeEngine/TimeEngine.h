//
//  TimeEngine.h
//  TimeEngine1
//
//  Created by doyoung gwak on 2014. 9. 7..
//  Copyright (c) 2014년 doyoung gwak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDate+Calendar.h"



enum TimeChangeType {
    tType_second = 1 << 0,
    tType_minute = 1 << 1,
    tType_hour   = 1 << 2,
    tType_day    = 1 << 3,
    tType_month  = 1 << 4,
    tType_year   = 1 << 5
};
@protocol TimeChangeDelegate <NSObject>

@required
- (void) timeWillChange:(NSDate *)date changeType:(enum TimeChangeType)type afterInterval:(float)afterT;
- (void) timeChanged:(NSDate *)date changeType:(enum TimeChangeType)type ;
@end




/*
    Class명 : TimeEngine(싱글톤)
    
    -(void)MAKE_TIMER; 를 호출하기 전에 changeType, afterInterval을 세팅해줘야한다.
    changeType:
        - 타이머가 만들어지는 시점에 필요한 파라메터
        - 타입중 가장 작은 단위로 설정하여 타이머를 만든다
    afterInterval:
        - 애니메이션 효과를 위한 미리알림
        - 예) afterInterval = .3f;
        - 위와같이 설정하면 [timeChanged::]가 호출되기 .3f초 전에 [timeWillChange:::]가 호출된다.
    그리고 delegate로 호출을 받는다
 
 
 
    타이머를 시작하려면 -(void)MAKE_TIMER;를 호출하면 된다.
 
 */
@interface TimeEngine : NSObject



+(TimeEngine *)shared ;
- (void) MAKE_TIMER ;





@property (nonatomic) enum TimeChangeType changeType;
@property (nonatomic) float afterInterval;
@property (nonatomic, retain) id <TimeChangeDelegate> delegate;
@end
