//
//  KNMultiRouteInfo.h
//  KNSDK
//
//  Created by rex.zar on 02/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNDirection.h"
#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 대안경로 정보
 
 주 경로와 대안경로간의 비교 정보
 */
@interface KNMultiRouteInfo : NSObject

/**
 대안경로 분기 정보
 
 주 경로와 대안경로가 분기되는 지점의 회전정보(대안경로 기준)
 */
@property (nonatomic, readonly) KNDirection     *direction;

/**
 대안경로 분기 시작 위치(주경로)
 
 주 경로와 대안경로가 분기되는 시작위치(주경로 기준 위치)
 */
@property (nonatomic, readonly) KNLocation      *fromLocation;

/**
 대안경로 분기 종료 위치(주경로)
 
 주 경로와 대안경로가 분기후 재합류되는 위치(주경로 기준 위치)
 */
@property (nonatomic, readonly) KNLocation      *toLocation;

/**
 대안경로 분기 시작 위치(대안경로)
 
 주 경로와 대안경로가 분기되는 시작위치(대안경로 기준 위치)
 */
@property (nonatomic, readonly) KNLocation      *fromLocationForSecondaryRoute;

/**
 대안경로 분기 종료 위치(대안경로)
 
 주 경로와 대안경로가 분기후 재합류되는 위치(대안경로 기준 위치)
 */
@property (nonatomic, readonly) KNLocation      *toLocationForSecondaryRoute;

/**
 구간 영역 정보
 
 주 경로와 보조 경로가 모두 포함되는 영역(KATEC MBR)
 */
@property (nonatomic, readonly) MBR             mbr;                //  주 경로와 보조 경로가 모두 포함되는 영역

/**
 거리 차이
 
 주 경로 대비 대안경로의 거리 차이
 */
@property (nonatomic, readonly) SInt32          distGap;

/**
 시간 차이
 
 주 경로 대비 대안경로의 시간 차이
 */
@property (nonatomic, readonly) SInt32          timeGap;

/**
 요금 차이
 
 주 경로 대비 대안경로의 요금 차이
 */
@property (nonatomic, readonly) SInt32          costGap;

@end

NS_ASSUME_NONNULL_END
