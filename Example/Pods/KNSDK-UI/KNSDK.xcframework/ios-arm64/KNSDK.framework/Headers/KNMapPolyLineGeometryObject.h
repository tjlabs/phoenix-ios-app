//
//  KNMapPolyLineGeometryObject.h
//  KNSDK
//
//  Created by jayg.025 on 2020/04/23.
//  Copyright © 2020 hyeon.k. All rights reserved.
//
#import "KNMapGeometryObject.h"
@interface KNMapPolyLineGeometryObject:KNMapGeometryObject

+(KNMapPolyLineGeometryObject* _Nonnull)polyLineGeometryWithID:(NSInteger)aID;
+(KNMapPolyLineGeometryObject* _Nonnull)polyLineGeometry;
-(bool)addPos:(vector_float2)pos;
-(bool)resetPos:(vector_float2)pos
          index:(int)aIndex;
@end
