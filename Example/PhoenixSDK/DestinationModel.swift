
import Foundation

let SECTORS_URL: String = "https://ap-northeast-2.user.phoenix.tjlabs.dev/2024-10-16/sectors"

public struct DestinationInfo: Codable {
    var name: String
    var address: String
    var coord: DestinationCoord
}

public struct DestinationCoord: Codable {
    var latitude: Double
    var longitude: Double
}

public struct InputSectors: Codable {
    let user_group_code: String
}

public struct BuildingInSectors: Codable {
    let name: String
    let description: String
    let address: String
    let latitude: Double
    let longitude: Double
}

public struct SectorFromServer: Codable {
    let id: Int
    let name: String
    let buildings: [BuildingInSectors]
}

public struct OutputSectors: Codable {
    let user_group_name: String
    let sectors: [SectorFromServer]
}

public struct DestinationInformation: Codable {
    let name: String
    let address: String
    let coord: DestinationCoord
    let description: String
}


struct SearchedDestinations: Codable {
    let documents: [PlaceList]
}

struct PlaceList: Codable {
    let addressName: String
    let categoryGroupCode: String
    let categoryGroupName: String
    let categoryName: String
    let distance, id, phone, placeName: String
    let placeURL: String
    let roadAddressName, x, y: String
    
    enum CodingKeys: String, CodingKey {
        case addressName = "address_name"
        case categoryGroupCode = "category_group_code"
        case categoryGroupName = "category_group_name"
        case categoryName = "category_name"
        case distance, id, phone
        case placeName = "place_name"
        case placeURL = "place_url"
        case roadAddressName = "road_address_name"
        case x, y
    }
}
