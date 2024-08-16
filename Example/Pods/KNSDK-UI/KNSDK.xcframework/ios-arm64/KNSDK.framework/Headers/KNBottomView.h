//
//  KNBottomView.h
//  KNSDK
//
//  Created by rex.zar on 2021/02/09.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#import "KNComponentView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KNBottomView : KNComponentView

/** 하단 시간 정보 변경 도착시간<->소요시간  default : Yes (도착시간)*/
@property (nonatomic, assign) BOOL isArrival;

@end

NS_ASSUME_NONNULL_END
