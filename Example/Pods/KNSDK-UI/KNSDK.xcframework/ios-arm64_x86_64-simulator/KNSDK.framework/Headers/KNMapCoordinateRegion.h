//
//  KNMapCoordinateRegion.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/11/30.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapCoordinateRegion_h
#define KNMapCoordinateRegion_h

/**
 실좌표계 영역을 정의하는 클래스입니다. 이 클래스를 이용하면 지도에 등록된 경로 오브젝트와 마커 오브젝트의 영역을 하나로 합치고 한 화면에 보여 줄 수 있습니다.
 
 @see KNMapCameraUpdate.fitToRegion
 @see KNMapCameraUpdate.fitToFittingRect
 @see KNMapView.getScreenRect
 @see KNMapView.isOverlappedWithScreenPoint
 @see KNMapView.isOverlappedWithScreenRect
 */
@interface KNMapCoordinateRegion : NSObject
/**
 KNMapCoordinateRegion 객체를 생성합니다.
 */
+(KNMapCoordinateRegion* _Nonnull) region NS_SWIFT_NAME(region());

/**
 카텍(KATEC) 영역의 최소, 최대 좌표 값을 받아 KNMapCoordinateRegion 객체를 생성합니다.
 
 @param aMin 영역의 최소 값.
 @param aMax 영역의 최대 값.
 @return min,max값을 가지는 region 인스턴스
 */
+(KNMapCoordinateRegion* _Nonnull) regionWithMin:(FloatPoint)aMin
                                             max:(FloatPoint)aMax NS_SWIFT_NAME(region(min:max:));

/**
 경로 리스트를 받아 KNMapCoordinateRegion 객체를 생성합니다.
 
 @param aRoutes 경로 리스트.
 @see KNRoute
 */
+(KNMapCoordinateRegion* _Nonnull) regionWithRoutes:(NSArray* _Nonnull)aRoutes  NS_SWIFT_NAME(region(routes:));

/**
 마커 리스트를 받아 KNMapCoordinateRegion 객체를 생성합니다.
 
 @param aMarkers 마커 리스트.
 @see KNMapMarker
 */
+(KNMapCoordinateRegion* _Nonnull) regionWithMarkers:(NSArray* _Nonnull)aMarkers  NS_SWIFT_NAME(region(markers:));

/**
 현재 설정된 영역과 카텍(KATEC) 영역을 모두 포함하는 최소 영역을 설정합니다.
 
 @param aMin 영역의 최소 값.
 @param aMax 영역의 최대 값.
 */
-(void) mergeWithMin:(FloatPoint)aMin
                 max:(FloatPoint)aMax;

/**
 경로 리스트를 받아 KNMapCoordinateRegion 객체를 생성합니다.
 
 @param aRoutes 경로 리스트.
 @see KNRoute
 */
-(void) mergeWithRoutes:(NSArray* _Nonnull)aRoutes;

/**
 현재 설정된 영역과 입력받은 마커 리스트의 영역을 모두 포함하는 최소 영역을 설정합니다.
 
 @param aMarkers 마커 리스트.
 @see KNMapMarker
 */
-(void) mergeWithMarkers:(NSArray* _Nonnull)aMarkers;

/**
 현재 설정된 영역과 입력받은 새로운 영역을 모두 포함하는 최소 영역을 설정합니다.
 
 @param aRegion KNMapCoordinateRegion.
 */
-(void) mergeWithRegion:(KNMapCoordinateRegion* _Nonnull)aRegion;

@end
#endif /* KNMapCoordinateRegion_h */
