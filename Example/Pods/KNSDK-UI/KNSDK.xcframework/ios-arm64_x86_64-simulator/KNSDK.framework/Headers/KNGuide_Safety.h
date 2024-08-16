//
//  KNGuide_Safety.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNSafety.h"

NS_ASSUME_NONNULL_BEGIN

/**
 안전운행 안내 정보
 
 안전운행 안내에 필요한 요소들의 정보를 전달한다.
 */
@interface KNGuide_Safety : NSObject

/**
 안내중인 안전운행 지점 리스트
 
 가까운 순서
 
 @see KNSafety
 @see KNSafety_Caution
 @see KNSafety_Camera
 @see KNSafety_Section
 */
@property (nonatomic, readonly) NSArray<__kindof KNSafety *>     *safetiesOnGuide;       //  안내중인 안전운행 지점, 가까운 순서

@end

NS_ASSUME_NONNULL_END
