//
//  KNMapPolygon.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/09/28.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapPolygon_h
#define KNMapPolygon_h

#import "KNMapGroundObject.h"

/**
 지도에 표시할 폴리곤(다각형)을 생성합니다. 폴리곤의 외곽선과 면 색상, 선의 종류 등을 설정할 수 있습니다. 폴리곤은 카텍(KATEC) 좌표의 정점을 연결하여 구성하며 각 좌표 정점의 입력 순서는 시계 방향의 순서로 설정해야 합니다.
 지도 위에 폴리곤을 추가하기 위해서는 `KNMapPolygon` 객체를 생성하여 `KNMapView`에 객체를 등록해야 합니다.
 
 @see KNMapView.addPolygon
 @see KNMapView.removePolygon
 @see KNMapView.removePolygonAll
 */
@interface KNMapPolygon : KNMapGroundObject

/**
 카텍(KATEC) 좌표의 정점을 전달하고 KNMapPolygon 객체를 생성합니다. 이 때, 정점은 시계 방향 순서로 이루어져야 합니다.
 
 @param aPoints 폴리곤의 정점 리스트 포인터.
 @param aCountPoints aPoints 리스트의 정점 개수.
 @return KNMapPolygon
 */
+(KNMapPolygon* _Nonnull)polygonWithPoints:(FloatPoint* _Nonnull)aPoints countPoints : (int)aCountPoints NS_SWIFT_NAME(polygon(points:countPoints:));

/**
 다각형 내부에 구멍을 추가합니다. 이 때, 카텍(KATEC) 좌표의 정점을 연결하여 구성되며 정점들의 입력 순서는 시계 방향으로 설정됩니다. 정점들은 리스트 형태로 제공됩니다.
 
 @param aPoints 구멍 정점 리스트 포인터.
 @param aCountPoints aPoints 리스트의 정점 개수.
 **/
-(void)addHoleWithPoints:(FloatPoint* _Nonnull)aPoints countPoints : (int)aCountPoints;

/**
 폴리곤의 외곽선 색상을 설정합니다. addHoleWithPoints에서 폴리곤 내 구멍을 만든 경우, 구멍의 외곽선에도 해당 설정이 동일하게 적용됩니다.
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* strokeColor;

/**
 폴리곤의 외곽선 두께를 설정합니다. (기본 값: 2, 외곽선 두께 설정 범위: 1~5)
 */
@property (nonatomic, assign) float strokeWidth;

/**
 폴리곤의 외곽선의 종류입니다. 실선, 점선, 파선, 1점 쇄선, 2점 쇄선 등을 설정할 수 있습니다. (기본 값: KNLineDashType_Solid)
 
 @see KNLineDashType
 */
@property (nonatomic, assign) KNLineDashType strokeDashType;

/**
 폴리곤의 면 색상을 설정합니다.
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* fillColor;

/**
 폴리곤의 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 폴리곤의 표시 우선 순위를 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 0, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, readwrite, assign) NSInteger priority;

/**
 폴리곤에 설정할 태그(tag)입니다. 태그는 Int 값을 가지며 카테고리 분류나 별도의 구분을 하고 싶을 때 사용할 수 있습니다. (선택 사항)
 */
@property (nonatomic, assign) NSInteger tag;
@end

#endif /* KNMapPolygon_h */
