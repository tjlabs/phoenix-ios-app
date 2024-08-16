//
//  KNGPSManager.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 11. 6..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "KNGPSData.h"
#import <CoreMotion/CoreMotion.h>
#import <KMLocationSDK/KMLocationSDK.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(SInt32, KNGPSBackgroundUpdateType)
{
    KNGPSBackgroundUpdateType_NotUsed           = 0,    //  사용안함
    KNGPSBackgroundUpdateType_WhenOnGuide       = 1,    //  주행중(Default)
    KNGPSBackgroundUpdateType_Always            = 2     //  항상
};

@protocol KNMotionReceiver <NSObject>

- (void)didDetectMotionActivity:(KMMotionActivity)aMotionActivity;
- (void)didChangeRapidSensor:(enum KMRapidChangedEvent)aRapidChangedEvent;

@end

@protocol KNGPSReceiver <NSObject>

- (void)didReceiveGpsData:(KNGPSData *)aGpsData;

@end


@protocol KNLocationReceiver <NSObject>

- (void)didReceiveLocationData:(KNGPSData *)aGpsData location:(CLLocation *)aLocation;

@end


@interface KNGPSManager : NSObject <CLLocationManagerDelegate>

@property (nonatomic, readonly) KNGPSData       *recentGpsData;
@property (nonatomic, readonly) KNGPSData       *lastValidGpsData;
@property (nonatomic, assign)   KNGPSBackgroundUpdateType   backgroundUpdateType;

@property (nonatomic, weak) id<KNMotionReceiver>            _Nullable motionReceiver;

/** LocationSDK의 사용여부를 확인하기위한 field**/
@property (nonatomic, readonly) BOOL                        useKMSDK;


- (void)requestUpdate:(id<KNGPSReceiver>)aReceiver;
- (void)stopUpdate:(id<KNGPSReceiver>)aReceiver;

- (void)requestLocationUpdate:(id<KNLocationReceiver>)aReceiver;
- (void)stopLocationUpdate:(id<KNLocationReceiver>)aReceiver;

- (void)showsBackgroundLocationIndicator:(BOOL)aIndicator;

/**
 featureAvailability 사용가능 여부 조회

 @KMFeatureAvailability FeatureAvailabilit 타입(KMFeatureAvailabilityINDOOR, KMFeatureAvailabilityRAPID_CHANGE, KMFeatureAvailabilityMOTION_ACTIVITY)
 @see KMFeatureAvailability
 */
- (BOOL)isFeatureAvailable:(KMFeatureAvailability)aFeatureAvailable;

/**
 LocationSDK에 외부 에러 메세지 전달

 @aCode 에러코드
 @aLogMsg 에러메시지
 */
- (void)sendExternalIndoorLogWithCode:(NSInteger)aCode logMsg:(NSString * _Nonnull)aLogMsg;

@end

NS_ASSUME_NONNULL_END
