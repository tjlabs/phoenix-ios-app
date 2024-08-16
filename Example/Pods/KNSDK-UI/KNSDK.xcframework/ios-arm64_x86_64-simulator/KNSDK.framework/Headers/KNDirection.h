//
//  KNDirection.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 7..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 회전구간 정보
 
 회전구간의 회전코드, 노드명, 방면명칭, 경로상 위치 정보를 포함한다.
 */
@interface KNDirection : NSObject

/**
 회전지점의 경로상 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation              *location;          //  위치 정보

/**
 회전코드
 
 @see KNRGCode
 */
@property (nonatomic, readonly) KNRGCode                rgCode;             //  회전 코드

/**
 노드명
 */
@property (nonatomic, readonly) NSString                * _Nullable nodeName;          //  회전지점의 노드명

/**
 방면명칭
 
 회전구간에서의 경로 진행 방면명칭(표지판 방면 명칭)
 */
@property (nonatomic, readonly) NSArray<NSString *>     * _Nullable directionNames;    //  회전지점에서 진행해야하는 방면명칭

/**
 방면명칭 타입
 */
@property (nonatomic, readonly) KNDirNameType           dirNameType;    //  방면명칭 타입

/**
 동일한 회전구간 정보인지 여부
 
 객체가 아닌 정보로 비교
 @return 동일여부
 */
- (BOOL)isSameToDirection:(KNDirection *)aDirection;

@end

NS_ASSUME_NONNULL_END
