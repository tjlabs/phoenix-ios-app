//
//  KNSDKDef.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 9. 4..
//  Copyright © 2018년 kakao. All rights reserved.
//

/**
 언어
 */
typedef NS_ENUM(NSInteger, KNLanguageType)
{
    /**  한국어 */
    KNLanguageType_KOREAN           = 0,
    /**  영어 */
    KNLanguageType_ENGLISH          = 1,
    /**  일본어 */
    KNLanguageType_JAPANESE         = 2,
    /**  UNKNOWN = 한국어 */
    KNLanguageType_UNKNOWN          = KNLanguageType_KOREAN
};


/**
 차종
 */
typedef NS_ENUM(NSInteger, KNCarType)
{
    /**  1종(소형차) */
    KNCarType_1             = 0,
    /**  2종(중형차) */
    KNCarType_2             = 1,
    /**  3종(대형차) */
    KNCarType_3             = 2,
    /**  4종(대형화물차) */
    KNCarType_4             = 3,
    /**  5종(특수화물차) */
    KNCarType_5             = 4,
    /**  6종(경차) */
    KNCarType_6             = 5,
    /**  이륜차 */
    KNCarType_Bike          = 6
};


/**
 화물차 차종
 */
typedef NS_ENUM(NSInteger, KNFreightCarType)
{
    /**  화물차 아님 */
    KNFreightCarType_NotFreight     = 0,
    /**  화물자동차 */
    KNFreightCarType_Freight        = 1,
    /**  건설기계 */
    KNFreightCarType_Construction   = 2,
    /**  특수자동차 */
    KNFreightCarType_Specialty      = 3,
    /**  고압가스, 위험물적재차량 */
    KNFreightCarType_TankLorry      = 4
};


/**
 유종
 */
typedef NS_ENUM(NSInteger, KNCarFuel)
{
    /**  가솔린 */
    KNCarFuel_Gasoline              = 0,
    /**  고급휘발류 */
    KNCarFuel_Premium_Gasoline      = 1,
    /**  디젤 */
    KNCarFuel_Diesel                = 2,
    /**  LPG */
    KNCarFuel_LPG                   = 3,
    /**  Electric */
    KNCarFuel_Electric              = 4,
    /**  Hybrid Electric */
    KNCarFuel_HybridElectric        = 5,
    /**  PlugInHybrid Electric */
    KNCarFuel_PlugInHybridElectric  = 6,
    /**  Hydrogen */
    KNCarFuel_Hydrogen              = 7
};


/**
 차종
 */
typedef NS_ENUM(NSInteger, KNCarUsage)
{
    /**  기본 */
    KNCarUsage_Default              = 0,
    /**  택시 */
    KNCarUsage_Taxi                 = 1,
    /**  응급 */
    KNCarUsage_Emergency            = 2
};



/**
 경로우선 옵션
 */
typedef NS_ENUM(SInt32, KNRoutePriority)
{
    /**  추천 */
    KNRoutePriority_Recommand       = 0,
    /**  시간 우선 */
    KNRoutePriority_Time            = 1,
    /**  거리 우선 */
    KNRoutePriority_Distance        = 2,
    /**  고속도로 우선 */
    KNRoutePriority_HighWay         = 3,
    /**  큰길 우선 */
    KNRoutePriority_WideWay         = 4,
    /**  큰길 우선 */
    KNRoutePriority_Preferred       = 5
};


/**
 경로회피 옵션
 */
typedef NS_ENUM(SInt32, KNRouteAvoidOption)
{
    /**  회피옵션 없음  */
    KNRouteAvoidOption_None             = 0x0000,
    /**  유고정보 회피  */
    KNRouteAvoidOption_RoadEvent        = 0x0001,
    /**  페리항로 회피 */
    KNRouteAvoidOption_Farries          = 0x0002,
    /**  유료도로 회피 */
    KNRouteAvoidOption_Fare             = 0x0004,
    /**  자동차전용도로 회피 */
    KNRouteAvoidOption_MotorWay         = 0x0008,
    /**  U턴 회피*/
    KNRouteAvoidOption_UTurn            = 0x0010,
    /**  교통약자 보호 구간 회피*/
    KNRouteAvoidOption_SZone            = 0x0020,
    /**  목적지 반대편 도로 회피*/
    KNRouteAvoidOption_Opposite         = 0x0040
};


/**
 보호구역 종별
 */
typedef NS_ENUM(SInt32, KNSafetyZoneType)
{
    /**  어린이 보호구역 */
    KNSafetyZoneType_SchoolZone             = 0x01,     //  어린이 보호구역
    /**  노인 보호구역 */
    KNSafetyZoneType_SilverZone             = 0x02,     //  노인 보호구역
    /**  장애인 보호구역 */
    KNSafetyZoneType_HandicappedZone        = 0x03      //  장애인 보호구역
};


/**
 교통정보 상태
 */
typedef NS_ENUM(SInt32, KNTrafficState)
{
    /**  교통정보 없음 */
    KNTrafficState_Unknown          = 0,    //  교통정보 없음
    /**  정체 */
    KNTrafficState_Red              = 1,    //  정체
    /**  지체 */
    KNTrafficState_Yellow           = 2,    //  지체
    /**  서행 */
    KNTrafficState_Green            = 3,    //  서행
    /**  원활 */
    KNTrafficState_Blue             = 4,    //  원활
    /**  통행불가 */
    KNTrafficState_Blocked          = 5     //  통행불가
};


/**
 도로 종별
 */
typedef NS_ENUM(SInt32, KNRoadType)
{
    /**  고속도로 */
    KNRoadType_Highway              = 0,    //  고속도로
    /**  일반도로 */
    KNRoadType_GeneralRoad          = 1,    //  일반도로
    /**  페리항로 */
    KNRoadType_Ferry                = 2,    //  페리항로
};


/**
 시설물 종별
 */
typedef NS_ENUM(SInt32, KNFacilityType)
{
    /**  도로 */
    KNFacilityType_Road             = 0,    //  도로
    /**  교량 */
    KNFacilityType_Bridge           = 1,    //  교량
    /**  터널 */
    KNFacilityType_Tunnel           = 2,    //  터널
    /**  고가차도 */
    KNFacilityType_OverPath         = 3,    //  고가차도
    /**  지하차도 */
    KNFacilityType_UnderPath        = 4     //  지하차도
};

typedef NS_ENUM(SInt32, KNLocationType)
{
    
    KNLocationType_OnRoute             = 0,    // 서버로 부터 받은 루트 위의 location
    KNLocationType_Raw                 = 1,    // 맵 매칭 raw location
    KNLocationType_VirtualRoute        = 2,    // network 맵매칭 location
};



/**
 방면명칭 타입
 */
typedef NS_ENUM(SInt8, KNDirNameType)
{
    /**  방면명칭 */
    KNDirNameType_DirName           = 0,    //  방면명
    /**  도로명 */
    KNDirNameType_RoadName          = 1,    //  도로명
    /**  노드명 */
    KNDirNameType_NodeName          = 2,    //  노드명
    /**  시설물명 */
    KNDirNameType_FacilityName      = 3,    //  시설물명
    /**  RG종별명 */
    KNDirNameType_RGTypeName        = 4,    //  RG종별명
    /**  목적지명 */
    KNDirNameType_GoalName          = 5     //  목적지명
};


/**
 안내 코드
 */
typedef NS_ENUM(SInt32, KNRGCode)
{
    KNRGCode_Start                      = 100,
    KNRGCode_Goal                       = 101,
    KNRGCode_Via                        = 1000,
    
    KNRGCode_Straight                   = 0,
    KNRGCode_LeftTurn                   = 1,
    KNRGCode_RightTurn                  = 2,
    KNRGCode_UTurn                      = 3,
    
    KNRGCode_LeftDirection              = 5,
    KNRGCode_RightDirection             = 6,
    
    KNRGCode_OutHighway                 = 7,
    KNRGCode_LeftOutHighway             = 8,
    KNRGCode_RightOutHighway            = 9,
    KNRGCode_InHighway                  = 10,
    KNRGCode_LeftInHighway              = 11,
    KNRGCode_RightInHighway             = 12,
    
    KNRGCode_OverPath                   = 14,
    KNRGCode_UnderPath                  = 15,
    KNRGCode_OverPathSide               = 16,
    KNRGCode_UnderPathSide              = 17,
    
    KNRGCode_Direction_1                = 18,
    KNRGCode_Direction_2                = 19,
    KNRGCode_Direction_3                = 20,
    KNRGCode_Direction_4                = 21,
    KNRGCode_Direction_5                = 22,
    KNRGCode_Direction_6                = 23,
    KNRGCode_Direction_7                = 24,
    KNRGCode_Direction_8                = 25,
    KNRGCode_Direction_9                = 26,
    KNRGCode_Direction_10               = 27,
    KNRGCode_Direction_11               = 28,
    KNRGCode_Direction_12               = 29,
    
    KNRGCode_RotaryDirection_1          = 30,
    KNRGCode_RotaryDirection_2          = 31,
    KNRGCode_RotaryDirection_3          = 32,
    KNRGCode_RotaryDirection_4          = 33,
    KNRGCode_RotaryDirection_5          = 34,
    KNRGCode_RotaryDirection_6          = 35,
    KNRGCode_RotaryDirection_7          = 36,
    KNRGCode_RotaryDirection_8          = 37,
    KNRGCode_RotaryDirection_9          = 38,
    KNRGCode_RotaryDirection_10         = 39,
    KNRGCode_RotaryDirection_11         = 40,
    KNRGCode_RotaryDirection_12         = 41,
    
    KNRGCode_OutCityway                 = 42,
    KNRGCode_LeftOutCityway             = 43,
    KNRGCode_RightOutCityway            = 44,
    KNRGCode_InCityway                  = 45,
    KNRGCode_LeftInCityway              = 46,
    KNRGCode_RightInCityway             = 47,
    
    KNRGCode_ChangeLeftHighway          = 48,
    KNRGCode_ChangeRightHighway         = 49,
    
    KNRGCode_InFerry                    = 61,
    KNRGCode_OutFerry                   = 62,
    
    KNRGCode_RoundaboutDirection_1      = 70,
    KNRGCode_RoundaboutDirection_2      = 71,
    KNRGCode_RoundaboutDirection_3      = 72,
    KNRGCode_RoundaboutDirection_4      = 73,
    KNRGCode_RoundaboutDirection_5      = 74,
    KNRGCode_RoundaboutDirection_6      = 75,
    KNRGCode_RoundaboutDirection_7      = 76,
    KNRGCode_RoundaboutDirection_8      = 77,
    KNRGCode_RoundaboutDirection_9      = 78,
    KNRGCode_RoundaboutDirection_10     = 79,
    KNRGCode_RoundaboutDirection_11     = 80,
    KNRGCode_RoundaboutDirection_12     = 81,
    
    KNRGCode_LeftStraight               = 82,
    KNRGCode_RightStraight              = 83,
    
    KNRGCode_Tollgate                   = 84,
    KNRGCode_NonstopTollgate            = 85,
    
    KNRGCode_JoinAfterBranch            = 86
};

//#define     SND_SAFETY_0                1000        // 교통사고다발 구간입니다
//#define     SND_SAFETY_1                1001        // 급회전 구간입니다
//#define     SND_SAFETY_2                1002        // 낙석위험 지역입니다
//#define     SND_SAFETY_3                1003        // 안개가 많은 지역입니다
//#define     SND_SAFETY_4                1004        // 추락위험 지역입니다
//#define     SND_SAFETY_5                1005        // 미끄러운도로 지역입니다
//#define     SND_SAFETY_6                1006        // 과속방지턱이 있습니다
//#define     SND_SAFETY_10               1010        // 철도건널목이 있습니다
//#define     SND_SAFETY_11               1011        // 어린이보호구역 입니다
//#define     SND_SAFETY_12               1012        // 도로폭이 좁아집니다
//#define     SND_SAFETY_13               1013        // 급경사 구간입니다
//#define     SND_SAFETY_14               1014        // 야생동물보호 지역입니다
//#define     SND_SAFETY_15               1015        // 졸음쉼터가 있습니다.
//#define     SND_SAFETY_20               1020        // 무정차 톨게이트 구간입니다.
//#define     SND_SAFETY_21               1021        // 자동차 사고다발 구간입니다.
//#define     SND_SAFETY_22               1022        // 보행자 사고다발 구간입니다.
//#define     SND_SAFETY_23               1023        // 어린이 사고다발 구간입니다.
//#define     SND_SAFETY_81               1081        // 이동식 과속단속 구간입니다
//#define     SND_SAFETY_82               1082        // 과속단속 구간입니다
//#define     SND_SAFETY_83               1083        // 정보수집 구간입니다
//#define     SND_SAFETY_84               1084        // 버스전용차로 위반 단속 구간입니다
//#define     SND_SAFETY_85               1085        // 과적위반 단속 구간입니다
//#define     SND_SAFETY_86               1086        // 신호위반 과속단속 구간입니다
//#define     SND_SAFETY_87               1087        // 주차위반 단속 구간입니다
//#define     SND_SAFETY_88               1088        // 적재불량 단속 구간입니다
//#define     SND_SAFETY_89               1089        // 버스전용차로 위반 과속단속 구간입니다
//#define     SND_SAFETY_90               1090        // 신호위반 단속 구간입니다
//#define     SND_SAFETY_92               1092        // 구간단속 시점입니다
//#define     SND_SAFETY_93               1093        // 구간단속 종점입니다
//#define     SND_SAFETY_94               1094        // 갓길 단속 구간입니다
//#define     SND_SAFETY_95               1095        // 끼어들기 단속 구간입니다
//#define     SND_SAFETY_96               1096        // 구간단속 구간입니다
//#define     SND_SAFETY_98               1098        // 차로변경 단속 시점입니다.
//#define     SND_SAFETY_99               1099        // 차로변경 단속 종점입니다.
//#define     SND_SAFETY_100              1100        // 과속단속(박스형)
//#define     SND_SAFETY_101              1101        // 안전띠 미착용 단속 구간입니다.
//
//#define     SND_SAFETY_92_V             1592        // 가변형 구간단속 시점입니다.
//#define     SND_SAFETY_93_V             1593        // 가변형 구간단속 종점입니다.
//#define     SND_SAFETY_96_V             1596        // 가변형 단속 구간입니다.

typedef NS_ENUM(NSInteger, KNReRouteType)     //  재탐색 유형
{
    /**  경로확인 */
    KNReRouteType_CheckRoute                        = 0,    //  경로확인
    /**  경로이탈 */
    KNReRouteType_OutOfRoute                        = 1,    //  경로이탈
    /**  교통상황 변경 */
    KNReRouteType_TrafficChanged                    = 2,    //  교통상황 변경
    /**  사용자 재탐색 */
    KNReRouteType_UserReRoute                       = 3,    //  사용자 재탐색
    /**  다중경로 선택됨(다중경로 구간에 진입 후 한가지 경로로 확정됨) */
    KNReRouteType_MultirouteSelected                = 4,    //  다중경로 선택됨(다중경로 구간에 진입 후 한가지 경로로 확정됨)
    /**  GPS 수신(GPS 불량 지역에서 경로탐색된 이후 GPS 수신됨) */
    KNReRouteType_ValidGPSReceived                  = 5,    //  GPS 수신(GPS 불량 지역에서 경로탐색된 이후 GPS 수신됨)
    /**  경유지 추가됨(주행중) */
    KNReRouteType_ViaAddedOnDriving                 = 6,    //  경유지 추가됨(주행중)
    /**  경유지 삭제됨(주행중) */
    KNReRouteType_ViaDeletedOnDriving               = 7,    //  경유지 삭제됨(주행중)
    /**  경유지 변경됨(주행중) */
    KNReRouteType_ViaChangedOnDriving               = 8,    //  경유지 변경됨(주행중)
    /**  경유지 추가됨(주행전) */
    KNReRouteType_ViaAddedBeforeDriving             = 9,    //  경유지 추가됨(주행전)
    /**  경유지 삭제됨(주행전) */
    KNReRouteType_ViaDeletedBeforeDriving           = 10,   //  경유지 삭제됨(주행전)
    /**  경유지 변경됨(주행전) */
    KNReRouteType_ViaChangedBeforeDriving           = 11,   //  경유지 변경됨(주행전)
    /**  저장경로 복구됨 */
    KNReRouteType_RouteDeserialized                 = 12    //  저장경로 복구됨
};

/**
 * GPS Provider
 */
typedef NS_ENUM(NSInteger, KNGPSProvider)
{
    /**
     * GPS
     * value : 0
     */
    KNGPSProvider_GPS                               = 0,

    /**
     * Simulation
     * value : 1
     */
    KNGPSProvider_Simulation                        = 1,

    /**
     * FIN
     * value : 2
     */
    KNGPSProvider_FIN                               = 2,

    /**
     * Fused
     * value : 3
     */
    KNGPSProvider_Fused                             = 3,

    /**
     * Indoor
     * value : 4
     */
    KNGPSProvider_Indoor                            = 4
};

/**
 지도 타입
 */
typedef NS_ENUM(NSInteger, KNMapType)     //맵 타입
{
    /**
     클라우드지도
     
     자동 다운로드형, 지도 버전업 시 자동 업데이트.
     */
    KNMapType_CloudMap                        = 0,    //  클라우드지도
    /**
     전체지도
     
     전체 지도 선 다운로드 형, 지도 버전업에 따라 자동 업데이트 되지 않는다.
     */
    KNMapType_FullMap                         = 1,    //  전체지도
};
