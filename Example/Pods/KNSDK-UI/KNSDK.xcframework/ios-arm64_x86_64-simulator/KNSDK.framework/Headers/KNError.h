//
//  KNError.h
//  KNSDK
//
//  Created by Rex.xar on 2018. 6. 12..
//  Copyright © 2018년 kakao. All rights reserved.
//

#import <Foundation/Foundation.h>

//  C에러 : 클라이언트 에러
#define KNError_Code_C000       @"C000"
#define KNError_Msg_C000        @"Unknown Error"

#define KNError_Code_C020       @"C020"
#define KNError_Msg_C020        @"Network Request Failed"

#define KNError_Code_C100       @"C100"
#define KNError_Msg_C100        @"경로데이터가 없습니다."

//  C100번대 에러 : 인증관련
#define KNError_Code_C101       @"C101"
#define KNError_Msg_C101        @"API Key Missed"

#define KNError_Code_C102       @"C102"
#define KNError_Msg_C102        @"User Key Missed"

#define KNError_Code_C103       @"C103"
#define KNError_Msg_C103        @"SDK Certification Failed"

#define KNError_Code_C104       @"C104"
#define KNError_Msg_C104        @"SDK Configuration initialize Failed"

#define KNError_Code_C105       @"C105"
#define KNError_Msg_C105        @"SDK GPS initialize Failed"

#define KNError_Code_C106       @"C106"
#define KNError_Msg_C106        @"SDK Map initialize Failed"

#define KNError_Code_C108       @"C108"
#define KNError_Msg_C108        @"SDK Route initialize Failed"

#define KNError_Code_C109       @"C109"
#define KNError_Msg_C109        @"SDK Guide initialize Failed"

#define KNError_Code_C110       @"C110"
#define KNError_Msg_C110        @"SDK Full Map initialize Failed"

#define KNError_Code_C111       @"C111"
#define KNError_Msg_C111        @"SDK On Initializing"

#define KNError_Code_C112       @"C112"
#define KNError_Msg_C112        @"Failed to remove local map data"

#define KNError_Code_C113       @"C113"
#define KNError_Msg_C113        @"SDK ParkingLot initialize Failed"

#define KNError_Code_C114       @"C114"
#define KNError_Msg_C114        @"SDK Meta-Info initialize Failed"

#define KNError_Code_C115       @"C115"
#define KNError_Msg_C115        @"SDK Style-Info initialize Failed"

//  C200번대 에러 : 다운로드 관련
#define KNError_Code_C200       @"C200"
#define KNError_Msg_C200        @"File not Found"

#define KNError_Code_C201       @"C201"
#define KNError_Msg_C201        @"File not Found on Redirection position"

#define KNError_Code_C202       @"C202"
#define KNError_Msg_C202        @"MD5 Checking Failed"


//  게이트웨이 에러
#define KNError_Code_G400       @"G400"
#define KNError_Msg_G400        @"잘못된 요청입니다."

#define KNError_Code_G401       @"G401"
#define KNError_Msg_G401        @"인증에 실패하였습니다."

#define KNError_Code_G404       @"G404"
#define KNError_Msg_G404        @"파일이 존재하지 않습니다."

#define KNError_Code_G500       @"G500"
#define KNError_Msg_G500        @"서버오류 입니다."

#define KNError_Code_G502       @"G502"
#define KNError_Msg_G502        @"서버오류(Bad Gateway) 입니다."

#define KNError_Code_G503       @"G503"
#define KNError_Msg_G503        @"서버오류(Service Unavailable) 입니다."

#define KNError_Code_G504       @"G504"
#define KNError_Msg_G504        @"서버오류(Gateway Timeout) 입니다."


//  경로 에러
#define KNError_Code_R106       @"R106"
#define KNError_Msg_R106        KNLocalizedString(@"목적지 근처에 적합한 도로 데이터가 없습니다.", nil)

#define KNError_Code_R123       @"R123"
#define KNError_Msg_R123        KNLocalizedString(@"경유지 근처에 적합한 도로 데이터가 없습니다.", nil)

#define KNError_Code_R124       @"R124"
#define KNError_Msg_R124        KNLocalizedString(@"출발지 근처에 적합한 도로 데이터가 없습니다.", nil)

#define KNError_Code_R125       @"R125"
#define KNError_Msg_R125        KNLocalizedString(@"목적지 근처에 적합한 도로 데이터가 없습니다.", nil)

#define KNError_Code_R126       @"R126"
#define KNError_Msg_R126        KNLocalizedString(@"자동차전용 경로만 존재합니다.", nil)

#define KNError_Code_R127       @"R127"
#define KNError_Msg_R127        KNLocalizedString(@"무료로 갈 수 있는 경로가 없습니다.", nil)

#define KNError_Code_R128       @"R128"
#define KNError_Msg_R128        KNLocalizedString(@"무료로 갈 수 있는 경로가 없습니다.", nil)

#define KNError_Code_R129       @"R129"
#define KNError_Msg_R129        KNLocalizedString(@"자동차전용 경로만 존재합니다.", nil)

#define KNError_Code_R240       @"R240"
#define KNError_Msg_R240        KNLocalizedString(@"출발지와 목적지가 너무 가까워서 길안내를 시작할 수 없습니다.", nil)

#define KNError_Code_R402       @"R402"
#define KNError_Msg_R402        KNLocalizedString(@"출발지 주변의 유고 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_R404       @"R404"
#define KNError_Msg_R404        KNLocalizedString(@"목적지 주변의 유고 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_D720       @"D720"
#define KNError_Msg_D720        KNLocalizedString(@"사용자의 유효한 경로 없음", nil)

#define KNError_Code_D722       @"D722"
#define KNError_Msg_D722        KNLocalizedString(@"사용자 경로와 서버의 네트워크데이터 버전 상이", nil)

#define KNError_Code_S999       @"S999"

#define KNError_Code_20410      @"20410"
#define KNError_Msg_20410       KNLocalizedString(@"출발지 주변에 안내가능한 도로가 없습니다.", nil)

#define KNError_Code_20411      @"20411"
#define KNError_Msg_20411       KNLocalizedString(@"목적지 주변에 안내 가능한 도로가 없습니다.", nil)

#define KNError_Code_20412      @"20412"
#define KNError_Msg_20412       KNLocalizedString(@"경유지 주변에 안내 가능한 도로가 없습니다.", nil)

#define KNError_Code_20413      @"20413"
#define KNError_Msg_20413       KNLocalizedString(@"자동차 전용 제외 경로가 존재하지 않습니다.", nil)

#define KNError_Code_20414      @"20414"
#define KNError_Msg_20414       KNLocalizedString(@"무료 도로 경로가 존재하지 않습니다.", nil)

#define KNError_Code_20415      @"20415"
#define KNError_Msg_20415       KNLocalizedString(@"페리 제외 경로가 존재하지 않습니다.", nil)

#define KNError_Code_20010      @"20010"
#define KNError_Msg_20010       KNLocalizedString(@"현재 위치와 목적지의 위치가 너무 가까워 경로 탐색이 불가능합니다.", nil)

#define KNError_Code_20011      @"20011"
#define KNError_Msg_20011       KNLocalizedString(@"출발지 주변의 유고 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20012      @"20012"
#define KNError_Msg_20012       KNLocalizedString(@"목적지 주변의 유고 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20013      @"20013"
#define KNError_Msg_20013       KNLocalizedString(@"경유지 주변의 유고 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20014      @"20014"
#define KNError_Msg_20014       KNLocalizedString(@"출발지 주변의 화물차 제한 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20015      @"20015"
#define KNError_Msg_20015       KNLocalizedString(@"도착지 주변의 화물차 제한 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20016      @"20016"
#define KNError_Msg_20016       KNLocalizedString(@"경유지 주변의 화물차 제한 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20017      @"20017"
#define KNError_Msg_20017       KNLocalizedString(@"출발지 주변의 상수원보호구역 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20018      @"20018"
#define KNError_Msg_20018       KNLocalizedString(@"도착지 주변의 상수원보호구역 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20019      @"20019"
#define KNError_Msg_20019       KNLocalizedString(@"경유지 주변의 상수원보호구역 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20020      @"20020"
#define KNError_Msg_20020       KNLocalizedString(@"출발지 주변의 도심권통행제한 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20021      @"20021"
#define KNError_Msg_20021       KNLocalizedString(@"도착지 주변의 도심권통행제한 정보로 인해 경로 제공이 불가능합니다.", nil)

#define KNError_Code_20022      @"20022"
#define KNError_Msg_20022       KNLocalizedString(@"경유지 주변의 도심권통행제한 정보로 인해 경로 제공이 불가능합니다.", nil)



/**
 KNSDK에서 발생하는 에러
 
 에러 코드에 대한 상세 내용은 KNError.h 파일 참조
 */
@interface KNError : NSObject

/**
 에러코드
 */
@property (nonatomic, readonly) NSString            *code;

/**
 에러메세지
 */
@property (nonatomic, readonly) NSString            * _Nullable msg;

/**
 표출용메세지
 */
@property (nonatomic, readonly) NSString            * _Nullable tagMsg;

/**
 부가정보
 */
@property (nonatomic, readonly) __kindof NSObject   * _Nullable extra;

+ (KNError *)error;
+ (KNError *)errorWithCode:(NSString *)aCode msg:(NSString *)aMsg;
+ (KNError *)errorWithCode:(NSString *)aCode msg:(NSString *)aMsg extra:(__kindof NSObject *)aExtra;
+ (KNError *)errorWithCode:(NSString *)aCode msg:(NSString *)aMsg tagMsg:(NSString *)aTagMsg extra:(__kindof NSObject *)aExtra;
//+ (KNError *)errorWithServerCode:(NSString *)aCode;

@end
