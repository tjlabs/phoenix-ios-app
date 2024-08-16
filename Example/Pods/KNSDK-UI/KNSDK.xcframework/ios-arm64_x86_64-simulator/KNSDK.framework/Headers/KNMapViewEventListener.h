//
//  KNMapViewEventListener.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/27.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapViewEventListener_h
#define KNMapViewEventListener_h
/**
 카메라 시점 조작(패닝, 줌, 기울기, 회전 등)과 화면 터치(한 번 탭, 이중 탭 등) 이벤트를 받을 수 있습니다.
 `KNMapViewEventListener` 인터페이스를 구현하여 `KNMapView`에 등록할 수 있습니다.
 
 @see KNMapView.viewEventListener
 @see KNMapView.markerEventListener
 @see KNMapView.animateCamera
 @see KNMapView.userLocation
 */
@class KNRoute;
@protocol KNMapViewEventListener <NSObject>

/**
 지도를 한 번 탭 하였을 때 호출되며 탭한 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
singleTappedWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;

/**
 지도를 두 번 탭(이중 탭) 하였을 때 호출되며 마지막으로 탭한 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표. */
-(void)mapView:(KNMapView *_Nonnull)aMapView
doubleTappedWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;
/**
 지도의 한 곳을 길게 눌렀을 때 호출되며 누른 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
longPressedWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;
/**
 지도를 한 방향으로 빠르게 움직이는 패닝(panning) 동작을 시작하는 시점에서 호출되며 탭한 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
panningStartedWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;

/**
 지도를 한 방향으로 빠르게 움직이는 패닝(panning) 동작을 진행하는 동안에 호출되며 이동할 때 변화하는 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
panningChangingWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;

/**
 지도를 한 방향으로 빠르게 움직이는 패닝(panning) 동작을 종료하는 시점에서 호출되며 마지막으로 손가락을 뗀 위치의 정보와 카텍(KATEC) 좌표 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aCoordinate 터치이벤트가 발생된 카텍 좌표.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
   panningEndedWithScreenPoint:(CGPoint)aScreenPoint
      coordinate:(FloatPoint)aCoordinate;

/**
 지도를 두 손가락을 이용해 오므리거나 벌려 화면의 확대 또는 축소를 시작하는 시점에서 호출되며 탭한 위치의 정보와 줌 레벨 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aZoom 현재 맵의 줌 배율.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
zoomingStartedWithScreenPoint:(CGPoint)aScreenPoint
          zoom:(float)aZoom;

/**
 지도를 두 손가락을 이용해 오므리거나 벌려 화면의 확대 또는 축소를 진행하는 동안에 호출되며 변화하는 위치의 정보와 줌 레벨 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aZoom 현재 맵의 줌 배율.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
zoomingChangingWithScreenPoint:(CGPoint)aScreenPoint
          zoom:(float)aZoom;

/**
 지도를 두 손가락을 이용해 오므리거나 벌려 화면의 확대 또는 축소를 종료하는 시점에서 호출되며 마지막으로 손가락을 뗀 위치의 정보와 줌 레벨 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aZoom 현재 맵의 줌 배율.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
zoomingEndedWithScreenPoint:(CGPoint)aScreenPoint
          zoom:(float)aZoom;

/**
 지도를 두 손가락을 이용해 시계 방향 또는 반시계 방향으로 회전을 시작하는 시점에서 호출되며 탭한 위치의 정보와 회전 각도 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aBearing 현재 맵의 bearing 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
bearingStartedWithScreenPoint:(CGPoint)aScreenPoint
       bearing:(float)aBearing;

/**
 지도를 두 손가락을 이용해 시계 방향 또는 반시계 방향으로 회전을 진행하는 동안에 호출되며 탭한 위치의 정보와 변화하는 회전 각도 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aBearing 현재 맵의 bearing 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
bearingChangingWithScreenPoint:(CGPoint)aScreenPoint
       bearing:(float)aBearing;

/**
 지도를 두 손가락을 이용해 시계 방향 또는 반시계 방향으로 회전을 종료하는 시점에서 호출되며 마지막으로 손가락을 뗀 위치의 정보와 회전 각도 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aBearing 현재 맵의 bearing 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
bearingEndedWithScreenPoint:(CGPoint)aScreenPoint
       bearing:(float)aBearing;

/**
 지도를 두 손가락을 이용해 수직 방향으로 움직여 기울기 조정을 시작하는 시점에서 호출되며 탭한 위치의 정보와 기울기 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aTilt 현재 맵의 tilt 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
tiltingStartedWithScreenPoint:(CGPoint)aScreenPoint
          tilt:(float)aTilt;
/**
 지도를 두 손가락을 이용해 수직 방향으로 움직여 기울기 조정을 진행하는 동안에 호출되며 탭한 위치의 정보와 변화하는 기울기 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aTilt 현재 맵의 tilt 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
tiltingChangingWithScreenPoint:(CGPoint)aScreenPoint
          tilt:(float)aTilt;
/**
 지도를 두 손가락을 이용해 수직 방향으로 움직여 기울기 조정을 종료하는 시점에서 호출되며 마지막으로 손가락을 뗀 위치의 정보와 기울기 정보를 반환합니다.
 
 @param aMapView 터치이벤트가 발생된 맵 뷰
 @param aScreenPoint 터치이벤트가 발생된 스크린 좌표.
 @param aTilt 현재 맵의 tilt 값.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
tiltingEndedWithScreenPoint:(CGPoint)aScreenPoint
          tilt:(float)aTilt;

/**
 지도에서 moveAnimateCamera를 호출한 뒤 카메라 애니메이션 동작이 취소된 시점에 호출됩니다.
 
 @param aMapView 카메라 애니메이션 이벤트가 발생된 맵 뷰
 @param aCameraUpdate 카메라 정보.
 @see KNMapView.animateCamera
 @see KNMapCameraUpdate
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
cameraAnimationCanceledWithCameraUpdate:(KNMapCameraUpdate *_Nonnull)aCameraUpdate;

/**
 지도에서 moveAnimateCamera를 호출한 뒤 카메라 애니메이션 동작이 끝나는 시점에 호출됩니다.
 
 @param aMapView 카메라 애니메이션 이벤트가 발생된 맵 뷰
 @param aCameraUpdate 카메라 정보.
 @see KNMapView.animateCamera
 @see KNMapCameraUpdate
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
cameraAnimationEndedWithCameraUpdate:(KNMapCameraUpdate *_Nonnull)aCameraUpdate;
@end

#endif /* KNMapViewEventListener_h */
