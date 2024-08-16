//
//  KNNaviViewInfo.h
//  KNSDK
//
//  Created by hyeon.k on 2021/03/30.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    AroundType_Oil,      //주유소
    AroundType_Food,     //음식점
    AroundType_CVS,      //편의점
    AroundType_Parking   //주차장
} AroundType;

typedef enum : NSUInteger
{
    InfoType_None        = 0,        // 없음
    InfoType_DynamicRouteChanged,    // 교통사황이 변하여 새로운 경로 안내
    InfoType_DynamicDetecting,       // 실시간 교통 상황을 확인
    InfoType_DynamicSameRoute,       // 기존 경로로 안내
    InfoType_BrokenAway,             // 경로 이탈
    InfoType_Rest,                   // 잠시 휴식
    InfoType_ErrorReport,            // 오류제보캡쳐
    InfoType_DestinationSave,        // 장소저장
    InfoType_VoiceDownStart,         // 음성다운 시작
    InfoType_VoiceDownSuccess,       // 음성다운 성공
    InfoType_VoiceDownFail,          // 음성다운 실패
    InfoType_GPSError,               // GPS 수신오류
    InfoType_YugoRouteChanged,       // 유고정보
    InfoType_AvoidSchoolZone,        // 어린이안심구역 회피 안내
    InfoType_ReqErrorReport,         // 오류제보
    InfoType_ReqErrorReport_Fail,    // 오류제보실패
} InfoType;

typedef enum : NSUInteger
{
    RouteType_CurRoute        = 0,        // 현재경로
    RouteType_SubRoute,                   // 대안경로
} RouteType;


typedef enum : NSUInteger
{
    CarImageType_Default        = 0,        // 기본자차
    CarImageType_AirPort,                   // 공항
    CarImageType_Bike,                      // 바이크
} CarImageType;

typedef enum : NSUInteger
{
    MapPinType_Cur        = 0,        // 현재경로
    MapPinType_Start,                   // 대안경로
    MapPinType_Goal,
    MapPinType_Via,
    MapPinType_Vias,
    MapPinType_SectionPin,
    MapPinType_Camera,
    MapPinType_MoveCamera,
    MapPinType_InfoCamera,
    MapPinType_Hump,
    MapPinType_ChildrenAcciden,
    MapPinType_Warning,
    MapPinType_MultiRouteInfo,
    MapPinType_YugoEvent_Accident,
    MapPinType_YugoEvent_Construction,
    MapPinType_YugoEvent_Control,
    MapPinType_UTurn,
    MapPinType_MultiRouteInfoPin,
    MapPinType_Caution,
    MapPinType_Cits_Walk,
    MapPinType_Cits
} MapPinType;


typedef enum : NSUInteger
{
    KNCategoryPoiCode_Myplace       = -1,       //  내장소
    KNCategoryPoiCode_None          = 0,        //  없음
    KNCategoryPoiCode_OilSt         = 10,       //  주유소
    KNCategoryPoiCode_LPG           = 11,       //  LPG
    KNCategoryPoiCode_Charge        = 12,       //  전기충전소
    KNCategoryPoiCode_Garage        = 13,       //  정비소
    KNCategoryPoiCode_GasSt         = 15,       //  기존 충전소 (폐기 예정)
    KNCategoryPoiCode_Parking       = 20,       //  주차장
    KNCategoryPoiCode_Food          = 30,       //  음식점
    KNCategoryPoiCode_Cafe          = 31,       //  까페
    KNCategoryPoiCode_Drink         = 32,       //  술집
    KNCategoryPoiCode_Bank          = 33,       //  은행
    KNCategoryPoiCode_Mart          = 5034,     //  마트
    KNCategoryPoiCode_Hotel         = 40,       //  숙박
    KNCategoryPoiCode_Travel        = 50,       //  여행
    KNCategoryPoiCode_Hospital      = 60,       //  병원
    KNCategoryPoiCode_Drugstore     = 69,       //  약국
    KNCategoryPoiCode_CVS           = 72        // 편의점
} KNCategoryPoiCode;


typedef enum : NSUInteger
{
    MapState_None        = 0,         //
    MapState_Panning,
    MapState_Zoom,
    MapState_Tilt,
    MapState_Rotate,
    MapState_CurPos
} MapState;


typedef enum : NSUInteger
{
    KNUI_MapType_Drive        = 0,           // 주행
    KNUI_MapType_FuLLRoute,                   // 전체지도
    KNUI_MapType_Panning,
} KNUI_MapType;


typedef enum : NSUInteger
{
    NONE = 0,                //초기상태
    DriveNormal,             //길안내 일반 모드 주행 상태
    DriveTouch,              //길안내 중 화면 이동 상태
    DriveFullRoute,          //길안내 중 전체경로 화면 상태
    DriveSection,            //길안내 중 구간정보 화면 상태
    DriveHighwayMode,        //길안내 고속도로 모드 주행 상태
    SafetyNormal,            //안전운행 주행 상태
    SafetyTouch,             //안전운행 중 화면 이동 상태
} KNNaviViewState;


typedef enum : NSInteger {
    DistType_100,
    DistType_150,
    DistType_250,
    DistType_350,
    DistType_450,
    DistType_550,
    DistType_650,
}DistType;


typedef enum : NSInteger {
    SpeedType_0     = 1,
    SpeedType_20,
    SpeedType_40,
    SpeedType_60,
    SpeedType_80,
    SpeedType_100,
}SpeedType;

typedef enum : NSInteger {
    ViaChangeType_Not     = 0,
    ViaChangeType_Add,
    ViaChangeType_Remove,
}ViaChangeType;

#define MapTilt                 50.0

#define Map_Ani_Time            500.0
#define Tunnel_Ani_Time         500.0


#define MapScale_DEFAULT        1.25
#define MapScale_3D_P_1         0.6
#define MapScale_3D_P_2         0.8
#define MapScale_3D_P_3         1.1
#define MapScale_3D_P_4         1.3
#define MapScale_3D_P_5         1.7
#define MapScale_3D_P_6         1.9
#define MapScale_3D_P_7         2.1

#define MapScale_3D_L_1         1.35
#define MapScale_3D_L_2         1.6
#define MapScale_3D_L_3         1.9
#define MapScale_3D_L_4         2.3
#define MapScale_3D_L_5         2.7
#define MapScale_3D_L_6         3.2
#define MapScale_3D_L_7         3.5

#define MapScale_2D_P_1         1.0
#define MapScale_2D_P_2         1.3
#define MapScale_2D_P_3         1.5
#define MapScale_2D_P_4         2.0
#define MapScale_2D_P_5         2.2
#define MapScale_2D_P_6         2.4
#define MapScale_2D_P_7         2.8

#define MapScale_2D_L_1         1.35
#define MapScale_2D_L_2         2.0
#define MapScale_2D_L_3         2.45
#define MapScale_2D_L_4         3.4
#define MapScale_2D_L_5         3.9
#define MapScale_2D_L_6         4.8
#define MapScale_2D_L_7         5.2

#define MapScale_Parking        0.3



