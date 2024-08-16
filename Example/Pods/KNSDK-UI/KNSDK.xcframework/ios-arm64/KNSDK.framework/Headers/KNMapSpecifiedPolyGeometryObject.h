//
//  KNMapSpecifiedPolyGeometryObject.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/02/26.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import "KNMapGeometryObject.h"
@interface KNMapSpecifiedPolyGeometryObject:KNMapGeometryObject
+(KNMapSpecifiedPolyGeometryObject* _Nonnull)specifiedPolyGeometryObjectWithID:(NSInteger)aID
                                             positions : (vector_float2* _Nonnull)aPositions
                                             countPositions : (int)aCountPositions;
+(KNMapSpecifiedPolyGeometryObject* _Nonnull)specifiedPolyGeometryObjectWithPositions:(vector_float2* _Nonnull)positions
                                             countPositions : (int)aCountPositions;
-(bool)addHole:(vector_float2* _Nonnull)positions
                                    countPositions : (int)aCountPositions;
@end
