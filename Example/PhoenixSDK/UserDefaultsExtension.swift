import Foundation

extension UserDefaults {
    
    func saveStruct<T: Codable>(_ value: T, forKey key: String) {
        if let encoded = try? JSONEncoder().encode(value) {
            self.set(encoded, forKey: key)
        }
    }
    
    func loadStruct<T: Codable>(_ key: String, type: T.Type) -> T? {
        if let data = self.data(forKey: key),
           let decoded = try? JSONDecoder().decode(type, from: data) {
            return decoded
        }
        return nil
    }
    
    func saveStructArray<T: Codable>(_ value: [T], forKey key: String) {
            if let encoded = try? JSONEncoder().encode(value) {
                self.set(encoded, forKey: key)
            }
        }
        
    func loadStructArray<T: Codable>(_ key: String, type: [T].Type) -> [T]? {
        if let data = self.data(forKey: key),
            let decodedArray = try? JSONDecoder().decode(type, from: data) {
            return decodedArray
        }
        return nil
    }
}
