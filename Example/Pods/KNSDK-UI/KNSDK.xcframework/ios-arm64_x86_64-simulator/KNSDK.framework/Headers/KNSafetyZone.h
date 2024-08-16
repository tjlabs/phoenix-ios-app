//
//  KNSafetyZone.h
//  KNSDK
//
//  Created by rex.zar on 25/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 보호구역 정보
 
 어린이보호구역, 노인보호구역, 장애인보호구역 정보
 
 현재 기준 어린이보호구역만 존재
 */
@interface KNSafetyZone : NSObject

/**
 구간 시작 지점의 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation          *fromLocation;      //  구간 시작

/**
 구간 종료 지점의 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation          *toLocation;        //  구간 끝

/**
 보호구역 종별
 
 @see KNSafetyZoneType
 */
@property (nonatomic, readonly) KNSafetyZoneType    safetyZoneType;     //  존 타입

@end

NS_ASSUME_NONNULL_END
