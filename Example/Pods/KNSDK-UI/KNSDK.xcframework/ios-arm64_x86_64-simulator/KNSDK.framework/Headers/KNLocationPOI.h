//
//  KNLocationPOI.h
//  KNSDK
//
//  Created by rex.zar on 27/07/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNPOI.h"
#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 POI와 POI에 대한 KNLocation을 갖는 클래스
 */
@interface KNLocationPOI : NSObject

/**
 POI
 
 @see KNPOI
 */
@property (nonatomic, readonly) KNPOI           *poi;

/**
 POI의 경로상 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation      * _Nullable location;

@end

NS_ASSUME_NONNULL_END
