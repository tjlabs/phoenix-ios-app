//
//  KNMapRouteTheme.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/25.
//  Copyright © 2021 hyeon.k. All rights reserved.
//
#ifndef KNMapRouteTheme_h
#define KNMapRouteTheme_h

#import "KNMapRouteThemeDef.h"

/**
 경로의 스타일을 설정합니다. 주 경로와 대안 경로의 선의 두께, 색상을 설정할 수 있습니다. 또한, 교통 혼잡 정보를 반영하여 혼잡도에 따라 색상을 구분하여 설정할 수도 있습니다.
 
 @see KNRouteColors
 @see KNAlterRouteInfo
 @see KNMapView.routeTheme
 */
@interface KNMapRouteTheme: NSObject

/**
 주간 주행 테마로 교통 혼잡도와 상관없이 한 가지 색으로만 표시됩니다.
 
 @return KNMapRouteTheme
 */
+(KNMapRouteTheme* _Nonnull) driveDay;

/**
 야간 주행 테마로 교통 혼잡도와 상관없이 한 가지 색으로만 표시됩니다.
 
 @return KNMapRouteTheme
 */
+(KNMapRouteTheme* _Nonnull) driveNight;

/**
 교통 혼잡 정보가 반영된 주간 테마로 교통 상황에 따라 각 구간들의 색이 구분되어 표시됩니다.
 
 @return KNMapRouteTheme
 */
+(KNMapRouteTheme* _Nonnull) trafficDay;

/**
 교통 혼잡 정보가 반영된 야간 테마로 교통 상황에 따라 각 구간들의 색이 구분되어 표시됩니다.
 
 @return KNMapRouteTheme
 */
+(KNMapRouteTheme* _Nonnull) trafficNight;

/**
 KNMapRouteTheme 객체를 생성합니다.
 
 @return KNMapRouteTheme
 */
+(KNMapRouteTheme* _Nonnull)routeTheme;

/**
 주 경로의 선 두께를 설정합니다.
 */
@property (nonatomic, assign) float lineWidth;

/**
 주 경로의 외곽선 두께를 설정합니다.
 */
@property (nonatomic, assign) float strokeWidth;

/**
 주 경로의 선 색상을 설정합니다. 현재의 교통 상황을 혼잡도에 따라 색상별로 표시합니다.
 혼잡도의 정도는 원활, 약간 혼잡, 혼잡, 매우 혼잡, 확인 불가, 통제 도로로 구분됩니다. 단, 선 색상을 단일 색상으로 설정하려면 프로퍼티 값을 한 가지 색상으로 설정해야 합니다.
 
 @see KNRouteColors
 */
@property (nonatomic, assign, nonnull) KNRouteColors* lineColors;

/**
 주 경로의 외곽선 색상을 설정합니다. 현재의 교통 상황을 혼잡도에 따라 색상별로 표시합니다.
 혼잡도의 정도는 원활, 약간 혼잡, 혼잡, 매우 혼잡, 확인 불가, 통제 도로로 구분됩니다. 단, 선 색상을 단일 색상으로 설정하려면 프로퍼티 값을 한 가지 색상으로 설정해야 합니다.
 
 @see KNRouteColors
 */
@property (nonatomic, assign, nonnull) KNRouteColors* strokeColors;

/**
 대안 경로의 선과 외곽선의 두께 및 색상을 설정합니다.
 
 @see KNMapAlterRouteInfo
 */
@property (nonatomic, assign, nonnull) KNMapAlterRouteInfo* alterRoute;

@end
#endif
