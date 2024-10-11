
import Foundation

let SECTORS_URL: String = "https://ap-northeast-2.user.phoenix.tjlabs.dev/2024-09-24/sectors"

struct DestinationInfo {
    var name: String
    var address: String
    var coord: DestinationCoord
}

struct DestinationCoord {
    var latitude: Double
    var longitude: Double
}

struct InputSectors {
    let user_group_name: String
    let user_group_code: String
}

struct BuildingInSectors {
    let name: String
    let description: String
    let address: String
    let latitude: Double
    let longitude: Double
}

struct SectorFromServer {
    let id: Int
    let name: String
    let buildings: [BuildingInSectors]
}

struct OutputSectors {
    let sectors: [SectorFromServer]
}
