//
//  KNGPSData_Protected.h
//  KNSDK
//
//  Created by rex.zar on 29/07/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import "KNGPSData.h"

#define KN_GPS_UPDATE_INTERVAL      0.5

@interface KNGPSData ()

@property (nonatomic, assign)   BOOL        valid;              // 유효성 여부
@property (nonatomic, assign)   DoublePoint pos;                // KATEC 위치
@property (nonatomic, assign)   SInt32      speed;              // 속도(Km/h)
@property (nonatomic, assign)   SInt32      angle;              // 향(0~360)
@property (nonatomic, assign)   SInt32      altitude;
@property (nonatomic, assign)   SInt32      hdop;
@property (nonatomic, assign)   SInt32      vdop;
@property (nonatomic, assign)   SInt32      openSkyAccuracy;    // 오픈스카이 정확도(0~100), 없을경우 -1
@property (nonatomic, strong)   NSDate      *timestamp;
@property (nonatomic, assign)   BOOL        posTrust;           // 위치 신뢰 여부
@property (nonatomic, assign)   BOOL        speedTrust;         // 속도 신뢰 여부
@property (nonatomic, assign)   BOOL        angleTrust;         // 방향 신뢰 여부
@property (nonatomic, assign)   KNGPSProvider provider;         // 위치 좌표 출처


@property (nonatomic, assign)   IntPoint    intPos;             // KATEC 위치
@property (nonatomic, assign)   BOOL        isOrigin;           // 실 GPS인지 여부

+ (void)reduceValidChkCnt;

- (id)initWithGpsData:(KNGPSData *)aGpsData;
- (id)initWithLocation:(CLLocation *)aLocation;
- (id)initWithLocation:(CLLocation *)aLocation avoidValidChk:(BOOL)aAvoidValidChk;
- (id)initWithDic:(NSDictionary *)aGpsDic;
- (id)initWithGpsLogData:(NSData *)aData;

- (NSDictionary *)toDictionary;

@end
