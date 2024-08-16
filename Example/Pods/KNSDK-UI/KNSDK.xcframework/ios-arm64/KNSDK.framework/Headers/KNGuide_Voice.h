//
//  KNGuide_Voice.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 음성 코드
 */
typedef NS_ENUM(SInt32, KNVoiceCode)
{
    /** 회전구간 안내 */
    KNVoiceCode_Turn            = 0,        //  회전구간 안내
    /** 안전운행 안내 */
    KNVoiceCode_Safety,                     //  안전운행 안내
    /** 안내시작 */
    KNVoiceCode_StartGuide,                 //  안내시작
    /** 안내종료 */
    KNVoiceCode_EndGuide,                   //  안내종료
    /** 상세교차로 차선 안내 */
    KNVoiceCode_DetalDir,                   //  상세교차로 차선 안내
    /** 다중경로 분기점 안내 */
    KNVoiceCode_MultiRoute,                 //  다중경로 분기점 안내
    /** 어린이 보호구역 */
    KNVoiceCode_SchoolZone,                 //  어린이 보호구역
    /** 하이패스 차선 안내 */
    KNVoiceCode_Hipass,                     //  하이패스 차선 안내
    /** 직진 안내 */
    KNVoiceCode_StrateToNext,               //  직진 안내
    /** 교통변화 체크 */
    KNVoiceCode_CheckingRouteChange,        //  교통변화 체크
    /** 경로 변경 */
    KNVoiceCode_RouteChanged,               //  경로 변경
    /** 기존 경로 */
    KNVoiceCode_RouteUnchanged,             //  기존 경로
    /** 경로 이탈 */
    KNVoiceCode_OutOfRoute,                 //  경로 이탈
    /** GPS 연결 */
    KNVoiceCode_GPSConnected,               //  GPS 연결
    /** 알람(안전운행지점 통과 등) */
    KNVoiceCode_Alram,                      //  알람(안전운행지점 통과 등)
    /** 경고(속도 초과 등) */
    KNVoiceCode_Alert,                      //  경고(속도 초과 등)
    /** 링크기반 음성 */
    KNVoiceCode_LinkSound                   //  링크기반 음성
};

/**
 안내 기준 거리 코드
 */
typedef NS_ENUM(SInt32, KNVoiceDist)
{
    /**
     거리코드 없음
     
     단일지점 안내, 안내시작, 직진안내 등
     */
    KNVoiceDist_None            = 0,        //  거리코드 없음(단일지점 안내, 안내시작, 직진안내 등)
    
    /**
     원거리
     
     - 회전구간 : 2100(고속도로), 1100(일반도로)
     - 안전운행 : 1100(고속도로), 1100(일반도로)
     */
    KNVoiceDist_Far,                        //  원거리 - 회전구간 : 2100(고속도로), 1100(일반도로) - 안전운행 : 1100(고속도로), 1100(일반도로)
    
    /**
     중거리
     
     - 회전구간 : 1100(고속도로), 550(일반도로)
     - 안전운행 : 550(고속도로), 550(일반도로)
     */
    KNVoiceDist_Middle,                     //  중거리 - 회전구간 : 1100(고속도로), 550(일반도로) - 안전운행 : 550(고속도로), 550(일반도로)
    
    /**
     근거리
     
     - 회전구간 : 550(고속도로), 350(일반도로)
     - 안전운행 : 250(고속도로), 150(일반도로)
     */
    KNVoiceDist_Near,                       //  근거리 - 회전구간 : 550(고속도로), 350(일반도로) - 안전운행 : 250(고속도로), 150(일반도로)
    
    /**
     안내지점
     
     - 회전구간 : 250(고속도로), 150(일반도로)
     - 안전운행 : 0(고속도로), 0(일반도로)
     */
    KNVoiceDist_AtPos                       //  안내지점 - 회전구간 : 250(고속도로), 150(일반도로) - 안전운행 : 0(고속도로), 0(일반도로)
};

/**
 음성 안내 정보
 */
@interface KNGuide_Voice : NSObject

/**
 음성 코드
 
 @see KNVoiceCode
 */
@property (nonatomic, readonly) KNVoiceCode         voiceCode;

/**
 안내 기준 거리 코드
 
 @see KNVoiceDist
 */
@property (nonatomic, readonly) KNVoiceDist         voiceDist;

/**
 안내 오브젝트
 
 voiceCode 가 KNVoiceCode_Turn, KNVoiceCode_Safety 일경우 존재, 그 외 nil
 
 - KNVoiceCode_Turn : KNDirection
 - KNVoiceCode_Safety : KNSafety
 - KNVoiceCode_CheckingRouteChange, KNVoiceCode_RouteChanged, KNVoiceCode_RouteUnchanged, KNVoiceCode_OutOfRoute  : NSString(경로요청 사유 - 경로이탈 : DEVIATION, 사용자 재탐색 : USER, GPS오류 재탐색 : GPS_ERROR, 경유지 추가 : WAYPOINT_ADD, 경유지 삭제 : WAYPOINT_DEL)
 
 @see KNDirection
 @see KNSafety
 */
@property (nonatomic, readonly) __kindof NSObject   *guideObj;      //  안내코드. KNVoiceCode_Turn : KNDirection, KNVoiceCode_Safety : KNSafety, KNVoiceCode_CheckingRouteChange, KNVoiceCode_RouteChanged, KNVoiceCode_RouteUnchanged, KNVoiceCode_OutOfRoute : NSString 에만 존재. 없을시 nil

/**
 음성 길이(초)
 */
@property (nonatomic, readonly) NSTimeInterval      duration;       //  음성 길이(초)

/**
 음성 데이터
 */
@property (nonatomic, readonly) NSData              *data;          //  안내 데이터

/**
 볼륨 설정
 
 @param aVolume 0~1
 */
- (void)setVolume:(float)aVolume;

@end

NS_ASSUME_NONNULL_END
