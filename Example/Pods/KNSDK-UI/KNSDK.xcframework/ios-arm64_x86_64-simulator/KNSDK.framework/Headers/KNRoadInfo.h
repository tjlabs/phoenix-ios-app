//
//  KNRoadInfo.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 7..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 도로정보 속성
 */
typedef NS_ENUM(SInt32, KNRoadInfoType)
{
    /** 도로 */
    KNRoadInfoType_Road         = 0,
    /** 시설물 */
    KNRoadInfoType_Facility     = 1
};


//  KNRoadInfo
//  ====================================================================================================================

/**
 회전구간 정보
 
 회전구간의 회전코드, 노드명, 방면명칭, 경로상 위치 정보를 포함한다.
 */
@interface KNRoadInfo : NSObject

/**
 명칭
 */
@property (nonatomic, readonly) NSString                * _Nullable name;   //  명칭

/**
 도로정보의 경로상 시작 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation              *fromLocation;      //  시작 위치 정보

/**
 도로정보의 경로상 종료 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation              *toLocation;        //  종료 위치 정보

/**
 도로정보 속성
 
 @return 도로정보 속성
 @see KNRoadInfoType
 */
- (KNRoadInfoType)roadInfoType;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNRoadInfo_Road
//  ====================================================================================================================
@interface KNRoadInfo_Road : KNRoadInfo

/**
 도로 종별
 */
@property (nonatomic, readonly) KNRoadType              roadType;           //  도로 종별

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNRoadInfo_Facility
//  ====================================================================================================================
@interface KNRoadInfo_Facility : KNRoadInfo

/**
 도로 종별
 */
@property (nonatomic, readonly) KNFacilityType          facilityType;       //  시설물 종별

@end
//  --------------------------------------------------------------------------------------------------------------------

NS_ASSUME_NONNULL_END
