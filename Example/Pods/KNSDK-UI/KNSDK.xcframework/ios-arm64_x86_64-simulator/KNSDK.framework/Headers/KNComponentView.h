//
//  KNComponentView.h
//  KNSample
//
//  Created by rex.zar on 2020/10/05.
//  Copyright © 2020 kakaomobility. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <KNSDK/KNSDK.h>

NS_ASSUME_NONNULL_BEGIN


typedef NS_ENUM(NSUInteger, KNNaviMode)
{
    KNNaviMode_Drive        = 0,         // 주행
    KNNaviMode_Safety,                   // 안전운행
};


@interface KNComponentView : UIView

@property (nonatomic, strong)     KNLocation      *curLocation;
@property (nonatomic, readonly)   BOOL            isPortrait;
@property (nonatomic, readonly)   BOOL            notchModel;
@property (nonatomic, readonly)   CGFloat         topPadding;
@property (nonatomic, readonly)   CGFloat         leftPadding;
@property (nonatomic, readonly)   CGFloat         rightPadding;
@property (nonatomic, readonly)   CGFloat         bottomPadding;

@property (nonatomic, assign)     BOOL            isNight;

@property (nonatomic, assign)   KNNaviMode        naviMode;

- (id)initWithTitle:(NSString *)aTitle;
- (void)setText:(NSString *)aText;
- (void)show:(BOOL)aOnOff;
- (void)setNight:(BOOL)aNight;
- (void)hideTimerForAfterAWhile:(float)aInterval;
- (void)hideTimerStop;
- (UIWindow *)getWindows;
@end

NS_ASSUME_NONNULL_END
