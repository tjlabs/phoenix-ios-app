//
//  KNMapRouteProperties.h
//  KNSDK
//
//  Created by luke.9p9 on 2023/04/27.
//  Copyright © 2023 hyeon.k. All rights reserved.
//

#ifndef KNMapRouteProperties_h
#define KNMapRouteProperties_h

#import "KNMapRouteTheme.h"

/**
 경로를 선택할 수 있는 제스처 이벤트를 받을 수 있습니다.
 `KNMapRouteEventListener` 인터페이스를 구현하여 `KNMapView.routeProperties`에 등록할 수 있습니다.
 
 @see KNMapView.routeProperties
 @see KNMapRouteProperties
 */
@protocol KNMapRouteEventListener<NSObject>

/**
 사용자가 손가락으로 경로를 터치한 경우 이벤트가 호출되며 선택된 Route를 전달합니다.
 
 @param aMapView KNRoute가 동록된 맵 뷰.
 @param aRoute 선택된 경로 입니다.
 @param aIndex 맵에 등록된 경로 목록에서 선택된 경로의 인덱스 정보입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onSingleTapped:(KNRoute*_Nonnull)aRoute
         index:(int)aIndex;

/**
 사용자가 손가락으로 경로를 더블 터치한 경우 이벤트가 호출되며 선택된 Route를 전달합니다.
 
 @param aMapView KNRoute가 동록된 맵 뷰.
 @param aRoute 선택된 경로 입니다.
 @param aIndex 맵에 등록된 경로 목록에서 선택된 경로의 인덱스 정보입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onDoubleTapped:(KNRoute*_Nonnull)aRoute
         index:(int)aIndex;

/**
 사용자가 손가락으로 경로를 롱 터치한 경우 이벤트가 호출되며 선택된 Route를 전달합니다.
 
 @param aMapView KNRoute가 동록된 맵 뷰.
 @param aRoute 선택된 경로 입니다.
 @param aIndex 맵에 등록된 경로 목록에서 선택된 경로의 인덱스 정보입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onLongPressed:(KNRoute*_Nonnull)aRoute
         index:(int)aIndex;
@end


/**
 KNMapView에 있는 경로 속성 프로퍼티입니다. 맵 뷰에 등록된 경로들의 색상이나 선 두께를 KNMapRouteTheme를 통해 설정할 수 있고 KNMapRouteEventListener를 통해 경로에 대한 제스처 이벤트를 콜백 받을 수 있습니다.
 
 @property isVisible 경로 표시여부를 설정 합니다. (기본값 : YES)
 @property isVisibleRGArrow 경로내에 그리는 화살표 표시여부를 설정 합니다. (기본값 : YES)
 @property isVisibleFullRoute cullPassedRoute로 잘려진 경로를 표출할건지 설정합니다. (기본값 : NO)
 @property useSingleTapped 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 @property useDoubleTapped 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 @property useLongPressed  롱 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 @property eventListener 맵 뷰에서 발생한 경로 이벤트를 넘겨줍니다.
 @property theme 경로의 스타일을 설정합니다. 주 경로와 대안 경로의 선의 두께, 색상을 설정할 수 있습니다. 또한, 교통 혼잡 정보를 반영하여 혼잡도에 따라 색상을 구분하여 설정할 수도 있습니다.
 
 @see KNMapView
 @see KNMapRouteEventListener
*/
@interface KNMapRouteProperties: NSObject
/**
 경로 표시여부를 설정 합니다. (기본값 : YES)
 */
@property (nonatomic, readwrite, assign) bool isVisible;
/**
 경로내에 그리는 화살표 표시여부를 설정 합니다. (기본값 : YES)
 */
@property (nonatomic, readwrite, assign) bool isVisibleRGArrow;
/**
 cullPassedRoute로 잘려진 경로를 표출할건지 설정합니다. (기본값 : NO)
 */
@property (nonatomic, readwrite, assign) bool isVisibleFullRoute;
/**
 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useSingleTapped;
/**
 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useDoubleTapped;
/**
 롱 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapRouteEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useLongPressed;
/**
 맵 뷰에서 발생한 경로 이벤트를 넘겨줍니다.
 */
@property (nonatomic, nullable, readwrite, weak) id<KNMapRouteEventListener> eventListener;
/**
 경로의 스타일을 설정합니다. 주 경로와 대안 경로의 선의 두께, 색상을 설정할 수 있습니다. 또한, 교통 혼잡 정보를 반영하여 혼잡도에 따라 색상을 구분하여 설정할 수도 있습니다.
 */
@property (nonatomic, readwrite, assign, nonnull) KNMapRouteTheme* theme;
@end

#endif /* KNMapRouteProperties_h */
