//
//  KNGuide_Location.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 7..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNGPSData.h"
#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 위치 안내 정보
 
 GPS정보와 경로상 위치 정보를 포함한다.
 */
@interface KNGuide_Location : NSObject

/**
 GPS 원 데이터
 
 @see KNGPSData
 */
@property (nonatomic, readonly) KNGPSData       *gpsOrigin;                     //  GPS 원 데이터

/**
 매칭 GPS 데이터
 
 경로 없을 시 gpsOrigin 과 동일
 
 @see KNGPSData
 */
@property (nonatomic, readonly) KNGPSData       *gpsMatched;                    //  매칭 GPS 데이터 : 경로 없을 시 gpsOrigin 과 동일

/**
 경로상 위치 정보
 
 경로 없을 시 nil
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation      * _Nullable location;                      //  경로상 위치 정보 : 경로 없을 시 nil

/**
 경로상 위치 정보(대안경로)
 
 대안경로상의 경로상 위치 정보
 
 경로 없을 시 nil
 */
@property (nonatomic, readonly) KNLocation      * _Nullable locationForSecondaryRoute;     //  경로상 위치 정보(대안경로) : 경로 없을 시 nil

@end

NS_ASSUME_NONNULL_END

