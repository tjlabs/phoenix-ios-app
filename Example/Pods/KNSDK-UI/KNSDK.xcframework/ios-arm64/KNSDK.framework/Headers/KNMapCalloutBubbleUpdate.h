//
//  KNMapCalloutBubbleUpdate.h
//  KNSDK
//
//  Created by luke.9p9 on 2022/01/20.
//  Copyright © 2022 hyeon.k. All rights reserved.
//

#ifndef KNMapCalloutBubbleUpdate_h
#define KNMapCalloutBubbleUpdate_h

/**
 마커에서 사용하는 말풍선을 설정합니다.
 해당 클래스를 사용하여 말풍선에 표시될 주 텍스트, 보조 텍스트, 폰트, 폰트 컬러를 설정할 수 있습니다.
 
 @see KNMapMarker
 */
@interface KNMapCalloutBubbleUpdate : NSObject

/**
 KNMapCalloutBubbleUpdate 객체를 생성합니다.
 title을 입력해야 말풍선이 표출됩니다.
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)calloutBubbleUpdate;

/**
 말풍선에 표출될 주된 타이틀을 설정합니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setTitle:(NSString* _Nonnull)aTitle;

/**
 말풍선에 표출될 보조 타이틀을 설정합니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitle:(NSString* _Nonnull)aSubTitle;

/**
 주된 타이틀의 폰트를 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setTitle
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setTitleFont:(UIFont* _Nonnull)aFont;

/**
 보조 타이틀의 폰트를 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setSubTitle
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitleFont:(UIFont* _Nonnull)aFont;

/**
 주된 타이틀의 폰트 색상을 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setTitle
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setTitleFontColor:(UIColor* _Nonnull)aFontColor;

/**
 보조 타이틀의 폰트 색상을 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setSubTitle
 @see KNMapMarker.updateCalloutBubble
 */
+(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitleFontColor:(UIColor* _Nonnull)aFontColor;

/**
 말풍선에 표출될 주된 타이틀을 설정합니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setTitle:(NSString* _Nonnull)aTitle;

/**
 말풍선에 표출될 보조 타이틀을 설정합니다.
 
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitle:(NSString* _Nonnull)aSubTitle;

/**
 주된 타이틀의 폰트를 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setTitle
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setTitleFont:(UIFont* _Nonnull)aFont;

/**
 보조 타이틀의 폰트를 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setSubTitle
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitleFont:(UIFont* _Nonnull)aFont;

/**
 주된 타이틀의 폰트 색상을 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setTitle
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setTitleFontColor:(UIColor* _Nonnull)aFontColor;

/**
 보조 타이틀의 폰트 색상을 설정합니다.
 
 @see KNMapCalloutBubbleUpdate.setSubTitle
 @see KNMapMarker.updateCalloutBubble
 */
-(KNMapCalloutBubbleUpdate* _Nonnull)setSubTitleFontColor:(UIColor* _Nonnull)aFontColor;

@end

#endif /* KNMapCalloutBubbleUpdate_h */
