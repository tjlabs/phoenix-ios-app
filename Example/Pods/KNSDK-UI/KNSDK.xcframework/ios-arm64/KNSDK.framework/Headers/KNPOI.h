//
//  KNPOI.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 POI
 */
@interface KNPOI : NSObject

/**
 명칭
 */
@property (nonatomic, readonly) NSString    *name;

/**
 위치
 */
@property (nonatomic, readonly) IntPoint    pos;

/**
 주소
 */
@property (nonatomic, readonly) NSString    *address;

/**
 생성자
 */
- (id)initWithName:(NSString *)aName x:(SInt32)aX y:(SInt32)aY;

/**
 생성자
 */
- (id)initWithName:(NSString *)aName pos:(IntPoint)aPos;

/**
 생성자
 */
- (id)initWithName:(NSString *)aName x:(SInt32)aX y:(SInt32)aY address:(NSString *)aAddress;

/**
 생성자
 */
- (id)initWithName:(NSString *)aName pos:(IntPoint)aPos address:(NSString *)aAddress;

@end

NS_ASSUME_NONNULL_END
