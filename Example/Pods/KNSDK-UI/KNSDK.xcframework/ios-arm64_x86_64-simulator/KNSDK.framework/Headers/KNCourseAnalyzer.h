//
//  KNCourseAnalyzer.h
//  KNSDK
//
//  Created by rex.zar on 2021/04/08.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNCourseAnalyzer : NSObject

@property (nonatomic, readonly) SInt32              heading;
@property (nonatomic, readonly) SInt32              course;

#ifdef KN_MAPMATCHING_TEST
@property (nonatomic, readonly) CFMutableArrayRef   arrPath;            //  for test
@property (nonatomic, readonly) CFMutableArrayRef   arrCoursePath;      //  for test
#endif

- (void)addPoint:(DoublePoint)aPoint;
- (void)removeLastPoint;
- (void)trimWithRadius:(SInt32)aRadius;
- (void)analyzeCourse;
//- (void)analyzeCourseWithPoint:(DoublePoint)aPoint;

@end

NS_ASSUME_NONNULL_END
