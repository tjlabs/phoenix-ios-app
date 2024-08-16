//
//  KNImageDirection.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 8..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 교차로 이미지 정보
 
 이미지를 통한 상세 분기 안내
 */
@interface KNImageDirection : NSObject

/**
 안내지점의 경로상 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation      *location;          //  위치 정보

/**
 안내지점 이미지
 */
@property (nonatomic, readonly) UIImage         * _Nullable directionImg;               //  이미지

@end

NS_ASSUME_NONNULL_END
