//
//  Header.h
//  KNSDK_JAYG
//
//  Created by jayg.025 on 2020/02/03.
//  Copyright © 2020 jayg.025. All rights reserved.
//
#import "KNMapOverlayObject.h"
typedef NS_ENUM(int, KNCustomObjectRenderType)
{
    /** 화면에 정렬 */
    KNCustomObjectRenderType_ScreenAlign = 0,
    /** 바닥에 눞힘 */
    KNCustomObjectRenderType_LayOnGround,
    /** 화면에 하지만 회전됨 */
    KNCustomObjectRenderType_ScreenWithCamera,
};

@interface KNMapCustomObject: KNMapOverlayObject
/** 렌더링 방식 */
@property (nonatomic, readwrite, assign) KNCustomObjectRenderType renderType;
/** 화면 오프셋(dp) */
@property (nonatomic, readwrite, assign) vector_float2 screenOffset;
/** 이미지 기준점(0.0 ~ 1.0) 좌->우 아래 -> 위 */
@property (nonatomic, readwrite, assign) vector_float2 anchor;
/** Grouping시 기준 사이즈 */
@property (nonatomic, readwrite, assign) vector_float2 hitBox;
/** 화면 표출 사이즈(dp) */
@property (nonatomic, readonly) vector_float2 renderSize;
/** Object의 회전 각도(Degree) */
@property (nonatomic, readwrite, assign) float angle;
/** Object의 배율 */
@property (nonatomic, readwrite, assign) float objScale;
/** Object의 위치(KATEC좌표) */
@property (nonatomic, readwrite, assign) vector_float2 position;

+ (KNMapCustomObject* _Nullable)customObjectWithID:(NSInteger)aID
                                      imageCacheID:(NSString*_Nonnull)aImageCacheID
                                            image:(UIImage*_Nonnull)aImage
                                         position:(vector_int2)aPosition;

+ (KNMapCustomObject* _Nullable)customObjectWithImageCacheID:(NSString*_Nonnull)aImageCacheID
                                                      image:(UIImage*_Nonnull)aImage
                                                   position:(vector_int2)aPosition;

+ (KNMapCustomObject* _Nullable)customObjectWithID:(NSInteger)aID
                                     imageCacheID:(NSString*_Nonnull)aImageCacheID
                                             view:(UIView*_Nonnull)aView
                                         position:(vector_int2)aPosition;

+ (KNMapCustomObject* _Nullable)customObjectWithImageCacheID:(NSString*_Nonnull)aImageCacheID
                                                       view:(UIView*_Nonnull)aView
                                                   position:(vector_int2)aPosition;

-(void)animateObjectWithPos:(vector_float2)aPosition
                      scale:(float)aScale
                      angle:(float)aAngle
              animationTime:(float)aAnimationTime
                 complition:(void (^_Nullable)(KNMapCustomObject* _Nonnull))aComplition;

- (BOOL)setImage:(UIImage* _Nonnull)aImage
    imageCacheID:(NSString*_Nonnull)aImageCacheID;

- (BOOL)setView:(UIView* _Nonnull)aView
   imageCacheID:(NSString*_Nonnull)aImageCacheID;

@end
