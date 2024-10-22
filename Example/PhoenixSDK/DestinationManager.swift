
import Foundation
import RxSwift

public class DestinationManager {
    static let shared = DestinationManager()
    let userDefaults = UserDefaults.standard
    
    private let destinationInfoListSubject = BehaviorSubject<[DestinationInformation]>(value: [])
    var destinationInfoListObservable: Observable<[DestinationInformation]> {
            return destinationInfoListSubject.asObservable()
        }
    
    public var destinationInfoList = [DestinationInformation]() {
            didSet {
                destinationInfoListSubject.onNext(destinationInfoList)
            }
        }
    
    public func getDestinationInfoList() -> [DestinationInformation] {
        return self.destinationInfoList
    }
    
    public func makeDestinationInformationList(outputSectors: OutputSectors) -> Bool {
        var isAlreadyHas: Bool = false
        var loadedDestinationInfoList = [DestinationInformation]()
        
        let userGroupName = outputSectors.user_group_name
        
        var destinationCounts = 0
        var alreadyHasCount = 0
        let sectors = outputSectors.sectors
        for sector in sectors {
            let buildings = sector.buildings
            for building in buildings {
                // sector -> building
                let destination = DestinationInformation(name: "\(sector.name) \(building.name)", address: building.address, coord: DestinationCoord(latitude: building.latitude, longitude: building.longitude), description: building.description)
                loadedDestinationInfoList.append(destination)
                destinationCounts += 1
            }
        }
        
        var newItemList = [DestinationInformation]()
        for loadedItem in loadedDestinationInfoList {
            let isItemAlreadyInList = self.destinationInfoList.contains { myItem in
                return myItem.name == loadedItem.name && myItem.address == loadedItem.address
            }
            if isItemAlreadyInList {
                alreadyHasCount += 1
            } else {
                newItemList.append(loadedItem)
            }
        }
        
        if alreadyHasCount == destinationCounts {
            isAlreadyHas = true
        }

        self.destinationInfoList += newItemList
        print("(Phoenix) Destination List : \(self.destinationInfoList)")
        self.saveDestinationInformationList()
        
        return isAlreadyHas
    }
    
    public func saveDestinationInformationList() {
        let userType = UserInfoManager.shared.userType
        var key = ""
        if userType == .BUSINESS {
            let businessUserInfo = UserInfoManager.shared.getBussinessUserInfo()
            key = "BUSINESS_\(businessUserInfo.name)_\(businessUserInfo.car_number)_\(businessUserInfo.company)"
        } else if userType == .PERSONAL {
            let personalUserInfo = UserInfoManager.shared.getPersonalUserInfo()
            key = "PERSONAL_\(personalUserInfo.email)_\(personalUserInfo.password)"
        } else {
            
        }
        
        if !self.destinationInfoList.isEmpty && userType != .NONE {
            userDefaults.saveStructArray(destinationInfoList, forKey: key)
            userDefaults.synchronize()
        }
    }
    
    public func loadPersonalDestinationInformationList(personalUserInfo: PersonalUserInfo) {
        // PERSONAL_EMAIL_PASSWORD
        let key = "PERSONAL_\(personalUserInfo.email)_\(personalUserInfo.password)"
        if let loadedStruct = userDefaults.loadStructArray(key, type: [DestinationInformation].self) {
            self.destinationInfoList = loadedStruct
            print("(Phoenix) Destination List : Load Destination of Personal User // \(self.destinationInfoList)")
        } else {
            self.destinationInfoList = [DestinationInformation]()
            print("(Phoenix) Destination List : Load Destination of Personal User // empty")
        }
    }
    
    public func loadBusinessDestinationInformationList(businessUserInfo: BusinessUserInfo) {
        // BUSINESS_NAME_CARNUMBER_COMPANY
        let key = "BUSINESS_\(businessUserInfo.name)_\(businessUserInfo.car_number)_\(businessUserInfo.company)"
        if let loadedStruct = userDefaults.loadStructArray(key, type: [DestinationInformation].self) {
            self.destinationInfoList = loadedStruct
            print("(Phoenix) Destination List : Load Destination of Business User // \(self.destinationInfoList)")
        } else {
            self.destinationInfoList = [DestinationInformation]()
            print("(Phoenix) Destination List : Load Destination of Business User // empty")
        }
    }
}
