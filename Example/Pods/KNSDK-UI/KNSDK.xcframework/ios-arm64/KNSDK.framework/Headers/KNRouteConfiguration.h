//
//  KNRouteConfiguration.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 11. 13..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

//  KNRouteConfiguration_FreightOption
//  ====================================================================================================================
/**
 화물차 회피 경로 설정 정보

 화물차 회피 경로 산정에 영향을 가지는 요소들에 대한 설정 정보
 설정된 옵션에 따른 가급적 회피
*/
@interface KNRouteConfiguration_FreightOption : NSObject
/**
 U턴 회피
 
 default : false
 */
@property(nonatomic, readonly)      BOOL                        avoidUTurn;                     //  U턴 회피, default : false

/**
 제한 왕복 차선수 회피
 - 설정된 차선수(왕복) 이하의 도로를 회피
 0 : 회피 없음
 
 default : 0
 */
@property(nonatomic, readonly)      SInt32                      avoidLaneCnt;                   //  제한 왕복 차선수 회피, default : 0

/**
 상수도 보호구역 회피
 
 default : false
 */
@property(nonatomic, readonly)      BOOL                        avoidWaterProtection;           //  상수도 보호구역 회피, default : false

/**
 도심권 통행제한 회피 화물차 차종
 - 설정된 차종의 도심통행제한 구역 회피
 default : KNFreightCarType_NotFreight
 
 @see KNFreightCarType
 */
@property(nonatomic, readonly)      KNFreightCarType            avoidCityRestriction;           //  도심권 통행제한 회피 화물차 차종, default : KNFreightCarType_NotFreight

/**
 초기화
 
 @param aAvoidUTurn U턴 회피
 @param aAvoidLaneCnt 제한 왕복 차선수 회피
 @param aWaterProtection 상수도 보호구역 회피
 @param aAvoidCityRestriction 도심권 통행제한 회피
 @see KNFreightCarType
 */
- (id)initWithAvoidUTurn:(BOOL)aAvoidUTurn laneCnt:(SInt32)aAvoidLaneCnt waterProtection:(BOOL)aWaterProtection cityRestriction:(KNFreightCarType)aAvoidCityRestriction;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNRouteConfiguration
//  ====================================================================================================================
/**
 경로 설정 정보
 
 경로 산정에 영향을 가지는 요소들에 대한 설정 정보
 */
@interface KNRouteConfiguration : NSObject

/**
 차종
 
 default : KNCarType_1
 
 @see KNCarType
 */
@property(nonatomic, readonly)      KNCarType       carType;                //  차종, default : KNCarType_1

/**
 유종
 
 default : KNCarType_1
 
 @see KNCarType
 */
@property(nonatomic, readonly)      KNCarFuel       fuel;                   //  차종, default : KNCarType_1

/**
 용도
 
 default : KNCarUsage_Default
 
 @see KNCarUsage
 */
@property(nonatomic, readonly)      KNCarUsage      usage;                  //  용도, default : KNCarUsage_Default

/**
 하이패스 사용 여부
 
 default : N
 */
@property(nonatomic, readonly)      BOOL            useHipass;              //  하이패스 사용 여부, default : N, 하이패스 여부는 경로에 영향을 미치기 때문에 정확한 장착여부가 확인되어야 함

/**
 전폭(cm)
 
 default : -1
 -1값이 설정되는 경우, 경로산정에 영향을 미치지 않는다.
 */
@property(nonatomic, readonly)      SInt32          carWidth;               //  전폭, default : -1

/**
 전고(cm)
 
 default : -1
 -1값이 설정되는 경우, 경로산정에 영향을 미치지 않는다.
 */
@property(nonatomic, readonly)      SInt32          carHeight;              //  전고, default : -1

/**
 전장(cm)
 
 default : -1
 -1값이 설정되는 경우, 경로산정에 영향을 미치지 않는다.
 */
@property(nonatomic, readonly)      SInt32          carLength;              //  전장, default : -1

/**
 중량(0.1t)
 
 default : -1
 -1값이 설정되는 경우, 경로산정에 영향을 미치지 않는다.
 */
@property(nonatomic, readonly)      SInt32          carWeight;              //  중량, default : -1

/**
 화물차 회피 경로 정보
 
 default : nil
 
 @see KNRouteConfiguration_FreightOption
 */
@property(nonatomic, readonly)      KNRouteConfiguration_FreightOption      *freightOption;         //  화물차 회피 경로 정보, default : nil

/**
 기본설정값으로 초기화 한다.
 */
- (id)init;

/**
 차종을 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType;

/**
 차종, 유종을 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @param aFuel 유종
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel;

/**
 차종, 유종, 하이패스 사용여부를 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass;

/**
 차종, 유종, 하이패스 사용여부, 용도를 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @param aUsage 용도
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass usage:(KNCarUsage)aUsage;


/**
 차종, 유종, 하이패스 사용여부, 차량정보를 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @param aCarWidth 전폭(cm)
 @param aCarHeight 전고(cm)
 @param aCarLength 전장(cm)
 @param aCarWeight 중량(0.1t)
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass carWidth:(SInt32)aCarWidth carHeight:(SInt32)aCarHeight carLength:(SInt32)aCarLength carWeight:(SInt32)aCarWeight;


/**
 차종, 유종, 하이패스 사용여부, 차량정보 및 화물차 회피 경로 정보를 설정하여 초기화 한다.
 
 나머지 설정값은 기본값으로 설정된다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @param aCarWidth 전폭(cm)
 @param aCarHeight 전고(cm)
 @param aCarLength 전장(cm)
 @param aCarWeight 중량(0.1t)
 @param aFreightOption 화물차 회피 경로 정보(회피 없음 : nil)
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass carWidth:(SInt32)aCarWidth carHeight:(SInt32)aCarHeight carLength:(SInt32)aCarLength carWeight:(SInt32)aCarWeight freightOption:(KNRouteConfiguration_FreightOption * _Nullable)aFreightOption;


/**
 차종, 유종, 하이패스 사용여부, 차량정보 및 용도를 설정하여 초기화 한다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @param aUsage 용도
 @param aCarWidth 전폭(cm)
 @param aCarHeight 전고(cm)
 @param aCarLength 전장(cm)
 @param aCarWeight 중량(0.1t)
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass usage:(KNCarUsage)aUsage carWidth:(SInt32)aCarWidth carHeight:(SInt32)aCarHeight carLength:(SInt32)aCarLength carWeight:(SInt32)aCarWeight;


/**
 모든 정보를 설정하여 초기화 한다.
 
 @param aCarType 차종
 @param aFuel 유종
 @param aUseHipass 하이패스 사용 여부
 @param aUsage 용도
 @param aCarWidth 전폭(cm)
 @param aCarHeight 전고(cm)
 @param aCarLength 전장(cm)
 @param aCarWeight 중량(0.1t)
 @param aFreightOption 화물차 회피 경로 정보(회피 없음 : nil)
 @see KNCarType
 */
- (id)initWithCarType:(KNCarType)aCarType fuel:(KNCarFuel)aFuel useHipass:(BOOL)aUseHipass usage:(KNCarUsage)aUsage carWidth:(SInt32)aCarWidth carHeight:(SInt32)aCarHeight carLength:(SInt32)aCarLength carWeight:(SInt32)aCarWeight freightOption:(KNRouteConfiguration_FreightOption * _Nullable)aFreightOption;

@end
//  --------------------------------------------------------------------------------------------------------------------

NS_ASSUME_NONNULL_END
