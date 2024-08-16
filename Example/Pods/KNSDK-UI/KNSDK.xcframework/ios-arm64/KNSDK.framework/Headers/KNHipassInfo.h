//
//  KNHipassInfo.h
//  KNSDK
//
//  Created by rex.zar on 01/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 하이패스 게이트 정보
 */
@interface KNHipassInfo : NSObject

/**
 하이패스 게이트 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation              *location;          //  위치 정보 (차선정보 종료 위치)

/**
 하이패스 차선 여부(BOOL)
 
 좌측차선부터 차선갯수만큼 존재)
 */
@property (nonatomic, readonly) NSArray<NSNumber *>     *gateInfo;          //  하이패스 차선 여부 (좌측차선부터 차선갯수만큼 존재)

/**
 게이트 이미지
 
 현재 기준, 존재하지 않음
 */
@property (nonatomic, readonly) UIImage                 *gateImg;           //  게이트 이미지 (현재 없음)

@end

NS_ASSUME_NONNULL_END
