//
//  KNMapMarkerEventListener.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/18.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapMarkerEventListener_h
#define KNMapMarkerEventListener_h

@class KNMapView, KNMapMarker;
/**
 마커를 선택하거나 마커 애니메이션의 종료 이벤트를 받을 수 있습니다.
 `KNMapMarkerEventListener` 인터페이스를 구현하여 `KNMapView`에 등록할 수 있습니다.
 
 @see KNMapMarker
 @see KNMapView.markerEventListener
 */
@protocol KNMapMarkerEventListener <NSObject>
/**
 마커를 탭하여 선택하였을 때 이벤트가 호출되며 선택된 마커를 전달합니다. 여러 개의 마커가 겹쳐있을 경우, 가장 위에 올라가 있는 마커를 반환합니다.
 
 @param aMapView 마커 오브젝트가 등록된 맵뷰.
 @param aMarker 선택된 마커 오브젝트.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onSingleTappedWithMarker:(KNMapMarker* _Nonnull)aMarker;

/**
 마커를 더블 탭하여 선택하였을 때 이벤트가 호출되며 선택된 마커를 전달합니다. 여러 개의 마커가 겹쳐있을 경우, 가장 위에 올라가 있는 마커를 반환합니다.
 
 @param aMapView 마커 오브젝트가 등록된 맵뷰.
 @param aMarker 선택된 마커 오브젝트.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onDoubleTappedWithMarker:(KNMapMarker* _Nonnull)aMarker;

/**
 마커를 롱 탭하여 선택하였을 때 이벤트가 호출되며 선택된 마커를 전달합니다. 여러 개의 마커가 겹쳐있을 경우, 가장 위에 올라가 있는 마커를 반환합니다.
 
 @param aMapView 마커 오브젝트가 등록된 맵뷰.
 @param aMarker 선택된 마커 오브젝트.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onLongPressedWithMarker:(KNMapMarker* _Nonnull)aMarker;

/**
 마커의 애니메이션 동작이 종료하는 시점에 이벤트를 반환하고 해당 마커를 전달합니다.
 
 @param aMapView 마커 오브젝트가 등록된 맵뷰.
 @param aMarker 이벤트 종료된 마커 오브젝트.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onMarkerAnimationEnded:(KNMapMarker* _Nonnull)aMarker;

/**
 마커 말풍선을 탭하여 선택하였을 때 이벤트가 호출되며 선택된 마커를 전달합니다. 여러 개의 말풍선이 겹쳐있을 경우, 가장 위에 올라가 있는 마커를 반환합니다.
 
 @param aMapView 마커 오브젝트가 등록된 맵뷰.
 @param aMarker 선택된 마커 오브젝트.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onCalloutBubbleSelected:(KNMapMarker* _Nonnull)aMarker;

@end
#endif /* KNMapMarkerEventListener_h */
