import Foundation

let RECORD_URL: String = "https://ap-northeast-2.rec.phoenix.tjlabs.dev/2024-08-05/mr"

struct KATEC {
    let x: Int32
    let y: Int32
}

struct PhoenixRecord: Codable {
    var user_id: String
    var company: String
    var car_number: String
    var mobile_time: Double
    var index: Int
    var latitude: Double
    var longitude: Double
    var remaining_time: Int
    var velocity: Double
    var sector_id: Int
    var building_name: String
    var level_name: String
    var x: Int
    var y: Int
    var absolute_heading: Double
    var is_indoor: Bool
}
