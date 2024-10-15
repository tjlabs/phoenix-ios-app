
import Foundation

public class UserInfoManager {
    static let shared = UserInfoManager()
    let userDefaults = UserDefaults.standard
    
    public var personalUserInfo = PersonalUserInfo(email: "", password: "")
    public var businessUserInfo = BusinessUserInfo(name: "", car_number: "", company: "", phone_number: "")
    
    public var isPersonalUserInfoSaved: Bool = false
    public var isBusinessUserInfoSaved: Bool = false
    
    public func setPersonalUserInfoSaved(flag: Bool) {
        self.isPersonalUserInfoSaved = flag
    }
    
    public func setBusinessUserInfoSaved(flag: Bool) {
        self.isBusinessUserInfoSaved = flag
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
        self.personalUserInfo = userInfo
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
}
