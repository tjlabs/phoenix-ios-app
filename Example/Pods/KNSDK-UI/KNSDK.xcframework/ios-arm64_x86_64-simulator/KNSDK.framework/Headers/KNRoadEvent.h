//
//  KNRoadEvent.h
//  KNSDK
//
//  Created by rex.zar on 18/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 유고 정보
 
 유고상황으로 인한 통행제한 정보
 */
@interface KNRoadEvent : NSObject

/**
 유고지점의 경로상 위치 정보
 */
@property (nonatomic, readonly) KNLocation          *location;          //  위치 정보 (유고정보 위치)

/**
 유고정보 명칭
 */
@property (nonatomic, readonly) NSString            * _Nullable title;             //  유고 명칭

/**
 상세 설명
 */
@property (nonatomic, readonly) NSString            * _Nullable desc;              //  상세 설명

/**
 유고 코드
 
 - 0 : 사고
 - 1 : 공사
 - 2 : 행사
 - 3 : 통제
 */
@property (nonatomic, readonly) SInt32              code;               //  유고 코드 : 0 - 사고, 1 - 공사, 2 - 행사, 3 - 통제

/**
 유고 타입
 
 - 0 : 통제없음
 - 1 : 전면통제
 - 2 : 부분통제
 */
@property (nonatomic, readonly) SInt32              type;               //  유고 타입 : 0 - 통제없음, 1 - 전면통제, 2 - 부분통제

/**
 시작일시
 */
@property (nonatomic, readonly) NSDate              *startTime;         //  시작일시

/**
 종료일시
 */
@property (nonatomic, readonly) NSDate              *endTime;           //  종료일시

/**
 위치
 
 KATEC
 */
@property (nonatomic, readonly) IntPoint            pos;                //  위치

/**
 아이콘
 
 유고정보 출처 아이콘
 */
@property (nonatomic, readonly) UIImage             * _Nullable icon;              //  아이콘

@end

NS_ASSUME_NONNULL_END
