//
//  KNMapParkingLot.h
//  KNSDK
//
//  Created by jayg.025 on 2022/07/22.
//  Copyright © 2022 hyeon.k. All rights reserved.
//

#ifndef KNMapParkingLot_h
#define KNMapParkingLot_h

/**
 주차장 이름과 고유 ID를 가지고 있는 데이터 클래스입니다. KNParkingLotManager을 이용하여 SDK에서 지원하는 주차장 ID들을 읽을 수 있습니다.
 
 @property name 주차장의 이름입니다.
 @property parkingLotId 주차장의 고유 ID입니다.
 
 @see KNParkingLotManager
*/
@interface KNParkingLotMetaData: NSObject
@property (nonatomic, readonly) NSString* _Nonnull name;
@property (nonatomic, readonly) int parkingLotId;
@end

/**
 주차장 면에 대한 타입입니다. KNParkingLotArea 클래스의 타입으로 지정됩니다.
 
 @see KNParkingLotArea
 */
typedef NS_ENUM(NSUInteger, KNParkingLotAreaType)
{
    KNParkingLotAreaType_General = 1, //일반, 일반 차량이 주차할 수 있는 주차장
    KNParkingLotAreaType_DisabledPerson = 2, //장애인, 장애인만 주차할 수 있는 주차장
    KNParkingLotAreaType_ElectricVehicle = 3, //전기차, 전기차만 주차할 수 있는 주차장
    KNParkingLotAreaType_PregnantWoman = 4, //임산부, 임산부만 주차할 수 있는 주차장
    KNParkingLotAreaType_Woman = 5, //여성, 여성만 주차할 수 있는 주차장
    KNParkingLotAreaType_ValetParking = 6 //발렛, 주차 대행 주차장
};

/**
 주차장 면에 대한 정보를 가지고 있는 데이터 클래스입니다. 주차면 아이디와 주차면 중점 좌표를 맵핑할때 사용 가능합니다. 면에 대한 타입을 가지고 있어서 일반 주차면과 특수 주차면을 구분할 수 있습니다.
 
 @property coordinate
 주차면의 중점좌표입니다. 주차면의 4점 중점 좌표를 가지고 있으며, 각 주차면에 마커를 통해 표시하고자 할때 사용합니다.
 @property type 주차면의 타입입니다. 지원하는 타입은 일반, 장애인, 전기차, 임산부, 여성, 기타입니다.
 
 @see KNParkingLotFloor
*/
@interface KNParkingLotArea: NSObject
@property (nonatomic, readonly) FloatPoint coordinate;
@property (nonatomic, readonly) KNParkingLotAreaType type;
@end

/**
 주차장  층에 대한 정보를 가지고 있는 데이터 클래스입니다. 해당 층에 존재하는 모든 주차면에 대한 정보를 가져올 수 있습니다.
 
 @property isUnderGround 해당 층이 지상/지하에 속하는지 구별하는 값
 @property floorName 해당 층의 이름입니다. 해당 층의 이름으로 주차장의 층을 선택할 수 있습니다.
 @property areas 해당 층에 모든 주차면 각 각의 좌표정보입니다. 주차면 아이디는 고유이며, 각 주차면 아이디당 고유 좌표정보가 맵핑되어 제공됩니다.
 
 @see KNParkingLotManager.requestParkingLotFloorAreaStates
 @see KNParkingLotManager.requestParkingLotFloorsAreaStates
*/
@interface KNParkingLotFloor: NSObject
@property (nonatomic, readonly) bool isUnderGround;
@property (nonatomic, readonly) NSString* _Nonnull floorName;
@property (nonatomic, readonly) NSDictionary<NSString*, KNParkingLotArea*>* _Nonnull areas;
@end

/**
 선택된 주차장 정보를 가지고 있는 데이터 클래스입니다. 주차장 이름, 고유 ID를 가지고 있으면 주차장 모든 층에 대한 정보를 가지고 있습니다.
 
 @property name 주차장의 이름입니다.
 @property parkingLotId 주차장의 고유 아이디 값입니다. 주차장 고유 아이디 값은, 표시할 주차장을 지정해서 표시하고자할 때 사용할 수 있습니다.
 @property floors 해당 주차장의 층수 정보입니다. 해당 주차장의 층들의 정보입니다. 이 정보로 주차장의 층정보를 가져올 수 있습니다.
 
 @see KNParkingLotManager.requestParkingLotFloorAreaStates
 @see KNParkingLotManager.requestParkingLotFloorsAreaStates 
*/
@interface KNParkingLot: NSObject
@property (nonatomic, readonly) NSString* _Nonnull name;
@property (nonatomic, readonly) int parkingLotId;
@property (nonatomic, readonly) NSArray<KNParkingLotFloor*>* _Nonnull floors;
@end

/**
 KNMapView의 parkingLotProperties에 등록되는 리시버입니다. 맵 뷰에 등록되어 현재 맵에 노출되는 지역에 있는 주차장 정보를 콜백 받습니다.
 
 @arg aMapView 이 리시버가 등록된 맵 뷰 객체를 반환 합니다.
 @arg parkingLots 현재 맵에 노출되는 지역에 있는 주차장 정보를 반환합니다. 만약 KNMapParkingProperties.parkingLotID를 통해 특정 주차장을 선택한 경우, 해당 주차장의 정보만 반환 합니다. isVisibleParkingLot의 설정과 관계없이 등록이 되어 있다면 조건이 만족되는 경우 호출 됩니다.
 
 @see KNMapParkingLotProperties
 @see KNMapView.parkingLotProperties
*/
@protocol KNMapParkingLotReceiver<NSObject>
-(void)mapView:(KNMapView *_Nonnull)aMapView
    onReceiveFocusedParkingLots:(NSArray<KNParkingLot*>*_Nonnull)parkingLots;
@end

/**
 KNMapView에 있는 주차장 속성 프로퍼티입니다. 맵 뷰에 표출할 주차장들을 지정할 수 있고 KNMapParkingLotReceiver를 등록하여 주차장의 이벤트를 콜백 받을 수 있습니다.
 
 @property isVisibleParkingLot 주차장 표시여부를 설정 합니다. 이 값을 false로 설정하여도, KNMapParkingLotReceiver를 등록한 상태라면, 주차장을 표시하진 않지만 주변 주차장 정보를 전달 해줍니다.
 @property parkingLotId 주차장 아이디를 지정하여 지정된 주차장만을 표시합니다. 주차장 아이디를 직접 지정하여, 주차장이 화면에 들어온 경우 다른 주차장을 보여주지 않고 지정된 주차장만 보여줍니다.
 @property floorName 화면에 노출할 주차장의 층수를 지정합니다. 보여지는 주차장에서 입력된 주차장 층수 이름을 찾지 못하는 경우 주차장을 표시하지 않습니다.
 @property parkingLotReceiver 화면에 들어온 주차장 정보를 넘겨줍니다. 화면(앵커 중점기준)으로 영역이 일치하거나 포함되는 주차장 정보를 반환합니다. 이 정보는 isVisibleParkingLot이 false로 설정되어도 반환합니다.
 
 @see KNMapView
 @see KNMapParkingLotReceiver
*/
@interface KNMapParkingLotProperties: NSObject
@property (nonatomic, readwrite, assign) bool isVisibleParkingLot;
@property (nonatomic, nullable, readwrite, weak) id<KNMapParkingLotReceiver> parkingLotReciver;
@property (nonatomic, readwrite, assign) int parkingLotId;
@property (nonatomic, nullable, readwrite, assign) NSString* floorName;
@end
#endif /* KNMapParkingLot_h */
