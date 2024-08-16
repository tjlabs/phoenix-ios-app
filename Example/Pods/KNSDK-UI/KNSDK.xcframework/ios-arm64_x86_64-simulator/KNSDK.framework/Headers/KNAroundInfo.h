//
//  KNAroundInfo.h
//  KNSDK
//
//  Created by rex.zar on 25/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 주변정보 종별
 */
typedef NS_ENUM(SInt8, KNAroundInfoType)
{
    /** Unknown */
    KNAroundInfoType_Unknown        = 0,
    /** 주유소 */
    KNAroundInfoType_OilStation     = 1,
    /** CCTV */
    KNAroundInfoType_CCTV           = 2
};

/**
 경로상 주변 정보
 
 현재 기준 주유소 정보만 존재
 */
@interface KNAroundInfo : NSObject

/**
 주변 정보 아이디
 */
@property (nonatomic, readonly) NSString            *infoId;            //  위치 정보 아이디

/**
 경로상 위치 정보
 */
@property (nonatomic, readonly) KNLocation          * _Nullable location;          //  위치 정보(주변정보 위치)

/**
 주변 정보 타입
 
 - 0 : 주유소
 */
@property (nonatomic, readonly) KNAroundInfoType    infoType;           //  위치 정보 타입

/**
 주변 정보 위치
 
 KATEC
 */
@property (nonatomic, readonly) IntPoint            pos;                //  위치 정보 위치

@end

NS_ASSUME_NONNULL_END
