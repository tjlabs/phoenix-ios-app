//
//  KNMapCameraUpdate.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/27.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapCameraUpdate_h
#define KNMapCameraUpdate_h
/**
 3D Map에서 사용하는 카메라(사용자 시점)를 설정합니다.
 해당 클래스를 사용하여 줌 레벨 설정, 위치 이동, 화면 기울기와 회전 각도를 설정할 수 있습니다.
 또한, 지도 내 특정 영역을 기준으로 화면을 맞출 수도 있습니다.
 @see KNMapView
 */
@class KNMapCoordinateRegion;
@interface KNMapCameraUpdate : NSObject

/**
 초기 값으로 설정된KNMapCameraUpdate 객체를 생성합니다.
 
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) cameraUpdate NS_SWIFT_NAME(cameraUpdate());

/**
 지도상 현재 위치를 새로운 위치로 이동합니다. 카텍(KATEC) 좌표계를 사용하여 위도와 경도를 표시합니다.
 
 @param aPosition 이동할 위치 좌표(카텍)
 @see KNMapView.coordinateCenter
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) targetTo:(FloatPoint)aPosition;

/**
 지도상 현재 위치를 중심으로 줌 레벨을 설정합니다. 줌 레벨 설정의 범위는 KNMapView 클래스의 setZoomRange에서 설정한 범위를 따릅니다.
 
 @param aZoom 맵에 적용할 배율 값
 @see KNMapView.zoom
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) zoomTo:(float)aZoom;

/**
 지도상 현재 위치를 중심으로 화면 기울기를 설정합니다. (기울기 설정 범위: 0~50)
 
 @param aDegree 맵에 적용할 기울기 (0~50)
 @see KNMapView.tilt
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) tiltTo:(float)aDegree;

/**
 지도상 현재 위치를 중심으로 회전 각도를 설정합니다. (회전 각도 설정 범위: 0~360)
 
 @param aDegree 맵에 적용할 회전각도 (0~360)
 @see KNMapView.bearing
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) bearingTo:(float)aDegree;

/**
 화면의 줌, 기울기, 회전의 기준점을 설정합니다. 기본 값은 정중앙(0.5, 0.5)이며 새롭게 설정한 기준점을 중심으로 줌 레벨, 기울기, 회전 방향을 동작합니다.
 화면의 값은 (x축, y축)으로 표시되며 좌측 상단 모서리 값은 (0, 0), 우측 하단 모서리 값은 (1, 1)입니다. 오른쪽으로 이동 시 x축 +0.1, 아래쪽으로 이동 시 y축 +0.1을 합니다.
 
 @param aAnchor 기준점 [ (0, 0), (1, 1) ]
 @see KNMapView.anchor
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) anchorTo:(FloatPoint)aAnchor;

/**
 KNMapCoordinateRegion에서 전달받은 좌표 영역을 화면에 맞춥니다.
 
 @param aRegion 영역을 계산할 대상 오브젝트, 경로, mbr영역을 담은 객체.
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) fitToRegion:(KNMapCoordinateRegion*_Nonnull)aRegion;

/**
 전달받은 좌표 영역을 화면 안의 특정 사각 영역(CGRect)에 맞춥니다.
 
 @param aRect 카메라 상태가 업데이트 되었을 때의 기준 화면 영역.
 @param aRegion 영역을 계산할 대상 오브젝트, 경로, mbr영역을 담은 객체.
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
+(KNMapCameraUpdate* _Nonnull) fitToFittingRect:(CGRect)aRect
                                      region:(KNMapCoordinateRegion*_Nonnull)aRegion;

/**
 지도상 현재 위치를 새로운 위치로 이동합니다. 카텍(KATEC) 좌표계를 사용하여 위도와 경도를 표시합니다. 
 
 @param aPosition 이동할 위치 좌표(카텍)
 @see KNMapView.coordinateCenter
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) targetTo:(FloatPoint)aPosition;

/**
 지도상 현재 위치를 중심으로 줌 레벨을 설정합니다.
 
 @param aZoom 맵에 적용할 배율 값
 @see KNMapView.zoom
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) zoomTo:(float)aZoom;

/**
 지도상 현재 위치를 중심으로 화면 기울기를 설정합니다. (설정 가능 기울기: 0~50)
 
 @param aDegree 맵에 적용할 기울기 (0~50)
 @see KNMapView.tilt
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) tiltTo:(float)aDegree;

/**
 지도상 현재 위치를 중심으로 회전 각도를 설정합니다. (설정 가능 각도: 0~360)
 
 @param aDegree 맵에 적용할 회전각도 (0~360)
 @see KNMapView.bearing
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) bearingTo:(float)aDegree;

/**
 화면의 줌, 기울기, 회전의 기준점을 설정합니다. 기본 값은 정중앙(0.5, 0.5)이며 새롭게 설정한 기준점을 중심으로 줌 레벨, 기울기, 회전 방향을 동작합니다.
 화면의 값은 (x축, y축)으로 표시되며 좌측 상단 모서리 값은 (0, 0), 우측 하단 모서리 값은 (1, 1)입니다. 오른쪽으로 이동 시 x축 +0.1, 아래쪽으로 이동 시 y축 +0.1을 합니다.
 
 @param aAnchor 기준점 [ (0, 0), (1, 1) ]
 @see KNMapView.anchor
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) anchorTo:(FloatPoint)aAnchor;

/**
 KNMapCoordinateRegion에서 전달받은 좌표 영역을 화면에 맞춥니다.
 
 @param aRegion 영역을 계산할 대상 오브젝트, 경로, mbr영역을 담은 객체.
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) fitToRegion:(KNMapCoordinateRegion*_Nonnull)aRegion;

/**
 전달받은 좌표 영역을 화면 안의 특정 사각 영역(CGRect)에 맞춥니다.
 
 @param aRect 카메라 상태가 업데이트 되었을 때의 기준 화면 영역.
 @param aRegion 영역을 계산할 대상 오브젝트, 경로, mbr영역을 담은 객체.
 @see KNMapView.animateCamera
 @see KNMapView.moveCamera
 */
-(KNMapCameraUpdate* _Nonnull) fitToFittingRect:(CGRect)aRect
                                      region:(KNMapCoordinateRegion*_Nonnull)aRegion;
@end


#endif /* KNMapCameraUpdate_h */
