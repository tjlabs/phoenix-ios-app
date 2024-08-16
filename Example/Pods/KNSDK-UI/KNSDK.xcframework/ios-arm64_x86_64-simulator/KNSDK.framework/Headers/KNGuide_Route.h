//
//  KNGuide_Route.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNDirection.h"
#import "KNImageDirection.h"
#import "KNLane.h"
#import "KNSafetyZone.h"
#import "KNHipassInfo.h"
#import "KNHighwayInfo.h"
#import "KNMultiRouteInfo.h"
#import "KNRoadEvent.h"
#import "KNAroundInfo.h"

NS_ASSUME_NONNULL_BEGIN

/**
 경로안내 정보
 
 경로안내에 필요한 요소들의 정보를 전달한다.
 */
@interface KNGuide_Route : NSObject

/**
 회전구간 정보
 
 @see KNDirection
 */
@property (nonatomic, readonly) KNDirection                 * _Nullable curDirection;

/**
 다음 회전구간 정보
 
 @see KNDirection
 */
@property (nonatomic, readonly) KNDirection                 * _Nullable nextDirection;

/**
 교차로 이미지 정보
 
 @see KNImageDirection
 */
@property (nonatomic, readonly) KNImageDirection            * _Nullable imgDirection;

/**
 차선 정보
 
 @see KNLane
 */
@property (nonatomic, readonly) KNLane                      * _Nullable lane;

/**
 보호구역 정보
 
 @see KNSafetyZone
 */
@property (nonatomic, readonly) NSArray<KNSafetyZone *>     * _Nullable safetyZones;

/**
 하이패스 입구 정보
 
 @see KNHipassInfo
 */
@property (nonatomic, readonly) KNHipassInfo                * _Nullable hipassInfo;

/**
 고속도로 정보
 
 @see KNHighwayInfo
 */
@property (nonatomic, readonly) KNHighwayInfo               * _Nullable hwInfo;

/**
 대안경로 정보
 
 @see KNMultiRouteInfo
 */
@property (nonatomic, readonly) KNMultiRouteInfo            * _Nullable multiRouteInfo;

/**
 유고 정보
 
 @see KNRoadEvent
 */
@property (nonatomic, readonly) NSArray<KNRoadEvent *>      * _Nullable roadEvents;

@end

NS_ASSUME_NONNULL_END
