//
//  KNMapGeometryObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/04/23.
//  Copyright © 2020 hyeon.k. All rights reserved.
//
typedef NS_ENUM(NSInteger, LineDotType)
{
    /** 실선 */
    LineDotType_Solid = 0,
    /** 파선 */
    LineDotType_Dashed = 1,
    /** 점선 */
    LineDotType_Dotted = 2,
    /** 1점 쇄선 */
    LineDotType_Dash_Dotted = 3,
    /** 2점 쇄선 */
    LineDotType_Dash_Dotted_Dotted = 4,
};

@interface KNMapGeometryObject: KNMapOverlayObject
@property (nonatomic, readwrite, assign) LineDotType lineDotType;
@property (nonatomic, readwrite, assign) float lineWidth;
@property (nonatomic, readwrite, assign) float strokeWidth;
@property (nonatomic, readwrite, assign) vector_uchar4 lineColor;
@property (nonatomic, readwrite, assign) vector_uchar4 strokeColor;
@property (nonatomic, readwrite, assign) vector_uchar4 color;
@property (nonatomic, assign, nullable) UIImage* patternImage;

@end
