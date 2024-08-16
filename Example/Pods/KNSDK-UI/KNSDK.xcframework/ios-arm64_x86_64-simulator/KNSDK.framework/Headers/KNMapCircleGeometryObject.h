//
//  KNArcGeometryObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/04/23.
//  Copyright © 2020 hyeon.k. All rights reserved.
//
#import "KNMapGeometryObject.h"
@interface KNMapCircleGeometryObject:KNMapGeometryObject
@property (nonatomic, readwrite, assign) vector_float2 circleCenter;
@property (nonatomic, readwrite, assign) float radius;

+(KNMapCircleGeometryObject* _Nullable)circleGeometryWithID:(NSInteger)aID
                           circleCenter:(vector_float2)aCircleCenter
                                 radius:(float)aRadius;

+(KNMapCircleGeometryObject* _Nullable)circleGeometryWithCircleCenter:(vector_float2)aCircleCenter
                                    radius:(float)aRadius;
@end
