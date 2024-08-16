//
//  KNSwitch.h
//  KNSDK
//
//  Created by hyeon.k on 2023/02/16.
//  Copyright © 2023 hyeon.k. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KNSwitch : UIView

- (id)initWithOn:(BOOL)aOn;
- (void)setOn:(BOOL)aOn;
- (void)setToggleOnImage:(UIImage * _Nullable)aImageOn imageOff:(UIImage * _Nullable)aImageOff colorOn:(UIColor * _Nullable)aColorOn colorOff:(UIColor * _Nullable)colorOff;
- (void)setBarOnImage:(UIImage * _Nullable)aImageOn imageOff:(UIImage * _Nullable)aImageOff colorOn:(UIColor * _Nullable)aColorOn colorOff:(UIColor * _Nullable)colorOff;
@end

NS_ASSUME_NONNULL_END
