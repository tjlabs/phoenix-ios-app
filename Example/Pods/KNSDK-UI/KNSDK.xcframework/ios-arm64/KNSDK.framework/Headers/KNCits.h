//
//  KNCits.h
//  KNSDK
//
//  Created by rex.zar on 02/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CITS 정보 속성
 */
typedef NS_ENUM(SInt32, KNCitsType)
{
    /**신호등 현시정보 */
    KNCitsType_TrafSignal       = 0,        //  신호등
    /**사고정보 */
    KNCitsType_Accident         = 1,        //  사고정보
    /**응급차량정보 */
    KNCitsType_Emergency        = 2         //  응급차량정보
};

/**
 CITS 정보 상태
 */
typedef NS_ENUM(SInt32, KNCitsState)
{
    KNCitsState_Unknown         = 0,        //  알수없음
    KNCitsState_OnSight         = 1,        //  안내거리에 들어옴
    KNCitsState_Passed          = 2,        //  지나침
    KNCitsState_OutOfSight      = 3,        //  안내거리에서 벗어남
};

/**
 CITS 신호현시정보 개별 신호 정보 속성
 
 개별 신호 속성(직진, 좌회전 등)
 */
typedef NS_ENUM(SInt32, KNCitsTrafSignalSpatType)
{
    KNCitsTrafSignalSpatType_Unknown        = 0,        //  알수없음
    KNCitsTrafSignalSpatType_Straight       = 1,        //  직진
    KNCitsTrafSignalSpatType_Left           = 2,        //  좌회전
    KNCitsTrafSignalSpatType_Right          = 3,        //  우회전
    KNCitsTrafSignalSpatType_UTurn          = 4,        //  유턴
    KNCitsTrafSignalSpatType_Bus            = 5,        //  버스
    KNCitsTrafSignalSpatType_Ped            = 6,        //  보행
    KNCitsTrafSignalSpatType_Bycycle        = 7         //  자전거
};

/**
 CITS 신호현시정보 개별 신호 정보 상태
 
 개별 신호 상태(점멸, 점등 등)
 */
typedef NS_ENUM(SInt32, KNCitsTrafSignalSpatState)
{
    KNCitsTrafSignalSpatState_Unknown           = 0,        //  알수없음
    KNCitsTrafSignalSpatState_Dark              = 1,        //  소등
    KNCitsTrafSignalSpatState_FlashingRed       = 2,        //  적색점멸
    KNCitsTrafSignalSpatState_Red               = 3,        //  적색점등
    KNCitsTrafSignalSpatState_FlashingGreen     = 4,        //  녹색점멸
    KNCitsTrafSignalSpatState_Green             = 5,        //  녹색점등
    KNCitsTrafSignalSpatState_FlashingYellow    = 6,        //  황색점멸
    KNCitsTrafSignalSpatState_Yellow            = 7         //  황색점등
};

//  KNCits
//  ====================================================================================================================
/**
 CITS 정보 루트 클래스
 */
@interface KNCits : NSObject

@property (nonatomic, readonly) KNCitsState         state;
@property (nonatomic, readonly) KNLocation          *location;

/**
 CITS 정보 속성
 
 @return CITS 정보 속성
 @see KNCitsType
 */
- (KNCitsType)citsType;                     // 서브클래스에서 오버라이드

/**
 동일한 CITS 정보인지 여부
 
 객체가 아닌 정보로 비교
 @return 동일여부
 */
- (BOOL)isSameToCits:(KNCits *)aCits;

@end
//  --------------------------------------------------------------------------------------------------------------------

//  KNCits_TrafSignal
//  ====================================================================================================================
/**
 CITS 신호현시정보 개별 신호 정보
 
 신호등의 개별 신호 정보
 */
@interface KNCits_TrafSignalSpat : NSObject

@property (nonatomic, readonly) KNCitsTrafSignalSpatType    type;
@property (nonatomic, readonly) KNCitsTrafSignalSpatState   state;
@property (nonatomic, readonly) SInt32                      remainTime;

@end

/**
 CITS 신호현시정보
 */
@interface KNCits_TrafSignal : KNCits

/**
 신호등 현시정보
 
 개별 신호에 대한 정보 리스트
 */
@property (nonatomic, readonly) NSArray<KNCits_TrafSignalSpat *>    *spats;

@end
//  --------------------------------------------------------------------------------------------------------------------

//  KNCits_Accident
//  ====================================================================================================================
/**
 사고 정보
 */
@interface KNCits_Accident : KNCits

@property (nonatomic, readonly) SInt64                  eventId;
@property (nonatomic, readonly) NSString                *title;
@property (nonatomic, readonly) NSString                *text;
@property (nonatomic, readonly) NSString                *roadName;
@property (nonatomic, readonly) NSString                *startTime;
@property (nonatomic, readonly) NSString                *endTime;
@property (nonatomic, readonly) NSString                *updateTime;
@property (nonatomic, readonly) NSString                *voiceMan;
@property (nonatomic, readonly) NSString                *voiceWoman;

@end
//  --------------------------------------------------------------------------------------------------------------------

//  KNCits_Emergency
//  ====================================================================================================================
/**
 응급 정보
 */
@interface KNCits_Emergency : KNCits

@property (nonatomic, readonly) SInt64                  eventId;
@property (nonatomic, readonly) NSString                *title;
@property (nonatomic, readonly) NSString                *text;
@property (nonatomic, readonly) NSString                *roadName;
@property (nonatomic, readonly) NSString                *updateTime;
@property (nonatomic, readonly) NSString                *voiceMan;
@property (nonatomic, readonly) NSString                *voiceWoman;

@end
//  --------------------------------------------------------------------------------------------------------------------

NS_ASSUME_NONNULL_END
