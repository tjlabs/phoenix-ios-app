
public func jsonToOutputSectors(jsonString: String) -> (Bool, OutputSectors) {
    let result = OutputSectors(user_group_name: "", sectors: [])
    
    if let jsonData = jsonString.data(using: .utf8) {
        do {
            let decodedData: OutputSectors = try JSONDecoder().decode(OutputSectors.self, from: jsonData)
            
            return (true, decodedData)
        } catch {
            print("Error decoding JSON: \(error)")
            
            return (false, result)
        }
    } else {
        return (false, result)
    }
}
