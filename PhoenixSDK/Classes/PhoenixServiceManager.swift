import Foundation

public class PhoenixServiceManager {
    
    // User Information
    var user_id: String = ""
    var user_company: String = ""
    var user_car_number: String = ""
    var user_latitude: Double = 0
    var user_longitude: Double = 0
    
    let bleManager = PhoenixBluetoothManager()
    var bleAvg = [String: Double]()
    var strongestBLE = [String: Double]()
    
    var dataPostTimer: DispatchSourceTimer?
    
    let BLE_ID_FOR_AUTH: String = "TJ-00CB-0000024C-0000"
    let BLE_RSSI_FOR_AUTH: Double = -50
    
    public init() {
//        bleManager.initBle()
    }
    
    public func startService(id: String, company: String, car_number: String) {
        self.user_id = id
        self.user_company = company
        self.user_car_number = car_number
        print(getLocalTimeString() + " , (Phoenix) Start Service : id = \(id) , company = \(company) , car_number = \(car_number)")
        bleManager.initBle()
//        self.startTimer()
    }
    
    public func stopService() {
        print(getLocalTimeString() + " , (Phoenix) Stop Service")
        bleManager.stopScan()
    }
    
    public func requestAuth() -> Bool {
        var isGranted: Bool = false
        var bleDataForAuth = [String: Double]()
        
        let validTime = PhoenixConstants.BLE_VALID_TIME
        let currentTime = getCurrentTimeInMilliseconds() - (Int(validTime)/2)
        
        let bleDictionary: [String: [[Double]]]? = bleManager.bleDictionary
        if let bleData = bleDictionary {
            let trimmedResult = PhoenixRFDFunctions.shared.trimBLEData(bleInput: bleData, nowTime: getCurrentTimeInMillisecondsDouble(), validTime: validTime)
            switch trimmedResult {
            case .success(let trimmedData):
                bleDataForAuth = PhoenixRFDFunctions.shared.avgBLEData(bleDictionary: trimmedData)
                let strongestBLE = PhoenixRFDFunctions.shared.getStrongestBLEData(bleData: bleDataForAuth)
//                print(getLocalTimeString() + " , (Phoenix) BLE = \(bleDataForAuth)")
//                print(getLocalTimeString() + " , (Phoenix) BLE Strong = \(strongestBLE)")
//                print(getLocalTimeString() + " , (Phoenix) ---------------------------------------------")
                for (key, value) in strongestBLE {
                    if BLE_ID_FOR_AUTH.contains(key) && value >= BLE_RSSI_FOR_AUTH {
                        print(getLocalTimeString() + " , (Phoenix) Auth Granted")
                        return true
                    }
                }
            case .failure(_):
                print("Trim Fail")
            }
        }
        
        return isGranted
    }
    
    @objc func runDatatPostTimer() {
        self.handleBLEData()
    }
    
    private func handleBLEData() {
        let validTime = PhoenixConstants.BLE_VALID_TIME
        let currentTime = getCurrentTimeInMilliseconds() - (Int(validTime)/2)
        
        let bleDictionary: [String: [[Double]]]? = bleManager.bleDictionary
        if let bleData = bleDictionary {
            let trimmedResult = PhoenixRFDFunctions.shared.trimBLEData(bleInput: bleData, nowTime: getCurrentTimeInMillisecondsDouble(), validTime: validTime)
            switch trimmedResult {
            case .success(let trimmedData):
                self.bleAvg = PhoenixRFDFunctions.shared.avgBLEData(bleDictionary: trimmedData)
                self.strongestBLE = PhoenixRFDFunctions.shared.getStrongestBLEData(bleData: self.bleAvg)
//                print(getLocalTimeString() + " , (Phoenix) BLE = \(self.bleAvg)")
//                print(getLocalTimeString() + " , (Phoenix) BLE Strong = \(self.strongestBLE)")
//                print(getLocalTimeString() + " , (Phoenix) ---------------------------------------------")
            case .failure(_):
                print("Trim Fail")
                self.bleAvg = [String: Double]()
                self.strongestBLE = [String: Double]()
            }
        }
    }
    
    private func startTimer() {
        if (self.dataPostTimer == nil) {
            let queueDataPost = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".dataPostTimer")
            self.dataPostTimer = DispatchSource.makeTimerSource(queue: queueDataPost)
            self.dataPostTimer!.schedule(deadline: .now(), repeating: PhoenixConstants.DATA_POST_INTERVAL)
            self.dataPostTimer!.setEventHandler(handler: self.runDatatPostTimer)
            self.dataPostTimer!.resume()
        }
    }
    
    private func stopTimer() {
        self.dataPostTimer?.cancel()
        self.dataPostTimer = nil
    }
}
