//
//  KNMapPOIProperties.h
//  KNSDK
//
//  Created by luke.9p9 on 2023/04/27.
//  Copyright © 2023 hyeon.k. All rights reserved.
//

#ifndef KNMapPOIProperties_h
#define KNMapPOIProperties_h

/**
 POI를 선택할 수 있는 제스처 이벤트를 받을 수 있습니다.
 `KNMapPOIEventListener` 인터페이스를 구현하여 `KNMapView.poiProperties`에 등록할 수 있습니다.
 
 @see KNMapView.poiEventListener
 @see KNMapPOIProperties
 */
@protocol KNMapPOIEventListener<NSObject>

/**
 사용자가 손가락으로 POI를 터치한 경우 이벤트가 호출되며 선택된 POI를 전달합니다.
 
 @param aMapView 맵 뷰.
 @param aPOIId 선택된 poi의 id입니다.
 @param aPOIName 선택된 poi의 이름 정보입니다.
 @param aCoordinate 선택된 poi의 좌표(KATEC)정보 입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onSingleTapped:(SInt64)aPOIId
    poiName:(NSArray* _Nullable)aPOIName
    coordinate:(FloatPoint)aCoordinate;

/**
 사용자가 손가락으로 POI를 더블 터치한 경우 이벤트가 호출되며 선택된 POI를 전달합니다.
 
 @param aMapView 맵 뷰.
 @param aPOIId 선택된 poi의 id입니다.
 @param aPOIName 선택된 poi의 이름 정보입니다.
 @param aCoordinate 선택된 poi의 좌표(KATEC)정보 입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
onDoubleTapped:(SInt64)aPOIId
    poiName:(NSArray* _Nullable)aPOIName
    coordinate:(FloatPoint)aCoordinate;

/**
 사용자가 손가락으로 POI의 한 점을 길게 눌른 경우 이벤트가 호출되며 선택된 POI를 전달합니다.
 
 @param aMapView 맵 뷰.
 @param aPOIId 선택된 poi의 id입니다.
 @param aPOIName 선택된 poi의 이름 정보입니다.
 @param aCoordinate 선택된 poi의 좌표(KATEC)정보 입니다.
 */
-(void)mapView:(KNMapView *_Nonnull)aMapView
 onLongPressed:(SInt64)aPOIId
    poiName:(NSArray* _Nullable)aPOIName
    coordinate:(FloatPoint)aCoordinate;

@end

/**
 KNMapView에 있는 POI(상호명, 건물명) 속성 프로퍼티입니다. 맵 뷰에 POI를 표출할 건지 지정할 수 있고 KNMapPOIEventListener를 등록하여 POI의 이벤트를 콜백 받을 수 있습니다.
 
 @property isVisible POI 표시여부를 설정 합니다. (기본값 : YES)
 @property useSingleTapped 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 @property useDoubleTapped 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 @property useLongPressed 롱 탭 제스처 사용 여부를 설정 합니다 (기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 @property eventListener 맵 뷰에서 발생한 POI 이벤트를 넘겨줍니다.
 
 @see KNMapView
 @see KNMapPOIEventListener
*/
@interface KNMapPOIProperties: NSObject
/**
 POI 표시여부를 설정 합니다. (기본값 : YES)
 */
@property (nonatomic, readwrite, assign) bool isVisible;
/**
 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useSingleTapped;
/**
 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useDoubleTapped;
/**
 롱 탭 제스처 사용 여부를 설정 합니다 (기본값 : YES). 만약 이 값이 NO라면, KNMapPOIEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useLongPressed;
/**
 맵 뷰에서 발생한 POI 이벤트를 넘겨줍니다.
 */
@property (nonatomic, nullable, readwrite, weak) id<KNMapPOIEventListener> eventListener;
@end

#endif /* KNMapPOIProperties_h */
