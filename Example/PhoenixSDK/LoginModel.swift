import Foundation

struct UserInfo {
    var name: String
    var company: String
    var carNumber: String
}

public enum UserType: String {
    case NONE
    case PERSONAL
    case BUSINESS
}

public struct PersonalUserInfo {
    var email: String
    var password: String
}

public struct BusinessUserInfo {
    var name: String
    var car_number: String
    var company: String
    var phone_number: String
}


