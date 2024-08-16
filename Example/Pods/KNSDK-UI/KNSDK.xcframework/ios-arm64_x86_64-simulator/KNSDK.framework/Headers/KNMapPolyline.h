//
//  KNMapPolyline.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/09/28.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapPolyline_h
#define KNMapPolyline_h

#import "KNMapGroundObject.h"

/**
 지도에 표시할 폴리라인(Polyline)을 생성합니다. 선의 색상, 두께, 종류 등을 설정할 수 있습니다. 폴리라인은 카텍(KATEC) 좌표의 정점을 연결하여 선을 그립니다.
 지도 위에 폴리라인을 추가하기 위해서는 `KNMapPolyline` 객체를 생성하여 `KNMapView`에 객체를 등록해야 합니다.
 
 @see KNMapView.addPolyline
 @see KNMapView.removePolyline
 @see KNMapView.removePolylineAll
 */
@interface KNMapPolyline : KNMapGroundObject

/**
 KNMapPolyline 객체를 생성합니다.
 
 @return KNMapPolyline
 */
+(KNMapPolyline* _Nonnull)polyline NS_SWIFT_NAME(polyline());

/**
 카텍(KATEC) 좌표들로 이뤄진 KNMapPolyline 객체를 생성합니다.
 
 @param aPoints 선의 정점 리스트 포인터.
 @param aCountPoints aPoints 리스트의 정점 개수
 @return KNMapPolyline
 */
+(KNMapPolyline* _Nonnull)polylineWithPoints:(FloatPoint* _Nonnull)aPoints countPoints : (int)aCountPoints NS_SWIFT_NAME(polyline(points:countPoints:));

/**
 카텍(KATEC) 좌표의 정점을 추가합니다. 현재 선의 마지막 정점과 추가된 정점을 연결합니다.
 
 @param aPoint 포인트
 */
-(void)addPoint:(FloatPoint) aPoint;

/**
 여러 개의 카텍(KATEC) 좌표의 정점을 추가합니다. 현재 선의 마지막 정점과 추가된 정점들을 연결합니다.
 
 @param aPoints 포인트 리스트 포인터
 @param aCountPoints aPoints 리스트의 개수
 */
-(void)addPoints:(FloatPoint* _Nonnull) aPoints countPoints : (int)aCountPoints;

/**
 폴리라인의 색상을 설정합니다. (기본 값: 검정색)
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* lineColor;

/**
 폴리라인의 두께를 설정합니다. (기본 값: 2, 최대 값: 5)
 */
@property (nonatomic, assign) float lineWidth;

/**
 폴리라인의 종류입니다. 실선, 점선, 파선, 1점 쇄선, 2점 쇄선 등을 설정할 수 있습니다. (기본 값: KNLineDashType_Solid)
 
 @see KNLineDashType
 */
@property (nonatomic, assign) KNLineDashType lineDashType;

/**
 폴리라인의 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 폴리라인을 표시할 우선 순위를 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 0, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, readwrite, assign) NSInteger priority;

/**
 폴리라인에 설정할 태그(tag)입니다. 태그는 Int 값을 가지며 카테고리 분류나 별도의 구분을 하고 싶을 때 사용할 수 있습니다. (선택 사항)
 */
@property (nonatomic, assign) NSInteger tag;

@end


#endif /* KNMapPolyline_h */
