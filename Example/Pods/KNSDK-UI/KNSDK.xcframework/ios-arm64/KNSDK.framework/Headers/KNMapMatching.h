//
//  KNMapMatching.h
//  KakaoNaviSDK
//
//  Created by Rex.xar on 2015. 10. 22..
//  Copyright © 2015년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNGPSData_Protected.h"

//  매칭 관련
#define KNMapMatching_MatchingRadiusTrust                   13          //  매칭 반경 : KNMapMatching_TrustScore 를 확보할 수 있는 최대 거리
#define KNMapMatching_MatchingRadiusDoubtful                23          //  매칭 반경 : KNMapMatching_DoubtfulScore 를 확보할 수 있는 최대 거리
#define KNMapMatching_MatchingRadiusCutline                 38          //  매칭 반경 : KNMapMatching_CutlineScore 를 확보할 수 있는 최대 거리
#define KNMapMatching_MatchingRadiusMax                     500         //  매칭 반경 : 최대 매칭 거리
#define KNMapMatching_MatchingRadiusInitLimit               2000        //  매칭 반경 : 초기매칭 최대 거리
#define KNMapMatching_AngleGapTrust                         52          //  매칭 방위각 : KNMapMatching_TrustScore 를 확보할 수 있는 최대 방위각 차
#define KNMapMatching_AngleGapDoubtful                      93          //  매칭 방위각 : KNMapMatching_DoubtfulScore 를 확보할 수 있는 최대 방위각 차
#define KNMapMatching_AngleGapCutline                       155         //  매칭 방위각 : KNMapMatching_CutlineScore 를 확보할 수 있는 최대 방위각 차
#define KNMapMatching_AngleGapMax                           180         //  매칭 방위각 : 최대 매칭 방위각 차

//  매칭 대상 선정 관련
#define KNMapMatching_MatchingDist                          1000        //  기본 매칭 거리
#define KNMapMatching_DrivingSpeedLimit                     200         //  최대 주행 속도
#define KNMapMatching_KmPerHToMPerSecFactor                 0.28        //  1km/h 로 1초간 이동거리(m)

//  후보 스코어링 관련
#define KNMapMatching_PenaltyRatio                          10          //  패널티 배율 : 방위각 차이 및 이격 차이 1당 패널티 배율
#define KNMapMatching_AngleGapPenaltyWeight                 1           //  방위각 패널티 가중치
#define KNMapMatching_ApproachGapPenaltyWeight              4           //  이격 패널티 가중치
#define KNMapMatching_BaseScore                             1000000     //  기본 점수
#define KNMapMatching_TrustScore                            998074      //  정확한 매칭 점수 : KNMapMatching_BaseScore - 1926 (방위각패널티(값 15) + 거리패널티(값 12))
#define KNMapMatching_DoubtfulScore                         994629      //  부정확한 매칭 점수 : KNMapMatching_BaseScore - 5371 (방위각패널티(값 25) + 거리패널티(값 22))
#define KNMapMatching_CutlineScore                          986274      //  컷라인 매칭 점수 : KNMapMatching_BaseScore - 13726 (방위각패널티(값 40) + 거리패널티(값 37))
#define KNMapMatching_DifferenceScoreRatio                  0.3         //  현격한 차이 : 패널티의 30%

//  이탈 관련
#define KNMapMatching_OutOfRoutePreventDist                 37          //  이탈 방지 거리
#define KNMapMatching_OutOfRouteDist                        40          //  이탈 거리(기본)
#define KNMapMatching_OutOfRouteAngleGap                    160         //  이탈 방지 방위각
#define KNMapMatching_OutOfRouteDistInTunnel                150         //  이탈 거리(터널)
#define KNMapMatching_OutOfRouteDistNearTG                  150         //  이탈 거리(톨게이트)
#define KNMapMatching_OutOfRouteAngle                       30          //  이탈 각도(기본)
#define KNMapMatching_OutOfRouteAngleInTunnel               45          //  이탈 각도(터널)
#define KNMapMatching_OutOfRouteAngleNearTG                 45          //  이탈 각도(톨게이트)

#define KNMapMatching_TunnelExtendDist                      50          //  터널 확장 거리(터널링크의 앞뒤로 OO거리만큼 터널로 간주한다.)
#define KNMapMatching_NearTGJudgeDist                       50          //  TG인근 판단 거리 : TG직전링크 시작점의 OOm 이후, TG직후링크의 끝점의 OOm 이내

#define KNMapMatching_DoubtfulMatchingCnt                   5           //  카운트 : 의심스러운 매칭을 확정시키기 위한 카운트조건
#define KNMapMatching_DoubtfulMatchingDist                  50          //  거리 : 의심스러운 매칭을 확정시키기 위한 거리조건

//  초기매칭 재탐색 관련
#define KNMapMatching_InitMatchingRetryDist                 100         //  초기매칭에서 후보없이 이탈된 경우의 재탐색 거리 주기
#define KNMapMatching_InitMatchingRetryTime                 10          //  초기매칭에서 후보없이 이탈된 경우의 재탐색 시간 주기

//  시뮬레이션 관련
#define KNMapMatching_NonTunnelSimulCnt                     2           //  터널이 아닌곳에서의 시뮬레이션 횟수

//  코스 분석기 관련
#define KNMapMatching_CourseAnalyzeRadius                   70          //  코스 분석 반경


/*
 패널티 배율에 따른 값과 패널티
 값      패널티
 10     155
 20     410
 30     765
 40     1220
 50     1775
 60     2430
 70     3185
 80     4040
 1000   510500
 */

typedef NS_ENUM(NSInteger, KNMapMatchingSt)
{
    KNMapMatchingSt_Init                = 0,    //  초기매칭 전
    KNMapMatchingSt_Trusted             = 1,    //  정확한 매칭
    KNMapMatchingSt_Doubtful            = 2,    //  부정확한 매칭
    KNMapMatchingSt_Simulated           = 3,    //  가상 매칭
    KNMapMatchingSt_UnMatched           = 4,    //  매칭되지 않음
    KNMapMatchingSt_OutOfRoute          = 5,    //  경로이탈
    KNMapMatchingSt_Arrived             = 6     //  도착
};

@class KNRoute;

#ifdef KN_MAPMATCHING_TEST
@class KNCourseAnalyzer;    //  for test
#endif

@interface KNMapMatchingResult : NSObject

@property (nonatomic, readonly) KNMapMatchingSt     matchingSt;
@property (nonatomic, readonly) KNGPSData           *gpsOrigin;
@property (nonatomic, readonly) KNGPSData           *gpsMatched;
@property (nonatomic, readonly) SInt32              polyIdx;
@property (nonatomic, readonly) SInt32              linkIdx;
@property (nonatomic, readonly) SInt32              rgIdx;
@property (nonatomic, readonly) SInt32              distFromS;
@property (nonatomic, readonly) SInt32              approachGap;
@property (nonatomic, readonly) SInt32              distGap;

@end


@interface KNMapMatching : NSObject

@property (nonatomic, readonly) KNRoute                         *route;
@property (nonatomic, readonly) NSArray<KNMapMatchingResult *>  *matchingResults;
@property (nonatomic, readonly) KNMapMatchingResult             *lastMatchingResult;

#ifdef KN_MAPMATCHING_TEST
@property (nonatomic, readonly) KNCourseAnalyzer        *originAnalyzer;    //  for test
@property (nonatomic, readonly) KNCourseAnalyzer        *matchedAnalyzer;   //  for test
@property (nonatomic, readonly) SInt32                  matchingRadius;    //  for test
#endif

- (id)initWithRoute:(KNRoute *)aRoute;
- (id)initWithRoute:(KNRoute *)aRoute matchingResults:(NSArray<KNMapMatchingResult *> *)aMatchingResults;
- (KNMapMatchingResult *)matchToLink:(KNGPSData *)aGpsData;
- (KNMapMatchingResult *)matchToLink:(KNGPSData *)aGpsData changed:(BOOL * _Nullable)aChanged;
- (KNMapMatchingResult *)simulateWithSpeed:(SInt32)aSpeed;

@end
