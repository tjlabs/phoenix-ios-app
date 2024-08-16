//
//  KNNaviMapView.h
//  KNSDK
//
//  Created by hyeon.k on 2021/01/25.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import "KNComponentView.h"

NS_ASSUME_NONNULL_BEGIN

/// CameraMode
typedef NS_ENUM(NSUInteger, MapViewCameraMode)
{
    /// 2D
    MapViewCameraMode_Top        = 0,
    /// 3D
    MapViewCameraMode_Bird,
};

@interface KNNaviMapView : KNComponentView <UIGestureRecognizerDelegate>

/// 자차 custom  설정
/// @param aArray 0 : 자차 on 주간, 1 :자차 on 야간, 2 : 자차 off 주간, 3 : 자차 off 야간
/// @param aAnchor 자차 anchor
- (void)setCustomCarImages:(NSArray *)aArray anchor:(CGPoint)aAnchor;

/// 지도 카메라 설정
/// @param aMapViewCameraMode 카메라 모드
/// @see MapViewCameraMode
- (void)useMapViewMode:(MapViewCameraMode)aMapViewCameraMode;

/// 주행경로 테마 설정
/// @param aDriveDay            주간 주행 경로 테마
/// @param aDriveNight       야간 주행 경로 테마
/// @param aTrafficDay       주간 트래픽 경로 테마
/// @param aTrafficNight   야간 트래픽 경로 테마
/// @see KNMapRouteTheme
- (void)setRouteThemeDriveDay:(KNMapRouteTheme * _Nullable)aDriveDay routeThemeDriveNight:(KNMapRouteTheme * _Nullable)aDriveNight routeThemeTrafficDay:(KNMapRouteTheme * _Nullable)aTrafficDay routeThemeTrafficNight:(KNMapRouteTheme * _Nullable)aTrafficNight;

@end

NS_ASSUME_NONNULL_END
