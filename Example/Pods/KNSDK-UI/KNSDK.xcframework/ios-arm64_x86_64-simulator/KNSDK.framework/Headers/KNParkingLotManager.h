//
//  KNParkingLotManager.h
//  KNSDK
//
//  Created by luke.9p9 on 2022/09/19.
//  Copyright © 2022 hyeon.k. All rights reserved.
//

#ifndef KNParkingLotManger_h
#define KNParkingLotManger_h

#import <Foundation/Foundation.h>

@class KNParkingLot, KNParkingLotMetaData;

/**
 주차장을 관리하고 정보를 전달합니다. KNMapParkingLotManager는 KNSDK를 통해 획득되어야 하고 1개만 존재합니다.
 */
@interface KNParkingLotManager : NSObject

/**
 주차장 메타 데이터입니다. 주차장의 이름과 고유 ID들을 조회합니다.
 
 @see KNParkingLotMetaData
 */
@property (nonatomic, readonly) NSArray<KNParkingLotMetaData*>* _Nonnull metaDatas;

/**
 주차장 정보를 요청하고 완료되면 결과 상태를 전달받습니다.
 
 @param aParkingLotId 주차장 ID입니다.
 @param aCompletion 리퀘스트 완료 후 결과상태 전달합니다.
 @arg aParkingLot  주차장 정보입니다.
 
 @see KNParkingLot
 */
- (void)requestParkingLotWithParkingLotId:(int)aParkingLotId completion:(void (^_Nonnull)(KNParkingLot*_Nullable aParkingLot))aCompletion;

/**
 주차층에 대한 주차면 점유 상태를 요청합니다. 요청이 완료되면 결과 상태를 전달받습니다.
 
 @param aParkingLotId 주차장 ID입니다.
 @param aFloorName 주차장 층 이름입니다.
 @param aCompletion 리퀘스트 완료 후 결과상태 전달받습니다.
 @arg aAreaAvailable  주차 가능 상태입니다. 딕셔너리의 키는 주차장 면 ID이고 값은 (1: 주차 가능, 0: 주차 불가능)입니다.
 @arg aExpriedDate 주차장 상태 갱신 만료 날짜입니다. 이 이후로 주차장 면의 상태 변화를 보장 할 수 없으므로 requestParkingLotFloorAreaStates를 다시 호출해서 상태를 갱신해야 합니다.
 
 @see KNParkingLotFloor
 @see KNParkingLot
 */
- (void)requestParkingLotFloorAreaStates:(int)aParkingLotId floorName:(NSString*_Nonnull)aFloorName completion:(void (^_Nonnull)(NSDictionary<NSString *, NSNumber *>* _Nullable aAreaAvailable, NSDate* _Nullable aExpriedDate))aCompletion;

/**
 주차층들에 대한 주차면 점유 상태를 요청합니다. 요청이 완료되면 결과 상태를 전달받습니다.
 
 @param aParkingLotId 주차장 ID입니다.
 @param aFloorNames 주차장 층 이름의 리스트입니다.
 @param aCompletion 리퀘스트 완료 후 결과상태 전달받습니다.
 @arg aFloorsAreaAvailable 주차층들에 대한 주차 가능 상태입니다. 첫 번째 딕션너리의 키는 주차층 이름이고 두 번째 딕셔너리의 키는 주차장 면 ID이고 값은 (1: 주차 가능, 0: 주차 불가능)입니다.
 @arg aExpriedDate 주차장 상태 갱신 만료 날짜입니다. 이 이후로 주차장 면의 상태 변화를 보장 할 수 없으므로 requestParkingLotFloorsAreaStates를 다시 호출해서 상태를 갱신해야 합니다.
 
 @see KNParkingLotFloor
 @see KNParkingLot
 */
- (void)requestParkingLotFloorsAreaStates:(int)aParkingLotId floorNames:(NSArray<NSString *>*_Nonnull)aFloorNames completion:(void (^_Nonnull)(NSDictionary<NSString *, NSDictionary<NSString *, NSNumber *>*>* _Nullable aFloorsAreaAvailable, NSDate* _Nullable aExpriedDate))aCompletion;
@end
#endif /* KNParkingLotManger_h */
