//
//  KNSoundContainer.h
//  KNSDK
//
//  Created by rex.zar on 11/06/2020.
//  Copyright © 2020 hyeon.k. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 음성 데이터 성별
 
 본 성별타입에 맞추어 방면음성(다운로드 데이터)이 적용된다.
 */
typedef NS_ENUM(NSInteger, KNVoiceGenderType)
{
    /** 여성음성 */
    KNVoiceGenderType_Woman,
    /** 남성음성 */
    KNVoiceGenderType_Man
};


/**
 음성 언어 타입
 
 본 언어타입에 맞추어 음성이 조합된다.
 */
typedef NS_ENUM(NSInteger, KNVoiceLangType)
{
    /** 한국어*/
    KNVoiceLangType_Korean,
    /** 영어*/
    KNVoiceLangType_English
};

/**
 음성안내 컨테이너
 
 카카오내비 음성안내 파일 규격을 따르는 데이터로 음성안내 셋을 구성한다.
 
 파일규격은 별도 문서 참고
 */
@interface KNSoundContainer : NSObject

/**
 음성 데이터 성별
 
 @see KNVoiceGenderType
 */
@property (nonatomic, readonly) KNVoiceGenderType   genderType;

/**
 음성 언어 타입
 
 @see KNVoiceLangType
 */
@property (nonatomic, readonly) KNVoiceLangType     langType;

/**
 음성 컨테이너를 생성한다.
 
 @param aData 카카오내비 음성안내 파일 규격을 따르는 데이터
 @param aGenderType 음성 데이터 성별
 @param aLangType 음성 언어 타입
 */
- (id)initWithData:(NSData *)aData genderType:(KNVoiceGenderType)aGenderType langType:(KNVoiceLangType)aLangType;

@end

NS_ASSUME_NONNULL_END
