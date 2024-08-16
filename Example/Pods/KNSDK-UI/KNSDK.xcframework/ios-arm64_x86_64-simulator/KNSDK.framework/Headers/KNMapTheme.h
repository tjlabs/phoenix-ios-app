//
//  KNMapTheme.h
//  KNSDK
//
//  Created by luke.9p9 on 2021/10/25.
//  Copyright © 2021 hyeon.k. All rights reserved.
//

#ifndef KNMapTheme_h
#define KNMapTheme_h
/**
 지도의 테마를 설정합니다. 지도의 배경 색상, 도로, 보행로, 건물, 텍스트와 아이콘 크기 등 사용자의 목적에 따라 부각되는 요소들을 설정할 수 있습니다.
 
 @see KNMapView.mapTheme
 */
@interface KNMapTheme: NSObject

/**
 주간 주행 테마로 밝은 색상의 지도에 주행에 필요한 요소들이 부각되어 표시됩니다.
 
 @return KNMapTheme
 */
+(KNMapTheme* _Nonnull) driveDay;

/**
 야간 주행 테마로 어두운 색상의 지도에 주행에 필요한 요소들이 부각되어 표시됩니다.
 
 @return KNMapTheme
 */
+(KNMapTheme* _Nonnull) driveNight;

/**
 주간 지도 검색 테마로 밝은 색상의 지도에 관심 지점(POI), 건물, 이정표 등 지도 검색 시 확인할 수 있는 요소들이 부각되어 표시됩니다.
 
 @return KNMapTheme
 */
+(KNMapTheme* _Nonnull) searchDay;

/**
 야간 지도 검색 테마로 어두운 색상의 지도에 관심 지점(POI), 건물, 이정표 등 지도 검색 시 확인할 수 있는 요소들이 부각되어 표시됩니다.
 
 @return KNMapTheme
 */
+(KNMapTheme* _Nonnull) searchNight;

@end

#endif /* KNMapTheme_h */
