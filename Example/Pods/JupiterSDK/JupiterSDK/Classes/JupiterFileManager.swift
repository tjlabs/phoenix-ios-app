import UIKit

public class JupiterFileManager {
    static let shared = JupiterFileManager()
    
    var sensorFileUrl: URL? = nil
    var bleFileUrl: URL? = nil
    
    private let dataQueue = DispatchQueue(label: "tjlabs.jupiter.dataQueue", attributes: .concurrent)
    
    var sensorData = [SensorData]()
    var bleTime = [Int]()
    var bleData = [[String: Double]]()
    
    var region: String = ""
    var sector_id: Int = 0
    var deviceModel: String = "Unknown"
    var osVersion: Int = 0
    
    init() {}
    
    public func setRegion(region: String) {
        self.region = region
    }
    
    private func createExportDirectory() -> URL? {
        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print(getLocalTimeString() + " , (JupiterFileManager) : Unable to access document directory.")
            return nil
        }
        let exportDirectoryUrl = documentDirectoryUrl.appendingPathComponent("Exports")
        if !FileManager.default.fileExists(atPath: exportDirectoryUrl.path) {
            do {
                try FileManager.default.createDirectory(at: exportDirectoryUrl, withIntermediateDirectories: true, attributes: nil)
                print(getLocalTimeString() + " , (JupiterFileManager) : Export directory created at: \(exportDirectoryUrl)")
            } catch {
                print(getLocalTimeString() + " , (JupiterFileManager) : Error creating export directory: \(error)")
                return nil
            }
        } else {
            print(getLocalTimeString() + " , (JupiterFileManager) : Export directory already exists at: \(exportDirectoryUrl)")
        }
        
        return exportDirectoryUrl
    }
    
    public func createFiles(region: String, sector_id: Int, deviceModel: String, osVersion: Int) {
        if let exportDir: URL = self.createExportDirectory() {
            self.region = region
            self.sector_id = sector_id
            self.deviceModel = deviceModel
            self.osVersion = osVersion
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
            dateFormatter.locale = Locale(identifier:"ko_KR")
            let nowDate = Date()
            let convertNowStr = dateFormatter.string(from: nowDate)
            
            let sensorFileName = "ios_\(region)_\(sector_id)_\(convertNowStr)_\(deviceModel)_\(osVersion)_sensor.csv"
            let bleFileName = "ios_\(region)_\(sector_id)_\(convertNowStr)_\(deviceModel)_\(osVersion)_ble.csv"
            sensorFileUrl = exportDir.appendingPathComponent(sensorFileName)
            bleFileUrl = exportDir.appendingPathComponent(bleFileName)
        } else {
            print(getLocalTimeString() + " , (JupiterFileManager) : Error creating export directory")
        }
    }
    
    public func writeSensorData(data: SensorData) {
        dataQueue.async(flags: .barrier) {
            self.sensorData.append(data)
        }
    }
    
    public func writeBleData(time: Int, data: [String: Double]) {
        dataQueue.async(flags: .barrier) {
            self.bleTime.append(time)
            self.bleData.append(data)
        }
    }
    
    private func saveSensorData() {
        var csvText = "time,acc_x,acc_y,acc_z,u_acc_x,u_acc_y,u_acc_z,gyro_x,gyro_y,gyro_z,mag_x,mag_y,mag_z,grav_x,grav_y,grav_z,att0,att1,att2,q0,q1,q2,q3,rm00,rm01,rm02,rm10,rm11,rm12,rm20,rm21,rm22,gv0,gv1,gv2,gv3,rv0,rv1,rv2,rv3,rv4,pressure,true_heading,mag_heading\n"
        for record in sensorData {
            csvText += "\(record.time),\(record.acc[0]),\(record.acc[1]),\(record.acc[2]),\(record.userAcc[0]),\(record.userAcc[1]),\(record.userAcc[2]),\(record.gyro[0]),\(record.gyro[1]),\(record.gyro[2]),\(record.mag[0]),\(record.mag[1]),\(record.mag[2]),\(record.grav[0]),\(record.grav[1]),\(record.grav[2]),\(record.att[0]),\(record.att[1]),\(record.att[2]),\(record.quaternion[0]),\(record.quaternion[1]),\(record.quaternion[2]),\(record.quaternion[3]),\(record.rotationMatrix[0][0]),\(record.rotationMatrix[0][1]),\(record.rotationMatrix[0][2]),\(record.rotationMatrix[1][0]),\(record.rotationMatrix[1][1]),\(record.rotationMatrix[1][2]),\(record.rotationMatrix[2][0]),\(record.rotationMatrix[2][1]),\(record.rotationMatrix[2][2]),\(record.gameVector[0]),\(record.gameVector[1]),\(record.gameVector[2]),\(record.gameVector[3]),\(record.rotVector[0]),\(record.rotVector[1]),\(record.rotVector[2]),\(record.rotVector[3]),\(record.rotVector[4]),\(record.pressure[0]),\(record.trueHeading),\(record.magneticHeading)\n"
        }

        do {
            if let fileUrl = sensorFileUrl {
                try csvText.write(to: fileUrl, atomically: true, encoding: .utf8)
                print(getLocalTimeString() + " , (JupiterFileManager) : Data saved to \(fileUrl)")
            } else {
                print(getLocalTimeString() + " , (JupiterFileManager) : Error: sensorFileUrl is nil")
            }
        } catch {
            print(getLocalTimeString() + " , (JupiterFileManager) : Error: \(error)")
        }
        
        sensorData = [SensorData]()
    }
    
    private func saveBleData() {
        var csvText = "time,ble\n"
        for i in 0..<bleTime.count {
            csvText += "\(bleTime[i]),"
            let record = bleData[i]
            for (key, value) in record {
                csvText += "\(key):\(value),"
            }
            csvText += "\n"
        }

        do {
            if let fileUrl = bleFileUrl {
                try csvText.write(to: fileUrl, atomically: true, encoding: .utf8)
                print(getLocalTimeString() + " , (JupiterFileManager) : Data saved to \(fileUrl)")
            } else {
                print(getLocalTimeString() + " , (JupiterFileManager) : Error: bleFileUrl is nil")
            }
        } catch {
            print(getLocalTimeString() + " , (JupiterFileManager) : Error: \(error)")
        }
        
        bleTime = [Int]()
        bleData = [[String: Double]]()
    }
    
    public func saveFilesForSimulation() {
        saveBleData()
        saveSensorData()
    }
    
    public func loadFilesForSimulation(bleFile: String, sensorFile: String) -> ([[String: Double]], [SensorData]) {
        var loadedBleData = [[String: Double]]()
        var loadedSenorData = [SensorData]()
        
        if let exportDir: URL = self.createExportDirectory() {
//            let bleFileName = "ble_check2.csv"
//            let sensorFileName = "sensor_check2.csv"
//            let bleFileName = "ble_ds04.csv"
//            let sensorFileName = "sensor_ds04.csv"
//            let bleFileName = "ble_coex02.csv"
//            let sensorFileName = "sensor_coex02.csv"
            let bleFileName = bleFile
            let sensorFileName = sensorFile
            
            let bleSimulationUrl = exportDir.appendingPathComponent(bleFileName)
            do {
                let csvData = try String(contentsOf: bleSimulationUrl)
                let bleRows = csvData.components(separatedBy: "\n")
                for row in bleRows {
                    let replacedRow = row.replacingOccurrences(of: "\r", with: "")
                    let columns = replacedRow.components(separatedBy: ",")
                    if columns[0] != "time" {
                        var bleDict = [String: Double]()
                        if (columns.count > 1) {
                            for i in 0..<columns.count {
                                if i == 0 {
                                    // time
                                } else {
                                    if (columns[i].count > 1) {
                                        let bleKeyValue = columns[i].components(separatedBy: ":")
                                        let bleKey = bleKeyValue[0]
                                        let bleValue = Double(bleKeyValue[1])!
                                        bleDict[bleKey] = bleValue
                                    }
                                }
                            }
                        }
                        
                        loadedBleData.append(bleDict)
                    }
                }
            } catch {
                print(getLocalTimeString() + " , (JupiterFileManager) : Error loading sensor file: \(error)")
            }
            

            let sensorSimulationUrl = exportDir.appendingPathComponent(sensorFileName)
            do {
                let csvData = try String(contentsOf: sensorSimulationUrl)
                let sensorRows = csvData.components(separatedBy: "\n")
                for row in sensorRows {
                    let replacedRow = row.replacingOccurrences(of: "\r", with: "")
                    let columns = replacedRow.components(separatedBy: ",")
                    if columns[0] != "time" && columns.count > 1 {
                        var jupiterSensorData = SensorData()
                        jupiterSensorData.time = Double(columns[0])!
                        jupiterSensorData.acc = [Double(columns[1])!, Double(columns[2])!, Double(columns[3])!]
                        jupiterSensorData.userAcc = [Double(columns[4])!, Double(columns[5])!, Double(columns[6])!]
                        jupiterSensorData.gyro = [Double(columns[7])!, Double(columns[8])!, Double(columns[9])!]
                        jupiterSensorData.mag = [Double(columns[10])!, Double(columns[11])!, Double(columns[12])!]
                        jupiterSensorData.grav = [Double(columns[13])!, Double(columns[14])!, Double(columns[15])!]
                        jupiterSensorData.att = [Double(columns[16])!, Double(columns[17])!, Double(columns[18])!]
                        jupiterSensorData.quaternion = [Double(columns[19])!, Double(columns[20])!, Double(columns[21])!, Double(columns[22])!]
                        jupiterSensorData.rotationMatrix = [[Double(columns[23])!, Double(columns[24])!, Double(columns[25])!], [Double(columns[26])!, Double(columns[27])!, Double(columns[28])!], [Double(columns[29])!, Double(columns[30])!, Double(columns[31])!]]
                        jupiterSensorData.gameVector = [Float(columns[32])!, Float(columns[33])!, Float(columns[34])!, Float(columns[35])!]
                        jupiterSensorData.rotVector = [Float(columns[36])!, Float(columns[37])!, Float(columns[38])!, Float(columns[39])!, Float(columns[40])!]
                        jupiterSensorData.pressure = [Double(columns[41])!]
                        if (columns.count > 42) {
                            jupiterSensorData.trueHeading = Double(columns[42])!
                            jupiterSensorData.magneticHeading = Double(columns[43])!
                        }
                        loadedSenorData.append(jupiterSensorData)
                    }
                }
            } catch {
                print(getLocalTimeString() + " , (JupiterFileManager) : Error loading sensor file: \(error)")
            }
            
        } else {
            print(getLocalTimeString() + " , (JupiterFileManager) : Error creating export directory")
        }
        
        return (loadedBleData, loadedSenorData)
    }
}
