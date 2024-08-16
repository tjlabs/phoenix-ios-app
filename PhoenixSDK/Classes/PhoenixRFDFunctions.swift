
public class PhoenixRFDFunctions: NSObject {
    static let shared = PhoenixRFDFunctions()
    
    enum TrimBLEDataError: Error {
        case invalidInput
        case noValidData
    }

    public func trimBLEData(bleInput: [String: [[Double]]]?, nowTime: Double, validTime: Double) -> Result<[String: [[Double]]], Error> {
        guard let bleInput = bleInput else {
                return .failure(TrimBLEDataError.invalidInput)
            }
            var trimmedData = [String: [[Double]]]()
            
            for (bleID, bleData) in bleInput {
                let newValue = bleData.filter { data in
                    let rssi = data[0]
                    let time = data[1]
                    return (nowTime - time <= validTime) && (rssi >= -100)
                }
                
                if !newValue.isEmpty {
                    trimmedData[bleID] = newValue
                }
            }
            
            if trimmedData.isEmpty {
                return .failure(TrimBLEDataError.noValidData)
            } else {
                return .success(trimmedData)
            }
    }

    public func trimBLEForCollect(bleData:[String: [[Double]]], nowTime: Double, validTime: Double) -> [String: [[Double]]] {
        var trimmedData = [String: [[Double]]]()

        for (bleID, bleData) in bleData {
            var newValue = [[Double]]()
            for data in bleData {
                let rssi = data[0]
                let time = data[1]

                if ((nowTime - time <= validTime) && (rssi >= -100)) {
                    let dataToAdd: [Double] = [rssi, time]
                    newValue.append(dataToAdd)
                }
            }

            if (newValue.count > 0) {
                trimmedData[bleID] = newValue
            }
        }

        return trimmedData
    }

    public func avgBLEData(bleDictionary: [String: [[Double]]]) -> [String: Double] {
        let digit: Double = pow(10, 2)
        var ble = [String: Double]()
        
        let keys: [String] = Array(bleDictionary.keys)
        for index in 0..<keys.count {
            let bleID: String = keys[index]
            let bleData: [[Double]] = bleDictionary[bleID]!
            let bleCount = bleData.count
            
            var rssiSum: Double = 0
            
            for i in 0..<bleCount {
                let rssi = bleData[i][0]
                rssiSum += rssi
            }
            let rssiFinal: Double = floor(((rssiSum/Double(bleData.count))) * digit) / digit
            
            if ( rssiSum == 0 ) {
                ble.removeValue(forKey: bleID)
            } else {
                ble.updateValue(rssiFinal, forKey: bleID)
            }
        }
        return ble
    }

    public func checkBLEChannelNum(bleAvg: [String: Double]?) -> Int {
        var numChannels: Int = 0
        if let bleAvgData = bleAvg {
            for key in bleAvgData.keys {
                let bleRssi: Double = bleAvgData[key] ?? -100.0
                
                if (bleRssi > -95.0) {
                    numChannels += 1
                }
            }
        }
        
        return numChannels
    }

    public func getLatestBLEData(bleDictionary: [String: [[Double]]]) -> [String: Double] {
        var ble = [String: Double]()
        
        let keys: [String] = Array(bleDictionary.keys)
        for index in 0..<keys.count {
            let bleID: String = keys[index]
            let bleData: [[Double]] = bleDictionary[bleID]!
            
            let rssiFinal: Double = bleData[bleData.count-1][0]
            
            ble.updateValue(rssiFinal, forKey: bleID)
        }
        return ble
    }
    
    public func getStrongestBLEData(bleData: [String: Double]) -> [String: Double] {
        var ble = [String: Double]()
        
        var strongestID: String = ""
        var strongestRSSI: Double = -100
        
        for (key, value) in bleData {
            if value > strongestRSSI {
                strongestID = key
                strongestRSSI = value
            }
        }
        
        ble.updateValue(strongestRSSI, forKey: strongestID)
        
        return ble
    }
}
