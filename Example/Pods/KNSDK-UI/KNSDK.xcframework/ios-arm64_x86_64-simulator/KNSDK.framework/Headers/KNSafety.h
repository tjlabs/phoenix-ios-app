//
//  KNSafety.h
//  KNSDK
//
//  Created by rex.zar on 02/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 안전운행 정보 속성
 
 데이터 타입과 무관하며 서비스를 위한 속성 구분
 */
typedef NS_ENUM(SInt32, KNSafetyType)
{
    /**주의 안내 지점 */
    KNSafetyType_Caution        = 0,        //  주의 안내 지점
    /** 단속카메라 안내 지점, 속도위반 카메라의 경우 제한속도에 따른 알림음 발생 */
    KNSafetyType_Camera         = 1,        //  단속카메라 안내 지점, 속도위반 카메라의 경우 제한속도에 따른 알림음 발생
    /** 구간단속 안내 지점, 제한속도에 따른 알림음 발생 */
    KNSafetyType_Section        = 2         //  구간단속 안내 지점, 제한속도에 따른 알림음 발생
};

/**
 안전운행 코드
 */
typedef NS_ENUM(SInt32, KNSafetyCode)
{
    /**  교통사고 다발 */
    KNSafetyCode_TrafficAccidentPos                     = 0,            //  교통사고 다발
    /**  급회전 */
    KNSafetyCode_SharpTurnSection                       = 1,            //  급회전
    /**  낙석위험 */
    KNSafetyCode_FallingRocksArea                       = 2,            //  낙석위험(데이터 없음)
    /**  안개지역 */
    KNSafetyCode_FogArea                                = 3,            //  안개지역
    /**  추락위험(데이터 없음) */
    KNSafetyCode_FallingCaution                         = 4,            //  추락위험(데이터 없음)
    /**  미끄럼주의(데이터 없음) */
    KNSafetyCode_SlippingRoad                           = 5,            //  미끄럼주의(데이터 없음)
    /**  과속방지턱 */
    KNSafetyCode_Hump                                   = 6,            //  과속방지턱
    /**  철도건널목 */
    KNSafetyCode_RailroadCrossing                       = 10,           //  철도건널목
    /**  어린이보호구역 */
    KNSafetyCode_ChildrenProtectionZone                 = 11,           //  어린이보호구역
    /**  좁아지는 도로(데이터 없음) */
    KNSafetyCode_RoadNarrows                            = 12,           //  좁아지는 도로(데이터 없음)
    /**  급경사(내리막) 지역 */
    KNSafetyCode_SteepDownhillSection                   = 13,           //  급경사(내리막) 지역
    /**  야생동물보호지역 */
    KNSafetyCode_AnimalsAppearingCaution                = 14,           //  야생동물보호지역
    /**  졸음쉼터 */
    KNSafetyCode_RestArea                               = 15,           //  졸음쉼터
    /**  졸음운전사고 다발(데이터 없음) */
    KNSafetyCode_DrowsyDrivingAccidentPos               = 16,           //  졸음운전사고 다발(데이터 없음)
    /**  오르막차로 구간(데이터 없음) */
    KNSafetyCode_UphillSection                          = 17,           //  오르막차로 구간(데이터 없음)
    /**  주의신호등(데이터 없음) */
    KNSafetyCode_CautionSignals                         = 18,           //  주의신호등(데이터 없음)
    /**  무정차 톨게이트 */
    KNSafetyCode_OneTollingGate                         = 20,           //  무정차 톨게이트
    /**  차대차사고 다발 */
    KNSafetyCode_CarAccidentPos                         = 21,           //  차대차사고 다발
    /**  보행자사고 다발 */
    KNSafetyCode_PedestrianAccidentPos                  = 22,           //  보행자사고 다발
    /**  어린이보호구역 내 어린이사고 다발 */
    KNSafetyCode_ChildrenAccidentPos                    = 23,           //  어린이보호구역 내 어린이사고 다발
    /**  어린이보호구역 내 어린이사고 다발 */
    KNSafetyCode_FrozenRoad                             = 24,           //  상습결빙구간
    /**  어린이보호구역 내 어린이사고 다발 */
    KNSafetyCode_HeightLimitPos                         = 28,           //  높이제한
    /**  어린이보호구역 내 어린이사고 다발 */
    KNSafetyCode_WeightLimitPos                         = 29,           //  중량제한
    /**  안개 주의구간(Live) */
    KNSafetyCode_FogAreaLive                            = 31,           //  안개 주의구간(Live)
    /**  결빙 주의구간(Live) */
    KNSafetyCode_FrozenRoadLive                         = 32,           //  결빙 주의구간(Live)
    /**  기타단속(데이터 없음) */
    KNSafetyCode_ViolationCamera                        = 80,           //  기타단속(데이터 없음)
    /**  이동식 과속단속 카메라 */
    KNSafetyCode_MovableSpeedViolationCamera            = 81,           //  이동식 과속단속 카메라
    /**  고정식 과속단속 카메라 */
    KNSafetyCode_SpeedViolationCamera                   = 82,           //  고정식 과속단속 카메라
    /**  정보수집 카메라 */
    KNSafetyCode_TrafficColectionCamera                 = 83,           //  정보수집 카메라
    /**  버스전용차로 위반단속 카메라 */
    KNSafetyCode_BuslaneViolationCamera                 = 84,           //  버스전용차로 위반단속 카메라
    /**  과적단속 카메라 */
    KNSafetyCode_OverloadViolationCamera                = 85,           //  과적단속 카메라
    /**  신호&과속단속 카메라 */
    KNSafetyCode_SignalAndSpeedViolationCamera          = 86,           //  신호&과속단속 카메라
    /**  주정차 위반단속 카메라 */
    KNSafetyCode_ParkingViolationCamera                 = 87,           //  주정차 위반단속 카메라
    /**  적재불량단속 카메라 */
    KNSafetyCode_CargoViolationCamera                   = 88,           //  적재불량단속 카메라
    /**  버스전용차로&신호 위반단속 카메라 */
    KNSafetyCode_BuslaneAndSpeedViolationCamera         = 89,           //  버스전용차로&신호 위반단속 카메라
    /**  신호 위반단속 카메라 */
    KNSafetyCode_SignalViolationCamera                  = 90,           //  신호 위반단속 카메라
    /**  차로&과속단속 카메라 */
    KNSafetyCode_LaneAndSpeedViolationCamera            = 91,           //  차로&과속단속 카메라
    /**  구간단속시점 카메라 */
    KNSafetyCode_SpeedViolationSectionInCamera          = 92,           //  구간단속시점 카메라
    /**  구간단속종점 카메라 */
    KNSafetyCode_SpeedViolationSectionOutCamera         = 93,           //  구간단속종점 카메라
    /**  갓길단속 카메라 */
    KNSafetyCode_ShoulderLaneViolationCamera            = 94,           //  갓길단속 카메라
    /**  끼어들기 위반단속 카메라 */
    KNSafetyCode_CutInViolationCamera                   = 95,           //  끼어들기 위반단속 카메라
    /**  구간단속 구간 */
    KNSafetyCode_SpeedViolationSection                  = 96,           //  구간단속 구간
    /**  지정차로단속 카메라 */
    KNSafetyCode_DrivingLaneViolationCamera             = 97,           //  지정차로단속 카메라
    /**  차로변경 구간단속시점 카메라 */
    KNSafetyCode_LandChangeViolationSectionInCamera     = 98,           //  차로변경 구간단속시점 카메라
    /**  차로변경 구간단속종점 카메라 */
    KNSafetyCode_LandChangeViolationSectionOutCamera    = 99,           //  차로변경 구간단속종점 카메라
    /**  박스형 과속단속 카메라 */
    KNSafetyCode_BoxedSpeedViolationCamera              = 100,          //  박스형 과속단속 카메라
    /**  안전띠 미착용단속 카메라 */
    KNSafetyCode_SeatBeltViolationCamera                = 101,          //  안전띠 미착용단속 카메라
    /**  고정식 과속단속 카메라(후면) */
    KNSafetyCode_SpeedViolationBackwardCamera           = 102,          //  고정식 과속단속 카메라(후면)
    /**  신호&과속단속 카메라(후면) */
    KNSafetyCode_SignalAndSpeedViolationBackwardCamera  = 103           //  신호&과속단속 카메라(후면)
};

//  KNSafety
//  ====================================================================================================================
/**
 안전운행 정보 루트 클래스
 */
@interface KNSafety : NSObject

@property (nonatomic, readonly) KNLocation          *location;
@property (nonatomic, readonly) KNSafetyCode        code;

/**
 안전운행 정보 속성
 
 @return 안전운행 정보 속성
 @see KNSafetyType
 */
- (KNSafetyType)safetyType;                 // 서브클래스에서 오버라이드

/**
 동일한 안전운행 정보인지 여부
 
 객체가 아닌 정보로 비교
 @return 동일여부
 */
- (BOOL)isSameToSafety:(KNSafety *)aSafety;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNSafety_Caution
//  ====================================================================================================================
/**
 안전운행 정보(주의 안내 지점)
 
 주의 표지판 정보, 방지턱 등
 */
@interface KNSafety_Caution : KNSafety

/**
 제한값
 코드에 따라 상이함. 높이제한 시 cm, 중량제한 시 0.1t, 값 없을 시 0
 */
@property (nonatomic, readonly) SInt32              limit;         //  제한값

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNSafety_Camera
//  ====================================================================================================================
/**
 안전운행 정보(단속 카메라 및 기타 카메라 정보)
 */
@interface KNSafety_Camera : KNSafety

/**
 제한속도(Km/h)
 */
@property (nonatomic, readonly) SInt32              speedLimit;         //  제한속도

/**
 가변속도제한 운영 유무
 */
@property (nonatomic, readonly) BOOL                isVariableSpeedLimit;         //  가변속도제한 운영 유무

/**
 위반상태 여부
 */
@property (nonatomic, readonly) BOOL                onViolation;        //  위반상태 여부

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNSafety_Section
//  ====================================================================================================================
/**
 안전운행 정보(구간단속)
 */
@interface KNSafety_Section : KNSafety_Camera

/**
 구간 평속(Km/h)
 */
@property (nonatomic, readonly) SInt32              sectionAvrSpeed;                //  구간 평속

/**
 위반 해제까지 남은 시간(초)
 */
@property (nonatomic, readonly) SInt32              remainTimeToCutline;            //  위반 시간까지 남은 시간.

@end
//  --------------------------------------------------------------------------------------------------------------------

NS_ASSUME_NONNULL_END
