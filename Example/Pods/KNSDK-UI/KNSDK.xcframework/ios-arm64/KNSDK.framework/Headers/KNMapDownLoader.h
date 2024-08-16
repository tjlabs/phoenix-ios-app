//
//  KNMapDownLoader.h
//  KNSDK
//
//  Created by hyeon.k on 2020/06/30.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@class KNMapDownLoader;

/** 다운로드 관련 상태 전달 */
@protocol MapDownloadDelegate <NSObject>

/** 현재 다운로드 받은 % */
- (void)downLoader:(KNMapDownLoader *)aMapDownLoader progress:(float)aProgress;

/** 다운로드 Error메시지 */
- (void)downLoader:(KNMapDownLoader *)aMapDownLoader error:(KNError *)aError;

/** 다운로드 완료 */
- (void)downLoader:(KNMapDownLoader *)aMapDownLoader onFinish:(NSInteger)aFinalFileSize;

@end

@interface KNMapDownLoader : NSObject 

@property (nonatomic, weak) id<MapDownloadDelegate>           mapDownLoadDelegate;

/** 다운로드 시작 */
- (void)downLoadStart;

/** 다운로드 일시정지 */
- (void)downLoadPause;

/** 다운로드 정지 */
- (void)downLoadCancel;

/** 다운받은 전체 지도 유무 */
- (BOOL)isDownloadedFullMap;

- (void)inBackground:(BOOL)aBackground;

/** 다운받은 전체 지도 버전 및 최신지도버전
 첫번째 값 : 전체다운로드 한 지도 버전 -1일 경우 다운로드 한 지도가 없음
 두번째 값 : 최신 지도 버전
 */

- (NSArray *)localDataWithUpdateVersion;
@end

NS_ASSUME_NONNULL_END
