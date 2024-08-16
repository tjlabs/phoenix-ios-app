//
//  KNSDK.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
@class KNMapImage;

//! Project version number for KNSDK.
FOUNDATION_EXPORT double KNSDKVersionNumber;

//! Project version string for KNSDK.
FOUNDATION_EXPORT const unsigned char KNSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <KNSDK/PublicHeader.h>

// public header : Common
#import "KNSDKDef.h"
#import "KNGeometry.h"
#import "KNError.h"
#import "KNPOI.h"

// public header : Map
#import "KNMapOverlayObject.h"
#import "KNMapCustomObject.h"
#import "KNMapMarker.h"
#import "KNMapCircle.h"
#import "KNMapPolyline.h"
#import "KNMapSegmentPolyline.h"
#import "KNMapPolygon.h"
#import "KNMapMarkerEventListener.h"
#import "KNMapUserLocation.h"
#import "KNMapGeometryObject.h"
#import "KNMapRectGeometryObject.h"
#import "KNMapCircleGeometryObject.h"
#import "KNMapPolyLineGeometryObject.h"
#import "KNMapSpecifiedPolyGeometryObject.h"
#import "KNMapTrackingLineObject.h"
#import "KNMapCameraUpdate.h"
#import "KNMapCalloutBubbleUpdate.h"
#import "KNMapViewEventListener.h"
#import "KNMapTheme.h"
#import "KNMapRouteTheme.h"
#import "KNMapRouteThemeDef.h"
#import "KNMapCoordinateRegion.h"
#import "KNMapPoiProperties.h"
#import "KNMapRouteProperties.h"


#import "KNParkingLotManager.h"
#import "KNParkingLot.h"

#import "KNMapView.h"
#import "KNMapViewDef.h"

// public header : Trip
#import "KNRouteConfiguration.h"
#import "KNTrip.h"
#import "KNRoute.h"

// public header : Guidance
#import "KNGuidance.h"
#import "KNGPSManager.h"
#import "KNMapDownLoader.h"


NS_ASSUME_NONNULL_BEGIN

/**
 SDK Delegate
 
 현재 SDK의 정보를 전달된다
 */

@protocol KNSDKDelegate

/**
 미완료된 주행 Trip을 전달 한다
 @param aTrip 미완료 주행 Trip
 @param aRouteOption 주행경로 옵션
 */
- (void)knsdkFoundUnfinishedTrip:(KNTrip *)aTrip priority:(KNRoutePriority)aPriority avoidOptios:(SInt32)aAvoidOptions;

/**
 
 */
- (void)knsdkNeedsLocationAuthorization;

@end


/**
 
 */
typedef NS_ENUM(NSInteger, KNSDKInitState)
{
    KNSDKInitState_NotInitialized,
    KNSDKInitState_OnInitializing,
    KNSDKInitState_Initialized
};


/**
 KNSDK
 
 KNSDK는 3가지의 주요 기능을 제공한다.
 
 지도, 경로 및 안내를 분리하여 서비스에 필요한 요소들만을 취사선택하여 구성할 수 있도록 모듈을 분리하였다.
 
 경로 모듈만을 사용해 ETA등의 정보를 획득할 수 있고, 지도 모듈을 연동해 지도위에 경로를 표출할 수 있으며, 가이던스와 연동해 내비게이션을 구현할 수 있다.
 
 일부 미구현 기능이 존재하나, 지도모듈이 별도로 존재한다면 경로와 가이던스 모듈만을 사용하여 별도의 기 보유중인 지도를 활용할 수 있도록 구성되어있다.
 
 향후 버전업그레이드 간 일부기능의 제한, 추가 및 변경이 이루어질 수 있다.
 
 1. Map
    - KNMapView
        - UIView 기반의 지도뷰
        - 지도 컨트롤을 위한 메소드를 제공하고 델리게이트를 통해 상태를 전달한다.
    - KNMapImage
        - UIImage 기반의 지도 스틸컷
        - 정적이미지 스타일의 지도가 필요할 경우 사용
 2. Trip
    - KNTrip
        - 경로 및 여정을 관리하는 클래스
        - 출도착지 및 경유지, 경로 설정정보등을 넘겨받아 옵션별 경로정보 및 요약정보(거리,요금,시간 등)를 조회/관리한다.
        - KNGuidance 와 연동해 길안내를 구동하고, 주행정보를 관리한다.
    - KNRotue
        - 개별 경로에 대한 정보를 가지는 클래스
    - KNRouteConfiguration
        - 경로 산정에 영향을 가지는 요소들에 대한 설정 정보
 3. Guidance
    - KNGuidance
        - 길안내를 관리하고 정보를 전달한다. 현재 기준, 가이던스는 1개만 존재한다.
        - 안내는 위치, 경로, 안전운행 및 음성의 4가지로 분류되며, 서비스에 필요한 안내만 취사선택하여 적용할 수 있다.
    - KNLocation
        - 경로상 위치정보를 포함하는 클래스
    - KNGuide_Location
        - 위치 안내 정보
    - KNGuide_Rotue
        - 경로 안내 정보
    - KNGuide_Safety
        - 안전운행 안내 정보
    - KNGuide_Voice
        - 음성 안내 정보
 
 */
@interface KNSDK : NSObject

@property (nonatomic, readonly) KNSDKInitState      initSt;
@property (nonatomic, weak)     id<KNSDKDelegate>   delegate;

/**
 KNSDK Version 을 반환한다.
 @return KNSDK Version
 */
+ (NSString *)sdkVersion;


/**
 KNSDK Singleton Object를 반환한다.
 @return KNSDK Singleton Object
 @see releaseInstance
 */
+ (nullable KNSDK *)sharedInstance;


/**
 KNSDK Singleton Object를 해제한다.
 @see sharedInstance
 */
+ (void)releaseInstance;


/**
 SDK의 상태를 변경한다.
 비활성 상태로 전환.
 현재 별도의 동작 없음.
 @see handleDidBecomeActive
 */
+ (void)handleWillResignActive;


/**
 SDK의 상태를 변경한다.
 백그라운드 동작 상태로 전환.
 백그라운드 동작 상태에서는, 주행중 음성안내를 제외한, 지도 및 안내의 갱신이 제한 될 수 있다. SDK를 사용한 화면요소들의 갱신이 없는 상태.
 
 @see handleWillEnterForeground
 @see handleWillTerminate
 */
+ (void)handleDidEnterBackground;


/**
 SDK의 상태를 변경한다.
 포그라운드 동작 상태로 전환.
 백그라운드 동작 상태를 복구한다.
 
 @see handleDidEnterBackground
 @see handleWillTerminate
 */
+ (void)handleWillEnterForeground;


/**
 SDK의 상태를 변경한다.
 활성 상태로 전환.
 중지된 사운드 세션을 복구한다.
 @see handleWillResignActive
 */
+ (void)handleDidBecomeActive;


/**
 SDK의 상태를 변경한다.
 종료 상태로 전환
 설정정보를 저장하고, 주행중인경우 주행정보를 저장하여 차기 실행시에 미완료된 주행 Trip으로 전달 한다
 
 @see handleDidEnterBackground
 @see handleWillEnterForeground
 */
+ (void)handleWillTerminate;


/**
 SDK의 상태를 변경한다.
 카플레이 연결 상태로 전환.
 카플레이 연결 상태일경우. 주행중 차선정보 전달 시 현재 차선은 전달하지 않는다.
 
 @see handleCarInterfaceDisconnected
 */
+ (void)handleCarInterfaceConnected;


/**
 SDK의 상태를 변경한다.
 카플레이 해제 상태로 전환.
 @see handleCarInterfaceConnected
 */
+ (void)handleCarInterfaceDisconnected;


/**
 KNSDK를 초기화 한다.
 
 KNSDK의 기능사용전에 필수로 선행되어야 한다.
 
     [[KNSDK sharedInstance] initializeWithApiKey:@"API Key" userKey:@"User Key" langType:KNLanguageType_KOREAN completion:^(KNError *error) {
         if (error)
         {
            //  SDK 초기화 실패
         }
         else
         {
            //  SDK 초기화 성공
         }
     }];
 
 @param aAppKey KNSDK 사용을 위해 발급된 API Key
 @param aLangType 언어설정
 @param aMapType  MapType설정
 @param aCompletion 초기화 완료 후 결과상태 전달
 @see KNLanguageType
 @see KNError
 */
- (void)initializeWithAppKey:(NSString *)aAppKey clientVersion:(NSString *)aClientVersion userKey:(NSString * _Nullable)aUserKey langType:(KNLanguageType)aLangType mapType:(KNMapType)aMapType completion:(void (^)(KNError * _Nullable aError))aCompletion;
- (void)initializeWithAppKey:(NSString *)aAppKey clientVersion:(NSString *)aClientVersion langType:(KNLanguageType)aLangType mapType:(KNMapType)aMapType completion:(void (^)(KNError * _Nullable aError))aCompletion;
- (void)initializeWithAppKey:(NSString *)aAppKey clientVersion:(NSString *)aClientVersion userKey:(NSString * _Nullable)aUserKey completion:(void (^)(KNError * _Nullable aError))aCompletion;
- (void)initializeWithAppKey:(NSString *)aAppKey clientVersion:(NSString *)aClientVersion completion:(void (^)(KNError * _Nullable aError))aCompletion;

/**
 userKey를 변경 및 등록 한다.
 
 @param aUserKey userKey설정
 */
- (void)setUserKey:(NSString * _Nullable)aUserKey;

//  Map API
//  ===========================================================================================================================

/** 현재 지도 버전 */
- (SInt32)mapVersion;

/** 맵 뷰 객체 요청 : 내부적으로 로더, 스타일러, 렌더러를 바인딩하고 초기화 한 후 전달한다. 맵 뷰 객체는 반드시 본 메소드를 통해 생성되어야 한다. */
- (KNMapView * _Nullable)makeMapViewWithFrame:(CGRect)aFrame;
- (KNMapView * _Nullable)makeCarPlayMapViewWithFrame:(CGRect)aFrame contentsScale:(CGFloat)contenstScale;
- (KNMapView * _Nullable)makeRemoteDebugingCarPlayMapViewWithFrame:(CGRect)aFrame contentsScale:(CGFloat)contenstScale __deprecated_msg("use makeCarPlayMapViewWithFrame instead.");

/** 지도 다운로더 : 전제지도 다운로드 필요시 */
- (KNMapDownLoader *)sharedMapDownLoader;

/** 현재 지도 타입 */
- (KNMapType)getMapType;

/** 맵 전환 클라우드<>전체다운로드지도 */
- (void)setMapType:(KNMapType)aMapType complition:(void (^)(KNError * _Nullable))aCompletion;

/** 맵캐시 데이터 삭제 */
- (void)mapCacheDeleteCompletion:(void (^)(KNError * _Nullable aError))aCompletion;

- (KNLanguageType)getLanguageType;
- (void)setLanguageType:(KNLanguageType)aLanguageType;

//  ---------------------------------------------------------------------------------------------------------------------------


//  Trip API
//  ===========================================================================================================================

/**
 KNTrip 을 생성한다.
 
 @param aStart 출발지
 @param aGoal 목적지
 @param aVias 경유지 리스트
 @param aCompletion Trip 전달 블럭
 @see KNPOI
 */
- (void)makeTripWithStart:(KNPOI *)aStart
                     goal:(KNPOI *)aGoal
                     vias:(NSArray<KNPOI *> * _Nullable)aVias
               completion:(void (^)(KNError * _Nullable aError, KNTrip * _Nullable aTrip))aCompletion;

/**
 KNTrip 을 생성한다.
 
 @param aStart 출발지
 @param aGoal 목적지
 @param aVias 경유지 리스트
 @param aCsId CS 대응 식별자, 현재 사용되지 않음
 @param aCompletion Trip 전달 블럭
 @see KNPOI
 */
- (void)makeTripWithStart:(KNPOI *)aStart
                     goal:(KNPOI *)aGoal
                     vias:(NSArray<KNPOI *> * _Nullable)aVias
                     csId:(NSString * _Nullable)aCsId
               completion:(void (^)(KNError * _Nullable aError, KNTrip * _Nullable aTrip))aCompletion;

//  ---------------------------------------------------------------------------------------------------------------------------


//  Guidance API
//  ===========================================================================================================================

/**
 KNGuidance 를 가져온다.
 
 현재 기준, KNGuidance는 1개만 존재한다.
 */
- (KNGuidance *)sharedGuidance;

//  ---------------------------------------------------------------------------------------------------------------------------


//  GPS API
//  ===========================================================================================================================

/**
 KNGPSManager 를 가져온다.
 
 현재 기준, KNGPSManager는 1개만 존재한다.
 */
- (KNGPSManager *)sharedGpsManager;

//  ---------------------------------------------------------------------------------------------------------------------------


//  Util API
//  ===========================================================================================================================
/**
 현재 주소지 정보를 요청한다
 
 @param aKatecPos 현재 위치정보 (Katec좌표)
 @param aCompletion 오류, 주소코드, 도, 시, 동 정보 전달
 */
- (void)reverseGeocodeWithPos:(IntPoint)aKatecPos completion:(void (^)(KNError * _Nullable aError, NSString * _Nullable aAddrCode, NSString * _Nullable aDoName, NSString * _Nullable aSiGunGuName, NSString * _Nullable aDongName))aCompletion;
/**
 WGS84좌표->KATEC좌표로 변환
 
 @param aWgs84Lon WGS Longitude 좌표
 @param aWgs84Lat WGS Latitude 좌표
 */
- (IntPoint)convertWGS84ToKATECWithLongitude:(double)aWgs84Lon latitude:(double)aWgs84Lat;

/**
 KATEC좌표->WGS84좌표로 변환
 
 @param aKatecX KATEC X좌표
 @param aKatecY KATEC Y좌표
 */
- (DoublePoint)convertKATECToWGS84WithX:(SInt32)aKatecX y:(SInt32)aKatecY;  //DoublePoint.x : Longitude, DoublePoint.y : Latitude

//  ---------------------------------------------------------------------------------------------------------------------------


//  Search API
//  ===========================================================================================================================
/**
 POI 검색
 @param aText 명칭
 @param aPage 검색 페이지 1페이
 @see NSDictionary "total_count" 검색으로 검색된 poi최대 수 "is_end" 마지막 페이지 유무
 */
- (void)reqPoiText:(NSString *)aText page:(int)aPage completion:(void (^)(KNError * _Nullable, NSDictionary * _Nullable))aCompletion;   //검색

//  ---------------------------------------------------------------------------------------------------------------------------

//  POI Detail API
//  ===========================================================================================================================
/**
 POI 디테일 정보
 @param aIdList Poi id리스트
 @see NSDictionary "detail_list" 검색된 Poi 정보 리스트
 */
- (void)reqPoiDetailWithIdList:(NSArray *)aIdList completion:(void (^)(NSDictionary * _Nullable, KNError * _Nullable))aCompletion;

//  ---------------------------------------------------------------------------------------------------------------------------


//  Location Update API
//  ===========================================================================================================================
/**
 위치 정보를 업데이트 한다
 @param aGPSReceiver KNGPSReceiver 정보
 */
- (void)requestLocationUpdate:(id<KNGPSReceiver>)aGPSReceiver;

//  ---------------------------------------------------------------------------------------------------------------------------


// Domain API
//  ===========================================================================================================================
// sandBox 접속
- (void)useSandbox;

// Real 접속
- (void)useReal;
//  ---------------------------------------------------------------------------------------------------------------------------


//  Trace API
//  ===========================================================================================================================

- (void)startTraceWithCompletion:(void (^)(KNError * _Nullable aError, NSString * _Nullable aTranceId))aCompletion;
- (void)stopTrace;

//  ---------------------------------------------------------------------------------------------------------------------------


//  ParkingLot API
//  ===========================================================================================================================
/**
 KNParkingLotManager 를 가져옵니다. 주차장 정보를 요청하고 받을 수 있습니다.
 
 현재 기준, KNParkingLotManager는 1개만 존재합니다.
 */
- (KNParkingLotManager* _Nullable)sharedParkingLotManager;
//  ---------------------------------------------------------------------------------------------------------------------------

/**
 POI 크기의 배율을 설정합니다 (최소 값: 0.5, 최대 값: 2.0)
 */
- (void)setPOIRatio:(float)aPOIRatio;

/**
 지도상 건물을 평탄하게 표현할건지 설정합니다. (기본 값: NO)
 */
- (void)setBuildingFlat:(bool)isBuildingFlat;

@end

NS_ASSUME_NONNULL_END
