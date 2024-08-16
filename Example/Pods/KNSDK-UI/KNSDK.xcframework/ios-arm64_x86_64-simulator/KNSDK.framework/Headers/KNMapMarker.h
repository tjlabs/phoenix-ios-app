//
//  KNMapMarker.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/09/15.
//  Copyright © 2021 hyeon.k. All rights reserved.
//
#ifndef KNMapMarker_h
#define KNMapMarker_h

#import "KNMapShape.h"
#import "KNMapCalloutBubbleUpdate.h"

/**
 지도상 특정 위치를 표시하는 마커를 설정합니다. 마커는 사용자가 직접 이미지를 설정할 수 있으며, 별도의 설정이 없는 경우 기본 핀 이미지로 표시됩니다.
 지도 위에 마커를 추가하기 위해서는 `KNMapMarker` 객체를 생성하여 `KNMapView`에 객체를 등록해야 합니다.
 */
@interface KNMapMarker : KNMapShape

/**
 KNMapMarker 객체를 생성합니다.
 
 @see KNMapView.addMarker
 @see KNMapView.removeMarker
 @see KNMapView.removeMarkerAll
 @return KNMapMarker
 */
+(KNMapMarker* _Nonnull)marker NS_SWIFT_NAME(marker());

/**
 지도상 위치를 설정하고 KNMapMarker 객체를 생성합니다.
 
 @param aCoordinate 카텍좌표 위치
 @return KNMapMarker
 */
+(KNMapMarker* _Nonnull)markerWithCoordinate:(FloatPoint)aCoordinate NS_SWIFT_NAME(marker(coordinate:));

/**
 애니메이션 효과와 함께 지도상 위치를 이동합니다.
 
 @param aCoordinate 이동시킬 카텍좌표.
 @param aDuration 애니메이션 동작 시간(ms).
 */
-(void)animateWithCoordinate:(FloatPoint)aCoordinate duration:(float)aDuration;

/**
 지도에서 마커를 표시할 줌 레벨 범위를 설정합니다. 설정한 줌 레벨 범위에서만 마커가 표시되며 특정한 줌 레벨에서 마커를 표시하고 싶지 않을 때 사용합니다.
 
 @param aMinZoom 최소 노출 zoom 배율
 @param aMaxZoom 최대 노출 zoom 배율
 */
-(void)setVisibleRangeWithMinZoom:(float)aMinZoom maxZoom:(float)aMaxZoom;

/**
  KNMapCalloutBubbleUpdate 설정 값으로 마커의 말풍선을 업데이트합니다.
 
 @param aCalloutBubbleUpdate 말풍선 업데이트 정보
 @see KNMapCalloutBubbleUpdate
 */
-(void)updateCalloutBubble:(KNMapCalloutBubbleUpdate* _Nonnull)aCalloutBubbleUpdate;
/**
 마커를 표시한 카텍(KATEC) 좌표입니다.
 */
@property (nonatomic, assign) FloatPoint coordinate;

/**
 마커의 이미지 위치를 보정합니다. 픽셀 단위로 보정되며 위치 값은 (x축, y축)으로 표시합니다.
 마커 하단 중앙 값을 원점으로 오른쪽으로 이동 시 x축 +1, 아래쪽으로 이동 시 y축 +1을 설정합니다. (기본 값: 원점)
*/
@property (nonatomic, assign) IntPoint pixelOffset;

/**
 마커 표시 여부를 설정합니다. (기본 값: `YES`)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 마커를 표시할 우선 순위를 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 0, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, assign) NSInteger priority;

/**
 마커 이미지를 설정합니다. 사용자가 마커 이미지를 직접 설정할 수 있으며, 별도의 설정이 없는 경우 기본 핀 이미지로 표시됩니다.
 
 @see UIImage
 */
@property (nonatomic, assign, nonnull) UIImage* icon;

/**
 마커에 설정할 태그(tag)입니다. 태그는 Int값을 가지며 마커를 그룹화 하거나 구분자로 사용할 수 있습니다. (선택 사항)
 */
@property (nonatomic, assign) NSInteger tag;

/**
 마커에 관련 정보가 저장된 컨테이너 클래스를 연결합니다. (선택 사항)
 */
@property (nonatomic, assign, nullable) NSObject* info;

/**
 마커 말풍선의 주 타이틀입니다. updateCalloutBubble 함수를 통해 말풍선의 주 타이틀을 설정 할 수 있습니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
@property (nonatomic, readonly, nullable) NSString* title;

/**
 마커 말풍선의 보조 타이틀입니다. updateCalloutBubble 함수를 통해 말풍선의 보조 타이틀을 설정 할 수 있습니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
@property (nonatomic, readonly, nullable) NSString* subTitle;

/**
 마커 말풍선의 표출 유무입니다. (기본 값: `YES`)
 
 @see KNMapMarker.updateCalloutBubble
 */
@property (nonatomic, assign) BOOL isVisibleCalloutBubble;

/**
 싱글 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapMarkerEventListener의 싱글 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useSingleTapped;

/**
 더블 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapMarkerEventListener의 더블 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useDoubleTapped;

/**
 롱 탭 제스처 사용 여부를 설정 합니다(기본값 : YES). 만약 이 값이 NO라면, KNMapMarkerEventListener의 롱 탭 이벤트를 받을 수 없습니다.
 */
@property (nonatomic, readwrite, assign) bool useLongPressed;

@end
#endif /* KNMapMarker_h */
