//
//  KNLane.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 8..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 *<pre>
 *차선정보
 *</pre>
 */

/**
 개별 차선정보
 */
@interface KNLane_LaneInfo : NSObject

@property (nonatomic, readonly)     SInt8 turnType;
@property (nonatomic, readonly)     SInt8 pocketType;
@property (nonatomic, readonly)     SInt8 busType;
@property (nonatomic, readonly)     SInt8 facilityType;
@property (nonatomic, readonly)     SInt8 highlightType;
@property (nonatomic, readonly)     SInt8 suggest;
@property (nonatomic, readonly)     SInt8 colorType;

@end

/**
 차선정보
 */
@interface KNLane : NSObject
/**
 위치 정보(차선정보 종료 위치)
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation                  *location;              //  위치 정보 (차선정보 종료 위치)

/**
 차선 정보
 
 좌측차선부터 차선갯수만큼 존재
 */
@property (nonatomic, readonly) NSArray<KNLane_LaneInfo *>  *laneInfos;             //  차선 정보 (좌측차선부터 차선갯수만큼 존재)

@end

NS_ASSUME_NONNULL_END
