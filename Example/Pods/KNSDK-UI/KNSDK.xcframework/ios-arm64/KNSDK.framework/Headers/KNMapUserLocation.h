//
//  KNMapUserLocation.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/09/28.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapUserLocation_h
#define KNMapUserLocation_h

#import "KNMapShape.h"

@class KNMapTransform;
@class KNMapUserLocation;

/**
 사용자 위치를 선택할 수 있는 제스처나 애니메이션 종료 이벤트를 받을 수 있습니다.
 `KNMapUserLocationEventListener` 인터페이스를 구현하여 `KNMapView.userLocation`에 등록할 수 있습니다.
 
 @see KNMapView.userLocation
 @see KNMapUserLocation
 */
@protocol KNMapUserLocationEventListener<NSObject>

/**
 사용자가 손가락으로 사용자 위치를 터치한 경우 이벤트가 호출됩니다.
 
 @param aMapView KNMapUserLocation이 동록된 맵 뷰.
 @param aUserLocation 선택된 자차 아이콘입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onSingleTappedWithUserLocation:(KNMapUserLocation*_Nonnull)aUserLocation;

/**
 사용자가 손가락으로 사용자 위치를 더블 터치한 경우 이벤트가 호출됩니다.
 
 @param aMapView KNMapUserLocation이 동록된 맵 뷰.
 @param aUserLocation 선택된 자차 아이콘입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onDoubleTappedWithUserLocation:(KNMapUserLocation*_Nonnull)aUserLocation;

/**
 사용자가 손가락으로 사용자 위치의 한 점을 길게 눌른 경우 이벤트가 호출됩니다.
 
 @param aMapView KNMapUserLocation이 동록된 맵 뷰.
 @param aUserLocation 선택된 자차 아이콘입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onLongPressedWithUserLocation:(KNMapUserLocation*_Nonnull)aUserLocation;

/**
 지도에서 사용자 위치의 애니메이션 동작이 끝나는 시점에 호출됩니다.
 
 @param aMapView UserLocation이 동록된 맵 뷰.
 @param aUserLocation 선택된 자차 아이콘입니다. 
 @see KNMapUsetLocation.animate
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
userLocationAnimationEnded:(KNMapUserLocation*_Nonnull)aUserLocation;

@end

/**
 현재 사용자의 위치를 표시합니다. 하나의 지도에서 두 개 이상의 사용자 위치 사용을 허용하지 않습니다.
 
 @see KNMapView.userLocation
 */
@interface KNMapUserLocation : KNMapShape

/**
 애니메이션 효과와 함께 현재 위치에서 목적지로 입력한 각도와 시간동안 이동합니다.
 
 @param aCoordinate 이동시킬 카텍좌표.
 @param aAngle 회전 각도.
 @param aDuration 애니메이션 동작시간(ms)
 */
-(void)animateWithCoordinate:(FloatPoint)aCoordinate angle:(float)aAngle duration:(float)aDuration;

/**
 애니메이션 효과와 함께 현재 위치에서 목적지로 입력한 시간동안 이동합니다.
 
 @param aCoordinate 이동시킬 카텍좌표
 @param aDuration 애니메이션 동작시간(ms)
 */
-(void)animateWithCoordinate:(FloatPoint)aCoordinate duration:(float)aDuration;

/**
 사용자 위치를 표시하는 이미지를 설정합니다. 사용자가 이미지를 직접 설정할 수 있으며, 설정하지 않을 경우 기본 이미지로 표시됩니다.
 
 @see UIImage
 */
@property (nonatomic, assign, nonnull) UIImage* icon;

/**
 사용자 위치가 표시되는 카텍(KATEC) 좌표입니다.
 */
@property (nonatomic, assign) FloatPoint coordinate;

/**
 사용자의 이미지 위치를 보정합니다. 픽셀 단위로 보정되며 위치 값은 (x축, y축)으로 표시합니다.
 이미지 하단 중앙 값을 원점으로 오른쪽으로 이동 시 x축 +1, 아래쪽으로 이동 시 y축 +1을 설정합니다. (기본 값: 원점)
*/
@property (nonatomic, assign) IntPoint pixelOffset;

/**
 사용자 위치 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 아이콘 이미지를 지표면에 깔아서 표출합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isFlat;

/**
 사용자 위치 표시의 우선 순위 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 65535, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, assign) NSInteger priority;

/**
 아이콘 이미지 회전 각도를 반환합니다. (반환 가능 각도: 0~360)
 */
@property (nonatomic, assign) float angle;

/**
 현재 사용자의 위치와 목적지를 직선으로 연결하는 안내선의 색상을 설정합니다. (기본 값: 파란색)
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* guideLineColor;

/**
 안내선을 이을 목적지의 위치를 설정합니다. 목적지의 위치를 직접 설정하여 보다 정확한 안내선을 표시할 수 있습니다.
 
 @see KNMapView.setRoute
 @see KNMapView.setRoutes
 */
@property (nonatomic, assign) FloatPoint guideLineGoal;

/**
 현재 사용자의 위치와 목적지를 직선으로 연결하는 안내선의 두께를 설정합니다. (선 두께 설정 범위: 1~5)
 */
@property (nonatomic, assign) float guideLineWidth;

/**
 현재 사용자의 위치와 목적지를 직선으로 연결하는 안내선의 모양을 설정합니다. (기본 값: KNLineDashType_Dashed)
 
 @see KNLineDashType
 */
@property (nonatomic, assign) KNLineDashType guideLineDashType;

/**
 현재 사용자의 위치와 목적지를 직선으로 연결하는 안내선의 표시 여부를 설정합니다. (기본 값: `YES`)
 사용자의 위치 표시를 나타내는 `isVisible`을 `NO`(표시 안 함)로 설정하면, 이 설정도 표시 안 함 상태로 전환됩니다. `isVisible`을 `YES`(표시함)로 설정하기 전까지는 해당 프로퍼티의 설정을 변경하더라도 그 변경 값을 반영하지 않습니다.
 */
@property (nonatomic, assign) BOOL isVisibleGuideLine;


/**
 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapUserLocationEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useSingleTapped;

/**
 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapUserLocationEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useDoubleTapped;

/**
 롱 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapUserLocationEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useLongPressed;

/**
 사용자 위치를 선택할 수 있는 제스처나 애니메이션 종료 이벤트를 받을 수 있습니다.
 */
@property (nonatomic, nullable, readwrite, weak) id<KNMapUserLocationEventListener> eventListener;

@end

#endif /* KNMapUserLocation_h */
