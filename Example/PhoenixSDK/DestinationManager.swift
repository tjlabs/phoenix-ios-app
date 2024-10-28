
import Foundation
import RxSwift
import Alamofire

public class DestinationManager {
    static let shared = DestinationManager()
    let userDefaults = UserDefaults.standard
    
    // My
    private let destinationInfoListSubject = BehaviorSubject<[DestinationInformation]>(value: [])
    var destinationInfoListObservable: Observable<[DestinationInformation]> {
        return destinationInfoListSubject.asObservable()
    }
    public var destinationInfoList = [DestinationInformation]() {
        didSet {
            destinationInfoListSubject.onNext(destinationInfoList)
        }
    }
    
    // Searched
    private let searchedDestinationInfoListSubject = BehaviorSubject<[DestinationInformation]>(value: [])
    var searchedDestinationInfoListObservable: Observable<[DestinationInformation]> {
        return searchedDestinationInfoListSubject.asObservable()
    }
    public var searchedDestinationInfoList = [DestinationInformation]() {
        didSet {
            searchedDestinationInfoListSubject.onNext(searchedDestinationInfoList)
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
    
    
    // Search
    func searchDestinationList(keyword: String) {
        self.getDestinationListWithKeyword(keyword: keyword) { result in
            switch result {
            case .success(let destinations):
                let destinationList = destinations.documents
                var destinationInfoList = [DestinationInformation]()
                for item in destinationList {
                    let dest = DestinationInformation(name: item.placeName, address: item.addressName, coord: DestinationCoord(latitude: Double(item.y)!, longitude: Double(item.x)!), description: item.roadAddressName)
                    destinationInfoList.append(dest)
                }
                self.searchedDestinationInfoList = destinationInfoList
//                print("(Phoenix) : Successfully retrieved destinations: \(self.searchedDestinationInfoList)")
            case .failure(let error):
                print("(Phoenix) : Failed to retrieve destinations with error: \(error.localizedDescription)")
            }
        }
    }
    
    func getDestinationListWithKeyword(keyword: String, completion: @escaping(Result<SearchedDestinations, AFError>) -> Void) {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String
        else {
            completion(.failure(AFError.explicitlyCancelled))
            return
        }
        
        let headers: HTTPHeaders = ["Authorization": "KakaoAK \(apiKey)",
                                    "content-type": "application/json;charset=UTF-8"]
//        let parameters: [String: Any] = ["y": y,
//                                         "x": x,
//                                         "radius": radius,
//                                         "page": page,
//                                         "query": keyword]
        let parameters: [String: Any] = ["query": keyword,
                                         "page": 1,
                                         "size": 15]
        let url = "https://dapi.kakao.com/v2/local/search/keyword.json"
//        print("(Phoenix) apiKey : \(apiKey)")
//        print("(Phoenix) url : \(url)")
//        print("(Phoenix) parameters : \(parameters)")
        
//        AF.request(url,
//                   method: .get,
//                   parameters: parameters,
//                   headers: headers)
//        .responseJSON { response in
//            switch response.result {
//            case .success(let data):
//                print("(Phoenix) Raw JSON Response: \(data)")
//            case .failure(let error):
//                print("(Phoenix) Failed with error: \(error)")
//            }
//        }
        
        AF.request(url,
                   method: .get,
                   parameters: parameters,
                   headers: headers)
        .responseDecodable(of: SearchedDestinations.self) { response in
            switch response.result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
