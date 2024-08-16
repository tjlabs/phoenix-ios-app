//
//  KNMapRectGeometryObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/04/23.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import "KNMapGeometryObject.h"
@interface KNMapRectGeometryObject:KNMapGeometryObject
@property (nonatomic, readwrite, assign) vector_float2 rectCenter;
@property (nonatomic, readwrite, assign) float rectWidth;
@property (nonatomic, readwrite, assign) float rectHeight;
+(KNMapRectGeometryObject* _Nullable)rectGeometryObjectWithID:(NSInteger)aID
                           rectCenter:(vector_float2)aRectCenter
                            rectWidth:(float)aRectWidth
                           rectHeight:(float)aRectHeight;

+(KNMapRectGeometryObject* _Nullable)rectGeometryObjectWithRectCenter:(vector_float2)aRectCenter
                            rectWidth:(float)aRectWidth
                           rectHeight:(float)aRectHeight;
@end
