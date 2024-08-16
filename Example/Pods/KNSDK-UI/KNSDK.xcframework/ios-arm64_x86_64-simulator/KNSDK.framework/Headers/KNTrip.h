//
//  KNTrip.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 8..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNError.h"
#import "KNPOI.h"
#import "KNRoute.h"
#import "KNRouteConfiguration.h"

NS_ASSUME_NONNULL_BEGIN

/**
 KNGuidance 연동 시 확장 정보
 
 KNGuidance와 연동시 주행관련 정보를 제공한다.
*/
@protocol KNTrip_GuidanceExtension <NSObject>

/** 남은 거리*/
- (SInt32)remainDist;
/** 남은 시간*/
- (SInt32)remainTime;
/** 남은 요금*/
- (SInt32)remainCost;
/** 주행 거리*/
- (SInt32)elapsedDist;
/** 주행 시간*/
- (SInt32)elapsedTime;
/** 주행 요금*/
- (SInt32)elapsedCost;
/** 지난 경유지 목록*/
- (NSArray<KNPOI *> * _Nullable)passedVias;

@end


/**
 경로 및 여정을 관리하는 클래스
 
 출도착지 및 경유지, 경로 설정정보등을 넘겨받아 옵션별 경로정보 및 요약정보(거리,요금,시간 등)를 조회/관리한다.
 
 KNGuidance 와 연동해 길안내를 구동하고, 주행정보를 관리한다.
 
 KNTrip은 KNSDK를 통해 생성되어야 한다.
 
    - (KNTrip *)makeTripWithStart:(KNPOI *)aStart goal:(KNPOI *)aGoal vias:(NSArray<KNPOI *> * _Nullable)aVias
 */
@interface KNTrip : NSObject <KNTrip_GuidanceExtension>

/** 출발지 */
@property (nonatomic, readonly) KNPOI                           *start;                         //  출발지
/** 목적지 */
@property (nonatomic, readonly) KNPOI                           *goal;                          //  목적지
/** 경유지 */
@property (nonatomic, readonly) NSArray<KNPOI *>                * _Nullable vias;               //  경유지
/** csid */
@property (nonatomic, readonly) NSString                        * _Nullable csId;               //  csid
/** 라우팅 컨피그레이션 정보 */
@property (nonatomic, strong)   KNRouteConfiguration            *routeConfig;                   //  라우팅 컨피그레이션 정보
/** 다중경로 사용 여부, default : YES */
@property (nonatomic, assign)   BOOL                            useMultiRoute;                  //  다중경로 사용 여부, default : YES
/** 선호경로 사용 여부, default : YES */
@property (nonatomic, assign)   BOOL                            usePreferredRoute;              //  선호경로 사용 여부, default : YES
/** 경로 TransId */
@property (nonatomic, strong)   NSString                        *transId;                       //  현재 경로의 TransId


/**
 경로 요청
 
 요청된 경로는 비동기로 전달된다.
 
 @param aRoutePriority 경로우선 옵션
 @param aAvoidOptions 경로회피 옵션
 @param aCompletion 요청된 경로정보 전달, 현재 기준으로 경로는 최대 2개가 전달될 수 있다. 순서대로 주경로 및 대안경로. 대안경로는 없을 수 있다.
 @see KNRouteOption
 @see KNRoute
 */
- (void)routeWithPriority:(KNRoutePriority)aPriority
             avoidOptions:(SInt32)aAvoidOptions
               completion:(void (^)(KNError * _Nullable aError, NSArray<KNRoute *> * _Nullable aRoutes))aCompletion;

///**
// 경로 요청(Deprecated)
//
// 요청된 경로는 비동기로 전달된다.
//
// @param aRouteOption 경로옵션
// @param aCompletion 요청된 경로정보 전달, 현재 기준으로 경로는 최대 2개가 전달될 수 있다. 순서대로 주경로 및 대안경로. 대안경로는 없을 수 있다.
// @see KNRouteOption
// @see KNRoute
// */
//- (void)routeWithRouteOption:(KNRouteOption)aRouteOption
//                  completion:(void (^)(KNError * _Nullable aError, NSArray<KNRoute *> * _Nullable aRoutes))aCompletion;

///**
// 경로 요약정보 요청(Deprecated)
//
// 요청된 경로 요약정보는 비동기로 전달된다.
//
// @param aCompletion 요청된 경로 요약정보 전달, 개별 경로 옵션들에 대한 요약정보가 아래의 딕셔너리 형태로 전달된다.
//
// 정상 : Dictionary [NSNumber(int), @"rp_opt", NSNumber(int), @"dist", NSNumber(int), @"time", NSNumber(int), @"cost"]
//
// 오류 : Dictionary [NSNumber(int), @"rp_opt", NSString, @"error_code", NSString, @"message"]
// */
//- (void)routeSummariesWithCompletion:(void (^)(KNError * _Nullable aError, NSArray<NSDictionary *> * _Nullable aRouteSummaries))aCompletion;

/**
 경유지 추가
 @param aVia 경유지 POI
 @param aIdx 경유지 추가 위치
 */
- (void)addVia:(KNPOI *)aVia atIndex:(NSInteger)aIdx;


/**
 경유지 추가
 @param aVia 경유지 POI
 @param aLocation 경유지 추가 위치
 */
- (void)addVia:(KNPOI *)aVia atLocation:(KNLocation *)aLocation;


/**
 경유지 삭제
 @param aIdx 경유지 삭제 위치
 */
- (void)removeViaAtIdx:(NSInteger)aIdx;


/**
 경유지 일괄 삭제
 */
- (void)removeAllVias;


/**
 경유지 일괄 설정
 */
- (void)setVias:(NSArray<KNPOI *> *)aVias;

@end

NS_ASSUME_NONNULL_END
