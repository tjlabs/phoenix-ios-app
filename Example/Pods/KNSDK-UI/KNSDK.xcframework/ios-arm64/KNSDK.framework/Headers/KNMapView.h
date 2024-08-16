//
//  KNMapView.h
//  KNSDK
//
//  Created by Rex.zar on 13/02/2019.
//  Copyright © 2019 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MetalKit/MTKView.h>

@class KNMapView, KNTrip, KNRoute, KNMapCameraUpdate, KNMapTheme, KNMapCoordinateRegion, KNLocation;
@protocol KNMapViewEventListener, KNMapParkingLotProperties;

/**
 지도 화면을 보여주는 View 클래스로 카메라 구도, 마커, 경로, 도형 그리기 등 지도 설정을 위한 다양한 기능을 제공합니다.
 */
@interface KNMapView : MTKView

/**
 경로 리스트를 전달받아 지도에 경로를 설정합니다.맵에 경로를 설정한다.
 
 @param routes 경로 리스트.
 @see KNRoute
 */
-(void)setRoutes:(NSArray<KNRoute*>* _Nonnull)routes NS_SWIFT_NAME(setRoutes(routes:));

/**
 지도에 경로를 설정합니다.
 
 @param route 경로.
 @see KNRoute
 */
-(void)setRoute:(KNRoute* _Nonnull)route NS_SWIFT_NAME(setRoute(route:));

/**
 지도에 설정된 모든 경로 리스트를 반환합니다.
 
 @return 맵에 등록된 경로 리스트.
 @see KNRoute
 */
-(NSArray<KNRoute*>* _Nonnull)getRoutes;

/**
 지도에 등록된 모든 경로를 삭제합니다.
 */
-(void)removeRoutesAll;

/**
 지도의 줌 레벨 최소, 최대 값을 설정하여 범위를 제한합니다. 범위는 서버 설정에 따라 0.1에서 9999.0까지 지정할 수 있으며 이 범위를 벗어나는 설정은 무시됩니다.
 
 @param aMinimum 카메라의 최소 줌 배율(최소 값 0.1).
 @param aMaximum 카메라의 최대 줌 배율(최대 값 9999.0).
 */
-(void)setZoomRangeWithMinimum:(float)aMinimum maximum:(float)aMaximum  NS_SWIFT_NAME(setZoomRange(minimum:maximum:));

/**
 입력받은 사용자의 위치 정보를 통해 사용자가 지나간 경로 부분을 자릅니다.  `isAnimate`가 활성화(`YES`)된 경우, 500 ms를 기준으로 서서히 경로가 잘리게 되며 비활성화(`NO`)된 경우 즉시 잘립니다.
 경로의 시작 위치는 `KNLocation`을 기준으로 합니다.
 
 @param aLocation 가이던스 위치정보.
 @param aIsAnimate 컬링 애니메이션 여부.
 @see KNLocation
 */
-(void)cullPassedRouteWithLocation:(KNLocation* _Nonnull)aLocation isAnimate:(BOOL)aIsAnimate;

/**
 지도에 마커를 추가합니다.
 
 @param aMarker 마커.
 @see KNMapMarker
 */
-(void)addMarker:(KNMapMarker*_Nonnull)aMarker;

/**
 지도에 마커 리스트를 추가합니다.
 
 @param aMarkers 마커 리스트.
 @see KNMapMarker
 */
-(void)addMarkers:(NSArray<KNMapMarker*>* _Nonnull)aMarkers;

/**
 지도에서 마커를 제거합니다.
 
 @param aMarker 마커.
 @see KNMapMarker
 */
-(void)removeMarker:(KNMapMarker*_Nonnull)aMarker;

/**
 지도에 추가된 모든 마커를 제거합니다.
 */
-(void)removeMarkersAll;

/**
 지도에 추가된 마커 리스트를 반환합니다. 추가된 마커가 없을 경우 빈 리스트를 반환합니다.
 
 @return 마커 리스트.
 @see KNMapMarker
 */
-(NSArray*_Nullable)getMarkers;

/**
 지도에 원을 추가합니다.
 
 @param aCircle 원.
 @see KNMapCircle
 */
-(void)addCircle:(KNMapCircle*_Nonnull)aCircle;

/**
 지도에서 원을 제거합니다.
 
 @param aCircle 원.
 @see KNMapCircle
 */
-(void)removeCircle:(KNMapCircle*_Nonnull)aCircle;

/**
 지도에 추가된 모든 원을 제거합니다.
 */
-(void)removeCirclesAll;

/**
 지도에 추가된 원 리스트를 반환합니다. 추가된 원이 없을 경우 빈 리스트를 반환합니다.
 
 @return 원 리스트.
 @see KNMapCircle
 */
-(NSArray*_Nullable)getCircles;

/**
 지도에 폴리라인을 추가합니다.
 
 @param aPolyline 폴리라인.
 @see KNMapPolyline
 */
-(void)addPolyline:(KNMapPolyline*_Nonnull)aPolyline;

/**
 지도에서 폴리라인을 제거합니다.
 
 @param aPolyline 폴리라인.
 @see KNMapPolyline
 */
-(void)removePolyline:(KNMapPolyline*_Nonnull)aPolyline;

/**
 지도에 추가된 모든 폴리라인을 제거합니다.
 */
-(void)removePolylinesAll;
/**
 지도에 추가된 폴리라인 리스트를 반환합니다. 추가된 폴리라인이 없을 경우 빈 리스트를 반환합니다.
 
 @return 폴리라인 리스트.
 @see KNMapPolyline
 */
-(NSArray*_Nullable)getPolylines;

/**
 지도에 폴리곤(다각형)을 추가합니다.
 
 @param aPolygon 폴리곤.
 @see KNMapPolygon
 */
-(void)addPolygon:(KNMapPolygon*_Nonnull)aPolygon;

/**
 지도에서 폴리곤(다각형)을 제거합니다.
 
 @param aPolygon 폴리곤.
 @see KNMapPolygon
 */
-(void)removePolygon:(KNMapPolygon*_Nonnull)aPolygon;

/**
 지도에 추가된 모든 폴리곤(다각형)을 제거합니다.
 */
-(void)removePolygonsAll;

/**
 지도에 추가된 폴리곤(다각형) 리스트를 반환합니다. 추가된 폴리곤이 없을 경우 빈 리스트를 반환합니다.
 
 @return 폴리곤 리스트.
 @see KNMapPolygon
 */
-(NSArray*_Nullable)getPolygons;

/**
 지도에 색분할 라인을 추가합니다.
 
 @param aSegmentPolyline 색분할 라인.
 @see KNMapSegmentPolyline
 */
-(void)addSegmentPolyline:(KNMapSegmentPolyline*_Nonnull)aSegmentPolyline;

/**
 지도에서 색분할 라인을 제거합니다.
 
 @param aSegmentPolyline 색분할 라인.
 @see KNMapSegmentPolyline
 */
-(void)removeSegmentPolyline:(KNMapSegmentPolyline*_Nonnull)aSegmentPolyline;

/**
 지도에 추가된 모든 색분할 라인을 제거합니다.
 */
-(void)removeSegmentPolylinesAll;
/**
 지도에 추가된 색분할 라인 리스트를 반환합니다. 추가된 색분할 라인이 없을 경우 빈 리스트를 반환합니다.
 
 @return 색분할라인 리스트.
 @see KNMapSegmentPolyline
 */
-(NSArray*_Nullable)getSegmentPolylines;

/**
 KNMapCoordinateRegion을 감싸는 화면의 사각 영역(CGRect)을 반환합니다.
 
 @param aRegion region.
 @return 스크린 영역.
 @see KNMapCoordinateRegion
 */
-(CGRect)getScreenRectWithRegion:(KNMapCoordinateRegion* _Nonnull)aRegion;

/**
 화면의 사각 영역(CGRect)이 KNMapCoordinateRegion과 겹치는지 여부를 확인합니다.
 
 @param aRegion KNMapCoordinateRegion.
 @param aScreenRect 스크린 영역.
 @return 겹침 여부 반환
 @see KNMapCoordinateRegion
 */
-(BOOL)isOverlappedWithScreenRect:(CGRect)aScreenRect
                     region:(KNMapCoordinateRegion* _Nonnull)aRegion;
/**
 화면의 좌표(CGPoint)가 KNMapCoordinateRegion과 겹치는지 여부를 확인합니다.
 
 @param aRegion KNMapCoordinateRegion.
 @param aScreenPoint 스크린 좌표.
 @return 겹침 여부 반환
 @see KNMapCoordinateRegion
 */
-(BOOL)isOverlappedWithScreenPoint:(CGPoint)aScreenPoint
                     region:(KNMapCoordinateRegion* _Nonnull)aRegion;

/**
 KNMapCameraUpdate의 설정 값으로 지도의 카메라 위치를 업데이트합니다.
 
 @param aCameraUpdate KNMapCameraUpdate
 @param aWithUserLocation 유저로케이션 위치동기화 여부
 @see KNMapCameraUpdate
 @see KNMapUserLocation
 */
-(void)moveCamera:(KNMapCameraUpdate* _Nonnull)aCameraUpdate
 withUserLocation:(BOOL)aWithUserLocation;

/**
 KNMapCameraUpdate에서 설정된 정보로 현재 지도상 위치와 줌, 각도를 aDuration에 입력된 시간동안 변경합니다. (단위: ms)
 
 @param aCameraUpdate KNMapCameraUpdate
 @param aDuraiton 애니메이션 동작 시간(ms)
 @param aWithUserLocation 유저로케이션 위치동기화 여부
 @see KNMapCameraUpdate
 @see KNMapUserLocation
 */
-(void)animateCamera:(KNMapCameraUpdate* _Nonnull)aCameraUpdate
            duration:(int)aDuraiton
    withUserLocation:(BOOL)aWithUserLocation;

/**
 현재 맵기준 KATEC좌표를 화면좌표로 변환합니다.
 
 @param katec KATEC좌표
 */
- (CGPoint)katecToScreen:(FloatPoint)katec;
/**
 현재 맵기준 화면좌표를 KATEC좌표로 변환합니다.
 
 @param screen 화면좌표
 */
- (FloatPoint)screenToKatec:(CGPoint)screen;

/**
 지도상 교통량 정보 표시 여부를 설정합니다. (기본 값: `NO`)
 (회색: 통행 불가 또는 알 수 없음, 파랑: 원활, 노랑: 서행, 주황: 지체, 빨강: 정체)
 */
@property (nonatomic, readwrite, assign) BOOL isVisibleTraffic;

/**
 지도상 건물의 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, readwrite, assign) BOOL isVisibleBuilding;

/**
 현재 지도의 위치를 표시한 카텍(KATEC) 좌표입니다.
 */
@property (nonatomic, readonly) FloatPoint coordinate;

/**
 카메라 줌, 기울기, 회전 시 기준이 되는 화면 기준점입니다.
 화면의 값은 (x축, y축)으로 표시되며 좌측 상단 모서리 값은 (0, 0), 우측 하단 모서리 값은 (1, 1)임. 오른쪽으로 이동 시 x축 +0.1, 아래쪽으로 이동 시 y축 +0.1을 합니다.
 */
@property (nonatomic, readonly) FloatPoint anchor;

/**
 지도의 방향 각도를 설정합니다. (단위: degree)
 */
@property (nonatomic, readonly) float bearing;

/**
 지도의 확대 또는 축소할 수 있으며 값이 클 수록 확대됩니다.
 */
@property (nonatomic, readonly) float zoom;

/**
 지도의 기울기를 설정합니다. (단위: degree)
 */
@property (nonatomic, readonly) float tilt;

/**
 지도의 테마(색상, 주간/야간 모드 등)를 설정합니다.
 
 @see KNMapTheme
 */
@property (nonatomic, readwrite, assign, nonnull) KNMapTheme* mapTheme;

/**
 카메라의 시점 조작(패닝, 줌, 기울기, 회전 등)과 화면 터치(한 번 탭, 이중 탭 등) 동작을 구현합니다.
 
 @see KNMapViewEventListener
 */
@property (nonatomic, nullable, readwrite, weak) id<KNMapViewEventListener> viewEventListener;

/**
 마커를 선택하거나 마커 애니메이션의 종료 동작을 구현합니다.
 
 @see KNMapMarkerViewEventListener
 */
@property (nonatomic, nullable, readwrite, weak) id<KNMapMarkerEventListener> markerEventListener;

/**
 현재 사용자의 위치를 표시합니다. 하나의 지도에서 두 개 이상의 사용자 위치 사용을 허용하지 않습니다.
 
 @see KNMapUserLocation
 */
@property (nonatomic, readonly, nonnull) KNMapUserLocation* userLocation;


/**
 지도의 기울기 동작 사용 여부를 설정합니다. (기본 값: YES)
 해당 값이 NO일 경우 지도에서 두 손가락을 이용해 수직 방향으로 움직여도 기울기가 변하지 않습니다.
 */
@property (nonatomic, readwrite, assign) bool useTiltGesture;

/**
 지도의 확대/축소 동작 사용 여부를 설정합니다. (기본 값: `YES`)
 해당 값이 `NO`일 경우 지도에서 두 손가락을 오므리거나 벌려도 지도의 크기가 변하지 않습니다.
 */
@property (nonatomic, readwrite, assign) bool useZoomGesture;

/**
 시계 방향/반시계 방향으로의 회전 동작 사용 여부를 설정합니다. (기본 값: `YES`)
 해당 값이 `NO`일 경우 지도에서 두 손가락을 이용해 시계 방향/반시계 방향으로 움직여도 화면의 기울기가 변하지 않습니다.
 */
@property (nonatomic, readwrite, assign) bool useBearingGesture;

/**
 지도를 한 방향으로 빠르게 움직이는 패닝(panning) 동작 사용 여부를 설정합니다. (기본 값: `YES`)
 해당 값이 `NO`일 경우 지도에서 손가락을 빠르게 움직여도 패닝 동작이 작동하지 않습니다.
 */
@property (nonatomic, readwrite, assign) bool usePanningGesture;

/**
 POI(상호명, 건물명) 속성 프로퍼티입니다. 맵 뷰에 POI를 표출할 건지 지정할 수 있고 KNMapPOIEventListener를 등록하여 POI의 이벤트를 콜백 받을 수 있습니다.
*/
@property (readonly, nullable) KNMapPOIProperties* poiProperties;

/**
 경로 속성 프로퍼티입니다. 경로의 색상이나 선 두께등을 지정할 수 있고 KNMapRouteEventListener를 등록하여 경로의 이벤트를 콜백 받을 수 있습니다.
*/
@property (readonly, nullable) KNMapRouteProperties* routeProperties;

/**
주차장 속성 프로퍼티입니다. 맵 뷰에 표출할 주차장들을 지정할 수 있고 KNMapParkingLotReceiver를 등록하여 주차장의 이벤트를 콜백 받을 수 있습니다.
*/
@property (readonly, nullable) KNMapParkingLotProperties* parkingLotProperties;


@end
