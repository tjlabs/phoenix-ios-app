//
//  KNMapOverlayObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/04/23.
//  Copyright © 2020 hyeon.k. All rights reserved.
//
typedef NS_ENUM(int, KNMapOverlayObjectType)
{
    KNMapOverlayObjectType_None = 0,
    KNMapOverlayObjectType_CustomObject,
    KNMapOverlayObjectType_Polyline,
    KNMapOverlayObjectType_Rect,
    KNMapOverlayObjectType_Circle,
    KNMapOverlayObjectType_SpecifiedPolygon,
    KNMapOverlayObjectType_RouteLineStroke,
    KNMapOverlayObjectType_RouteLine,
    KNMapOverlayObjectType_StaticPattern
};
@interface KNMapOverlayObject : NSObject
/** object의 타입 */
@property (nonatomic, readonly, assign) KNMapOverlayObjectType objectType;
/** 고유 ID */
@property (nonatomic, readonly) NSInteger objectID;
/** 화면 표시 유무 */
@property (nonatomic, readwrite, assign) bool isShow;
/** 클릭 가능 여부 */

@property (nonatomic, readwrite, assign) bool useSingleTapped;

@property (nonatomic, readwrite, assign) bool useDoubleTapped;

@property (nonatomic, readwrite, assign) bool useLongPressed;
/** 표출 최대 Scale */
@property (nonatomic, readwrite, assign) float maxScale;
/** 표출 최소 Scale */
@property (nonatomic, readwrite, assign) float minScale;
/** 표출 우선 순위 */
@property (nonatomic, readwrite, assign) int priority;
/** 추가 할당 정보 */
@property (nonatomic, readwrite, assign, nullable) id aditionalParam;
/** 클릭 딜리게이트  KNMapGeometryObject 추후 지원 예정*/
@property (nonatomic, readwrite, assign, nullable) void (^onClickDelegate)(CGPoint aPos, KNMapOverlayObject* _Nonnull obj);

@end
