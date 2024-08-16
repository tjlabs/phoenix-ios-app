//
//  KNLocation.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 8..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNLocation.h"

NS_ASSUME_NONNULL_BEGIN

/**
 경로상 위치정보를 포함하는 클래스
 
 특성 상 경로에 종속되는 정보이기에, 서로 다른 경로로부터 파생된 KNLocation간의 위치 연산은 부정확할 수 있다.
 */
@interface KNLocation : NSObject
/**
 위치(KATEC)
 */
@property (nonatomic, readonly) DoublePoint         pos;                //  위치

/**
 도로명
 */
@property (nonatomic, readonly) NSString            * _Nullable roadName;          //  도로명

/**
 도로 종별
 
 고속도로(도시고속도로 포함), 일반도로, 페리항로
 
 @see KNRoadType
 */
@property (nonatomic, readonly) KNRoadType          roadType;           //  도로 종별 (고속도로(도시고속도로 포함), 일반도로, 페리항로)

/**
 시설물 종별

 도로, 교량, 터널, 고가차도, 지하차도
 
 @see KNFacilityType
 */
@property (nonatomic, readonly) KNFacilityType      facilityType;       //  시설물 종별 (도로, 교량, 터널, 고가차도, 지하차도)


@property (nonatomic, readonly) KNLocationType      locationType; 

/**
 교통정보 상태
 
 교통정보 없음, 정체, 지체, 서행, 원활, 통행 불가
 
 @see KNTrafficState
 */
@property (nonatomic, readonly) KNTrafficState      trafficSt;          //  교통정보 상태

/**
 교통정보 속도(Km/h)
 */
@property (nonatomic, readonly) SInt32              trafficSpd;         //  교통정보 속도

/**
 경로상 위치간 거리(m)
 
 경로가 없는 경우 직선거리
 
 @param aLocation 목표 위치
 @return 거리(m)
 */
- (SInt32)distToLocation:(KNLocation *)aLocation;                     //  경로상 거리(m), 경로가 없는 경우 직선거리

/**
 경로상 위치간 시간(초)
 
 @return 시간(초)
 */
- (SInt32)timeToLocation:(KNLocation *)aLocation;                     //  경로상 시간(초), 경로가 없는 경우 -1

/**
 경로상 위치간 요금(원)
 
 @param aLocation 목표 위치
 @return 요금(원)
 */
- (SInt32)costToLocation:(KNLocation *)aLocation;                     //  경로상 요금(원) : 두 지점 간 요금 합계, 경로가 없는 경우 -1

/**
 경로상 위치간 요금(원)
 
 @param aDist 거리
 @return 경로상 위치
 */
- (KNLocation *)locationAfterDist:(SInt32)aDist;                    //  경로상 위치

/**
 경로상 위치간 교통정보 상태 및 평균속도
 
 두 지점간 교통정보 상태 및 속도의 평균값을 조합하여 전달한다.
 
 @param aLocation 목표 위치
 @return 경로상 교통 상황 및 평균속도 : 평균속도 * 10 + 교통정보상태
 
 ex)고속도로에서 평속이 100km/h 인경우 1004 리턴
 */
- (SInt32)avrSpeedAndTrafStToLocation:(KNLocation *)aLocation;        //  경로상 교통 상황 및 평균속도 : 평균속도 * 10 + 교통상태, ex)고속도로에서 평속이 100km/h 인경우 1004 리턴

/**
 경로상 위치의 동일여부 판단
 
 @param aLocation 비교 대상 위치
 @return 동일 여부
 */
- (BOOL)isSameToLocation:(KNLocation *)aLocation;

@end

NS_ASSUME_NONNULL_END
