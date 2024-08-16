//
//  KNHighwayInfo.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 8..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 고속도로 정보 지점 종별
 */
typedef NS_ENUM(SInt32, KNHighwayRGType)
{
    /** IC */
    KNHighwayRGType_IC          = 0,
    /** JC */
    KNHighwayRGType_JC          = 1,
    /** 요금소 */
    KNHighwayRGType_TG          = 2,
    /** 휴게소 */
    KNHighwayRGType_SA          = 3,
    /** 졸음쉼터 */
    KNHighwayRGType_RA          = 4
};


//  KNHighwayRG
//  ====================================================================================================================
/**
 고속도로 정보 지점 루트 클래스
 */
@interface KNHighwayRG : NSObject

/**
 경로상 위치 정보
 
 @see KNLocation
 */
@property (nonatomic, readonly) KNLocation          *location;          //  위치 정보 (차선정보 시작 위치)

/**
 지점 명
 */
@property (nonatomic, readonly) NSString            * _Nullable nodeName;          //  지점 명칭

/**
 고속도로 정보 지점 종별
 
 @return 고속도로 정보 지점 종별
 @see KNHighwayRGType
 */
- (KNHighwayRGType)highwayRgType;        // 서브클래스에서 오버라이드

/**
 동일한 고속도로 정보인지 여부
 
 객체가 아닌 정보로 비교
 @return 동일여부
 */
- (BOOL)isSameToHighwayRG:(KNHighwayRG *)aHighwayRG;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayRG_IC
//  ====================================================================================================================
/**
 고속도로 정보 지점(IC))
 */
@interface KNHighwayRG_IC : KNHighwayRG
@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayRG_JC
//  ====================================================================================================================
/**
 고속도로 정보 지점(JC))
 */
@interface KNHighwayRG_JC : KNHighwayRG
@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayRG_TG
//  ====================================================================================================================
/**
 고속도로 정보 지점(요금소))
 */
@interface KNHighwayRG_TG : KNHighwayRG

/**
 통행료(원)
 */
@property (nonatomic, readonly) SInt32              tollFare;               // 통행료

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayRG_SA
//  ====================================================================================================================
/**
 고속도로 정보 지점(휴게소))
 */
@interface KNHighwayRG_SA : KNHighwayRG

/**
 주유소 정보
 
 - 0: 없음
 - 1: SK
 - 2: GS
 - 3: OilBank
 - 4: S-Oil
 - 6: 기타무폴
 - 7: 알뜰
 */
@property (nonatomic, readonly) SInt8                       gasBrand;       //  0: 없음, 1: SK, 2: GS, 3: OilBank, 4: S-Oil, 6: 기타무폴, 7: 알뜰

/**
 LPG 충전소 정보
 
 - 0: 없음
 - 1: SK
 - 2: GS
 - 3: OilBank
 - 4: S-Oil
 - 5: E1
 - 6: 기타무폴
 - 7: 알뜰
*/
@property (nonatomic, readonly) SInt8                       lpgBrand;       //  0: 없음, 1: SK, 2: GS, 3: OilBank, 4: S-Oil, 5: E1, 6: 기타무폴, 7: 알뜰

/**
 경정비 존재 여부
 */
@property (nonatomic, readonly) BOOL                        repairExist;

/**
 ATM 존재 여부
 */
@property (nonatomic, readonly) BOOL                        atmExist;

/**
 푸드 서비스 존재 여부
 */
@property (nonatomic, readonly) BOOL                        foodExist;

/**
 전기충전소 존재 여부
 */
@property (nonatomic, readonly) BOOL                        elecChargerExist;

/**
 화물차 휴게소 존재 여부
 */
@property (nonatomic, readonly) BOOL                        freightCarRestExist;

/**
 주유소 POI ID 리스트
 */
@property (nonatomic, readonly) NSArray<NSString *>         *gasStIds;

/**
 가스충전소 POI ID 리스트
 */
@property (nonatomic, readonly) NSArray<NSString *>         *lpgStIds;

/**
 수소충전소 POI ID 리스트
 */
@property (nonatomic, readonly) NSArray<NSString *>         *hydrogenStIds;

/**
 전기충전소 POI ID 리스트
 */
@property (nonatomic, readonly) NSArray<NSString *>         *elecChargerStIds;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayRG_RA
//  ====================================================================================================================
/**
 고속도로 정보 지점(졸음쉼터))
 */
@interface KNHighwayRG_RA : KNHighwayRG
/**
 화장실 존재 여부
 */
@property (nonatomic, readonly) BOOL                        restRoomExist;

@end
//  --------------------------------------------------------------------------------------------------------------------


//  KNHighwayInfo
//  ====================================================================================================================
/**
 고속도로 정보
 
 인접 지점 리스트, 인접 휴게소 리스트 및 최기 분기점 정보
 */
@interface KNHighwayInfo : NSObject

/**
 가장 가까운 고속도로 지점 정보
 
 현재 기준 3개
 
 @see KNHighwayRG
 @see KNHighwayRG_IC
 @see KNHighwayRG_JC
 @see KNHighwayRG_TG
 @see KNHighwayRG_SA
 */
@property (nonatomic, readonly) NSArray<__kindof KNHighwayRG *> *nearRgs;       //  가까운 고속도로 RG, 현재 3개.

/**
 가장 가까운 휴게소 정보
 
 현재 기준 2개
 
 @see KNHighwayRG_SA
 */
@property (nonatomic, readonly) NSArray<KNHighwayRG_SA *>       *nearSas;       //  가장 가까운 휴게소, 현재 2개

/**
 가장 가까운 분기점 정보
 
 @see KNHighwayRG_JC
 */
@property (nonatomic, readonly) KNHighwayRG_JC                  *nearestJc;     //  가장 가까운 분기점

@end
//  --------------------------------------------------------------------------------------------------------------------

NS_ASSUME_NONNULL_END
