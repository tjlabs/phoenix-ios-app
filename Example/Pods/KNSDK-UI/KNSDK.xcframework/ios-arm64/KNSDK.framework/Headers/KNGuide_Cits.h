//
//  KNGuide_Cits.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNCits.h"

NS_ASSUME_NONNULL_BEGIN

/**
 CITS 안내 정보
 
 CITS 정보를 전달한다.
 */
@interface KNGuide_Cits : NSObject

/**
 안내중인 CITS 리스트
 
 @see KNCits
 @see KNCits_TrafSignal
 */
@property (nonatomic, readonly) NSArray<__kindof KNCits *>     *citsList;        //  안내중인 CITS 리스트

@end

NS_ASSUME_NONNULL_END
