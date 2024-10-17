
import Foundation

public class UserInfoManager {
    static let shared = UserInfoManager()
    let userDefaults = UserDefaults.standard
    
    public var userType = UserType.NONE
    public var personalUserInfo = PersonalUserInfo(email: "", password: "")
    public var businessUserInfo = BusinessUserInfo(name: "", car_number: "", company: "", phone_number: "")
    
    public var isPersonalUserInfoSaved: Bool = false
    public var isBusinessUserInfoSaved: Bool = false
    
    // Personal
    public func setPersonalUserInfoSaved(flag: Bool) {
        self.isPersonalUserInfoSaved = flag
    }
    
    public func loadPersonalUserInfo() -> PersonalUserInfo {
        var loadedUserInfo = PersonalUserInfo(email: "", password: "")
        
        var loadCount: Int = 0
        if let email = userDefaults.string(forKey: "personalUserEmail") {
            loadedUserInfo.email = email
            loadCount += 1
        }
        if let password = userDefaults.string(forKey: "personalUserPassword") {
            loadedUserInfo.password = password
            loadCount += 1
        }

        if (loadCount == 2) {
            self.setPersonalUserInfoSaved(flag: true)
        }
        
        return loadedUserInfo
    }
    
    public func checkPersonalUserInfo(userInfo: PersonalUserInfo) -> Bool {
        let email = userInfo.email
        let password = userInfo.password
      
        if (email == "" || email.contains(" ") || !email.contains("@")) {
            return false
        } else if (password == "" || password.contains(" ")) {
            return false
        }
        return true
    }
    
    public func setPersonalUserInfo(userInfo: PersonalUserInfo) {
        self.userType = UserType.PERSONAL
        self.personalUserInfo = userInfo
    }
    
    public func getPersonalUserInfo() -> PersonalUserInfo {
        return self.personalUserInfo
    }
    
    public func savePersonalUserInfo(userInfo: PersonalUserInfo, initialize: Bool) {
        if (initialize) {
            userDefaults.set(nil, forKey: "personalUserEmail")
            userDefaults.set(nil, forKey: "personalUserPassword")
        } else {
            let email = userInfo.email
            let password = userInfo.password
            userDefaults.set(email, forKey: "personalUserEmail")
            userDefaults.set(password, forKey: "personalUserPassword")
        }
        userDefaults.synchronize()
    }
    
    
    // Business
    public func setBusinessUserInfoSaved(flag: Bool) {
        self.isBusinessUserInfoSaved = flag
    }
    
    public func loadBusinessUserInfo() -> BusinessUserInfo {
        var loadedUserInfo = BusinessUserInfo(name: "", car_number: "", company: "", phone_number: "")
        
        var loadCount: Int = 0
        if let name = userDefaults.string(forKey: "businessUserName") {
            loadedUserInfo.name = name
            loadCount += 1
        }
        if let carNumber = userDefaults.string(forKey: "businessUserCarNumber") {
            loadedUserInfo.car_number = carNumber
            loadCount += 1
        }
        if let company = userDefaults.string(forKey: "businessUserCompany") {
            loadedUserInfo.company = company
            loadCount += 1
        }
        if let phoneNumber = userDefaults.string(forKey: "businessUserPhoneNumber") {
            loadedUserInfo.phone_number = phoneNumber
            loadCount += 1
        }

        if (loadCount == 4) {
            self.setBusinessUserInfoSaved(flag: true)
        }
        
        return loadedUserInfo
    }
    
    public func checkBusinessUserInfo(userInfo: BusinessUserInfo) -> Bool {
        let name = userInfo.name
        let carNumber = userInfo.car_number
        let company = userInfo.company
        let phoneNumber = userInfo.phone_number
      
        if (name == "" || name.contains(" ")) {
            return false
        } else if (carNumber == "" || carNumber.contains(" ")) {
            return false
        } else if (company == "" || company.contains(" ")) {
            return false
        } else if (phoneNumber == "" || phoneNumber.contains(" ")) {
            return false
        }
        return true
    }
    
    public func setBusinessUserInfo(userInfo: BusinessUserInfo) {
        self.userType = UserType.BUSINESS
        self.businessUserInfo = userInfo
    }
    
    public func getBussinessUserInfo() -> BusinessUserInfo {
        return self.businessUserInfo
    }
    
    public func saveBusinessUserInfo(userInfo: BusinessUserInfo, initialize: Bool) {
        if (initialize) {
            userDefaults.set(nil, forKey: "businessUserName")
            userDefaults.set(nil, forKey: "businessUserCarNumber")
            userDefaults.set(nil, forKey: "businessUserCompany")
            userDefaults.set(nil, forKey: "businessUserPhoneNumber")
        } else {
            let name = userInfo.name
            let carNumber = userInfo.car_number
            let company = userInfo.company
            let phoneNumber = userInfo.phone_number
            
            userDefaults.set(name, forKey: "businessUserName")
            userDefaults.set(carNumber, forKey: "businessUserCarNumber")
            userDefaults.set(company, forKey: "businessUserCompany")
            userDefaults.set(phoneNumber, forKey: "businessUserPhoneNumber")
        }
        userDefaults.synchronize()
    }
}
