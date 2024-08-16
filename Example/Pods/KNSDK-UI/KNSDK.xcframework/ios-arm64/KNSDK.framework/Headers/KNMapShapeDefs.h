//
//  KNMapShapeDefs.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/14.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapShapeDefs_h
#define KNMapShapeDefs_h

typedef NS_ENUM(NSInteger, KNLineDashType)
{
    /** 실선 */
    KNLineDashType_Solid = 0,
    /** 파선 */
    KNLineDashType_Dashed = 1,
    /** 점선 */
    KNLineDashType_Dotted = 2,
    /** 1점 쇄선 */
    KNLineDashType_Dash_Dotted = 3,
    /** 2점 쇄선 */
    KNLineDashType_Dash_Dotted_Dotted = 4,
};
typedef NS_ENUM(NSInteger, KNLineCapType) {
    KNLineCapType_Flat = 0,
    KNLineCapType_Round = 1,
};
#endif /* KNMapShapeDefs_h */
