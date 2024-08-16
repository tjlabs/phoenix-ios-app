//
//  KNNaviView.h
//  KNSDK
//
//  Created by rex.zar on 2020/08/26.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KNSDK/KNMenuView.h>
#import <KNSDK/KNNaviMapView.h>
#import <KNSDK/KNCurDirectionView.h>
#import <KNSDK/KNNextDirectionView.h>
#import <KNSDK/KNBottomView.h>
#import "KNNaviViewInfo.h"

@class KNNaviView;
@class KNGuidance;

#ifdef KN_NETWORKLINK_SAFETY_MERGE
@class KNNetworkLinkObj_Stream;
#endif
/**
 현재 상태 Delegate
*/

@protocol KNNaviView_StateDelegate <NSObject>

/** 내비 볼륨 변경시 호출 */

- (void)naviViewDidUpdateSndVolume:(float)aVolume;

/** 주<->야간 변경될시 호출*/
- (void)naviViewDidUpdateUseDarkMode:(BOOL)aDarkMode;

/** 카메라 모드 변경시 호출*/
- (void)naviViewDidUpdateMapCameraMode:(MapViewCameraMode)aMapViewCameraMode;


/** 추가된 커스텀 버튼의 이벤트 동작시 호출
 @param aId 커스텀 버튼 id
 @param aToggle 커스텀 버튼이 토글 버튼일 경우의 상태값
 */
- (void)naviViewDidMenuItemWithId:(int)aId toggle:(BOOL)aToggle;

/** ViewState 상태가 변경될때 호출*/
- (void)naviViewScreenState:(KNNaviViewState)aKNNaviViewState;

/** popUpView 상태가 변경될때 호출*/
- (void)naviViewPopupOpenCheck:(BOOL)aOpen;

/** bottom 도착시간<->소요시간 변경시 호출 yes: 도착시간 no : 소요시간*/
- (void)naviViewIsArrival:(BOOL)aIsArrival;

@end

/**
 현재 주행중인 내비뷰 상태 Delegate
*/
@protocol KNNaviView_GuideStateDelegate <NSObject>

/** 현재 내비뷰 길안내 뷰 닫기 호출시 */

- (void)naviViewGuideEnded:(KNNaviView * _Nonnull)aNaviView;

/** GuideState 상태가 변경될때 호출*/

- (void)naviViewGuideState:(KNGuideState)aGuideState;

@end


/**
 KNNaviView
 
 KNNaviView는 카카오내비 게이션의 UI View기능을 제공하고 있습니다.
 */
@interface KNNaviView : UIView

@property (nonatomic, readonly) BOOL                                    useDarkMode;            // 현재 다크모드 상태
@property (nonatomic, readonly) KNMenuView                              * _Nonnull menuView;    // 메뉴UI
@property (nonatomic, readonly) KNNaviMapView                           * _Nonnull mapView;     // 지도(맵) UI
@property (nonatomic, readonly) KNCurDirectionView                      * _Nonnull curDirView;  // 1차RG UI
@property (nonatomic, readonly) KNNextDirectionView                     * _Nonnull nextDirView; // 2차RG UI
@property (nonatomic, readonly) KNBottomView                            * _Nonnull bottomView;  // 하단 UI
@property (nonatomic, weak) id<KNNaviView_GuideStateDelegate>           _Nullable guideStateDelegate;  // 현재 주행중인 내비뷰 상태 Delegate
@property (nonatomic, weak) id<KNNaviView_StateDelegate>                _Nullable stateDelegate;       // 현재 상태 Delegate

/**
 naviView 생성
 @param aGuidance                        주행 Guidance
 @param aTrip                                 주행 경로
 @param aRouteOption                 경로우선 옵션
 @param aAvoidOption                 경로회피 옵션
*/
- (id _Nonnull)initWithGuidance:(KNGuidance * _Nonnull)aGuidance trip:(KNTrip * _Nullable)aTrip routeOption:(KNRoutePriority)aRouteOption avoidOption:(SInt32)aAvoidOption;

/**
 야간모드 On/Off
@param aMode 야간모드 On/Off : default : Off
*/
- (void)useDarkMode:(BOOL)aMode;

/**
 볼륨 설정
@param aVolume 볼륨설정 0~1.0f
*/
- (void)sndVolume:(float)aVolume;

/** 유종변경
 @param aFuelType 유종
 */
- (void)fuelType:(KNCarFuel)aFuelType;

/** 차종변경
 @param aCarType 차종
 */
- (void)carType:(KNCarType)aCarType;

/** naviView 뷰 랜더링 재개*/
- (void)resumeView;

/** naviView 뷰 랜더링 일시정지*/
- (void)pauseView;

/** naviView 뷰 해제*/
- (void)releaseView;

/** 현재 주행 중인 경로를 취소*/
- (void)guideCancel;

/** 안전운전->해당 경로로 주행시작
 @param aTrip 주행할 Trip
 */
- (void)guideNewDestinations:(KNTrip * _Nonnull)aTrip priority:(KNRoutePriority)aPriority avoidOptions:(SInt32)aAvoidOptions;


//각 Delegate에서 받은 정보를 UI로 정보를 전달시 UI업데이트 처리

//  KNGuidance_GuideStateDelegate
//  ===========================================================================================================================
/**
 안내 시작
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 */
- (void)guidanceGuideStarted:(KNGuidance * _Nonnull)aGuidance;

/**
 경로 변경 체킹. 교통변화로 인한 재탐색, 경로이탈 재탐색 및 사용자 재탐색 시 전달.
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 */
- (void)guidanceCheckingRouteChange:(KNGuidance * _Nonnull)aGuidance;

/**
 경로 이탈됨.
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 */
- (void)guidanceOutOfRoute:(KNGuidance * _Nonnull)aGuidance;

/**
 경로 변경되지 않음. 교통변화 감지 후 경로변화가 없거나 혹은, 교통상황이 변하여 새로운 경로를 요청하였으나 기존 경로와 동일한 경우.
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 */
- (void)guidanceRouteUnchanged:(KNGuidance * _Nonnull)aGuidance;

/**
 경로 에러 발생
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aError 주행가이던스에서 delegate에서 전달 받은 Error정보
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance routeUnchangedWithError:(KNError * _Nonnull)aError;

/**
 경로 변경시 전달. 여러개의 경로 존재 시 첫번째 경로가 주행경로, 이하 대안경로.
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 */
- (void)guidanceRouteChanged:(KNGuidance * _Nonnull)aGuidance;

/**
 안내 종료됨
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aIsShow 도착완료 팝업 노출 여부
 */
- (void)guidanceGuideEnded:(KNGuidance * _Nonnull)aGuidance isShowDriveResultDialog:(BOOL)aIsShow;

/**
 경로 변경됨
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aRoutes 주행가이던스에서 delegate에서 전달 받은 Routes
 @param aMultiRouteInfo 주행가이던스에서 delegate에서 전달 받은 MultiRouteInfo
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateRoutes:(NSArray<KNRoute *> *)aRoutes multiRouteInfo:(KNMultiRouteInfo * _Nullable)aMultiRouteInfo;
//  ---------------------------------------------------------------------------------------------------------------------------


//  KNGuidance_LocationGuideDelegate
//  ===========================================================================================================================
/**
 위치정보 업데이트
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aLocationGuide 주행가이던스에서 delegate에서 전달 받은 LocationGuide
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateLocation:(KNGuide_Location * _Nonnull)aLocationGuide;
//  ---------------------------------------------------------------------------------------------------------------------------

//  KNGuidance_RouteGuideDelegate
//  ===========================================================================================================================
/**
 경로안내 정보 변경시 전달, 상세 항목 중 1개이상 변경 발생시.
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aRouteGuide 주행가이던스에서 delegate에서 전달 받은 RouteGuide
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateRouteGuide:(KNGuide_Route * _Nonnull)aRouteGuide;
//  ---------------------------------------------------------------------------------------------------------------------------

//  KNGuidance_SafetyGuideDelegate
//  ===========================================================================================================================
/**
 안전운행 정보 변경시, 상세 항목 중 1개이상 변경 발생시
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aSafetyGuide 주행가이던스에서 delegate에서 전달 받은 SafetyGuide
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateSafetyGuide:(KNGuide_Safety * _Nonnull)aSafetyGuide;

/**
 주변의 safey 데이터
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aSafeties 주행가이던스에서 delegate에서 전달 받은 Safeties
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateAroundSafeties:(NSArray<__kindof KNSafety *> * _Nullable)aSafeties;
//  ---------------------------------------------------------------------------------------------------------------------------

//  KNGuidance_VoiceGuideDelegate
//  ===========================================================================================================================
/**
 음성안내 표출 여부 : NO 리턴시 음성은 플레이되지 않는다
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance
 @param aVoiceGuide 주행가이던스에서 delegate에서 전달 받은 VoiceGuide
 @param aNewData 변경할 음성, 설정 시 해당 음성으로 변경되어 표출된다.
 */
- (BOOL)guidance:(KNGuidance * _Nonnull)aGuidance shouldPlayVoiceGuide:(KNGuide_Voice *)aVoiceGuide replaceSndData:(NSData **)aNewData;

/**
 음성안내 플레이 시작
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance를 UI업데이트 하기 위해 전달
 @param aVoiceGuide 주행가이던스에서 delegate에서 전달 받은 VoiceGuide를 UI업데이트 하기 위해 전달
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance willPlayVoiceGuide:(KNGuide_Voice * _Nonnull)aVoiceGuide;

/**
 음성안내 플레이 종료
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance를 UI업데이트 하기 위해 전달
 @param aVoiceGuide 주행가이던스에서 delegate에서 전달 받은 VoiceGuide를 UI업데이트 하기 위해 전달
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didFinishPlayVoiceGuide:(KNGuide_Voice * _Nonnull)aVoiceGuide;
//  ---------------------------------------------------------------------------------------------------------------------------

//  KNGuidance_CitsGuideDelegate
//  ===========================================================================================================================
/**
 CITS 정보 변경시
 @param aGuidance 주행가이던스에서 delegate에서 전달 받은 Guidance를 UI업데이트 하기 위해 전달
 @param aCitsGuide 주행가이던스에서 delegate에서 전달 받은 CitsGuide를 UI업데이트 하기 위해 전달
 */
- (void)guidance:(KNGuidance * _Nonnull)aGuidance didUpdateCitsGuide:(KNGuide_Cits * _Nonnull)aCitsGuide;
//  ---------------------------------------------------------------------------------------------------------------------------
#ifdef KN_NETWORKLINK_SAFETY_MERGE
- (void)guidance:(KNGuidance * _Nonnull)aGuidance mainStream:(KNNetworkLinkObj_Stream * _Nonnull)aMainStream;
#endif
@end
