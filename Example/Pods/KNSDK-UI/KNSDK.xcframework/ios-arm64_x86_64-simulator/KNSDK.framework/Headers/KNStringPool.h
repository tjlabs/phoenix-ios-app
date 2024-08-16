//
//  KNStringPool.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 12. 3..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNStringPool : NSObject

- (NSString *)pooledString:(NSString *)aString;
- (void)releasePool;

@end
