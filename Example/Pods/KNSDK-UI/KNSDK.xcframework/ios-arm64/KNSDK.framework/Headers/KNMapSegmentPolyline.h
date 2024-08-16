//
//  KNMapSegmentPolyline.h
//  KNSDK
//
//  Created by luke.9p9 on 2022/03/10.
//  Copyright © 2022 hyeon.k. All rights reserved.
//

#ifndef KNMapSegmentPolyline_h
#define KNMapSegmentPolyline_h

#import "KNMapGroundObject.h"

@interface KNMapSegmentPolyline : KNMapGroundObject

/**
 KNMapSegmentLine 객체를 생성합니다. 라인에 패턴 이미지를 입히거나 분할된 색상을 적용하여 폴리라인을 커스터마이징 할 수 있습니다.
 @return KNMapSegmentPolyline
 */
+(KNMapSegmentPolyline* _Nonnull)segmentPolyline NS_SWIFT_NAME(segmentPolyline());

/**
 여러 개의 카텍(KATEC) 좌표의 정점 색을 추가하여 하나의 라인 세그먼트를 추가합니다. 현재 선의 세그먼트와 마지막 추가된 세그먼트를 연결합니다.
 
 @param aPoints 포인트 리스트 포인터
 @param aCountPoints aPoints 리스트의 개수
 @param aColor 색상
 */
-(void)addSegment:(FloatPoint* _Nonnull) aPoints countPoints : (int)aCountPoints color : (UIColor*)aColor;

/**
 라인의 외곽선 색상을 설정합니다.
 
 @see UIColor
 */
@property (nonatomic, assign, nonnull) UIColor* strokeColor;

/**
 라인의 두께를 설정합니다. (기본 값: 15, 최대 값: 50)
 */
@property (nonatomic, assign) float lineWidth;

/**
 라인의 외곽선 두께를 설정합니다. (기본 값: 4, 최대 값: 10)
 */
@property (nonatomic, assign) float strokeWidth;

/**
 라인의 양쪽 끝부분을 어떻게 그릴지 설정합니다.
 */
@property (nonatomic, assign) KNLineCapType capType;

/**
 라인의 표시 여부를 설정합니다. (기본 값: YES)
 */
@property (nonatomic, assign) BOOL isVisible;

/**
 라인을 표시할 우선 순위를 설정합니다. 숫자가 높을수록 상위로 표시됩니다. (기본 값: 0, 우선 순위 설정 범위: 0~65535)
 */
@property (nonatomic, readwrite, assign) NSInteger priority;

/**
 라인 안쪽에 나타나는 패턴 이미지를 설정합니다. (기본값: nil)
 
 @see UIImage
 */
@property (nonatomic, assign, nullable) UIImage* patternImage;

/**
 라인에 설정할 태그(tag)입니다. 태그는 Int 값을 가지며 카테고리 분류나 별도의 구분을 하고 싶을 때 사용할 수 있습니다. (선택 사항)
 */
@property (nonatomic, assign) NSInteger tag;

@end
#endif /* KNMapLineSegment_h */
