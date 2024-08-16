//
//  KNGPSData.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 12..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KMIndoorLocInfo;

@interface KNGPSData : NSObject

/** 유효성 여부 */
@property (nonatomic, readonly) BOOL        valid;          //    유효성 여부
/** KATEC 위치 */
@property (nonatomic, readonly) DoublePoint pos;            //    KATEC 위치
/** 속도(Km/h) */
@property (nonatomic, readonly) SInt32      speed;          //    속도(Km/h)
/** 방향(0~360) */
@property (nonatomic, readonly) SInt32      angle;          //    방향(0~360)
@property (nonatomic, readonly) SInt32      altitude;
@property (nonatomic, readonly) SInt32      hdop;
@property (nonatomic, readonly) SInt32      vdop;
@property (nonatomic, readonly) SInt32      openSkyAccuracy;
@property (nonatomic, readonly) NSDate      *timestamp;
/** 위치 신뢰 여부 */
@property (nonatomic, readonly) BOOL        posTrust;       //    위치 신뢰 여부
/** 속도 신뢰 여부 */
@property (nonatomic, readonly) BOOL        speedTrust;     //    속도 신뢰 여부
/** 방향 신뢰 여부 */
@property (nonatomic, readonly) BOOL        angleTrust;     //    방향 신뢰 여부

/** 실내 위치 정보 */
@property (nonatomic, readonly) KMIndoorLocInfo * _Nullable indoorLocInfo;

@end
