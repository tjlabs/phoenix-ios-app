//
//  KNMapRouteThemeDef.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/27.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapRouteThemeDef_h
#define KNMapRouteThemeDef_h

/**
 주경로 관련 색상 컨테이너 클래스.
 
 @see KNMapRouteTheme.lineColors
 @see KNMapRouteTheme.strokeColors
 */
@interface KNRouteColors: NSObject

/**
 교통 원활
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* normal;

/**
 교통 약간 혼잡
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* trafficJamModerate;

/**
 교통 혼잡
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* trafficJamHeavy;

/**
 교통 매우 혼잡
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* trafficJamVeryHeavy;

/**
 교통정보 확인 불가
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* unknown;

/**
 도로를 통제하거나 현재 갈 수 없는 도로 색
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* blocked;

/**
 KNRouteColors 객체를 생성한다.
 
 @return KNRouteColors
 */
+(KNRouteColors* _Nonnull)routeColors NS_SWIFT_NAME(routeColors());

@end

/**
 대안 경로 관련 스타일 정보. 대안 경로의 선의 두께나 색상을 커스터마이징 한다.
 
 
 */
@interface KNMapAlterRouteInfo: NSObject
/**선 두께.*/
@property (nonatomic, assign) float lineWidth;
/**외곽선 두께.*/
@property (nonatomic, assign) float strokeWidth;
/**선 색.*/
@property (nonatomic, assign) UIColor* _Nonnull lineColor;
/**외곽선 색.*/
@property (nonatomic, assign) UIColor* _Nonnull strokeColor;

/**KNMapAlterRouteInfo 객체를 생성한다. */
+(KNMapAlterRouteInfo* _Nonnull)alterRouteInfo NS_SWIFT_NAME(alterRouteInfo());

@end

#endif /* KNMapRouteThemeDef_h */
