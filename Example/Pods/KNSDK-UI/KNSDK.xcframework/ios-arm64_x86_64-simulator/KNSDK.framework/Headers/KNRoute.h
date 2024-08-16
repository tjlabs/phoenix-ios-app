//
//  KNRoute.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"
#import "KNDirection.h"
#import "KNSafety.h"
#import "KNSafetyZone.h"
#import "KNRoadEvent.h"
#import "KNAroundInfo.h"
#import "KNRoadInfo.h"
#import "KNHighwayInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 경로정보
 
 경로에 대한 정보를 포함한다.
 */
@interface KNRoute : NSObject

/**
 경로우선 옵션
 
 @see KNRoutePriority
 */
@property (nonatomic, readonly) KNRoutePriority priority;

/**
 경로회피 옵션
 
 @see KNRouteAvoidOption
 */
@property (nonatomic, readonly) SInt32                  avoidOptions;

/** 경로 전체 거리(m)*/
@property (nonatomic, readonly) SInt32                  totalDist;
/** 경로 전체 예상시간(초)*/
@property (nonatomic, readonly) SInt32                  totalTime;
/** 경로 전체 요금(원)*/
@property (nonatomic, readonly) SInt32                  totalCost;
/** 경로 특징*/
@property (nonatomic, readonly) NSString                *desc;
/** 선호경로 정보*/
@property (nonatomic, readonly) NSDictionary            *predefinedRouteInfo;
/** 목적지의 경로상 위치(좌측 여부)*/
@property (nonatomic, readonly) BOOL                    isDestinationOnLeftSide;
/** 목적지 반대편 경로 존재 여부*/
@property (nonatomic, readonly) BOOL                    hasTheOtherSideRoute;
/** 경로 내 페리항로 포함 여부*/
@property (nonatomic, readonly) BOOL                    containsFerryRoute;

/**
 경로상 특정 위치부터의 남은 거리
 
 @param aLocation 기준 위치
 @return 경로상 남은 거리(m)
 @see KNLocation
 */
- (SInt32)remainDistFromLocation:(KNLocation *)aLocation;

/**
 경로상 특정 위치부터의 남은 시간
 
 @param aLocation 기준 위치
 @return 경로상 남은 시간(초)
 @see KNLocation
 */
- (SInt32)remainTimeFromLocation:(KNLocation *)aLocation;

/**
 경로상 특정 위치부터의 남은 요금
 
 @param aLocation 기준 위치
 @return 경로상 남은 요금(원)
 @see KNLocation 
 */
- (SInt32)remainCostFromLocation:(KNLocation *)aLocation;

/**
 보호구역 포함여부
 
 @param aSafetyZoneType 보호구역 종별
 @see KNSafetyZoneType
 */
- (BOOL)containsSafetyZone:(KNSafetyZoneType)aSafetyZoneType;        //  보호구역 포함여부

/**
 주요 회전구간 정보
 
 경로상 주요 회전구간들에 대한 리스트
 
 @return 회전구간 리스트
 @see KNDirection
 */
- (NSArray<KNDirection *> * _Nullable)mainDirectionList;

/**
 주요 도로구간 정보
 
 경로상 주요 도로구간에 대한 리스트
 
 @return 도로정보 리스트
 @see KNRoadInfo_Road
 */
- (NSArray<KNRoadInfo_Road *> * _Nullable)mainRoadList;

/**
 주요 시설물구간 정보
 
 경로상 주요 시설물구간들에 대한 리스트
 교량, 터널, 고가차도 및 지하차도
 
 @return 시설물정보 리스트
 @see KNLocation
 */
- (NSArray<KNRoadInfo_Facility *> * _Nullable)mainFacilityList;

/**
 고속도로 정보 리스트
 
 경로상 고속도로 정보 리스트
 연속된 고속도로 단위로 분리(일반도로 -> 고속도로(정보1) -> 일반도로 -> 고속도로(정보2) -> 일반도로)
 
 @return 고속도로 정보 리스트
 @see KNLocation
 */
- (NSArray<NSArray<__kindof KNHighwayRG *> *> * _Nullable)highwayRGList;

/**
 안전운행 지점  정보
 
 경로상 안전운행 지점들에 대한 리스트
 
 @return 안전운행 리스트
 @see KNSafety
 */
- (NSArray<__kindof KNSafety *> * _Nullable)safetyList;

/**
 보호구역  정보
 
 경로상 보호구역 구간들에 대한 리스트
 
 @return 보호구역 리스트
 @see KNSafetyZone
 */
- (NSArray<KNSafetyZone *> * _Nullable)safetyZoneList;

/**
 유고정보
 
 경로상 유고정보들에 대한 리스트
 
 @return 유고정보 리스트
 @see KNRoadEvent
 */
- (NSArray<KNRoadEvent *> * _Nullable)roadEventList;

/**
 주변정보
 
 경로상 주변정보들에 대한 리스트, 현재 기준 경로상 주유소 정보만 존재
 
 @return 주변정보 리스트
 @see KNAroundInfo
 */
- (NSArray<KNAroundInfo *> * _Nullable)aroundInfoList;

/**
 * 경로 선형 정보
 *
 * Katec 좌표계인 경로 선형 정보를 WGS84로 변형하여 제공
 * @return WGS84 좌표계 경로 선형 정보
 * @see DoublePoint
 */
- (NSArray *)routePolylineWGS84;

/**
 * POI 의 경로상 위치를 구한다.
 *
 * 현재, 경유지에 대해서(출도착지 제외) 경로상 위치를 반환한다.
 * 이미 지나친 경유지의 경우, 경로상태에 따라서 경로상 위치를 반환하지 않을 수 있다(경로이탈등으로 지난경로의 확인이 불가능한 경우, 해당 경로상의 경유지는 위치를 파악할 수 없다.)
 * @return POI의 경로상 위치, 경로상 위치를 확인할 수 없는 경우 nil
 * @see KNLocation
 */
- (KNLocation * _Nullable)locationOfPoi:(KNPOI *)aPoi;

@end

NS_ASSUME_NONNULL_END
