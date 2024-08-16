//
//  KNNextDirectionView.h
//  KNSample
//
//  Created by rex.zar on 2020/10/14.
//  Copyright © 2020 kakaomobility. All rights reserved.
//

#import "KNComponentView.h"
#import "KNDirection.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNNextDirectionView : KNComponentView

/// 2차RG 배경 색상
/// @param aDayColor 주간 색상
/// @param aNightColor 야간 색상
- (void)setBackgroundColor:(UIColor * _Nonnull)aDayColor nightColor:(UIColor * _Nonnull)aNightColor;

@end

NS_ASSUME_NONNULL_END
