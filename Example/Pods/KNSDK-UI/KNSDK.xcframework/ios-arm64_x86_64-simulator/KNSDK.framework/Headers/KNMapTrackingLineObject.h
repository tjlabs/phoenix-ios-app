//
//  KNMapTrackingLineObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/07/20.
//  Copyright © 2020 hyeon.k. All rights reserved.
//
#import "KNMapGeometryObject.h"
/** 맵 현위치와 끝 위치를 연결하는 선*/
@interface KNMapTrackingLineObject:NSObject
/** 화면 표시 유무 */
@property (nonatomic, readwrite, assign) bool isShow;
/** 라인 점선 타입 */
@property (nonatomic, readwrite, assign) LineDotType lineDotType;
/** 라인 두께 */
@property (nonatomic, readwrite, assign) float lineWidth;
/** 라인 색상*/
@property (nonatomic, readwrite, assign) vector_uchar4 lineColor;
+(KNMapTrackingLineObject* _Nonnull)trackingLineObjectWithEndPos:(vector_float2)aEndPos;
@end
