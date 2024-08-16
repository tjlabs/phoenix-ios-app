//
//  KNMenuView.h
//  KNSDK
//
//  Created by hyeon.k on 2021/02/17.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import "KNComponentView.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KNCustomMenuType)
{
    /// 전체경로
    MENU_FULL_ROUTE,
    /// 다른경로
    MENU_ANOTHER_ROUTE,
    /// 경로 취소
    MENU_CANCEL_ROUTE,
    /// 경유지 취소
    MENU_CANCEL_VIA,
    /// 커스텀
    MENU_CUSTOM
};

typedef NS_ENUM(NSInteger, KNCustomMenuStyle)
{
    /// Item 터치
    MENU_BUTTON_TOUCH,
    /// Item 토글
    MENU_BUTTON_TOGGLE,
};

@class KNMenuView;


@interface KNCustomBottomMenuItem : UIView

/// 메뉴 버튼 Item
/// @param aId  item Id
/// @param aName  item 이름
/// @param aIcon  item 주간 이미지
/// @param aNightIcon  item 야간 이미지
/// @param aStyle  item 스타일
/// @param aToggleOn item 스타일 toggle 형태일 경우 생성때 값
/// @see KNCustomMenuStyle
- (id)initWithId:(int)aId name:(NSString * _Nullable)aName icon:(UIImage * _Nullable)aIcon nightIcon:(UIImage * _Nullable)aNightIcon style:(KNCustomMenuStyle)aStyle toggleOn:(BOOL)aToggleOn;

@end

@interface KNMenuView : KNComponentView

/// 현재 볼륨
@property (nonatomic, readwrite) float     curVolume;

/// 경로 취소 버튼 활성화
- (void)useGuideCancel:(BOOL)aCancel;

/// 메뉴 버튼 추가
/// @param aCustomMenu  Custom 메뉴 버튼 추가 리스트
/// @see KNCustomBottomMenuItem
- (void)setCustomMenu:(NSArray<KNCustomBottomMenuItem *> *)aCustomMenu;
@end

NS_ASSUME_NONNULL_END
