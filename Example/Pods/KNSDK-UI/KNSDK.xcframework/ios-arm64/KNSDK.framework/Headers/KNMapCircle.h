//
//  KNMapCircle.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/09/28.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapCircle_h
#define KNMapCircle_h

#import "KNMapGroundObject.h"

/**
 지도에 표시할 원을 생성합니다. 원의 외곽선과 면 색상, 선의 종류 등을 설정할 수 있습니다.
 지도 위에 원을 추가하기 위해서는 `KNMapCircle` 객체를 생성하여 `KNMapView`에 객체를 등록해야 합니다.
 
 @see KNMapView.addCircle
 @see KNMapView.removeCircle
 @see KNMapView.removeCircleAll
 */
@interface KNMapCircle : KNMapGroundObject

/**
 KNMapCircle 객체를 생성합니다.
 
 @return KNMapCircle
 */
+(KNMapCircle* _Nonnull)circle NS_SWIFT_NAME(circle());

/**
 카텍(KATEC) 좌표와 반지름을 설정하여 KNMapCircle 객체를 생성합니다.
 
 @return KNMapCircle
 */
+(KNMapCircle* _Nonnull)circleWithCenter:(FloatPoint)aCenter
              radius: (float)aRadius NS_SWIFT_NAME(circle(center:radius:));

/**
 원이 표시되는 카텍(KATEC) 좌표입니다.
 */
@property (nonatomic, assign) FloatPoint center;

/**
 원의 반지름 크기를 설정합니다.
 */
@property (nonatomic, assign) float radius;

/**
 원의 면 색상을 설정합니다.
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* fillColor;

/**
 원의 외곽선 색상을 설정합니다.
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* strokeColor;

/**
 원의 외곽선 두께를 설정합니다. (외곽선 두께 설정 범위: 1~5)
 */
@property (nonatomic, assign) float strokeWidth;

/**
 원의 외곽선 종류입니다. 실선, 점선, 파선, 1점 쇄선, 2점 쇄선 등을 설정할 수 있습니다. (기본 값: KNLineDashType_Solid)
 
 @see KNLineDashType
 */
@property (nonatomic, assign) KNLineDashType strokeDashType;

/**
 원의 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 원을 표시할 우선 순위를 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 0, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, readwrite, assign) NSInteger priority;

/**
 원에 설정할 태그(tag)입니다. 태그는 Int 값을 가지며 카테고리 분류나 별도의 구분을 하고 싶을 때 사용할 수 있습니다. (선택 사항)
 */
@property (nonatomic, assign) NSInteger tag;

@end


#endif /* KNMapCircle_h */
