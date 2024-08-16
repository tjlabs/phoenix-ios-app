//
//  KNGuidance.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 5. 24..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KNTrip.h"
#import "KNLocation.h"
#import "KNGuide_Location.h"
#import "KNGuide_Route.h"
#import "KNGuide_Safety.h"
#import "KNGuide_Voice.h"
#import "KNGuide_Cits.h"
#import "KNSoundContainer.h"

NS_ASSUME_NONNULL_BEGIN

@class KNGuidance;

@class KNNetworkLinkObj_Stream, KNNetworkLinkObj_Safety;

/**
 가이던스 상태
 */
typedef NS_ENUM(SInt32, KNGuideState)
{
    /** 초기 상태 */
    KNGuideState_Init               = 0,    //  초기상태
    /** 경로 안내중 */
    KNGuideState_OnRouteGuide,              //  경로 안내중
    /** 안전운행 안내중 */
    KNGuideState_OnSafetyGuide              //  안전운행 안내중
};

/**
 교차로 이미지 종별
 */
typedef NS_ENUM(SInt32, KNGuideImgType)
{
    /** 주간 큰 이미지 (앱용) */
    KNGuideImgType_DayLarge,                //  주간 큰 이미지(앱용)
    /** 주간 작은 이미지(카플레이용) */
    KNGuideImgType_DaySmall,                //  주간 작은 이미지(카플레이용)
    /** 야간 큰 이미지(앱용) */
    KNGuideImgType_NightLarge,              //  야간 큰 이미지(앱용)
    /** 야간 작은 이미지(카플레이용) */
    KNGuideImgType_NightSmall               //  야간 작은 이미지(카플레이용)
};

/**
 경로 변경 사유
 */
typedef NS_ENUM(SInt32, KNGuideRouteChangeReason)
{
    /** 유효 GPS 수신으로 인한 재탐색*/
    KNGuideRouteChangeReason_ValidGpsReceive            = 0,        //  유효 GPS 수신으로 인한 재탐색
    /** 경로 이탈 */
    KNGuideRouteChangeReason_OutOfRoute                 = 1,        //  경로 이탈
    /** 교통정보 변경 */
    KNGuideRouteChangeReason_DynamicChanged             = 2,        //  자동 재탐색
    /** 사용자 재탐색 */
    KNGuideRouteChangeReason_UserReroute                = 3,        //  사용자 재탐색
    /** 대안경로 선택 */
    KNGuideRouteChangeReason_SecondaryRouteSelected     = 4,        //  대안경로 선택
    /** 경유지 추가 */
    KNGuideRouteChangeReason_ViaAdded                   = 5,        //  경유지 추가
    /** 경유지 삭제 */
    KNGuideRouteChangeReason_ViaDeleted                 = 6,        //  경유지 삭제
    /** 경로 이어하기 시작 */
    KNGuideRouteChangeReason_GuideContinued             = 7         //  경로 이어하기 시작
};

/**
 가인던스 상태 Delegate
 
 주행 중 안내상태의 변경시 호출된다.
 
 모든 콜백은 메인스레드로 전달된다.
 */
@protocol KNGuidance_GuideStateDelegate

/**
 안내 시작
 
 안내가 시작되면 호출된다.
 
 카카오내비 기준 "안내를 시작" 멘트 발생 시점
 
 @param aGuidance 가이던스
 */
- (void)guidanceGuideStarted:(KNGuidance *)aGuidance;                                                                                                   //  안내 시작됨

/**
 경로 변경 체킹
 
 경로 변경 체킹을 위한 서버요청시 호출된다.
 
 카카오내비 기준 "교통변화 감지" 멘트 발생 시점
 
 @param aGuidance 가이던스
*/
- (void)guidanceCheckingRouteChange:(KNGuidance *)aGuidance;                                                                                            //  경로 변경 체킹. 교통변화로 인한 재탐색, 경로이탈 재탐색 및 사용자 재탐색 시 전달.

/**
 경로 이탈
 
 경로 이탈 후 새로운 경로 요청시 호출된다.
 
 카카오내비 기준 "경로 이탈 재탐색" 멘트 발생 시점
 
 @param aGuidance 가이던스
 */
- (void)guidanceOutOfRoute:(KNGuidance *)aGuidance;                                                                                                     //  경로 이탈됨.

/**
 경로 변경되지 않음
 
 경로 수신 후 경로가 변경되지 않았을 경우 호출된다.
 
 카카오내비 기준 "기존 경로로 안내" 멘트 발생 시점
 
 @param aGuidance 가이던스
 */
- (void)guidanceRouteUnchanged:(KNGuidance *)aGuidance;                                                                                                 //  경로 변경되지 않음. 교통변화 감지 후 경로변화가 없거나 혹은, 교통상황이 변하여 새로운 경로를 요청하였으나 기존 경로와 동일한 경우.

/**
 오류 발생
 
 경로 오류 발생시 호출.
 
 맵매칭이 유효한 경우 기존 경로 유지, 경로 이탈인경우 수동재탐색 시행 전까지 재이탈 되지 않음.
 
 @param aGuidance 가이던스
 @param aError 오류
 */
- (void)guidance:(KNGuidance *)aGuidance routeUnchangedWithError:(KNError *)aError;

/**
 경로 변경 됨.
 
 경로 수신 후 경로가 변경되었을 경우 호출된다.
 
 카카오내비 기준 "경로변경, 새로운 경로로 길안내" 멘트 발생 시점
 
 @param aGuidance 가이던스
 @param aFromRoute 기존 경로(주경로)
 @param aFromLocation 기존 위치(주경로)
 @param aToRoute 변경 경로(주경로)
 @param aToLocation 변경 위치(주경로)
 @param aChangeReason 경로변경 사유
 @see KNRoute
 @see KNLocation
 @see KNGuideRouteChangeReason
 */
- (void)guidanceRouteChanged:(KNGuidance *)aGuidance fromRoute:(KNRoute *)aFromRoute fromLocation:(KNLocation *)aFromLocation toRoute:(KNRoute *)aToRoute toLocation:(KNLocation *)aToLocation reason:(KNGuideRouteChangeReason)aChangeReason;  //  경로 변경시 전달.

/**
 안내 종료
 
 경로 안내 종료 시 호출된다.
 
 카카오내비 기준 "목적지 도착, 안내 종료" 멘트 발생 시점
 
 @param aGuidance 가이던스
 */
- (void)guidanceGuideEnded:(KNGuidance *)aGuidance;                                                                                                     //  안내 종료됨

/**
 경로 변경됨
 
 주행 중 여러 이유로 경로가 변경되었을 때 호출된다. guidanceRouteUnchanged, guidanceRouteChanged 와는 별개로 동작한다. 동일한 경로이더라도 물리적은 경로 데이터가 변경되었을 경우 호출될 수 있다.
 
 KNMap을 연동하는 경우, 본 콜백이 발생하면, KNMap에 경로 데이터를 변경해주어야 한다.
 
 @param aGuidance 가이던스
 @param aRoutes 경로 리스트, 최대 2개의 경로가 전달될 수 있다. 순서대로 주경로 및 대안경로, 대안경로는 없을 수 있다.
 @param aMultiRouteInfo 대안경로 존재 시, 대안경로 정보
 @see KNRoute
 @see KNMultiRouteInfo
 */
- (void)guidance:(KNGuidance *)aGuidance didUpdateRoutes:(NSArray<KNRoute *> *)aRoutes multiRouteInfo:(KNMultiRouteInfo * _Nullable)aMultiRouteInfo;                                                                                                     //  안내 종료됨

@end

/**
 위치 안내 Delegate
 
 위치정보 변경시 호출된다. 현재 기준, 매 GPS 수신시 호출된다.
 
 모든 콜백은 메인스레드로 전달된다.
*/
@protocol KNGuidance_LocationGuideDelegate

/**
 위치정보 업데이트
 
 위치정보가 업데이트 될 경우 호출된다.
 
 @param aGuidance 가이던스
 @param aLocationGuide 위치 안내 정보
 @see KNGuide_Location
 */
- (void)guidance:(KNGuidance *)aGuidance didUpdateLocation:(KNGuide_Location *)aLocationGuide;      //  경로안내 정보 변경시 전달, 상세 항목 중 1개이상 변경 발생시에 전달.

@end

/**
 경로안내 Delegate
 
 경로안내 정보 변경시 호출된다.
 
 모든 콜백은 메인스레드로 전달된다.
*/
@protocol KNGuidance_RouteGuideDelegate

/**
 경로안내 정보 업데이트
 
 aRouteGuide 포함 항목 중 1개이상 변경 발생시에 전달된다.
 
 aRouteGuide 의 세부 항목 중 변경이 없는 항목은 이전과 동일한 객체로 전달된다.
 
 @param aGuidance 가이던스
 @param aRouteGuide 경로안내 정보
 @see KNGuide_Route
*/
- (void)guidance:(KNGuidance *)aGuidance didUpdateRouteGuide:(KNGuide_Route *)aRouteGuide;          //  경로안내 정보 변경시 전달, 상세 항목 중 1개이상 변경 발생시에 전달.

@end

/**
 안전운행 Delegate
 
 안전운행 정보 변경시 호출된다.
 
 모든 콜백은 메인스레드로 전달된다.
*/
@protocol KNGuidance_SafetyGuideDelegate

/**
 안전운행 정보 업데이트
 
 aSafetyGuide 포함 항목 중 1개이상 변경 발생시에 전달된다.
 
 aSafetyGuide 의 세부 항목 중 변경이 없는 항목은 이전과 동일한 객체로 전달된다.
 
 @param aGuidance 가이던스
 @param aSafetyGuide 안전운행 정보
 @see KNGuide_Safety
*/
- (void)guidance:(KNGuidance *)aGuidance didUpdateSafetyGuide:(KNGuide_Safety *)aSafetyGuide;                   //  안전운행 정보 변경시 전달, 상세 항목 중 1개이상 변경 발생시에 전달.

/**
 주변의 안전운행 정보 업데이트
 
 주변에 존재하는 안전운행 정보를 전달한다.
 
 @param aGuidance 가이던스
 @param aSafeties 주변의 안전운행 정보
 @see KNGuide_Safety
 */
- (void)guidance:(KNGuidance *)aGuidance didUpdateAroundSafeties:(NSArray<__kindof KNSafety *> * _Nullable)aSafeties;     //  주변의 safey 데이터 전달.

@end

/**
 음성안내 Delegate
 
 음성안내 표출 및 종료와 관련한 정보 요청 및 전달
 
 모든 콜백은 메인스레드로 전달된다.
*/
@protocol KNGuidance_VoiceGuideDelegate

/**
 음성안내 표출 여부
 
 NO 리턴시 음성은 플레이되지 않는다
 
 @param aGuidance 가이던스
 @param aVoiceGuide 안내음성 정보
 @param aNewData 변경할 음성, 설정 시 해당 음성으로 변경되어 표출된다.
 @see KNGuide_Voice
*/
- (BOOL)guidance:(KNGuidance *)aGuidance shouldPlayVoiceGuide:(KNGuide_Voice *)aVoiceGuide replaceSndData:(NSData **)aNewData;  //  음성안내 표출 여부 : NO 리턴시 음성은 플레이되지 않는다

/**
 음성안내 플레이 시작
 
 @param aGuidance 가이던스
 @param aVoiceGuide 안내음성 정보
 @see KNGuide_Voice
*/
- (void)guidance:(KNGuidance *)aGuidance willPlayVoiceGuide:(KNGuide_Voice *)aVoiceGuide;           //  음성안내 플레이 시작

/**
 음성안내 플레이 종료
 
 @param aGuidance 가이던스
 @param aVoiceGuide 안내음성 정보
 @see KNGuide_Voice
*/
- (void)guidance:(KNGuidance *)aGuidance didFinishPlayVoiceGuide:(KNGuide_Voice *)aVoiceGuide;      //  음성안내 플레이 종료

@end

/**
 CITS Delegate
 
 CITS 정보 변경시 호출된다.
 
 모든 콜백은 메인스레드로 전달된다.
*/
@protocol KNGuidance_CitsGuideDelegate

/**
 CITS 정보 업데이트
 
 aCitsGuide 포함 항목 중 1개이상 변경 발생시에 전달된다.
 
 aCitsGuide 의 세부 항목 중 변경이 없는 항목은 이전과 동일한 객체로 전달된다.
 
 @param aGuidance 가이던스
 @param aCitsGuide CITS 정보
 @see KNCitsData
*/
- (void)guidance:(KNGuidance *)aGuidance didUpdateCitsGuide:(KNGuide_Cits *)aCitsGuide;                   //  CITS 정보 변경시 전달, 상세 항목 중 1개이상 변경 발생시에 전달.

@end

/**
        For Network Link Test
*/
#ifdef KN_NETWORKLINK_SAFETY_MERGE
@protocol KNGuidance_NetworkLinkDelegate
// test 용 델리게이트 함수, 본선을 지도에 그릴때 사용한다.
- (void)guidance:(KNGuidance *)aGuidance mainStream:(KNNetworkLinkObj_Stream *)aMainStream;

@end
#endif


/**
 가이던스
 
 길안내를 관리하고 정보를 전달한다. 현재 기준, 가이던스는 1개만 존재한다.
 
 가이던스는 KNSDK를 통해 획득하여야 한다.
 
        KNSDK.sharedInstance.sharedGuidance
*/
@interface KNGuidance : NSObject

/**
 가인던스 상태 Delegate
 
 @see KNGuidance_GuideStateDelegate
 */
@property (nonatomic, weak) id<KNGuidance_GuideStateDelegate>            _Nullable guideStateDelegate;

/**
 위치 안내 Delegate
 
 @see KNGuidance_LocationGuideDelegate
 */
@property (nonatomic, weak) id<KNGuidance_LocationGuideDelegate>         _Nullable locationGuideDelegate;

/**
 경로안내 Delegate
 
 @see KNGuidance_RouteGuideDelegate
 */
@property (nonatomic, weak) id<KNGuidance_RouteGuideDelegate>            _Nullable routeGuideDelegate;

/**
 안전운행 Delegate
 
 @see KNGuidance_VoiceGuideDelegate
 */
@property (nonatomic, weak) id<KNGuidance_SafetyGuideDelegate>           _Nullable safetyGuideDelegate;

/**
 음성안내 Delegate
 
 @see KNGuidance_VoiceGuideDelegate
 */
@property (nonatomic, weak) id<KNGuidance_VoiceGuideDelegate>            _Nullable voiceGuideDelegate;

/**
 CITS Delegate
 
 @see KNGuidance_CitsGuideDelegate
 */
@property (nonatomic, weak) id<KNGuidance_CitsGuideDelegate>            _Nullable citsGuideDelegate;

/**
 NetworkMainStream Delegate
 */
#ifdef KN_NETWORKLINK_SAFETY_MERGE
@property (nonatomic, weak) id<KNGuidance_NetworkLinkDelegate>            _Nullable networkLinkDelegate;
#endif
/**
 안내중인 Trip
 
 안전운행 시 미존재
 */
@property (nonatomic, readonly) KNTrip                  * _Nullable trip;              //  현재 주행 경로

/**
 최근 위치안내 정보
 
 locationGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 @see KNGuide_Location
 */
@property (nonatomic, readonly) KNGuide_Location        * _Nullable locationGuide;     //  현재 위치 가이드 locationGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.

/**
 최근 경로안내 정보
 
 routeGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNGuide_Route
 */
@property (nonatomic, readonly) KNGuide_Route           * _Nullable routeGuide;        //  현재 안내 가이드 routeGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.

/**
 최근 안전운행 정보
 
 safetyGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNGuide_Safety
 */
@property (nonatomic, readonly) KNGuide_Safety          * _Nullable safetyGuide;       //  현재 안전운행 가이드 safetyGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.

/**
 최근 CITS 정보
 
 citsGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNGuide_Cits
 */
@property (nonatomic, readonly) KNGuide_Cits            * _Nullable citsGuide;          //  현재 CITS 가이드 citsGuideDelegate가 설정되어있지 않으면 갱신되지 않는다.

/**
 현재 주행 경로
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNRoute
 */
@property (nonatomic, readonly) NSArray<KNRoute *>      * _Nullable routesOnGuide;     //  현재 주행 경로

/**
 최근 주변 안전운행 정보
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNSafety
 */
@property (nonatomic, readonly) NSArray<KNSafety *>     * _Nullable aroundSafeties;     //  현재 주변 안전운행 정보

/**
 다중경로 정보
 
 UI 갱신등으로 마지막 정보가 필요시 사용
 
 @see KNSafety
 */
@property (nonatomic, readonly) KNMultiRouteInfo        * _Nullable multiRouteInfo;     //  다중경로 정보

/**
 안내 상태
 
 @see KNGuideState
 */
@property (nonatomic, readonly) KNGuideState            guideState;         //  안내 상태

/**
 방면음성 안내 여부
 
 default : YES
 */
@property (nonatomic, assign)   BOOL                    useDirSound;        //  방면음성 안내 여부, default : YES

/**
 자동 재탐색 여부
 
 default : YES
 */
@property (nonatomic, assign)   BOOL                    useAutoReroute;     //  자동 재탐색 여부, default : YES

/**
 백그라운드 업데이트 여부
 
 default : YES
 */
@property (nonatomic, assign)   BOOL                    useBackgroundUpdate;     //  자동 재탐색 여부, default : YES

/**
 안내 이미지 타입(복잡교차로 등)
 
 default : KNGuideImgType_DayLarge
 
 @see KNGuideImgType
 */
@property (nonatomic, assign)   KNGuideImgType          guideImgType;       //  안내 이미지 타입(복잡교차로 등), default : KNGuideImgType_DayLarge

/**
 안전운행 제외 코드(안전운행 코드)
 
 default : nil
 
 등록된 코드는 안전운행 및 음성 모두 안내에서 제외된다.
 
 @see KNSafetyCode
 */
@property (nonatomic, strong)   NSSet<NSNumber *>       *excludedSafeties;  //  안전운행 제외 코드(안전운행 코드), default : nil

/**
 음성 컨테이너
 
 default : 기본음성
 
 카카오내비용 음성데이터 포멧을 따르는 음성데이터를 설정하여 안내음성셋을 변경할 수 있다.
 @see KNSoundContainer
 */
@property (nonatomic, strong)   KNSoundContainer        * _Nullable sndContainer;      //  음성 컨테이너, default : 기본음성

/**
 Trip과 경로우선순위 및 경로회피옵션을 설정하여 길안내를 시작한다.
 
 @param aTrip 주행에 사용할 Trip
 @param aPriority 주행 시작 경로우선순위
 @param aAvoidOptions 주행 시작 경로회피옵션
 @see KNTrip
 @see KNRouteOption
 */
- (void)startWithTrip:(KNTrip * _Nullable)aTrip priority:(KNRoutePriority)aPriority avoidOptions:(SInt32)aAvoidOptions;

/**
 안전운행 모드로 안내를 시작한다.
 */
- (void)startWithoutTrip;

/**
 안내를 종료한다.
 
 안내중인 음성이 있다면, 즉시 중지된다.
 
 cancelRoute와 달리 안전운행으로 전환되지 않으며, GPS모니터링을 해제한다.
 
 @see cancelRoute
 */
- (void)stop;

/**
 재탐색
 */
- (void)reRoute;

/**
 경로우선순위 및 경로회피옵션으로 재탐색
 
 @param aPriority 재탐색 할 경로우선순위
 @param aAvoidOptions 재탐색 할 경로회피옵션
 */
- (void)reRouteWithPriority:(KNRoutePriority)aPriority avoidOptions:(SInt32)aAvoidOptions;

/**
 대안경로로 변경
 
 주행중인 주경로를 대안경로로 변경한다.
 
 대안경로가 존재하지 않을시 무시된다.
 */
- (void)changeRoute;                                                        //  대안경로로 변경


/**
 경로 취소(안전운행으로 전환)
 
 길안내를 종료하고 안전운행으로 전환한다.
 
 @see stop
 */
- (void)cancelRoute;                                                        //  경로 취소(안전운행으로 전환)

@end

NS_ASSUME_NONNULL_END
