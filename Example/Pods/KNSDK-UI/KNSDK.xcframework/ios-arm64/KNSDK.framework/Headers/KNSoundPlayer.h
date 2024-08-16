//
//  KNSoundPlayer.h
//  KNSDK
//
//  Created by rex.zar on 11/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@class KNSoundPlayer;

/**
 사운드 플레이어 Delegate
 
 음성 사운드 플레이 발생시 호출된다.
 */

@protocol KNSoundPlayerDelegate

/**
 사운드 플레이 직전 호출
 
 @param aSoundPlayer 사운드플레이
 */

- (void)soundPlayerWillPlaySounds:(KNSoundPlayer *)aSoundPlayer;

/**
 사운드 플레이 종료후 호출
 
 @param aSoundPlayer 사운드플레이
 */
- (void)soundPlayerDidFinishPlaySounds:(KNSoundPlayer *)aSoundPlayer;

@end

@interface KNSoundPlayer : NSObject

@property (nonatomic, readonly) BOOL paused;
@property (nonatomic, weak) id<KNSoundPlayerDelegate>   _Nullable delegate;

+ (nullable KNSoundPlayer *)sharedInstance;

- (void)stopAllSound;
- (void)pause;
- (void)resume;

- (void)play:(AVAudioPlayer * _Nonnull)aPlayer sync:(BOOL)aSync startCompletion:(AVAudioPlayer* (^ _Nullable)(void))aStartCompletion finishCompletion:(void (^ _Nullable)(void))aFinishCompletion;

@end

NS_ASSUME_NONNULL_END
