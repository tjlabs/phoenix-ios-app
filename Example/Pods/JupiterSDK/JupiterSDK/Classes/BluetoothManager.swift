import Foundation
import CoreBluetooth

let NRF_UUID_SERVICE         = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E";
let NRF_UUID_CHAR_READ       = "6E400003-B5A3-F393-E0A9-E50E24DCCA9E";
let NRF_UUID_CHAR_WRITE      = "6E400002-B5A3-F393-E0A9-E50E24DCCA9E";
let NI_UUID_SERVICE          = "00001530-1212-efde-1523-785feabcd123";
let RSSI_BIAS: Double        = 0

let TJLABS_UUID: String          = "0000FEAA-0000-1000-8000-00805f9b34fb";

enum BLEScanOption: Int {
    case Foreground = 1
    case Background
}

let UUIDService = CBUUID(string: NRF_UUID_SERVICE)
let UUIDRead    = CBUUID(string: NRF_UUID_CHAR_READ)
let UUIDWrite   = CBUUID(string: NRF_UUID_CHAR_WRITE)
let NIService   = CBUUID(string: NI_UUID_SERVICE)
let digit: Double = pow(10, 2)

class BLECentralManager: NSObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    var centralManager: CBCentralManager!
    var peripherals = [CBPeripheral]()
    var devices = [(name:String, device:CBPeripheral, RSSI:NSNumber)]()
    
    var discoveredPeripheral: CBPeripheral!
    
    var readCharacteristic: CBCharacteristic?
    var writeCharacteristic: CBCharacteristic?
    
    var identifier:String = ""
    
    var authorized: Bool = false
    var bluetoothReady:Bool = false
    
    var connected:Bool = false
    var isDeviceReady: Bool = false
    var isTransferring: Bool = false
    
    var isScanning: Bool = false
    var tryToConnect: Bool = false
    var isNearScan: Bool = false
    
    var foundDevices = [String]() // serial number save
    
    var isBackground: Bool = false
    
    var waitTimer: Timer? = nil
    var waitTimerCounter: Int = 0
    
    var baseUUID: String = "-0000-1000-8000-00805f9b34fb"
    
    let oneServiceUUID   = CBUUID(string: TJLABS_UUID)
    
    var bleDictionary = [String: [[Double]]]()
    var bleDiscoveredTime: Double = 0
    public var bleLastScannedTime: Double = 0
    
    public var BLE_VALID_TIME: Double = 1000
    
    override init() {
        super.init()
        self.centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        self.bleLastScannedTime = getCurrentTimeInMillisecondsDouble()
    }
    
    var isBluetoothPermissionGranted: Bool {
        if #available(iOS 13.1, *) {
            return CBCentralManager.authorization == .allowedAlways
        } else if #available(iOS 13.0, *) {
            return CBCentralManager().authorization == .allowedAlways
        }
        return true
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch (central.state) {
        case .poweredOff:
            self.bluetoothReady = false
            break
        case .poweredOn:
            self.bluetoothReady = true
            NotificationCenter.default.post(name: .bluetoothReady, object: nil, userInfo: nil)
            
            if self.centralManager.isScanning == false {
                startScan(option: .Foreground)
            }
            break
        case .resetting:
            break
        case .unauthorized:
            break
        case .unknown:
            break
        case .unsupported:
            break
        @unknown default:
            print("CBCentralManage: unknown state")
        }
        
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        discoveredPeripheral = peripheral
        self.bleLastScannedTime = getCurrentTimeInMillisecondsDouble()
        if let bleName = discoveredPeripheral.name {
            if bleName.contains("TJ-") {
                let deviceIDString = bleName.substring(from: 8, to: 15)
                
                var userInfo = [String:String]()
                userInfo["Identifier"] = peripheral.identifier.uuidString
                userInfo["DeviceID"] = deviceIDString
                userInfo["RSSI"] = String(format: "%d", RSSI.intValue )
                
                let bleTime = getCurrentTimeInMilliseconds()
                let validTime = (self.BLE_VALID_TIME*2)
                self.bleDiscoveredTime = bleTime
                
                if RSSI.intValue != 127 {
                    NotificationCenter.default.post(name: .scanInfo, object: nil, userInfo: userInfo)
                    
                    let condition: ((String, [[Double]])) -> Bool = {
                        $0.0.contains(bleName)
                    }
                    
                    var bleScanned = self.bleDictionary
                    
                    let rssiValue = RSSI.doubleValue
                    if (bleScanned.contains(where: condition)) {
                        let data = bleScanned.filter(condition)
                        var value:[[Double]] = data[bleName]!
                        
                        let dataToAdd: [Double] = [rssiValue, bleTime]
                        value.append(dataToAdd)
                        
                        bleScanned.updateValue(value, forKey: bleName)
                    } else {
                        bleScanned.updateValue([[rssiValue, bleTime]], forKey: bleName)
                    }
                    let trimmedResult = trimBleData(bleInput: bleScanned, nowTime: bleTime, validTime: validTime)
                    switch trimmedResult {
                    case .success(let trimmedData):
                        self.bleDictionary = trimmedData
                    case .failure(let error):
                        print(getLocalTimeString() + " , (Jupiter) Error : BleManager \(error)")
                    }
                    
                    NotificationCenter.default.post(name: .scanInfo, object: nil, userInfo: userInfo)
                }
            }
        }
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("Failed to connect to \(peripheral).(\(error!.localizedDescription))")
        
        self.connected = false
        
        centralManager.cancelPeripheralConnection(peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        
        self.discoveredPeripheral.delegate = self
        self.connected = true
        
        var userInfo = [String:String]()
        userInfo["Identifier"] = peripheral.identifier.uuidString
        
        NotificationCenter.default.post(name: .deviceConnected, object: nil, userInfo: userInfo)
        
        discoveredPeripheral.discoverServices([UUIDService])
    }
    
    // MARK: - CBPeripheralDelegate
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            
            return
        }
        
        for service in (peripheral.services)! {
            discoveredPeripheral.discoverCharacteristics([UUIDRead, UUIDWrite], for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let error = error {
            print("Error discovering services: \(error.localizedDescription)")
            
            return
        }
        
        for characteristic in (service.characteristics)! {
            if characteristic.uuid.isEqual(UUIDRead) {
                
                readCharacteristic = characteristic
                if readCharacteristic!.isNotifying != true {
                    discoveredPeripheral.setNotifyValue(true, for: readCharacteristic!)
                    
                }
            }
            if characteristic.uuid.isEqual(UUIDWrite) {
                
                writeCharacteristic = characteristic
                
                var userInfo = [String:String]()
                userInfo["Identifier"] = peripheral.identifier.uuidString
                
                NotificationCenter.default.post(name: .deviceReady, object: nil, userInfo: userInfo)
                
                isDeviceReady = true
            }
            
        }
    }
    
    func setValidTime(mode: String) {
        if (mode == "dr") {
            self.BLE_VALID_TIME = 1000
        } else {
            self.BLE_VALID_TIME = 1500
        }
    }
    
//    func trimBleData(bleInput: Dictionary<String, [[Double]]>?, nowTime: Double, validTime: Double) -> Result<Dictionary<String, [[Double]]>, Error> {
//        guard let bleInput = bleInput else {
//                return .failure(TrimBleDataError.invalidInput)
//            }
//            
//            var trimmedData = [String: [[Double]]]()
//            
//            for (bleID, bleData) in bleInput {
//                let newValue = bleData.filter { data in
//                    let rssi = data[0]
//                    let time = data[1]
//                    
//                    return (nowTime - time <= validTime) && (rssi >= -100)
//                }
//                
//                if !newValue.isEmpty {
//                    trimmedData[bleID] = newValue
//                }
//            }
//            
//            if trimmedData.isEmpty {
//                return .failure(TrimBleDataError.noValidData)
//            } else {
//                return .success(trimmedData)
//            }
//    }
//
//    enum TrimBleDataError: Error {
//        case invalidInput
//        case noValidData
//    }
    
    func isConnected() -> Bool {
        return connected
    }
    
    func disconnectAll() {
        if discoveredPeripheral != nil {
            centralManager.cancelPeripheralConnection(discoveredPeripheral)
        }
    }
    
    func startScan(option: BLEScanOption) {
        if centralManager.isScanning {
            stopScan()
        }
        
        if bluetoothReady {
            self.centralManager.scanForPeripherals(withServices: [oneServiceUUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey : NSNumber(value: true as Bool)])
            self.isScanning = true
            
            NotificationCenter.default.post(name: .startScan, object: nil)
        }
    }
    
    func stopScan() {
        self.centralManager.stopScan()
        
        self.isScanning = false
        
        self.bleDictionary = [String: [[Double]]]()
        self.bleDiscoveredTime = 0
        
        NotificationCenter.default.post(name: .stopScan, object: nil)
    }
    
    // timer
    func startWaitTimer() {
        waitTimerCounter = 0
        self.waitTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(self.waitTimerUpdate), userInfo: nil, repeats: true)
    }
    
    func stopWaitTimer() {
        if waitTimer != nil {
            waitTimer!.invalidate()
            waitTimer = nil
        }
    }
    
    @objc func waitTimerUpdate() {
        stopScan()
        
        startScan(option: .Background)
    }
    
    func getCurrentTimeInMilliseconds() -> Double
    {
        return Double(Date().timeIntervalSince1970 * 1000)
    }
    
    // Eddystone parsing
    func parseURLFromFrame(frameData: NSData) -> NSURL? {
        if frameData.length > 0 {
            let count = frameData.length
            var frameBytes = [UInt8](repeating: 0, count: count)
            frameData.getBytes(&frameBytes, length: count)
            
            if let URLPrefix = URLPrefixFromByte(schemeID: frameBytes[2]) {
                var output = URLPrefix
                for i in 3..<frameBytes.count {
                    if let encoded = encodedStringFromByte(charVal: frameBytes[i]) {
                        output.append(encoded)
                    }
                }
                
                return NSURL(string: output)
            }
        }
        
        return nil
    }
    
    func URLPrefixFromByte(schemeID: UInt8) -> String? {
        switch schemeID {
        case 0x00:
            return "http://www."
        case 0x01:
            return "https://www."
        case 0x02:
            return "http://"
        case 0x03:
            return "https://"
        default:
            return nil
        }
    }
    
    func encodedStringFromByte(charVal: UInt8) -> String? {
        switch charVal {
        case 0x00:
            return ".com/"
        case 0x01:
            return ".org/"
        case 0x02:
            return ".edu/"
        case 0x03:
            return ".net/"
        case 0x04:
            return ".info/"
        case 0x05:
            return ".biz/"
        case 0x06:
            return ".gov/"
        case 0x07:
            return ".com"
        case 0x08:
            return ".org"
        case 0x09:
            return ".edu"
        case 0x0a:
            return ".net"
        case 0x0b:
            return ".info"
        case 0x0c:
            return ".biz"
        case 0x0d:
            return ".gov"
        default:
            return String(data: Data(bytes: [ charVal ] as [UInt8], count: 1), encoding: .utf8)
        }
    }
    
    func getLocalTimeString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        let nowDate = Date()
        let convertNowStr = dateFormatter.string(from: nowDate)
        
        return convertNowStr
    }
}
