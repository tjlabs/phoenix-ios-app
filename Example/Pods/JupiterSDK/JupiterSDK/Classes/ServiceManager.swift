import Foundation
import CoreMotion
import UIKit

public class ServiceManager: Observation {
    public static let sdkVersion: String = "3.4.5.1"
    var isSimulationMode: Bool = false
    var bleFileName: String = ""
    var sensorFileName: String = ""
    
    var simulationBleData = [[String: Double]]()
    var simulationSensorData = [SensorData]()
    var bleLineCount: Int = 0
    var sensorLineCount: Int = 0
    
    func tracking(input: FineLocationTrackingResult, isPast: Bool) {
        for observer in observers {
            var result = input
            if (result.x != 0 && result.y != 0 && result.building_name != "" && result.level_name != "") {
                let validInfo = self.checkSolutionValidity(reportFlag: self.pastReportFlag, reportTime: self.pastReportTime, isIndoor: result.isIndoor)
                result.validity = validInfo.0
                result.validity_flag = validInfo.1
                if (result.ble_only_position) {
                    result.absolute_heading = 0
                }
                
                self.jupiterResult = result
                observer.update(result: result)
                
                if (self.isSaveFlag) {
                    let scale = self.normalizationScale
                    let deviceMin = self.deviceMinRss
                    let scCompensation = self.scCompensation
                    
                    let data = MobileResult(user_id: self.user_id, mobile_time: result.mobile_time, sector_id: self.sector_id, building_name: result.building_name, level_name: result.level_name, scc: result.scc, x: result.x, y: result.y, absolute_heading: result.absolute_heading, phase: result.phase, calculated_time: result.calculated_time, index: result.index, velocity: result.velocity, ble_only_position: result.ble_only_position, normalization_scale: scale, device_min_rss: Int(deviceMin), sc_compensation: scCompensation, is_indoor: result.isIndoor)
                    inputMobileResult.append(data)
                    if ((inputMobileResult.count-1) >= MR_INPUT_NUM) {
                        inputMobileResult.remove(at: 0)
                        NetworkManager.shared.postMobileResult(url: MR_URL, input: inputMobileResult, completion: { [self] statusCode, returnedStrig in
                            if (statusCode != 200) {
                                let localTime = getLocalTimeString()
                                let log: String = localTime + " , (Jupiter) Error \(statusCode) : Fail to send mobile result"
                                print(log)
                            }
                        })
                        inputMobileResult = [MobileResult(user_id: "", mobile_time: 0, sector_id: 0, building_name: "", level_name: "", scc: 0, x: 0, y: 0, absolute_heading: 0, phase: 0, calculated_time: 0, index: 0, velocity: 0, ble_only_position: false, normalization_scale: 0, device_min_rss: 0, sc_compensation: 0, is_indoor: false)]
                    }
                }
            }
        }
    }
    
    func reporting(input: Int) {
        if (input != -1 || input != -2) {
            self.pastReportTime = getCurrentTimeInMillisecondsDouble()
            self.pastReportFlag = input
        }

        postReport(report: input)
        for observer in observers {
            observer.report(flag: input)
        }
    }
    
    public var isSaveFlag: Bool = false
    var inputMobileResult: [MobileResult] = [MobileResult(user_id: "", mobile_time: 0, sector_id: 0, building_name: "", level_name: "", scc: 0, x: 0, y: 0, absolute_heading: 0, phase: 0, calculated_time: 0, index: 0, velocity: 0, ble_only_position: false, normalization_scale: 0, device_min_rss: 0, sc_compensation: 0, is_indoor: false)]
    
    
    // 1 ~ 7 : Release  //  0 : Test
    var serverType: Int = 7
    var region: String = "Korea"
    var regionName: String = "Korea"
    
    let jupiterServices: [String] = ["SD", "BD", "CLD", "FLD", "CLE", "FLT", "OSA"]
    var user_id: String = ""
    var sector_id: Int = 0
    var sectorIdOrigin: Int = 0
    var service: String = ""
    var mode: String = ""
    var runMode: String = ""
    var currentMode: String = ""
    
    var deviceModel: String = "Unknown"
    var deviceIdentifier: String = "Unknown"
    var deviceOsVersion: Int = 0
    var os: String = "Unknown"
    
    var LoadPathPoint = [String: Bool]()
    
    var EntranceArea = [String: [[Double]]]()
    var EntranceOuterWards = [String]()
    var EntranceWards = [String: [String: Int]]()
    var EntranceScales = [String: Double]()
    var allEntranceWards = [String]()
    var LevelChangeArea = [String: [[Double]]]()
    var EntranceNumbers: Int = 0
    var EntranceLevelInfo = [String: [String]]()
    var EntranceInfo = [String: [[Double]]]()
    var EntranceVelocityScale = [Double]()
    var currentEntrance: String = ""
    var currentEntranceLength: Int = 0
    var currentEntranceIndex: Int = 0
    var isStartSimulate: Bool = false
    var isPhaseBreakInSimulate: Bool = false
    var isStopReqeust: Bool = false
    var indexAfterSimulate: Int = 0
    var buildingsAndLevels = [String:[String]]()
    
    public var isLoadEnd = [String: [Bool]]()
    var isBackground: Bool = false
    var isForeground: Bool = false
    var timeBecomeForeground: Double = 0
    
    // ----- Sensor & BLE ----- //
    public var collectData = CollectData()
    var sensorManager = SensorManager()
    var jupiterLocationManager = JupiterLocationManager()
    var bleManager = BLECentralManager()
    // ------------------------ //
    
    // ----- ReceivedForceData ----- //
    var RFD_INPUT_NUM: Int = 7
    // ----------------------------- //
    
    // ----- UserVelocityData ----- //
    var UVD_INPUT_NUM: Int = 3
    var VALUE_INPUT_NUM: Int = 5
    var INIT_INPUT_NUM: Int = 3
    // ---------------------------- //
    
    var phaseController = PhaseController()
    var paramEstimator = ParameterEstimator()
    var pmCalculator = PathMatchingCalculator()
    
    // ----- Timer ----- //
    var backgroundUpTimer: DispatchSourceTimer?
    var backgroundUvTimer: DispatchSourceTimer?
    var backgroundTaskIdentifier: UIBackgroundTaskIdentifier?
    
    var receivedForceTimer: DispatchSourceTimer?
    var RFD_INTERVAL: TimeInterval = 1/2 // second
    var BLE_VALID_TIME: Double = 1000
    var bleTrimed = [String: [[Double]]]()
    var bleAvg = [String: Double]()
    var lastScannedEntranceOuterWardTime: Double = 0
    var detectNetworkBadEntrance: Bool = false
    var isInNetworkBadEntrance: Bool = false
    var networkBadEntrance: [String] = ["COEX_B0_1"]
    
    var userVelocityTimer: DispatchSourceTimer?
    var UVD_INTERVAL: TimeInterval = 1/40 // second
    var pastUvdTime: Int = 0
    var requestIndex: Int = 10
    var requestIndexPdr: Int = 4
    var requestIndexDr: Int = 10
    
    var updateTimer: DispatchSourceTimer?
    var UPDATE_INTERVAL: TimeInterval = 1/5 // second
    
    var osrTimer: DispatchSourceTimer?
    var OSR_INTERVAL: TimeInterval = 2
    var phase2ReqCount: Int = 0
    var phase2BadCount: Int = 0
    var isMovePhase2To4: Bool = false
    var isUnknownTraj: Bool = false
    var isNeedRemovePhase2To4Trajectroy: Bool = false
    var distanceAfterPhase2To4: Double = 0
    var SCC_FOR_PHASE4: Double = 0.5
    var isVenusMode: Bool = false
    var collectTimer: Timer?
    // ------------------ //
    
    
    // ----- Network ----- //
    var inputReceivedForce: [ReceivedForce] = [ReceivedForce(user_id: "", mobile_time: 0, ble: [:], pressure: 0)]
    var inputUserVelocity: [UserVelocity] = [UserVelocity(user_id: "", mobile_time: 0, index: 0, length: 0, heading: 0, looking: true)]
    // ------------------- //
    
    
    // ----- Fine Location Tracking ----- //
    var rflowCorrelator = RflowCorrelator()
    var bleData: [String: [[Double]]]?
    var unitDRInfo = UnitDRInfo()
    var unitDrBuffer: [UnitDRInfo] = []
    var unitDrInfoIndex: Int = 0
    var unitDRGenerator = UnitDRGenerator()
    var userTrajectory = TrajectoryInfo()
    var userTrajectoryInfo: [TrajectoryInfo] = []
    var pastUserTrajectoryInfo: [TrajectoryInfo] = []
    var pastSearchDirection: Int = 0
    var pastTailIndex: Int = 0
    var phase2Trajectory: [TrajectoryInfo] = []
    var phase2Range: [Int] = []
    var phase2Direction: [Int] = []
    var preSearchRange: [Int] = []
    var serverResultBuffer: [FineLocationTrackingFromServer] = []
    var DR_BUFFER_SIZE: Int = 30
    var DR_BUFFER_SIZE_FOR_STRAIGHT: Int = 10
    var USER_TRAJECTORY_LENGTH_ORIGIN: Double = 60
    var USER_TRAJECTORY_LENGTH: Double = 60
    var USER_TRAJECTORY_DIAGONAL: Double = 20
    var NUM_STRAIGHT_INDEX_DR = 10
    var NUM_STRAIGHT_INDEX_PDR = 10
    var magHeading: Double = 0
    
    var isStartFlag: Bool = false
    var isStartComplete: Bool = false
    var lookingState: Bool = true
    var isLookingCount: Int = 0
    var isNotLookingCount: Int = 0
    var isMoveNotLookingToLooking: Bool = false
    
    var preOutputMobileTime: Int = 0
    var preUnitHeading: Double = 0
    
    public var displayOutput = ServiceResult()
    
    var networkCount: Int = 0
    var isNetworkConnectReported: Bool = false
    var nowTime: Int = 0
    var RECENT_THRESHOLD: Int = 10000 // 2200
    var INDEX_THRESHOLD: Int = 11
    let VALID_BL_CHANGE_TIME = 7000
    
    let DEFAULT_SPOT_DISTANCE: Double = 80
    var lastOsrId: Int = 0
    var buildingLevelChangedTime: Int = 0
    var travelingOsrDistance: Double = 0
    var isDetermineSpot: Bool = false
    var spotCutIndex: Int = 15
    var accumulatedLengthWhenPhase2: Double = 0
    
    var isGetFirstResponse: Bool = false
    var indexAfterResponse: Int = 0
    
    var isPossibleNormalize: Bool = false
    var deviceMinRss: Double = -99.0
    var standardMinRss: Double = -99.0
    var standradMaxRss: Double = -58.0
    var normalizationScale: Double = 1.0
    var preNormalizationScale: Double = 1.0
    var isScaleLoaded: Bool = false
    var isScaleConverged: Bool = false
    
    var sccBadCount: Int = 0
    var scCompensationArray: [Double] = [0.8, 1.0, 1.2]
    var scCompensationArrayPdr: [Double] = [0.9, 1.0, 1.2]
    var scCompensation: Double = 1.0
    var scCompensationBadCount: Int = 0
    var scVelocityScale: Double = 1.0
    var entranceVelocityScale: Double = 1.0
    
    var scRequestTime: Int = 0
    var isScRequested: Bool = false
    // --------------------------------- //
    
    // ----- Fine Location Tracking ----- //
    var isMockMode: Bool = false
    var mockFltResult = FineLocationTrackingResult()
    var mockOsaResult: String = ""
    // --------------------------------- //
    
    // ----------- Kalman Filter ------------ //
    var phase: Int = 0
    var indexCurrent: Int = 0
    var indexPast: Int = 0
    
    var indexSend: Int = 0
    var sendFailUvdIndexes = [Int]()
    var validIndex: Int = 0
    var isNeedRemoveIndexSendFailArray: Bool = false
    
    var timeUpdateFlag: Bool = false
    var measurementUpdateFlag: Bool = false
    var isPhaseBreak: Bool = false
    var isNeedTrajInit: Bool = false
    
    var kalmanP: Double = 1
    var kalmanQ: Double = 0.3
    var kalmanR: Double = 0.5
    var kalmanK: Double = 1
    
    var updateHeading: Double = 0
    var headingKalmanP: Double = 0.5
    var headingKalmanQ: Double = 0.5
    var headingKalmanR: Double = 1
    var headingKalmanK: Double = 1
    
    var pastKalmanP: Double = 1
    var pastKalmanQ: Double = 0.3
    var pastKalmanR: Double = 0.5
    var pastKalmanK: Double = 1
    
    var pastHeadingKalmanP: Double = 0.5
    var pastHeadingKalmanQ: Double = 0.5
    var pastHeadingKalmanR: Double = 1
    var pastHeadingKalmanK: Double = 1
    // ------------------------------------- //
    
    var timeUpdatePosition = KalmanOutput()
    var measurementPosition = KalmanOutput()
    
    var timeUpdateOutput = FineLocationTrackingFromServer()
    var measurementOutput = FineLocationTrackingFromServer()
    var trajMatchingIndex: Int = 0
    
    var headingBeforePm: Double = 0
    var currentBuilding: String = ""
    var currentLevel: String = "0F"
    var currentSpot: Int = 0
    
    var isMapMatching: Bool = false
    var isLoadingPp: Bool = false
    
    var isActiveService: Bool = true
    var isActiveRF: Bool = true
    var isAnswered: Bool = false
    var isActiveKf: Bool = false
    var isStartKf: Bool = false
    var isStop: Bool = true
    var isSufficientRfd: Bool = false
    var isPossibleToIndoor: Bool = false
    var isBleOff: Bool = false
    
    var timeBleOff: Double = BLE_OFF_THRESHOLD
    var timeActiveRF: Double = 0
    var timeFailRF: Double = 0
    var timeActiveUV: Double = 0
    var timeRequest: Double = 0
    var timeSleepRF: Double = 0
    var timeSleepUV: Double = 0
    
    var lastTrackingTime: Int = 0
    var lastResult = FineLocationTrackingResult()
    var jupiterResult = FineLocationTrackingResult()
    var phaseBreakResult = FineLocationTrackingFromServer()
    
    var SQUARE_RANGE: Double = 10
    let SQUARE_RANGE_SMALL: Double = 10
    let SQUARE_RANGE_LARGE: Double = 20
    
    var pastMatchingResult: [Double] = [0, 0, 0, 0]
    
    var uvdIndexBuffer = [Int]()
    var uvdHeadingBuffer = [Double]()
    var tuResultBuffer = [[Double]]()
    var isNeedUvdIndexBufferClear: Bool = false
    var usedUvdIndex: Int = 0
    var currentTuResult = FineLocationTrackingResult()
    var pastTuResult = FineLocationTrackingResult()
    var headingBuffer = [Double]()
    var isNeedHeadingCorrection: Bool = false
    
    public var serverResult: [Double] = [0, 0, 0]
    public var timeUpdateResult: [Double] = [0, 0, 0]
    
    // Output
    var outputResult = FineLocationTrackingResult()
    var resultToReturn = FineLocationTrackingResult()
    var flagPast: Bool = false
    var lastOutputTime: Int = 0
    var pastOutputTime: Int = 0
    var isIndoor: Bool = false
    var pastReportTime: Double = 0
    var pastReportFlag: Int = 0
    var timeForInit: Double = 26
    public var TIME_INIT_THRESHOLD: Double = 25
    
    // State Observer
    private var venusObserver: Any!
    private var jupiterObserver: Any!
    
    public override init() {
        super.init()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        dateFormatter.locale = Locale(identifier:"ko_KR")
        let nowDate = Date()
        
        deviceIdentifier = UIDevice.modelIdentifier
        deviceModel = UIDevice.modelName
        os = UIDevice.current.systemVersion
        let arr = os.components(separatedBy: ".")
        deviceOsVersion = Int(arr[0]) ?? 0
    }
    
    public func initService(service: String, mode: String) -> (Bool, String) {
        let localTime = getLocalTimeString()
        let log: String = localTime + " , (Jupiter) Success : Service Initalization"
        
        var isSuccess: Bool = true
        var message: String = log
        
        if (service == "FLT" || service == "FLT+") {
            unitDRInfo = UnitDRInfo()
            unitDRGenerator.setMode(mode: mode)
            self.notificationCenterAddObserver()

            if (mode == "auto") {
                self.runMode = "dr"
                self.currentMode = "dr"
            } else if (mode == "pdr") {
                self.runMode = "pdr"
            } else if (mode == "dr") {
                self.runMode = "dr"
            } else {
                isSuccess = false
                message = localTime + " , (Jupiter) Error : Invalid Service Mode"
                return (isSuccess, message)
            }
            setModeParam(mode: self.runMode, phase: self.phase)
        }
        
        // Init Sensors
        let initSensors = sensorManager.initializeSensors()
        if (!initSensors.0) {
            isSuccess = initSensors.0
            message = initSensors.1
            
            return (isSuccess, message)
        }
        
        // Init Bluetooth
        let initBle = startBLE()
        if (!initBle.0) {
            isSuccess = initBle.0
            message = initBle.1
            
            return (isSuccess, message)
        }
        
        return (isSuccess, message)
    }
    
    public func enableMockMode() {
        let currentTime = getCurrentTimeInMilliseconds()
        self.isMockMode = true
        
        let input = JupiterMock(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id)
        NetworkManager.shared.postMock(url: MOCK_URL, input: input, completion: { [self] statusCode, returnedString in
            if (statusCode == 200) {
                let result = decodeMock(json: returnedString)
                let fltResult = result.FLT
                let osaResult = result.OSA
                
                self.mockFltResult.mobile_time = fltResult.mobile_time
                self.mockFltResult.building_name = fltResult.building_name
                self.mockFltResult.level_name = fltResult.level_name
                self.mockFltResult.scc = fltResult.scc
                self.mockFltResult.x = fltResult.x
                self.mockFltResult.y = fltResult.y
                self.mockFltResult.absolute_heading = fltResult.absolute_heading
                self.mockFltResult.phase = 3
                self.mockFltResult.calculated_time = fltResult.calculated_time
                self.mockFltResult.index = fltResult.index
                self.mockFltResult.velocity = displayOutput.velocity
                self.mockFltResult.mode = self.runMode
                self.mockFltResult.ble_only_position = self.isVenusMode
                self.mockFltResult.isIndoor = true
                
                if let encodingData = JSONConverter.encodeJson(param: osaResult) {
                    self.mockOsaResult = String(decoding: encodingData, as: UTF8.self)
                }
                print(getLocalTimeString() + " , (Jupiter) Success : Enable Mock Mode")
            } else {
                print(getLocalTimeString() + " , (Jupiter) Fail : Enable Mock Mode")
            }
        })
    }
    
    public func disableMockMode() {
        self.isMockMode = false
        print(getLocalTimeString() + " , (Jupiter) Success : Disable Mock Mode")
    }
    
    public func changeRegion(regionName: String) {
        self.regionName = regionName
        setRegion(regionName: regionName)
        setServerUrl(server: self.serverType)
    }
    
    public func setMinimumTimeForIndoorReport(time: Double) {
        self.TIME_INIT_THRESHOLD = time
        self.timeForInit = time + 1
    }
    
    public func saveSimulationFile() -> Bool {
        JupiterFileManager.shared.saveFilesForSimulation()
        return true
    }
    
    public func startService(id: String, sector_id: Int, service: String, mode: String, completion: @escaping (Bool, String) -> Void) {
        let localTime = getLocalTimeString()
        print(localTime + " , (Jupiter) Information : Try startService")
        let log: String = localTime + " , (Jupiter) Success : Service Initalization"
        var message: String = log
        
        self.sectorIdOrigin = sector_id
        self.sector_id = sector_id
        
        self.user_id = id
        self.service = service
        self.mode = mode
        if (mode == "auto") {
            self.runMode = "dr"
        } else {
            self.runMode = mode
        }
        
        var countBuildingLevel: Int = 0
        
        let numInput = 2
        let interval: Double = 1/2
        self.RFD_INPUT_NUM = numInput
        self.RFD_INTERVAL = interval
        
        if (!jupiterServices.contains(service)) {
            let log: String = getLocalTimeString() + " , (Jupiter) Error : Invalid Service Name"
            message = log
            completion(false, message)
        } else {
            if (self.isStartFlag) {
                message = getLocalTimeString() + " , (Jupiter) Error : Please stop another service"
                completion(false, message)
            } else {
                self.isStartFlag = true
                let initService = self.initService(service: service, mode: mode)
                if (!initService.0) {
                    message = initService.1
                    self.isStartFlag = false
                    self.notificationCenterRemoveObserver()
                    completion(false, message)
                } else {
                    setServerUrl(server: self.serverType)
                    
                    // Check Save Flag
                    let debugInput = MobileDebug(sector_id: sector_id)
                    NetworkManager.shared.postMobileDebug(url: DEBUG_URL, input: debugInput, completion: { [self] statusCode, returnedString in
                        if (statusCode == 200) {
                            let result = decodeMobileDebug(json: returnedString)
                            setSaveFlag(flag: result.sector_debug)
                        }
                    })

                    if (self.user_id.isEmpty || self.user_id.contains(" ")) {
                        let log: String = getLocalTimeString() + " , (Jupiter) Error : User ID(input = \(self.user_id)) cannot be empty or contain space"
                        message = log
                        self.isStartFlag = false
                        self.notificationCenterRemoveObserver()
                        completion(false, message)
                    } else {
                        // Login Success
                        let userInfo = UserLogin(user_id: self.user_id, device_model: deviceModel, os_version: deviceOsVersion, sdk_version: ServiceManager.sdkVersion)
                        NetworkManager.shared.postUserLogin(url: LOGIN_URL, input: userInfo, completion: { [self] statusCode, returnedString in
                            if (statusCode == 200) {
                                let log: String = getLocalTimeString() + " , (Jupiter) Success : User Login(input = \(self.user_id))"
                                print(log)
                                
                                let inputInfo = Info(sector_id: sector_id, operating_system: "ios")
                                NetworkManager.shared.postInfo(url: INFO_URL, input: inputInfo, completion: { [self] statusCode, returnedString in
                                    if (statusCode == 200) {
                                        let sectorInfoResult = jsonToInfoResult(json: returnedString)
                                        let entranceInfo = sectorInfoResult.entrances
                                        if (sectorInfoResult.standard_rss_list.isEmpty) {
                                            self.standardMinRss = -99.9
                                            self.standradMaxRss = -58.0
                                        } else {
                                            self.standardMinRss = Double(sectorInfoResult.standard_rss_list[0])
                                            self.standradMaxRss = Double(sectorInfoResult.standard_rss_list[1])
                                        }
                                        
                                        self.EntranceNumbers = entranceInfo.count
                                        var entranceOuterWards: [String] = []
                                        var entranceScales: [Double] = []
                                        for i in 0..<self.EntranceNumbers {
                                            entranceOuterWards.append(entranceInfo[i].outermost_ward_id)
                                            entranceScales.append(entranceInfo[i].entrance_scale)
                                            
                                            let entranceKey = "\(entranceInfo[i].entrance_number)"
                                            self.EntranceWards[entranceKey] = entranceInfo[i].entrance_rss
                                            self.EntranceScales[entranceKey] = entranceInfo[i].entrance_scale
                                            
                                            for (key, _) in entranceInfo[i].entrance_rss {
                                                let wardId: String = key
                                                self.allEntranceWards.append(wardId)
                                            }
                                        }
                                        self.EntranceOuterWards = entranceOuterWards
                                        self.EntranceVelocityScale = entranceScales

                                        let buildings_n_levels: [[String]] = sectorInfoResult.building_level
                                        var infoBuilding = [String]()
                                        var infoLevel = [String:[String]]()
                                        var infoLevelWithoutD = [String:[String]]()
                                        for building in 0..<buildings_n_levels.count {
                                            let buildingName: String = buildings_n_levels[building][0]
                                            // Building
                                            if !(infoBuilding.contains(buildingName)) {
                                                infoBuilding.append(buildingName)
                                            }
                                            
                                            // Level
                                            let levelName: String = buildings_n_levels[building][1]
                                            if let value = infoLevel[buildingName] {
                                                var levels:[String] = value
                                                levels.append(levelName)
                                                infoLevel[buildingName] = levels
                                            } else {
                                                let levels:[String] = [levelName]
                                                infoLevel[buildingName] = levels
                                            }
                                            
                                            if (!levelName.contains("_D")) {
                                                if let value = infoLevelWithoutD[buildingName] {
                                                    var levels:[String] = value
                                                    levels.append(levelName)
                                                    infoLevelWithoutD[buildingName] = levels
                                                } else {
                                                    let levels:[String] = [levelName]
                                                    infoLevelWithoutD[buildingName] = levels
                                                }
                                            }
                                        }
                                        self.buildingsAndLevels = infoLevel
                                        let countAll = countAllValuesInDictionary(infoLevelWithoutD)
                                        
                                        self.isMapMatching = true
                                        // Key-Value Saved
                                        for i in 0..<infoBuilding.count {
                                            let buildingName = infoBuilding[i]
                                            let levelList = infoLevelWithoutD[buildingName]
                                            for j in 0..<levelList!.count {
                                                let levelName = levelList![j]
                                                let key: String = "\(buildingName)_\(levelName)"
                                                self.LoadPathPoint[key] = true
                                                
                                                let url = self.getPpUrl(server: self.serverType, key: key)
                                                let urlComponents = URLComponents(string: url)
                                                let requestURL = URLRequest(url: (urlComponents?.url)!)
                                                let dataTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { [self] (data, response, error) in
                                                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                                                    
                                                    if (statusCode == 200) {
                                                        if let responseData = data {
                                                            if let utf8Text = String(data: responseData, encoding: .utf8) {
                                                                ( pmCalculator.PathType[key], pmCalculator.PathPoint[key], pmCalculator.PathMagScale[key], pmCalculator.PathHeading[key] ) = pmCalculator.parseRoad(data: utf8Text)
                                                                phaseController.pmCalculator.PathType[key] = pmCalculator.PathType[key]
                                                                phaseController.pmCalculator.PathPoint[key] = pmCalculator.PathPoint[key]
                                                                phaseController.pmCalculator.PathMagScale[key] = pmCalculator.PathMagScale[key]
                                                                phaseController.pmCalculator.PathHeading[key] = pmCalculator.PathHeading[key]
                                                                self.isLoadEnd[key] = [true, true]
                                                            }
                                                        }
                                                    } else {
                                                        self.isLoadEnd[key] = [true, false]
                                                    }
                                                })
                                                dataTask.resume()
                                                
                                                if (levelName == "B0") {
                                                    for i in 0..<self.EntranceNumbers {
                                                        let number = i+1
                                                        let entranceKey = key + "_\(number)"
                                                        
                                                        let loadedData = loadEntranceFromCache(key: entranceKey)
                                                        if (loadedData.0.isEmpty) {
                                                            print(getLocalTimeString() + " , (Jupiter) Information : Download Entrance-Info // \(entranceKey)")
                                                            loadEntranceFromUrl(key: entranceKey)
                                                        } else {
                                                            self.EntranceLevelInfo[entranceKey] = loadedData.0
                                                            self.EntranceInfo[entranceKey] = loadedData.1
                                                            print(getLocalTimeString() + " , (Jupiter) Information : Already have Entrance-Info // \(entranceKey)")
                                                        }
                                                    }
                                                }
                                            }
                                            
                                            for j in 0..<levelList!.count {
                                                let levelName = levelList![j]
                                                let input = JupiterGeo(sector_id: self.sector_id, building_name: buildingName, level_name: levelName)
                                                NetworkManager.shared.postGeo(url: GEO_URL, input: input, completion: { [self] statusCode, returnedString, buildingGeo, levelGeo in
                                                    if (statusCode >= 200 && statusCode <= 300) {
                                                        let result = decodeGeo(json: returnedString)
                                                        let key: String = "\(buildingGeo)_\(levelGeo)"
                                                        self.EntranceArea[key] = result.entrance_area
                                                        pmCalculator.EntranceMatchingArea[key] = result.entrance_matching_area
                                                        phaseController.pmCalculator.EntranceMatchingArea[key] = pmCalculator.EntranceMatchingArea[key]
                                                        self.LevelChangeArea[key] = result.level_change_area
                                                        
                                                        countBuildingLevel += 1
                                                        
                                                        if (countBuildingLevel == countAll) {
                                                            if (bleManager.bluetoothReady) {
                                                                // Load Trajectory Info
                                                                let inputGetTraj = JupiterTraj(sector_id: sector_id)
                                                                NetworkManager.shared.postTraj(url: TRAJ_URL, input: inputGetTraj, completion: { [self] statusCode, returnedString in
                                                                    if (statusCode == 200) {
                                                                        let resultTraj = decodeTraj(json: returnedString)
                                                                        self.USER_TRAJECTORY_LENGTH_ORIGIN = Double(resultTraj.trajectory_length + 10)
                                                                        self.USER_TRAJECTORY_LENGTH = Double(resultTraj.trajectory_length + 10)
                                                                        self.USER_TRAJECTORY_DIAGONAL = Double(resultTraj.trajectory_diagonal + 5)
                                                                        
                                                                        self.NUM_STRAIGHT_INDEX_DR = Int(ceil(self.USER_TRAJECTORY_LENGTH/6))
                                                                        self.NUM_STRAIGHT_INDEX_PDR = Int(ceil(self.USER_TRAJECTORY_DIAGONAL/6))
                                                                        self.phaseController.setPhaseLengthParam(lengthConditionPdr: Double(resultTraj.trajectory_diagonal), lengthConditionDr: Double(resultTraj.trajectory_length))
                                                                        print(getLocalTimeString() + " , (Jupiter) Trajectory Info Load : \(self.USER_TRAJECTORY_LENGTH) // \(self.USER_TRAJECTORY_DIAGONAL) // \(self.NUM_STRAIGHT_INDEX_DR)")
                                                                        
                                                                        // Load Bias
                                                                        let inputGetParam = JupiterParamGet(device_model: self.deviceModel, os_version: self.deviceOsVersion, sector_id: self.sector_id)
                                                                        NetworkManager.shared.getJupiterParam(url: RC_URL, input: inputGetParam, completion: { [self] statusCode, returnedString in
                                                                            let loadedScale = paramEstimator.loadNormalizationScale(sector_id: self.sector_id)
                                                                            if (statusCode == 200) {
                                                                                let result = decodeParam(json: returnedString)
                                                                                if (result.rss_compensations.isEmpty) {
                                                                                    let inputGetDeviceParam = JupiterDeviceParamGet(device_model: self.deviceModel, sector_id: self.sector_id)
                                                                                    NetworkManager.shared.getJupiterDeviceParam(url: RC_URL, input: inputGetDeviceParam, completion: { [self] statusCode, returnedString in
                                                                                        if (statusCode == 200) {
                                                                                            let result = decodeParam(json: returnedString)
                                                                                            if (result.rss_compensations.isEmpty) {
                                                                                                // Need Bias Estimation
                                                                                                self.isScaleLoaded = false
                                                                                                self.isStartComplete = true
                                                                                                self.startTimer()
                                                                                                
                                                                                                print(localTime + " , (Jupiter) Information : Need Estimation")
                                                                                                let log: String = localTime + " , (Jupiter) Success : Service Initalization"
                                                                                                message = log
                                                                                                self.reporting(input: START_FLAG)
                                                                                                self.initSimulationMode()
                                                                                                completion(true, message)
                                                                                            } else {
                                                                                                // Success Load without OS
                                                                                                if let closest = findClosestStructure(to: self.deviceOsVersion, in: result.rss_compensations) {
                                                                                                    let paramFromServer: rss_compensation = closest
                                                                                                    
                                                                                                    if (loadedScale.0) {
                                                                                                        self.normalizationScale = loadedScale.1
                                                                                                        self.preNormalizationScale = loadedScale.1
                                                                                                        print(localTime + " , (Jupiter) Load Param (Device // Cache) : \(loadedScale.0) , \(loadedScale.1)")
                                                                                                    } else {
                                                                                                        self.normalizationScale = paramFromServer.normalization_scale
                                                                                                        self.preNormalizationScale = paramFromServer.normalization_scale
                                                                                                        print(localTime + " , (Jupiter) Load Param (Device) : \(paramFromServer.normalization_scale)")
                                                                                                    }
                                                                                                    self.isScaleLoaded = true
                                                                                                    self.isStartComplete = true
                                                                                                    self.startTimer()
                                                                                                    
                                                                                                    let log: String = localTime + " , (Jupiter) Success : Service Initalization"
                                                                                                    message = log
                                                                                                    self.reporting(input: START_FLAG)
                                                                                                    self.initSimulationMode()
                                                                                                    completion(true, message)
                                                                                                } else {
                                                                                                    self.isScaleLoaded = false
                                                                                                    self.isStartComplete = true
                                                                                                    self.startTimer()
                                                                                                    
                                                                                                    print(localTime + " , (Jupiter) Information : Need Estimation")
                                                                                                    let log: String = localTime + " , (Jupiter) Success : Service Initalization"
                                                                                                    message = log
                                                                                                    self.reporting(input: START_FLAG)
                                                                                                    self.initSimulationMode()
                                                                                                    completion(true, message)
                                                                                                }
                                                                                            }
                                                                                        } else {
                                                                                            let log: String = getLocalTimeString() + " , (Jupiter) Error : Load Parameters (Device)"
                                                                                            message = log
                                                                                            self.stopTimer()
                                                                                            self.isStartFlag = false
                                                                                            self.notificationCenterRemoveObserver()
                                                                                            completion(false, message)
                                                                                        }
                                                                                    })
                                                                                } else {
                                                                                    // Succes Load Bias
                                                                                    let paramFromServer: rss_compensation = result.rss_compensations[0]
                                                                                    if (loadedScale.0) {
                                                                                        self.normalizationScale = loadedScale.1
                                                                                        self.preNormalizationScale = loadedScale.1
                                                                                        print(localTime + " , (Jupiter) Load Param (Device // Cache) : \(loadedScale.0) , \(loadedScale.1)")
                                                                                    } else {
                                                                                        self.normalizationScale = paramFromServer.normalization_scale
                                                                                        self.preNormalizationScale = paramFromServer.normalization_scale
                                                                                        print(localTime + " , (Jupiter) Load Param (Device) : \(paramFromServer.normalization_scale)")
                                                                                    }
                                                                                    self.isScaleLoaded = true
                                                                                    self.isStartComplete = true
                                                                                    self.startTimer()
                                                                                    
                                                                                    let log: String = localTime + " , (Jupiter) Success : Service Initalization"
                                                                                    message = log
                                                                                    self.reporting(input: START_FLAG)
                                                                                    self.initSimulationMode()
                                                                                    completion(true, message)
                                                                                }
                                                                            } else {
                                                                                let log: String = getLocalTimeString() + " , (Jupiter) Error : Load Parameters"
                                                                                message = log
                                                                                self.stopTimer()
                                                                                self.isStartFlag = false
                                                                                completion(false, message)
                                                                            }
                                                                        })
                                                                    } else {
                                                                        let log: String = getLocalTimeString() + " , (Jupiter) Error : Load Trajectory Info"
                                                                        message = log
                                                                        self.stopTimer()
                                                                        self.isStartFlag = false
                                                                        self.notificationCenterRemoveObserver()
                                                                        completion(false, message)
                                                                    }
                                                                })
                                                            } else {
                                                                let log: String = getLocalTimeString() + " , (Jupiter) Error : Bluetooth is not enabled"
                                                                message = log
                                                                self.stopTimer()
                                                                self.isStartFlag = false
                                                                self.notificationCenterRemoveObserver()
                                                                completion(false, message)
                                                            }
                                                        }
                                                    } else {
                                                        self.stopTimer()
                                                        if (!NetworkCheck.shared.isConnectedToInternet()) {
                                                            let log: String = getLocalTimeString() + " , (Jupiter) Error : Network is not connected"
                                                            message = log
                                                            self.isStartFlag = false
                                                            self.notificationCenterRemoveObserver()
                                                            completion(false, message)
                                                        } else {
                                                            let log: String = getLocalTimeString() + " , (Jupiter) Error : Load Abnormal Area // \(buildingGeo) \(levelGeo)"
                                                            message = log
                                                            self.isStartFlag = false
                                                            self.notificationCenterRemoveObserver()
                                                            completion(false, message)
                                                        }
                                                    }
                                                })
                                            }
                                        }
                                    } else {
                                        self.stopTimer()
                                        if (!NetworkCheck.shared.isConnectedToInternet()) {
                                            let log: String = getLocalTimeString() + " , (Jupiter) Error : Network is not connected"
                                            message = log
                                            self.isStartFlag = false
                                            self.notificationCenterRemoveObserver()
                                            completion(false, message)
                                        } else {
                                            let log: String = getLocalTimeString() + " , (Jupiter) Error : Load Building & Level Information"
                                            message = log
                                            self.isStartFlag = false
                                            self.notificationCenterRemoveObserver()
                                            completion(false, message)
                                        }
                                    }
                                })
                            } else {
                                self.stopTimer()
                                if (!NetworkCheck.shared.isConnectedToInternet()) {
                                    let log: String = getLocalTimeString() + " , (Jupiter) Error : Network is not connected"
                                    message = log
                                    self.isStartFlag = false
                                    self.notificationCenterRemoveObserver()
                                    completion(false, message)
                                } else {
                                    let log: String = getLocalTimeString() + " , (Jupiter) Error : User Login"
                                    message = log
                                    self.isStartFlag = false
                                    self.notificationCenterRemoveObserver()
                                    completion(false, message)
                                }
                            }
                        })
                    }
                }
            }
        }
    }
    
    public func setSimulationMode(flag: Bool, bleFileName: String, sensorFileName: String) {
        self.isSimulationMode = flag
        self.bleFileName = bleFileName
        self.sensorFileName = sensorFileName
        
        print(getLocalTimeString() + " , (Jupiter) Simulation Mode : flag = \(self.isSimulationMode)")
    }
    
    private func initSimulationMode() {
        if (isSimulationMode) {
            let result = JupiterFileManager.shared.loadFilesForSimulation(bleFile: self.bleFileName, sensorFile: self.sensorFileName)
            simulationBleData = result.0
            simulationSensorData = result.1
        } else {
            JupiterFileManager.shared.setRegion(region: region)
            JupiterFileManager.shared.createFiles(region: region, sector_id: sector_id, deviceModel: deviceModel, osVersion: deviceOsVersion)
        }
    }
    
    public func setSaveFlag(flag: Bool) {
        self.isSaveFlag = flag
        print(getLocalTimeString() + " , (Jupiter) Information : Set Save Flag = \(self.isSaveFlag)")
    }
    
    
    public func setServerUrl(server: Int) {
        if (server == 0) {
            SERVER_TYPE = "-t"
        } else if (server == 1) {
            SERVER_TYPE = ""
        } else {
            SERVER_TYPE = "-\(server)"
        }
        
        BASE_URL = CALC_URL + SERVER_TYPE + REGION + "/"
        setBaseURL(url: BASE_URL)
    }
    
    func getPpUrl(server: Int, key: String) -> String {
        var url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/pp/\(self.sectorIdOrigin)/\(key).csv"
        
        if (server == 0) {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/pp-test/\(self.sectorIdOrigin)/\(key).csv"
        } else if (server == 1) {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/pp/\(self.sectorIdOrigin)/\(key).csv"
        } else {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/pp-\(server)/\(self.sectorIdOrigin)/\(key).csv"
        }
        
        return url
    }
    
    func loadEntranceFromCache(key: String) -> ([String], [[Double]]) {
        let entranceKey: String = key
        
        var entranceLevel = [String]()
        var entrance = [[Double]]()
        
        if let entranceLevelInfo: [String] = UserDefaults.standard.object(forKey: entranceKey+"_level") as? [String] {
            entranceLevel = entranceLevelInfo
        }
        
        if let entranceInfo: [[Double]] = UserDefaults.standard.object(forKey: entranceKey) as? [[Double]] {
            entrance = entranceInfo
        }
        
        return (entranceLevel, entrance)
    }
    
    func saveEntranceToCache(key: String, entranceLevelData: [String], entranceData: [[Double]]) {
        do {
            UserDefaults.standard.set(entranceLevelData, forKey: key+"_level")
            print(getLocalTimeString() + " , (Jupiter) Success : Save EntranceInfoLevel \(key)")
        } catch {
            print(getLocalTimeString() + " , (Jupiter) Error : Fail to save EntranceInfoLevel \(key)")
        }
        
        do {
            UserDefaults.standard.set(entranceData, forKey: key)
            print(getLocalTimeString() + " , (Jupiter) Success : Save EntranceInfo \(key)")
        } catch {
            print(getLocalTimeString() + " , (Jupiter) Error : Fail to save EntranceInfo \(key)")
        }
    }
    
    func loadEntranceFromUrl(key: String) {
        let entranceKey = key
        let entranceUrl = self.getEntranceUrl(server: self.serverType, key: entranceKey)
        let entranceUrlComponents = URLComponents(string: entranceUrl)
        let entranceRequestURL = URLRequest(url: (entranceUrlComponents?.url)!)
        let entranceDataTask = URLSession.shared.dataTask(with: entranceRequestURL, completionHandler: { [self] (data, response, error) in
            let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
            if (statusCode == 200) {
                if let responseData = data {
                    if let utf8Text = String(data: responseData, encoding: .utf8) {
                        let parsedData = self.parseEntrance(data: utf8Text)
                        self.EntranceLevelInfo[entranceKey] = parsedData.0
                        self.EntranceInfo[entranceKey] = parsedData.1
                        print(getLocalTimeString() + " , (Jupiter) Success : Load EntranceInfo from url // \(entranceKey)")
                        self.saveEntranceToCache(key: entranceKey, entranceLevelData: parsedData.0, entranceData: parsedData.1)
                    }
                }
            } else {
                let log: String = getLocalTimeString() + " , (Jupiter) Warnings : Load \(entranceKey) EntranceInfo"
                print(log)
            }
        })
        entranceDataTask.resume()
    }
    
    func getEntranceUrl(server: Int, key: String) -> String {
        var url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/entrance/\(self.sectorIdOrigin)/\(key).csv"
        
        if (server == 0) {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/entrance-test/\(self.sectorIdOrigin)/\(key).csv"
        } else if (server == 1) {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/entrance/\(self.sectorIdOrigin)/\(key).csv"
        } else {
            url = "https://storage.googleapis.com/\(IMAGE_URL)/ios/entrance-\(server)/\(self.sectorIdOrigin)/\(key).csv"
        }
        
        return url
    }
    
    public func stopService() -> (Bool, String) {
        let localTime: String = getLocalTimeString()
        var message: String = localTime + " , (Jupiter) Success : Stop Service"
        
        if (self.isStartComplete) {
            self.notificationCenterRemoveObserver()
            self.stopTimer()
            self.stopBLE()
            
            if (self.service == "FLT" || self.service == "FLT+") {
                unitDRInfo = UnitDRInfo()
                userTrajectory = TrajectoryInfo()
                paramEstimator.saveNormalizationScale(scale: self.normalizationScale, sector_id: self.sector_id)
                self.postParam(sector_id: self.sector_id, normailzationScale: self.normalizationScale)
            }
            
            self.initVariables()
            self.isStartFlag = false
            self.isStartComplete = false
            displayOutput.phase = String(0)
            self.isMapMatching = false
            
            return (true, message)
        } else {
            self.notificationCenterRemoveObserver()
            message = localTime + " , (Jupiter) Fail : After the service has fully started, it can be stop "
            return (false, message)
        }
    }
    
    public func forceStopService() {
        self.notificationCenterRemoveObserver()
        self.stopTimer()
        self.stopBLE()
        
        if (self.service == "FLT" || self.service == "FLT+") {
            unitDRInfo = UnitDRInfo()
            userTrajectory = TrajectoryInfo()
            paramEstimator.saveNormalizationScale(scale: self.normalizationScale, sector_id: self.sector_id)
            self.postParam(sector_id: self.sector_id, normailzationScale: self.normalizationScale)
        }
        
        self.initVariables()
        self.isStartFlag = false
        self.isStartComplete = false
        displayOutput.phase = String(0)
        self.isMapMatching = false
    }
    
    public func setBackgroundMode(flag: Bool) {
        if (flag) {
            self.runBackgroundMode()
        } else {
            self.runForegroundMode()
        }
    }
    
    func runBackgroundMode() {
        self.isBackground = true
        self.unitDRGenerator.setIsBackground(isBackground: true)
        self.bleManager.stopScan()
        self.stopTimer()
            
        if let existingTaskIdentifier = self.backgroundTaskIdentifier {
            UIApplication.shared.endBackgroundTask(existingTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid
        }

        self.backgroundTaskIdentifier = UIApplication.shared.beginBackgroundTask(withName: "BackgroundOutputTimer") {
            UIApplication.shared.endBackgroundTask(self.backgroundTaskIdentifier!)
            self.backgroundTaskIdentifier = .invalid
        }
            
        if (self.backgroundUpTimer == nil) {
            self.backgroundUpTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
            self.backgroundUpTimer!.schedule(deadline: .now(), repeating: UPDATE_INTERVAL)
            self.backgroundUpTimer!.setEventHandler(handler: self.outputTimerUpdate)
            self.backgroundUpTimer!.resume()
        }
            
        if (self.backgroundUvTimer == nil) {
            self.backgroundUvTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
            self.backgroundUvTimer!.schedule(deadline: .now(), repeating: UVD_INTERVAL)
            self.backgroundUvTimer!.setEventHandler(handler: self.userVelocityTimerUpdate)
            self.backgroundUvTimer!.resume()
        }
            
        self.bleTrimed = [String: [[Double]]]()
        self.bleAvg = [String: Double]()
        self.reporting(input: BACKGROUND_FLAG)
    }
    
    func runForegroundMode() {
        if let existingTaskIdentifier = self.backgroundTaskIdentifier {
            UIApplication.shared.endBackgroundTask(existingTaskIdentifier)
            self.backgroundTaskIdentifier = .invalid
        }
            
        self.backgroundUpTimer?.cancel()
        self.backgroundUvTimer?.cancel()
        self.backgroundUpTimer = nil
        self.backgroundUvTimer = nil
            
        self.bleManager.startScan(option: .Foreground)
        self.startTimer()
            
        self.isBackground = false
        self.unitDRGenerator.setIsBackground(isBackground: false)
        self.isForeground = true
        self.timeBecomeForeground = getCurrentTimeInMillisecondsDouble()
        self.reporting(input: FOREGROUND_FLAG)
    }
    
    private func initVariables() {
        self.timeBleOff = BLE_OFF_THRESHOLD
        self.timeForInit = 0
        self.timeFailRF = 0
        self.lastScannedEntranceOuterWardTime = 0
        
        self.inputReceivedForce = [ReceivedForce(user_id: user_id, mobile_time: 0, ble: [:], pressure: 0)]
        self.inputUserVelocity = [UserVelocity(user_id: user_id, mobile_time: 0, index: 0, length: 0, heading: 0, looking: true)]
        self.inputMobileResult = [MobileResult(user_id: "", mobile_time: 0, sector_id: 0, building_name: "", level_name: "", scc: 0, x: 0, y: 0, absolute_heading: 0, phase: 0, calculated_time: 0, index: 0, velocity: 0, ble_only_position: false, normalization_scale: 0, device_min_rss: 0, sc_compensation: 0, is_indoor: false)]
        self.indexAfterResponse = 0
        self.indexAfterSimulate = 0
        self.lastOsrId = 0
        self.phase = 0
        
        self.timeRequest = 0
        self.isPhaseBreak = false
        self.isGetFirstResponse = false
        self.isNeedTrajInit = false
        
        self.isActiveKf = false
        self.updateHeading = 0
        self.timeUpdateFlag = false
        self.measurementUpdateFlag = false
        
        self.timeUpdatePosition = KalmanOutput()
        self.measurementPosition = KalmanOutput()
        self.timeUpdateOutput = FineLocationTrackingFromServer()
        self.measurementOutput = FineLocationTrackingFromServer()
        
        self.timeUpdateResult = [0, 0, 0]
        
        self.isStartSimulate = false
        unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
        self.isPhaseBreakInSimulate = false
        self.currentEntrance = ""
        self.currentEntranceLength = 0
        self.currentEntranceIndex = 0
        
        self.detectNetworkBadEntrance = false
        self.isInNetworkBadEntrance = false
        self.isScaleConverged = false
    }
    
    func notificationCenterAddObserver() {
        self.venusObserver = NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNotification), name: .didBecomeVenus, object: nil)
        self.jupiterObserver = NotificationCenter.default.addObserver(self, selector: #selector(onDidReceiveNotification), name: .didBecomeJupiter, object: nil)
    }
    
    func notificationCenterRemoveObserver() {
        NotificationCenter.default.removeObserver(self.venusObserver)
        NotificationCenter.default.removeObserver(self.jupiterObserver)
    }
    
    @objc func onDidReceiveNotification(_ notification: Notification) {
        if notification.name == .didBecomeVenus {
            self.phase = 1
            self.isActiveKf = false
            self.timeUpdateFlag = false
            self.measurementUpdateFlag = false
            self.timeUpdatePosition = KalmanOutput()
            self.measurementPosition = KalmanOutput()
            self.timeUpdateOutput = FineLocationTrackingFromServer()
            self.measurementOutput = FineLocationTrackingFromServer()
            self.isVenusMode = true
            self.isStartSimulate = false
            unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
            self.reporting(input: VENUS_FLAG)
        }
    
        if notification.name == .didBecomeJupiter {
            self.isVenusMode = false
            self.reporting(input: JUPITER_FLAG)
        }
    }
    
    public func initCollect() {
        unitDRGenerator.setMode(mode: "pdr")
        sensorManager.initializeSensors()
        startBLE()
        startCollectTimer()
    }
    
    public func startCollect() {
        isStartFlag = true
    }
    
    public func stopCollect() {
        stopCollectTimer()
        stopBLE()
        
        isStartFlag = false
    }
    
    public func getResult(completion: @escaping (Int, String) -> Void) {
        let currentTime: Int = getCurrentTimeInMilliseconds()
        
        switch(self.service) {
        case "SD":
            let input = CoarseLevelDetection(user_id: self.user_id, mobile_time: currentTime, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), standard_min_rss: Int(self.standardMinRss))
            NetworkManager.shared.postCLD(url: CLD_URL, input: input, completion: { statusCode, returnedString in
                let sdString = CLDtoSD(json: returnedString)
                completion(statusCode, sdString)
            })
        case "BD":
            let input = CoarseLevelDetection(user_id: self.user_id, mobile_time: currentTime, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), standard_min_rss: Int(self.standardMinRss))
            NetworkManager.shared.postCLD(url: CLD_URL, input: input, completion: { statusCode, returnedString in
                let bdString = CLDtoBD(json: returnedString)
                completion(statusCode, bdString)
            })
        case "CLD":
            let input = CoarseLevelDetection(user_id: self.user_id, mobile_time: currentTime, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), standard_min_rss: Int(self.standardMinRss))
            NetworkManager.shared.postCLD(url: CLD_URL, input: input, completion: { statusCode, returnedString in
                completion(statusCode, returnedString)
            })
        case "FLD":
            let input = CoarseLocationEstimation(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id, search_direction_list: [0, 90, 180, 270], normalization_scale: self.normalizationScale, device_min_rss: Int(self.standardMinRss))
            NetworkManager.shared.postCLE(url: CLE_URL, input: input, completion: { statusCode, returnedString in
                let fldString = CLEtoFLD(json: returnedString)
                completion(statusCode, fldString)
            })
        case "CLE":
            let input = CoarseLocationEstimation(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id, search_direction_list: [0, 90, 180, 270], normalization_scale: self.normalizationScale, device_min_rss: Int(self.standardMinRss))
            NetworkManager.shared.postCLE(url: CLE_URL, input: input, completion: { statusCode, returnedString in
                completion(statusCode, returnedString)
            })
        case "OSA":
            let input = OnSpotAuthorization(user_id: self.user_id, mobile_time: currentTime)
            NetworkManager.shared.postOSA(url: OSA_URL, input: input, completion: { statusCode, returnedString in
                completion(statusCode, returnedString)
            })
        default:
            completion(500, "(Jupiter) Error : Invalid Service Name")
        }
    }
    
    public func getSpotResult(completion: @escaping (Int, String) -> Void) {
        let currentTime: Int = getCurrentTimeInMilliseconds()
        
        if (self.isMockMode) {
            if (self.mockOsaResult != "") {
                completion(200, self.mockOsaResult)
            } else {
                let input = JupiterMock(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id)
                NetworkManager.shared.postMock(url: MOCK_URL, input: input, completion: { [self] statusCode, returnedString in
                    if (statusCode == 200) {
                        let result = decodeMock(json: returnedString)
                        let osaResult = result.OSA
                        if let encodingData = JSONConverter.encodeJson(param: osaResult) {
                            self.mockOsaResult = String(decoding: encodingData, as: UTF8.self)
                        }
                    }
                })
            }
        } else {
            if (self.user_id != "") {
                let input = OnSpotAuthorization(user_id: self.user_id, mobile_time: currentTime)
                NetworkManager.shared.postOSA(url: OSA_URL, input: input, completion: { statusCode, returnedString in
                    completion(statusCode, returnedString)
                })
            } else {
                completion(500, " , (Jupiter) Error : Invalid User ID")
            }
        }
    }
    
    public func getRecentResult(id: String, completion: @escaping (Int, FineLocationTrackingFromServer) -> Void) {
        let currentTime: Int = getCurrentTimeInMilliseconds()
        let input = RecentResult(user_id: id, mobile_time: currentTime)
        NetworkManager.shared.postRecent(url: RECENT_URL, input: input, completion: { [self] statusCode, returnedString in
            if (statusCode == 200) {
                let result = jsonToResult(json: returnedString)
                var recentResult = result
                
                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: result.x, y: result.y, heading: result.absolute_heading, isPast: false, HEADING_RANGE: 46, isUseHeading: true, pathType: 0, range: 10)
                let resultTime: Int = result.mobile_time
                let resultIndex = result.index
                let resultBuildingName: String = result.building_name
                let resultLevelNameAll: String = result.level_name
                let resultLevelName: String = removeLevelDirectionString(levelName: resultLevelNameAll)
                
                recentResult.building_name = resultBuildingName
                recentResult.level_name = resultLevelName
                recentResult.x = pathMatchingResult.xyhs[0]
                recentResult.y = pathMatchingResult.xyhs[1]
                recentResult.absolute_heading = pathMatchingResult.xyhs[2]
                
                completion(statusCode, recentResult)
            } else {
                completion(statusCode, FineLocationTrackingFromServer())
            }
        })
    }
    
    public func getRecentJupiterResult(id: String, completion: @escaping (Int, JupiterToDisplay) -> Void) {
        var recentResult = JupiterToDisplay()
        let currentTime = getCurrentTimeInMilliseconds()
        
        let input = RecentResult(user_id: id, mobile_time: currentTime)
        NetworkManager.shared.postRecent(url: RECENT_URL, input: input, completion: { [self] statusCode, returnedString in
            if (statusCode == 200) {
                let decodedResult = jsonToRecent(json: returnedString)
                recentResult.building = decodedResult.building_name
                recentResult.level = decodedResult.level_name
                
                let pmResultWithHeading = pmCalculator.pathMatching(building: decodedResult.building_name, level: decodedResult.level_name, x: decodedResult.x, y: decodedResult.y, heading: decodedResult.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                
                if (pmResultWithHeading.isSuccess) {
                    recentResult.x = pmResultWithHeading.xyhs[0]
                    recentResult.y = pmResultWithHeading.xyhs[1]
                    recentResult.heading = pmResultWithHeading.xyhs[2]
                } else {
                    let pmResult = pmCalculator.pathMatching(building: decodedResult.building_name, level: decodedResult.level_name, x: decodedResult.x, y: decodedResult.y, heading: decodedResult.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 1, range: SQUARE_RANGE)
                    recentResult.x = pmResult.xyhs[0]
                    recentResult.y = pmResult.xyhs[1]
                    recentResult.heading = pmResult.xyhs[2]
                }
                recentResult.isIndoor = true
                
                completion(statusCode, recentResult)
            } else {
                completion(statusCode, recentResult)
            }
        })
    }
    
    func startBLE() -> (Bool, String) {
        let localTime: String = getLocalTimeString()
        
        let isSuccess: Bool = true
        let message: String = localTime + " , (Jupiter) Success : Bluetooth Initialization"
        
        bleManager.setValidTime(mode: self.runMode)
        bleManager.startScan(option: .Foreground)
        
        return (isSuccess, message)
    }
    
    
    func stopBLE() {
        bleManager.stopScan()
    }
    
    func startTimer() {
        if (self.receivedForceTimer == nil) {
            let queueRFD = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".receivedForceTimer")
            self.receivedForceTimer = DispatchSource.makeTimerSource(queue: queueRFD)
            self.receivedForceTimer!.schedule(deadline: .now(), repeating: RFD_INTERVAL)
            self.receivedForceTimer!.setEventHandler(handler: self.receivedForceTimerUpdate)
            self.receivedForceTimer!.resume()
        }
        
        if (self.userVelocityTimer == nil) {
            let queueUVD = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".userVelocityTimer")
            self.userVelocityTimer = DispatchSource.makeTimerSource(queue: queueUVD)
            self.userVelocityTimer!.schedule(deadline: .now(), repeating: UVD_INTERVAL)
            self.userVelocityTimer!.setEventHandler(handler: self.userVelocityTimerUpdate)
            self.userVelocityTimer!.resume()
        }
        
        
        if (self.updateTimer == nil) {
            let queueUP = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".updateTimer")
            self.updateTimer = DispatchSource.makeTimerSource(queue: queueUP)
            self.updateTimer!.schedule(deadline: .now(), repeating: UPDATE_INTERVAL)
            self.updateTimer!.setEventHandler(handler: self.outputTimerUpdate)
            self.updateTimer!.resume()
        }
        
        
        if (self.osrTimer == nil) {
            let queueOSR = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".osrTimer")
            self.osrTimer = DispatchSource.makeTimerSource(queue: queueOSR)
            self.osrTimer!.schedule(deadline: .now(), repeating: OSR_INTERVAL)
            self.osrTimer!.setEventHandler(handler: self.osrTimerUpdate)
            self.osrTimer!.resume()
        }
    }
    
    func stopTimer() {
        self.receivedForceTimer?.cancel()
        self.userVelocityTimer?.cancel()
        self.osrTimer?.cancel()
        self.updateTimer?.cancel()
        self.backgroundUpTimer?.cancel()
        
        self.receivedForceTimer = nil
        self.userVelocityTimer = nil
        self.osrTimer = nil
        self.updateTimer = nil
        self.backgroundUvTimer = nil
    }
    
    func enterSleepMode() {
        let localTime: String = getLocalTimeString()
        print(localTime + " , (Jupiter) Enter Sleep Mode")
        self.updateTimer?.cancel()
        self.updateTimer = nil
    }
    
    func wakeUpFromSleepMode() {
        if (self.service == "FLT" || self.service == "FLT+") {
            if (self.updateTimer == nil && !self.isBackground) {
                let queue = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".updateTimer")
                self.updateTimer = DispatchSource.makeTimerSource(queue: queue)
                self.updateTimer!.schedule(deadline: .now(), repeating: UPDATE_INTERVAL)
                self.updateTimer!.setEventHandler(handler: self.outputTimerUpdate)
                self.updateTimer!.resume()
            }
        }
    }
    
    func startCollectTimer() {
        if (self.collectTimer == nil) {
            self.collectTimer = Timer.scheduledTimer(timeInterval: UVD_INTERVAL, target: self, selector: #selector(self.collectTimerUpdate), userInfo: nil, repeats: true)
            RunLoop.current.add(self.collectTimer!, forMode: .common)
        }
    }
    
    func stopCollectTimer() {
        if (self.collectTimer != nil) {
            self.collectTimer!.invalidate()
            self.collectTimer = nil
        }
    }
    
    @objc func outputTimerUpdate() {
        if (self.isActiveService) {
            let currentTime = getCurrentTimeInMilliseconds()
            
            if (self.isMockMode) {
                if (self.mockFltResult.building_name != "") {
                    self.tracking(input: self.mockFltResult, isPast: false)
                } else {
                    let input = JupiterMock(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id)
                    NetworkManager.shared.postMock(url: MOCK_URL, input: input, completion: { [self] statusCode, returnedString in
                        if (statusCode == 200) {
                            let result = decodeMock(json: returnedString)
                            let fltResult = result.FLT
                            
                            self.mockFltResult.mobile_time = fltResult.mobile_time
                            self.mockFltResult.building_name = fltResult.building_name
                            self.mockFltResult.level_name = fltResult.level_name
                            self.mockFltResult.scc = fltResult.scc
                            self.mockFltResult.x = fltResult.x
                            self.mockFltResult.y = fltResult.y
                            self.mockFltResult.absolute_heading = fltResult.absolute_heading
                            self.mockFltResult.phase = 3
                            self.mockFltResult.calculated_time = fltResult.calculated_time
                            self.mockFltResult.index = fltResult.index
                            self.mockFltResult.velocity = displayOutput.velocity
                            self.mockFltResult.mode = self.runMode
                            self.mockFltResult.ble_only_position = self.isVenusMode
                            self.mockFltResult.isIndoor = true
                        }
                    })
                }
            } else {
                var resultToReturn = self.resultToReturn
                resultToReturn.mode = self.runMode
                resultToReturn.mobile_time = currentTime
                resultToReturn.ble_only_position = self.isVenusMode
                resultToReturn.velocity = displayOutput.velocity
                resultToReturn.isIndoor = self.isIndoor
                
                self.tracking(input: resultToReturn, isPast: self.flagPast)
                self.lastOutputTime = currentTime
            }
        }
    }
    
    func makeOutputResult(input: FineLocationTrackingResult, isPast: Bool, runMode: String, isVenusMode: Bool) -> FineLocationTrackingResult {
        var result = input
        if (result.x != 0 && result.y != 0 && result.building_name != "" && result.level_name != "") {
            result.index = self.unitDrInfoIndex
            result.absolute_heading = compensateHeading(heading: result.absolute_heading)
            result.mode = runMode
            
            let buildingName: String = result.building_name
            let levelName: String = removeLevelDirectionString(levelName: result.level_name)
            
            // Map Matching
            if (self.isMapMatching) {
                self.headingBeforePm = result.absolute_heading
                if (runMode == "pdr") {
                    let isUseHeading: Bool = false
                    let correctResult = pmCalculator.pathMatching(building: buildingName, level: levelName, x: result.x, y: result.y, heading: result.absolute_heading, isPast: isPast, HEADING_RANGE: HEADING_RANGE, isUseHeading: isUseHeading, pathType: 0, range: SQUARE_RANGE)
                    if (correctResult.isSuccess) {
                        displayOutput.isPmSuccess = true
                        result.x = correctResult.xyhs[0]
                        result.y = correctResult.xyhs[1]
                        result.absolute_heading = correctResult.xyhs[2]
                    } else {
                        displayOutput.isPmSuccess = false
                        let localTime: String = getLocalTimeString()
                        
                        let key: String = "\(buildingName)_\(levelName)"
                        
                        var isLoadPathPoint: Bool = true
                        if let isLoad: Bool = self.LoadPathPoint[key] { isLoadPathPoint = isLoad }
                        if let mainRoad: [[Double]] = pmCalculator.PathPoint[key] {
                            self.LoadPathPoint[key] = true
                        } else {
                            if (isLoadPathPoint) {
                                self.LoadPathPoint[key] = false
                                let url = self.getPpUrl(server: self.serverType, key: key)
                                
                                let urlComponents = URLComponents(string: url)
                                let requestURL = URLRequest(url: (urlComponents?.url)!)
                                let dataTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { [self] (data, response, error) in
                                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                                    if (statusCode == 200) {
                                        if let responseData = data {
                                            if let utf8Text = String(data: responseData, encoding: .utf8) {
                                                ( pmCalculator.PathType[key], pmCalculator.PathPoint[key], pmCalculator.PathMagScale[key], pmCalculator.PathHeading[key] ) = pmCalculator.parseRoad(data: utf8Text)
                                                phaseController.pmCalculator.PathType[key] = pmCalculator.PathType[key]
                                                phaseController.pmCalculator.PathPoint[key] = pmCalculator.PathPoint[key]
                                                phaseController.pmCalculator.PathMagScale[key] = pmCalculator.PathMagScale[key]
                                                phaseController.pmCalculator.PathHeading[key] = pmCalculator.PathHeading[key]
                                                self.LoadPathPoint[key] = true
                                                let log: String = localTime + " , (Jupiter) Success : Load \(buildingName) \(levelName) Path-Point (when PP was empty)"
                                                print(log)
                                            }
                                        }
                                    } else {
                                        let log: String = localTime + " , (Jupiter) Warnings : Load \(buildingName) \(levelName) Path-Point (When Pp was empty)"
                                        print(log)
                                    }
                                })
                                dataTask.resume()
                            }
                        }
                        
                        
                        if (self.isActiveKf) {
                            result = self.lastResult
                        } else {
                            let correctResult = pmCalculator.pathMatching(building: buildingName, level: levelName, x: result.x, y: result.y, heading: result.absolute_heading, isPast: isPast, HEADING_RANGE: HEADING_RANGE, isUseHeading: isUseHeading, pathType: 0, range: SQUARE_RANGE)
                            if (correctResult.isSuccess) {
                                result.x = correctResult.xyhs[0]
                                result.y = correctResult.xyhs[1]
                                result.absolute_heading = correctResult.xyhs[2]
                            }
                        }
                    }
                } else {
                    var isUseHeading: Bool = true
                    if (isVenusMode) {
                        isUseHeading = false
                    }
                    let correctResult = pmCalculator.pathMatching(building: buildingName, level: levelName, x: result.x, y: result.y, heading: result.absolute_heading, isPast: isPast, HEADING_RANGE: HEADING_RANGE, isUseHeading: isUseHeading, pathType: 1, range: SQUARE_RANGE)
                    unitDRGenerator.setVelocityScaleFactor(scaleFactor: correctResult.xyhs[3])
                    if (correctResult.isSuccess) {
                        displayOutput.isPmSuccess = true
                        result.x = correctResult.xyhs[0]
                        result.y = correctResult.xyhs[1]
                        result.absolute_heading = correctResult.xyhs[2]
                    } else {
                        displayOutput.isPmSuccess = false
                        let localTime: String = getLocalTimeString()
                        
                        let key: String = "\(buildingName)_\(levelName)"
                        
                        var isLoadPathPoint: Bool = true
                        if let isLoad: Bool = self.LoadPathPoint[key] { isLoadPathPoint = isLoad }
                        if let mainRoad: [[Double]] = pmCalculator.PathPoint[key] {
                            self.LoadPathPoint[key] = true
                        } else {
                            if (isLoadPathPoint) {
                                self.LoadPathPoint[key] = false
                                let url = self.getPpUrl(server: self.serverType, key: key)
                                
                                let urlComponents = URLComponents(string: url)
                                let requestURL = URLRequest(url: (urlComponents?.url)!)
                                let dataTask = URLSession.shared.dataTask(with: requestURL, completionHandler: { [self] (data, response, error) in
                                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 500
                                    if (statusCode == 200) {
                                        if let responseData = data {
                                            if let utf8Text = String(data: responseData, encoding: .utf8) {
                                                ( pmCalculator.PathType[key], pmCalculator.PathPoint[key], pmCalculator.PathMagScale[key], pmCalculator.PathHeading[key] ) = pmCalculator.parseRoad(data: utf8Text)
                                                phaseController.pmCalculator.PathType[key] = pmCalculator.PathType[key]
                                                phaseController.pmCalculator.PathPoint[key] = pmCalculator.PathPoint[key]
                                                phaseController.pmCalculator.PathMagScale[key] = pmCalculator.PathMagScale[key]
                                                phaseController.pmCalculator.PathHeading[key] = pmCalculator.PathHeading[key]
                                                self.LoadPathPoint[key] = true
                                                let log: String = localTime + " , (Jupiter) Success : Load \(buildingName) \(levelName) Path-Point (when PP was empty)"
                                                print(log)
                                            }
                                        }
                                    } else {
                                        let log: String = localTime + " , (Jupiter) Warnings : Load \(buildingName) \(levelName) Path-Point (When Pp was empty)"
                                        print(log)
                                    }
                                })
                                dataTask.resume()
                            }
                        }
                        
                        if (self.isActiveKf) {
                            result = self.lastResult
                        } else {
                            result.x = correctResult.xyhs[0]
                            result.y = correctResult.xyhs[1]
                            result.absolute_heading = correctResult.xyhs[2]
                        }
                    }
                }
            }
            
            result.isIndoor = self.isIndoor
            result.level_name = removeLevelDirectionString(levelName: result.level_name)
            result.velocity = round(displayOutput.velocity*100)/100
            if (isVenusMode) {
                result.phase = 1
            }
            
            displayOutput.heading = result.absolute_heading
            displayOutput.building = buildingName
            displayOutput.level = levelName
            
            self.lastResult = result
        }
        
        displayOutput.mode = runMode
       
        return result
    }
    
    @objc func receivedForceTimerUpdate() {
        handleRfd()
    }
    
    private func handleRfd() {
        let localTime: String = getLocalTimeString()
        if (isSimulationMode) {
            bleManager.setValidTime(mode: self.runMode)
            self.setValidTime(mode: self.runMode)
            let validTime = self.BLE_VALID_TIME
            let currentTime = getCurrentTimeInMilliseconds() - (Int(validTime)/2)
            if (bleLineCount < simulationBleData.count-1) {
                let bleData = simulationBleData[bleLineCount]
                self.bleAvg = bleData
                let scannedResult = getLastScannedEntranceOuterWardTime(bleAvg: self.bleAvg, entranceOuterWards: self.EntranceOuterWards)
                if (scannedResult.0) {
                    self.lastScannedEntranceOuterWardTime = scannedResult.1
                }
                
                if (!self.isGetFirstResponse) {
                    let findResult = findNetworkBadEntrance(bleAvg: self.bleAvg)
                    self.detectNetworkBadEntrance = findResult.0
                    
                    if (!self.isIndoor && (self.timeForInit >= TIME_INIT_THRESHOLD)) {
                        if (self.detectNetworkBadEntrance) {
                            self.isGetFirstResponse = true
                            self.isIndoor = true
                            self.reporting(input: INDOOR_FLAG)
                            
                            let result = findResult.1
                            
                            self.outputResult.phase = 3
                            self.outputResult.building_name = result.building_name
                            self.outputResult.level_name = result.level_name
                            self.outputResult.isIndoor = self.isIndoor
                            
                            for i in 0..<self.EntranceNumbers {
                                if (!self.isStartSimulate) {
                                    let entranceResult = self.findEntrance(result: result, entrance: i)
                                    if (entranceResult.0 != 0) {
                                        let entranceKey: String = "\(entranceResult.0)"
                                        if let velocityScale: Double = self.EntranceScales[entranceKey] {
                                            self.entranceVelocityScale = velocityScale
                                        } else {
                                            self.entranceVelocityScale = 1.0
                                        }
                                        self.currentEntrance = "\(result.building_name)_\(result.level_name)_\(entranceResult.0)"
                                        if (self.networkBadEntrance.contains(self.currentEntrance)) {
                                            self.isInNetworkBadEntrance = true
                                        }
                                        self.currentEntranceLength = entranceResult.1
                                        self.isStartSimulate = true
                                        unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                                    }
                                }
                            }
                        }
                    }
                }
                
                paramEstimator.refreshWardMinRssi(bleData: self.bleAvg)
                paramEstimator.refreshWardMaxRssi(bleData: self.bleAvg)
                let maxRssi = paramEstimator.getMaxRssi()
                let minRssi = paramEstimator.getMinRssi()
                let diffMinMaxRssi = abs(maxRssi - minRssi)
                if (minRssi <= -97) {
                    let deviceMin: Double = paramEstimator.getDeviceMinRss()
                    self.deviceMinRss = deviceMin
                }
                if (self.isGetFirstResponse && self.isIndoor && (self.unitDrInfoIndex%4 == 0) && diffMinMaxRssi >= 25 && minRssi <= -97) {
                    if (self.isScaleLoaded) {
                        if (self.currentLevel != "B0") {
                            let normalizationScale = paramEstimator.calNormalizationScale(standardMin: self.standardMinRss, standardMax: self.standradMaxRss)
                            if (!self.isScaleConverged) {
                                if (normalizationScale.0) {
                                    let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: normalizationScale.1)
                                    self.normalizationScale = smoothedScale
                                    let diffScale = abs(smoothedScale - self.preNormalizationScale)
                                    if (diffScale < 1e-3 && self.indexAfterResponse >= 700 && (smoothedScale != self.preNormalizationScale)) {
                                        self.isScaleConverged = true
                                    }
                                    self.preNormalizationScale = smoothedScale
                                } else {
                                    let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: self.preNormalizationScale)
                                    self.normalizationScale = smoothedScale
                                }
                            }
                        }
                    } else {
                        if (!self.isScaleConverged) {
                            let normalizationScale = paramEstimator.calNormalizationScale(standardMin: self.standardMinRss, standardMax: self.standradMaxRss)
                            if (normalizationScale.0) {
                                let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: normalizationScale.1)
                                self.normalizationScale = smoothedScale
                                let diffScale = abs(smoothedScale - self.preNormalizationScale)
                                if (diffScale < 1e-3 && self.indexAfterResponse >= 700 && (smoothedScale != self.preNormalizationScale)) {
                                    self.isScaleConverged = true
                                }
                                self.preNormalizationScale = smoothedScale
                            } else {
                                let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: self.preNormalizationScale)
                                self.normalizationScale = smoothedScale
                            }
                        }
                    }
                }
                
                if (!self.isBackground) {
                    paramEstimator.refreshAllEntranceWardRssi(allEntranceWards: self.allEntranceWards, bleData: self.bleAvg)
                    let isSufficientRfdBuffer = rflowCorrelator.accumulateRfdBuffer(bleData: self.bleAvg)
                    let isSufficientRfdVelocityBuffer = rflowCorrelator.accumulateRfdVelocityBuffer(bleData: self.bleAvg)
                    let isSufficientRfdAutoMode = rflowCorrelator.accumulateRfdAutoModeBuffer(bleData: self.bleAvg)
                    if(!self.isStartSimulate) {
                        unitDRGenerator.setRflow(rflow: rflowCorrelator.getRflow(), rflowForVelocity: rflowCorrelator.getRflowForVelocityScale(), rflowForAutoMode: rflowCorrelator.getRflowForAutoMode(), isSufficient: isSufficientRfdBuffer, isSufficientForVelocity: isSufficientRfdVelocityBuffer, isSufficientForAutoMode: isSufficientRfdAutoMode)
                    }
                }
                
                if (!self.bleAvg.isEmpty) {
                    self.timeBleOff = 0
                    self.timeActiveRF = 0
                    self.timeSleepRF = 0
                    
                    self.isActiveRF = true
                    self.isBleOff = false
                    self.isActiveService = true
                    
                    self.wakeUpFromSleepMode()
                    if (self.isActiveService) {
                        let data = ReceivedForce(user_id: self.user_id, mobile_time: currentTime, ble: self.bleAvg, pressure: self.sensorManager.pressure)
                        
                        inputReceivedForce.append(data)
                        if ((inputReceivedForce.count-1) >= RFD_INPUT_NUM) {
                            inputReceivedForce.remove(at: 0)
                            NetworkManager.shared.postReceivedForce(url: RF_URL, input: inputReceivedForce, completion: { [self] statusCode, returnedString, inputRfd in
                                if (statusCode != 200) {
                                    let localTime = getLocalTimeString()
                                    let log: String = localTime + " , (Jupiter) Record Error : RFD \(statusCode) // " + returnedString
                                    
                                    if (self.isIndoor && self.isGetFirstResponse && !self.isBackground) {
                                        print(log)
                                        self.reporting(input: RFD_FLAG)
                                    }
                                }
                            })
                            inputReceivedForce = [ReceivedForce(user_id: "", mobile_time: 0, ble: [:], pressure: 0)]
                        }
                    }
                } else if (!self.isBackground) {
                    // Add
                    let lastBleDiscoveredTime: Double = bleManager.bleDiscoveredTime
                    let cTime = getCurrentTimeInMillisecondsDouble()
                    if (cTime - lastBleDiscoveredTime > BLE_VALID_TIME && lastBleDiscoveredTime != 0) {
                        self.timeActiveRF += RFD_INTERVAL
                    } else {
                        self.timeActiveRF = 0
                    }
                    
                    if (self.timeActiveRF >= SLEEP_THRESHOLD_RF) {
                        self.isActiveRF = false
                        // Here
                        if (self.isIndoor && self.isGetFirstResponse) {
                            if (!self.isBleOff) {
                                let lastResult = self.resultToReturn
                                let isOutdoor = self.determineIsOutdoor(lastResult: lastResult, currentTime: cTime, inFailCondition: false)
                                if (isOutdoor) {
                                    self.initVariables()
                                    self.currentLevel = "B0"
                                    self.isIndoor = false
                                    self.reporting(input: OUTDOOR_FLAG)
                                }
                            }
                        }
                    }
                    
                    self.timeSleepRF += RFD_INTERVAL
                    if (self.timeSleepRF >= SLEEP_THRESHOLD) {
                        self.isActiveService = false
                        self.timeSleepRF = 0
                        self.enterSleepMode()
                    }
                }
                
                bleLineCount += 1
            }
        } else {
            if (!bleManager.bluetoothReady) {
                self.timeBleOff += RFD_INTERVAL
                if (self.timeBleOff >= BLE_OFF_THRESHOLD) {
                    if (!self.isBleOff) {
                        self.isBleOff = true
                        self.timeBleOff = 0
                        self.reporting(input: BLE_OFF_FLAG)
                    }
                }
            } else {
                let checkLastScannedTime = (getCurrentTimeInMillisecondsDouble() - bleManager.bleLastScannedTime)*1e-3
                if (checkLastScannedTime >= 6) {
                    // 스캔이 동작안한지 6초 이상 지남
                    self.reporting(input: BLE_SCAN_STOP_FLAG)
                }
            }
            
            bleManager.setValidTime(mode: self.runMode)
            self.setValidTime(mode: self.runMode)
            let validTime = self.BLE_VALID_TIME
            let currentTime = getCurrentTimeInMilliseconds() - (Int(validTime)/2)
            let bleDictionary: [String: [[Double]]]? = bleManager.bleDictionary
            if let bleData = bleDictionary {
                let trimmedResult = trimBleData(bleInput: bleData, nowTime: getCurrentTimeInMillisecondsDouble(), validTime: validTime)
                switch trimmedResult {
                case .success(let trimmedData):
                    self.bleAvg = avgBleData(bleDictionary: trimmedData)
                    let scannedResult = getLastScannedEntranceOuterWardTime(bleAvg: self.bleAvg, entranceOuterWards: self.EntranceOuterWards)
                    if (scannedResult.0) {
                        self.lastScannedEntranceOuterWardTime = scannedResult.1
                    }
                    
                    if (!self.isGetFirstResponse) {
                        let findResult = findNetworkBadEntrance(bleAvg: self.bleAvg)
                        self.detectNetworkBadEntrance = findResult.0
                        
                        if (!self.isIndoor && (self.timeForInit >= TIME_INIT_THRESHOLD)) {
                            if (self.detectNetworkBadEntrance) {
                                self.isGetFirstResponse = true
                                self.isIndoor = true
                                self.reporting(input: INDOOR_FLAG)
                                
                                let result = findResult.1
                                
                                self.outputResult.phase = 3
                                self.outputResult.building_name = result.building_name
                                self.outputResult.level_name = result.level_name
                                self.outputResult.isIndoor = self.isIndoor
                                
                                for i in 0..<self.EntranceNumbers {
                                    if (!self.isStartSimulate) {
                                        let entranceResult = self.findEntrance(result: result, entrance: i)
                                        if (entranceResult.0 != 0) {
                                            let entranceKey: String = "\(entranceResult.0)"
                                            if let velocityScale: Double = self.EntranceScales[entranceKey] {
                                                self.entranceVelocityScale = velocityScale
                                            } else {
                                                self.entranceVelocityScale = 1.0
                                            }
                                            self.currentEntrance = "\(result.building_name)_\(result.level_name)_\(entranceResult.0)"
                                            if (self.networkBadEntrance.contains(self.currentEntrance)) {
                                                self.isInNetworkBadEntrance = true
                                            }
                                            self.currentEntranceLength = entranceResult.1
                                            self.isStartSimulate = true
                                            unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    if (self.isIndoor && self.isGetFirstResponse && !self.isBackground) {
                        let diffTime = (getCurrentTimeInMillisecondsDouble() - self.timeBecomeForeground)*1e-3
                        if (!self.isBleOff && diffTime > 5) {
                            self.reporting(input: BLE_ERROR_FLAG)
                            let lastResult = self.resultToReturn
                            let isFailTrimBle = self.determineIsOutdoor(lastResult: lastResult, currentTime: getCurrentTimeInMillisecondsDouble(), inFailCondition: true)
                            if (isFailTrimBle) {
                                self.bleAvg = [String: Double]()
                            }
                        }
                    }
                }
    //            self.bleAvg = ["TJ-00CB-0000038C-0000":-76.0] // COEX B2 <-> B3
    //            self.bleAvg = ["TJ-00CB-0000030D-0000":-76.0] // COEX B2
    //            self.bleAvg = ["TJ-00CB-00000242-0000":-76.0] // S3 7F
    //            self.bleAvg = ["TJ-00CB-000003E7-0000":-76.0] // Plan Group
    //            self.bleAvg = ["TJ-00CB-00000464-0000":-76.0] // ASJTM
    //            self.bleAvg = ["TJ-00CB-0000033B-0000":-62.0] // DS 3F
                
                paramEstimator.refreshWardMinRssi(bleData: self.bleAvg)
                paramEstimator.refreshWardMaxRssi(bleData: self.bleAvg)
                let maxRssi = paramEstimator.getMaxRssi()
                let minRssi = paramEstimator.getMinRssi()
                let diffMinMaxRssi = abs(maxRssi - minRssi)
                if (minRssi <= -97) {
                    let deviceMin: Double = paramEstimator.getDeviceMinRss()
                    self.deviceMinRss = deviceMin
                }
                if (self.isGetFirstResponse && self.isIndoor && (self.unitDrInfoIndex%4 == 0) && diffMinMaxRssi >= 25 && minRssi <= -97) {
                    if (self.isScaleLoaded) {
                        if (self.currentLevel != "B0") {
                            let normalizationScale = paramEstimator.calNormalizationScale(standardMin: self.standardMinRss, standardMax: self.standradMaxRss)
                            if (!self.isScaleConverged) {
                                if (normalizationScale.0) {
                                    let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: normalizationScale.1)
                                    self.normalizationScale = smoothedScale
                                    let diffScale = abs(smoothedScale - self.preNormalizationScale)
                                    if (diffScale < 1e-3 && self.indexAfterResponse >= 700 && (smoothedScale != self.preNormalizationScale)) {
                                        self.isScaleConverged = true
                                    }
                                    self.preNormalizationScale = smoothedScale
                                } else {
                                    let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: self.preNormalizationScale)
                                    self.normalizationScale = smoothedScale
                                }
                            }
                        }
                    } else {
                        if (!self.isScaleConverged) {
                            let normalizationScale = paramEstimator.calNormalizationScale(standardMin: self.standardMinRss, standardMax: self.standradMaxRss)
                            if (normalizationScale.0) {
                                let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: normalizationScale.1)
                                self.normalizationScale = smoothedScale
                                let diffScale = abs(smoothedScale - self.preNormalizationScale)
                                if (diffScale < 1e-3 && self.indexAfterResponse >= 700 && (smoothedScale != self.preNormalizationScale)) {
                                    self.isScaleConverged = true
                                }
                                self.preNormalizationScale = smoothedScale
                            } else {
                                let smoothedScale: Double = paramEstimator.smoothNormalizationScale(scale: self.preNormalizationScale)
                                self.normalizationScale = smoothedScale
                            }
                        }
                    }
                }
                
                if (!self.isBackground) {
                    paramEstimator.refreshAllEntranceWardRssi(allEntranceWards: self.allEntranceWards, bleData: self.bleAvg)
                    let isSufficientRfdBuffer = rflowCorrelator.accumulateRfdBuffer(bleData: self.bleAvg)
                    let isSufficientRfdVelocityBuffer = rflowCorrelator.accumulateRfdVelocityBuffer(bleData: self.bleAvg)
                    let isSufficientRfdAutoMode = rflowCorrelator.accumulateRfdAutoModeBuffer(bleData: self.bleAvg)
                    if(!self.isStartSimulate) {
                        unitDRGenerator.setRflow(rflow: rflowCorrelator.getRflow(), rflowForVelocity: rflowCorrelator.getRflowForVelocityScale(), rflowForAutoMode: rflowCorrelator.getRflowForAutoMode(), isSufficient: isSufficientRfdBuffer, isSufficientForVelocity: isSufficientRfdVelocityBuffer, isSufficientForAutoMode: isSufficientRfdAutoMode)
                    }
                }
                
                if (!self.bleAvg.isEmpty) {
                    self.timeBleOff = 0
                    self.timeActiveRF = 0
                    self.timeSleepRF = 0
                    
                    self.isActiveRF = true
                    self.isBleOff = false
                    self.isActiveService = true
                    
                    self.wakeUpFromSleepMode()
                    if (self.isActiveService) {
                        let data = ReceivedForce(user_id: self.user_id, mobile_time: currentTime, ble: self.bleAvg, pressure: self.sensorManager.pressure)
                        
                        inputReceivedForce.append(data)
                        if ((inputReceivedForce.count-1) >= RFD_INPUT_NUM) {
                            inputReceivedForce.remove(at: 0)
                            NetworkManager.shared.postReceivedForce(url: RF_URL, input: inputReceivedForce, completion: { [self] statusCode, returnedString, inputRfd in
                                if (statusCode != 200) {
                                    let localTime = getLocalTimeString()
                                    let log: String = localTime + " , (Jupiter) Record Error : RFD \(statusCode) // " + returnedString
                                    
                                    if (self.isIndoor && self.isGetFirstResponse && !self.isBackground) {
                                        print(log)
                                        self.reporting(input: RFD_FLAG)
                                    }
                                }
                            })
                            inputReceivedForce = [ReceivedForce(user_id: "", mobile_time: 0, ble: [:], pressure: 0)]
                        }
                    }
                } else if (!self.isBackground) {
                    // Add
                    let lastBleDiscoveredTime: Double = bleManager.bleDiscoveredTime
                    let cTime = getCurrentTimeInMillisecondsDouble()
                    if (cTime - lastBleDiscoveredTime > BLE_VALID_TIME && lastBleDiscoveredTime != 0) {
                        self.timeActiveRF += RFD_INTERVAL
                    } else {
                        self.timeActiveRF = 0
                    }
                    
                    if (self.timeActiveRF >= SLEEP_THRESHOLD_RF) {
                        self.isActiveRF = false
                        // Here
                        if (self.isIndoor && self.isGetFirstResponse) {
                            if (!self.isBleOff) {
                                let lastResult = self.resultToReturn
                                let isOutdoor = self.determineIsOutdoor(lastResult: lastResult, currentTime: cTime, inFailCondition: false)
                                if (isOutdoor) {
                                    self.initVariables()
                                    self.currentLevel = "B0"
                                    self.isIndoor = false
                                    self.reporting(input: OUTDOOR_FLAG)
                                }
                            }
                        }
                    }
                    
                    self.timeSleepRF += RFD_INTERVAL
                    if (self.timeSleepRF >= SLEEP_THRESHOLD) {
                        self.isActiveService = false
                        self.timeSleepRF = 0
                        self.enterSleepMode()
                    }
                }
            } else {
                let log: String = localTime + " , (Jupiter) Warnings : Fail to get recent ble"
                print(log)
            }
            
            JupiterFileManager.shared.writeBleData(time: currentTime, data: bleAvg)
            
            if (!self.isIndoor) {
                self.timeForInit += RFD_INTERVAL
            }
        }
    }
    
    @objc func userVelocityTimerUpdate() {
        sensorManager.setRunMode(mode: self.runMode)
        let currentTime = getCurrentTimeInMilliseconds()
        let localTime = getLocalTimeString()
        // UV Control
        setModeParam(mode: self.runMode, phase: self.phase)
        
        var sensorData = SensorData()
        sensorData.time = Double(currentTime)

        if (service.contains("FLT")) {
            if (isSimulationMode) {
                if (sensorLineCount < simulationSensorData.count-1) {
                    sensorData = simulationSensorData[sensorLineCount]
                    sensorLineCount += 1
                }
            } else {
                sensorData = sensorManager.sensorData
            }
            unitDRInfo = unitDRGenerator.generateDRInfo(sensorData: sensorData)
            JupiterFileManager.shared.writeSensorData(data: sensorData)
        }
        
        var backgroundScale: Double = 1.0
        if (self.isBackground && self.runMode == "dr") {
            let diffTime = currentTime - self.pastUvdTime
            backgroundScale = Double(diffTime)/(1000/SAMPLE_HZ)
        }
        self.pastUvdTime = currentTime
        
        if (unitDRInfo.isIndexChanged && !self.isVenusMode) {
            self.headingBuffer.append(unitDRInfo.heading)
            self.isNeedHeadingCorrection = self.checkHeadingCorrection(buffer: self.headingBuffer)
            
            self.unitDrBuffer.append(self.unitDRInfo)
            if (self.unitDrBuffer.count > DR_BUFFER_SIZE) {
                self.unitDrBuffer.remove(at: 0)
            }
            
            self.wakeUpFromSleepMode()
            self.timeActiveUV = 0
            self.timeSleepUV = 0
            
            self.isStop = false
            self.isActiveService = true
            
            displayOutput.isIndexChanged = unitDRInfo.isIndexChanged
            displayOutput.indexTx = unitDRInfo.index
            displayOutput.length = unitDRInfo.length
            displayOutput.velocity = unitDRInfo.velocity * 3.6
            
            var curUnitDRLength: Double = 0
            if (self.isBackground) {
                curUnitDRLength = unitDRInfo.length*backgroundScale
            } else {
                curUnitDRLength = unitDRInfo.length
            }
            curUnitDRLength = round(curUnitDRLength*10000)/10000
            self.unitDrInfoIndex = unitDRInfo.index
            
            if (self.mode == "auto") {
                let autoMode = unitDRInfo.autoMode
                if (autoMode == 0) {
                    self.runMode = "pdr"
                    self.sector_id = self.sectorIdOrigin - 1
                    self.kalmanR = 10
                } else {
                    self.runMode = "dr"
                    self.sector_id = self.sectorIdOrigin
                    self.kalmanR = 1
                }
                
                if (self.runMode != self.currentMode) {
                    self.isNeedTrajInit = true
                    self.phase = 1
                }
                self.currentMode = self.runMode
                
                setModeParam(mode: self.runMode, phase: self.phase)
            }
            
            let data = UserVelocity(user_id: self.user_id, mobile_time: currentTime, index: unitDRInfo.index, length: curUnitDRLength, heading: round(unitDRInfo.heading*100)/100, looking: unitDRInfo.lookingFlag)
            timeUpdateOutput.index = unitDRInfo.index
            inputUserVelocity.append(data)
            
            let isLooking = unitDRInfo.lookingFlag
            if (self.lookingState) {
                // I'm looking
                if (!isLooking) {
                    self.isNotLookingCount += 1
                } else {
                    self.isNotLookingCount = 0
                }
                if (self.isNotLookingCount > 5) {
                    // Looking True -> False
                    self.lookingState = false
                }
            } else {
                // I'm not looking
                if (isLooking) {
                    self.isLookingCount += 1
                } else {
                    self.isLookingCount = 0
                }
                if (self.isLookingCount > 2) {
                    // Looking False -> True
                    self.lookingState = true
                    self.isMoveNotLookingToLooking = true
                }
            }
            
            if (!self.lookingState) {
                self.phase = 1
            }
            
            if (self.isActiveService) {
                if (self.isMovePhase2To4) {
                    self.distanceAfterPhase2To4 += curUnitDRLength
                    if (self.distanceAfterPhase2To4 >= USER_TRAJECTORY_LENGTH*0.8) {
                        self.distanceAfterPhase2To4 = 0
                        self.isMovePhase2To4 = false
                    }
                }
                
                if (self.isGetFirstResponse && self.runMode == "dr") {
                    let lastResult = self.lastResult
                    if (lastResult.building_name != "" && lastResult.level_name != "") {
                        self.travelingOsrDistance += curUnitDRLength
                    }
                }
                
                if (self.isGetFirstResponse && self.isIndoor) {
                    self.indexAfterResponse += 1
                }
                
                // Check Entrance Level
                let isEntrance = self.checkInEntranceLevel(result: self.jupiterResult, isGetFirstResponse: self.isGetFirstResponse, isStartSimulate: self.isStartSimulate)
                unitDRGenerator.setIsEntranceLevel(flag: isEntrance)
                
                if (self.isGetFirstResponse) {
                    if (self.isStartSimulate) {
                        self.indexAfterSimulate += 1
                        unitDRGenerator.setEntranceVelocityScaleFactor(scaleFactor: self.entranceVelocityScale)
                    } else {
                        unitDRGenerator.setEntranceVelocityScaleFactor(scaleFactor: 1.0)
                    }
                }
                
                
                // Make User Trajectory Buffer
                var numChannels: Int = 0
                let bleData: [String: Double]? = self.bleAvg
                if let bleAvgData = bleData {
                    numChannels = checkBleChannelNum(bleDict: bleAvgData)
                }

                
                // Kalman Filter
                let diffHeading = unitDRInfo.heading - self.preUnitHeading
                self.preUnitHeading = unitDRInfo.heading
                
                // Time Update
                if (self.isActiveKf) {
                    if (self.timeUpdateFlag) {
                        let tuOutput = timeUpdate(length: curUnitDRLength, diffHeading: diffHeading, mobileTime: currentTime, isNeedHeadingCorrection: isNeedHeadingCorrection, drBuffer: self.unitDrBuffer, runMode: self.runMode)
                        var tuResult = fromServerToResult(fromServer: tuOutput, velocity: displayOutput.velocity, resultPhase: self.phase)
                        
                        self.timeUpdateResult[0] = tuResult.x
                        self.timeUpdateResult[1] = tuResult.y
                        self.timeUpdateResult[2] = tuResult.absolute_heading
                        
                        if (self.isNeedUvdIndexBufferClear) {
                            self.uvdIndexBuffer = sliceArray(self.uvdIndexBuffer, startingFrom: self.usedUvdIndex)
                            self.uvdHeadingBuffer = sliceArray(self.uvdHeadingBuffer, startingFrom: self.usedUvdIndex)
                            self.tuResultBuffer = sliceArray(self.tuResultBuffer, startingFrom: self.usedUvdIndex)
                            self.isNeedUvdIndexBufferClear = false
                        }
                        
                        self.uvdIndexBuffer.append(unitDRInfo.index)
                        self.uvdHeadingBuffer.append(unitDRInfo.heading)
                        self.tuResultBuffer.append([tuResult.x, tuResult.y, tuResult.absolute_heading])
                        
                        self.currentTuResult = tuResult
                        
                        let trackingTime = getCurrentTimeInMilliseconds()
                        tuResult.mobile_time = trackingTime
                        self.outputResult = tuResult
                        self.flagPast = false
                    }
                } else {
                    self.timeUpdateResult[0] = self.outputResult.x
                    self.timeUpdateResult[1] = self.outputResult.y
                    self.timeUpdateResult[2] = self.outputResult.absolute_heading
                }
                makeTrajectoryInfo(unitDRInfo: self.unitDRInfo, uvdLength: curUnitDRLength, resultToReturn: self.resultToReturn, tuHeading: self.updateHeading, isPmSuccess: self.displayOutput.isPmSuccess, bleChannels: numChannels, mode: self.runMode)
                
                // Add
                if (self.isStartSimulate) {
                    if (self.currentEntranceIndex < self.currentEntranceLength) {
                        let entraceKey: String = self.currentEntrance
                        let entranceWardKey: [String] = entraceKey.components(separatedBy: "_")
                        if let entranceWards = self.EntranceWards[entranceWardKey[entranceWardKey.count-1]] {
                            paramEstimator.refreshEntranceWardRssi(entranceWard: entranceWards, bleData: self.bleAvg)
                        }
                        
                        self.resultToReturn = self.simulateEntrance(originalResult: self.outputResult, runMode: self.runMode, currentEntranceIndex: self.currentEntranceIndex)
                        if (self.currentEntranceIndex == 0) {
                            self.isIndoor = true
                            self.reporting(input: INDOOR_FLAG)
                        }
                        self.currentEntranceIndex += 1
                        if (self.isVenusMode) {
                            print(getLocalTimeString() + " , (Jupiter) Entrance Simulator : Finish (BLE Only Mode)")
                            self.isStartSimulate = false
                            unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                            self.isPhaseBreakInSimulate = false
                            self.detectNetworkBadEntrance = false
                            self.isInNetworkBadEntrance = false
                            self.indexAfterSimulate = 0
                            self.currentEntrance = ""
                            self.currentEntranceLength = 0
                            self.currentEntranceIndex = 0
                        } else {
                            if (self.resultToReturn.level_name != "B0") {
                                let cLevel = removeLevelDirectionString(levelName: self.currentLevel)
                                if (self.isActiveKf && (cLevel == self.resultToReturn.level_name)) {
                                    self.timeUpdatePosition.x = self.outputResult.x
                                    self.timeUpdatePosition.y = self.outputResult.y
                                    self.timeUpdatePosition.heading = self.outputResult.absolute_heading
                                    self.timeUpdateOutput.x = self.outputResult.x
                                    self.timeUpdateOutput.y = self.outputResult.y
                                    self.timeUpdateOutput.absolute_heading = self.outputResult.absolute_heading
                                    self.measurementPosition.x = self.outputResult.x
                                    self.measurementPosition.y = self.outputResult.y
                                    self.measurementPosition.heading = self.outputResult.absolute_heading
                                    self.measurementOutput.x = self.outputResult.x
                                    self.measurementOutput.y = self.outputResult.y
                                    self.measurementOutput.absolute_heading = self.outputResult.absolute_heading
                                    
                                    print(getLocalTimeString() + " , (Jupiter) Entrance Simulator : Finish (Enter Phase4)")
                                    self.isStartSimulate = false
                                    unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                                    self.isPhaseBreakInSimulate = false
                                    self.detectNetworkBadEntrance = false
                                    self.isInNetworkBadEntrance = false
                                    self.indexAfterSimulate = 0
                                    self.currentEntrance = ""
                                    self.currentEntranceLength = 0
                                    self.currentEntranceIndex = 0
                                }
                            }
                        }
                    } else {
                        self.currentLevel = self.resultToReturn.level_name
                        if (self.isPhaseBreakInSimulate) {
                            if (self.isActiveKf) {
                                self.timeUpdatePosition.x = self.outputResult.x
                                self.timeUpdatePosition.y = self.outputResult.y
                                self.timeUpdatePosition.heading = self.outputResult.absolute_heading
                                self.timeUpdateOutput.x = self.outputResult.x
                                self.timeUpdateOutput.y = self.outputResult.y
                                self.timeUpdateOutput.absolute_heading = self.outputResult.absolute_heading
                                self.measurementPosition.x = self.outputResult.x
                                self.measurementPosition.y = self.outputResult.y
                                self.measurementPosition.heading = self.outputResult.absolute_heading
                                self.measurementOutput.x = self.outputResult.x
                                self.measurementOutput.y = self.outputResult.y
                                self.measurementOutput.absolute_heading = self.outputResult.absolute_heading
                            }
                            print(getLocalTimeString() + " , (Jupiter) Entrance Simulator : Finish (End Simulating in PhaseBreak)")
                        } else {
                            if (self.isActiveKf) {
                                self.timeUpdatePosition.x = self.outputResult.x
                                self.timeUpdatePosition.y = self.outputResult.y
                                self.timeUpdatePosition.heading = self.outputResult.absolute_heading
                                self.timeUpdateOutput.x = self.outputResult.x
                                self.timeUpdateOutput.y = self.outputResult.y
                                self.timeUpdateOutput.absolute_heading = self.outputResult.absolute_heading
                                self.measurementPosition.x = self.outputResult.x
                                self.measurementPosition.y = self.outputResult.y
                                self.measurementPosition.heading = self.outputResult.absolute_heading
                                self.measurementOutput.x = self.outputResult.x
                                self.measurementOutput.y = self.outputResult.y
                                self.measurementOutput.absolute_heading = self.outputResult.absolute_heading
                            }
                            print(getLocalTimeString() + " , (Jupiter) Entrance Simulator : Finish (End Simulating)")
                        }
                        self.isStartSimulate = false
                        unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                        self.isPhaseBreakInSimulate = false
                        self.detectNetworkBadEntrance = false
                        self.isInNetworkBadEntrance = false
                        self.currentEntrance = ""
                        self.currentEntranceLength = 0
                        self.currentEntranceIndex = 0
                    }
                } else {
                    if (self.isActiveKf) {
                        self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                    }
                }
                
                // Put UV
                if ((inputUserVelocity.count-1) >= UVD_INPUT_NUM) {
                    inputUserVelocity.remove(at: 0)
                    NetworkManager.shared.postUserVelocity(url: UV_URL, input: inputUserVelocity, completion: { [self] statusCode, returnedString, inputUvd in
                        if (statusCode == 200) {
                            self.pastTuResult = self.currentTuResult
                            self.indexSend = Int(returnedString) ?? 0
                            self.isAnswered = true
                        } else {
                            let localTime: String = getLocalTimeString()
                            let log: String = localTime + " , (Jupiter) Record Error : UVD \(statusCode) // " + returnedString
                            if (self.isIndoor && self.isGetFirstResponse) {
                                print(log)
                                self.reporting(input: UVD_FLAG)
                            }
                            
                            // Stack UVD Send Fail Data
                            if (self.isNeedRemoveIndexSendFailArray) {
                                var updatedArray = [Int]()
                                for i in 0..<self.sendFailUvdIndexes.count {
                                    if self.sendFailUvdIndexes[i] > self.validIndex {
                                        updatedArray.append(self.sendFailUvdIndexes[i])
                                    }
                                }
                                self.sendFailUvdIndexes = updatedArray
                                self.isNeedRemoveIndexSendFailArray = false
                            }
                            
                            for i in 0..<inputUvd.count {
                                self.sendFailUvdIndexes.append(inputUvd[i].index)
                            }
                        }
                    })
                    inputUserVelocity = [UserVelocity(user_id: user_id, mobile_time: 0, index: 0, length: 0, heading: 0, looking: true)]
                }
                
                // Phase 4 Request
                if (self.isAnswered && self.phase == 4) {
                    self.isAnswered = false
                    let phase4Trajectory = self.userTrajectoryInfo
                    let accumulatedLength = calculateAccumulatedLength(userTrajectory: phase4Trajectory)
                    let accumulatedDiagonal = calculateAccumulatedDiagonal(userTrajectory: phase4Trajectory)
                    if (!self.isBackground) {
                        if (self.isMovePhase2To4) {
                            let searchInfo = makeSearchAreaAndDirection(userTrajectory: phase4Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: USER_TRAJECTORY_LENGTH, diagonal: accumulatedDiagonal, mode: self.runMode, phase: self.phase, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                            if (searchInfo.3 != 0) {
                                processPhase4(currentTime: currentTime, localTime: localTime, userTrajectory: phase4Trajectory, searchInfo: searchInfo)
                            } else {
                                self.isUnknownTraj = true
                            }
                        } else {
                            let searchInfo = makeSearchAreaAndDirection(userTrajectory: phase4Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: accumulatedLength, diagonal: accumulatedDiagonal, mode: self.runMode, phase: self.phase, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                            if (searchInfo.3 != 0) {
                                processPhase4(currentTime: currentTime, localTime: localTime, userTrajectory: phase4Trajectory, searchInfo: searchInfo)
                            } else {
                                self.isUnknownTraj = true
                            }
                        }
                    }
                }
                
                if ((self.unitDrInfoIndex % self.requestIndex) == 0 && !self.isBackground) {
                    if (self.phase == 2) {
                        let phase2Trajectory = self.userTrajectoryInfo
                        let accumulatedLength = calculateAccumulatedLength(userTrajectory: phase2Trajectory)
                        var searchInfo = makeSearchAreaAndDirection(userTrajectory: phase2Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: accumulatedLength, diagonal: accumulatedLength, mode: self.runMode, phase: self.phase, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                        
                        if (self.isStartSimulate) {
                            if (accumulatedLength >= 40) {
                                self.phase2ReqCount += 1
                                if (self.phase2ReqCount > 2) {
                                    let expandRange: Int = Int((accumulatedLength - 40)/2)
                                    searchInfo.0 = [searchInfo.0[0]-expandRange, searchInfo.0[1]-expandRange, searchInfo.0[2]+expandRange, searchInfo.0[3]+expandRange]
                                }
                                processPhase2(currentTime: currentTime, localTime: localTime, userTrajectory: phase2Trajectory, searchInfo: searchInfo)
                            }
                        } else {
                            if (accumulatedLength >= 40) {
                                self.phase2ReqCount += 1
                                if (self.phase2ReqCount > 2) {
                                    let expandRange: Int = Int((accumulatedLength - 40)/2)
                                    searchInfo.0 = [searchInfo.0[0]-expandRange, searchInfo.0[1]-expandRange, searchInfo.0[2]+expandRange, searchInfo.0[3]+expandRange]
                                }
                                processPhase2(currentTime: currentTime, localTime: localTime, userTrajectory: phase2Trajectory, searchInfo: searchInfo)
                            }
                        }
                    } else if (self.phase < 4) {
                        // Phase 1 ~ 3
                        let phase3Trajectory = self.userTrajectoryInfo
                        let accumulatedLength = calculateAccumulatedLength(userTrajectory: phase3Trajectory)
                        let searchInfo = makeSearchAreaAndDirection(userTrajectory: phase3Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: accumulatedLength, diagonal: accumulatedLength, mode: self.runMode, phase: self.phase, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                        
                        if (!self.isStartSimulate) {
                            if (self.isActiveKf) {
                                if (searchInfo.3 != 0) {
                                    processPhase3(currentTime: currentTime, localTime: localTime, userTrajectory: phase3Trajectory, searchInfo: searchInfo)
                                }
                            } else {
                                processPhase3(currentTime: currentTime, localTime: localTime, userTrajectory: phase3Trajectory, searchInfo: searchInfo)
                            }
                        } else {
                            if (self.isPhaseBreakInSimulate) {
                                processPhase3(currentTime: currentTime, localTime: localTime, userTrajectory: phase3Trajectory, searchInfo: searchInfo)
                            }
                        }
                    }
                }
            }
        } else {
            self.timeRequest += UVD_INTERVAL
            if (self.isVenusMode && self.timeRequest >= 2) {
                self.timeRequest = 0
                let phase3Trajectory = self.userTrajectoryInfo
                let accumulatedLength = calculateAccumulatedLength(userTrajectory: phase3Trajectory)
                let searchInfo = makeSearchAreaAndDirection(userTrajectory: phase3Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: accumulatedLength, diagonal: accumulatedLength, mode: self.runMode, phase: 1, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                processPhase3(currentTime: currentTime, localTime: localTime, userTrajectory: phase3Trajectory, searchInfo: searchInfo)
            } else {
                if (!self.isGetFirstResponse && self.timeRequest >= 2) {
                    self.timeRequest = 0
                    let phase3Trajectory = self.userTrajectoryInfo
                    let accumulatedLength = calculateAccumulatedLength(userTrajectory: phase3Trajectory)
                    let searchInfo = makeSearchAreaAndDirection(userTrajectory: phase3Trajectory, serverResultBuffer: self.serverResultBuffer, pastUserTrajectory: self.pastUserTrajectoryInfo, pastSearchDirection: self.pastSearchDirection, length: accumulatedLength, diagonal: accumulatedLength, mode: self.runMode, phase: self.phase, isKf: self.isActiveKf, isPhaseBreak: self.isPhaseBreak)
                    processPhase3(currentTime: currentTime, localTime: localTime, userTrajectory: phase3Trajectory, searchInfo: searchInfo)
                }
            }
            
            // UV가 발생하지 않음
            self.timeActiveUV += UVD_INTERVAL
            if (self.timeActiveUV >= STOP_THRESHOLD) {
                if (self.isVenusMode) {
                    self.isStop = false
                } else {
                    self.isStop = true
                }
                self.timeActiveUV = 0
                displayOutput.velocity = 0
            }
            
            self.timeSleepUV += UVD_INTERVAL
            if (self.timeSleepUV >= SLEEP_THRESHOLD) {
                self.isActiveService = false
                self.timeSleepUV = 0
                self.enterSleepMode()
            }
        }
    }
    
    func accumulateLengthAndRemoveOldest(isDetermineSpot: Bool, isUnknownTraj: Bool, isMovePhase2To4: Bool, LENGTH_CONDITION: Double) {
        if (isDetermineSpot) {
            self.isDetermineSpot = false
            let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: self.spotCutIndex)
            self.userTrajectoryInfo = newTraj
            self.accumulatedLengthWhenPhase2 = calculateAccumulatedLength(userTrajectory: self.userTrajectoryInfo)
            self.phase2ReqCount = 0
            self.phase2BadCount = 0
            
            displayOutput.phase = String(2)
            self.phase = 2
            self.outputResult.phase = 2
        } else if (isUnknownTraj) {
            self.isUnknownTraj = false
            let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: 45)
            self.userTrajectoryInfo = newTraj
        } else {
            if (isMovePhase2To4) {
                let isInLevelChangeArea = self.checkInLevelChangeArea(result: self.lastResult, mode: self.runMode)
                if (isInLevelChangeArea && self.isNeedRemovePhase2To4Trajectroy) {
                    self.isNeedRemovePhase2To4Trajectroy = false
                    let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: 30)
                    self.userTrajectoryInfo = newTraj
                } else {
                    let accumulatedLength = calculateAccumulatedLength(userTrajectory: self.userTrajectoryInfo)
                    if accumulatedLength > LENGTH_CONDITION {
                        self.userTrajectoryInfo.removeFirst()
                    }
                }
            } else {
                let accumulatedLength = calculateAccumulatedLength(userTrajectory: self.userTrajectoryInfo)
                if accumulatedLength > LENGTH_CONDITION {
                    self.userTrajectoryInfo.removeFirst()
                }
            }
            let accumulatedLength = calculateAccumulatedLength(userTrajectory: self.userTrajectoryInfo)
            if accumulatedLength > LENGTH_CONDITION {
                self.userTrajectoryInfo.removeFirst()
            }
        }
        
        if (!self.userTrajectoryInfo.isEmpty) {
            let isTailIndexSendFail = checkIsTailIndexSendFail(userTrajectory: self.userTrajectoryInfo, sendFailUvdIndexes: self.sendFailUvdIndexes)
            if (isTailIndexSendFail) {
                let validTrajectoryInfoResult = getValidTrajectory(userTrajectory: self.userTrajectoryInfo, sendFailUvdIndexes: self.sendFailUvdIndexes, mode: self.runMode)
                if (!validTrajectoryInfoResult.0.isEmpty) {
                    let trajLength = calculateAccumulatedLength(userTrajectory: validTrajectoryInfoResult.0)
                    if (trajLength > 10) {
                        self.userTrajectoryInfo = validTrajectoryInfoResult.0
                        self.validIndex = validTrajectoryInfoResult.1
                        self.isNeedRemoveIndexSendFailArray = true
                    } else {
                        // Phase 깨줘야한다
                        self.phase = 1
                        self.userTrajectoryInfo = [TrajectoryInfo]()
                        self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
                    }
                } else {
                    // Phase 깨줘야한다
                    self.phase = 1
                    self.userTrajectoryInfo = [TrajectoryInfo]()
                    self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
                }
            }
        }
    }
    
    func accumulateDiagonalAndRemoveOldest(LENGTH_CONDITION: Double) {
        let updatedTrajectoryInfoWithLength = checkAccumulatedLength(userTrajectory: self.userTrajectoryInfo, LENGTH_CONDITION: LENGTH_CONDITION)
        let isTailIndexSendFail = checkIsTailIndexSendFail(userTrajectory: updatedTrajectoryInfoWithLength, sendFailUvdIndexes: self.sendFailUvdIndexes)
        if (isTailIndexSendFail) {
            let validTrajectoryInfoResult = getValidTrajectory(userTrajectory: updatedTrajectoryInfoWithLength, sendFailUvdIndexes: self.sendFailUvdIndexes, mode: self.runMode)
            if (!validTrajectoryInfoResult.0.isEmpty) {
                let trajLength = calculateAccumulatedLength(userTrajectory: validTrajectoryInfoResult.0)
                if (trajLength > 5) {
                    self.userTrajectoryInfo = validTrajectoryInfoResult.0
                    self.validIndex = validTrajectoryInfoResult.1
                    self.isNeedRemoveIndexSendFailArray = true
                } else {
                    // Phase 깨줘야한다
                    self.phase = 1
                    self.userTrajectoryInfo = [TrajectoryInfo]()
                    self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
                }
            } else {
                // Phase 깨줘야한다
                self.phase = 1
                self.userTrajectoryInfo = [TrajectoryInfo]()
                self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
            }
        } else {
            if (!updatedTrajectoryInfoWithLength[0].lookingFlag) {
                let validTrajectoryInfoResult = getValidTrajectory(userTrajectory: updatedTrajectoryInfoWithLength, sendFailUvdIndexes: self.sendFailUvdIndexes, mode: self.runMode)
                if (!validTrajectoryInfoResult.0.isEmpty) {
                    let trajLength = calculateAccumulatedLength(userTrajectory: validTrajectoryInfoResult.0)
                    if (trajLength > 5) {
                        self.userTrajectoryInfo = validTrajectoryInfoResult.0
                        self.validIndex = validTrajectoryInfoResult.1
                        self.isNeedRemoveIndexSendFailArray = true
                    } else {
                        // Phase 깨줘야한다
                        self.phase = 1
                        self.userTrajectoryInfo = [TrajectoryInfo]()
                        self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
                    }
                } else {
                    // Phase 깨줘야한다
                    self.phase = 1
                    self.userTrajectoryInfo = [TrajectoryInfo]()
                    self.phaseBreakResult = self.serverResultBuffer[self.serverResultBuffer.count-1]
                }
            } else {
                self.userTrajectoryInfo = updatedTrajectoryInfoWithLength
            }
        }
    }
    
    func accumulateServerResultAndRemoveOldest(serverResult: FineLocationTrackingFromServer) {
        self.serverResultBuffer.append(serverResult)
        if (self.serverResultBuffer.count > 10) {
            self.serverResultBuffer.remove(at: 0)
        }
    }
    
    func makeTrajectoryInfo(unitDRInfo: UnitDRInfo, uvdLength: Double, resultToReturn: FineLocationTrackingResult, tuHeading: Double, isPmSuccess: Bool, bleChannels: Int, mode: String) {
        if (resultToReturn.x != 0 && resultToReturn.y != 0) {
            if (mode == "pdr") {
                if (self.isMoveNotLookingToLooking) {
                    let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: 15)
                    self.userTrajectoryInfo = newTraj
                    self.isMoveNotLookingToLooking = false
                } else {
                    if (self.isNeedTrajInit) {
                        if (self.isPhaseBreak) {
                            let cutIdx = Int(ceil(USER_TRAJECTORY_DIAGONAL*0.5))
                            let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: cutIdx)
                            var isNeedAllClear: Bool = false
                            
                            if (newTraj.count > 1) {
                                for i in 1..<newTraj.count {
                                    let diffX = abs(newTraj[i].userX - newTraj[i-1].userX)
                                    let diffY = abs(newTraj[i].userY - newTraj[i-1].userY)
                                    if (sqrt(diffX*diffX + diffY*diffY) > 3) {
                                        isNeedAllClear = true
                                        break
                                    }
                                }
                            }
                            
                            if (isNeedAllClear) {
                                self.userTrajectoryInfo = [TrajectoryInfo]()
                            } else {
                                self.userTrajectoryInfo = newTraj
                            }
                        } else {
                            self.userTrajectoryInfo = [TrajectoryInfo]()
                        }
                        self.isNeedTrajInit = false
                    } else if (!self.isGetFirstResponse && (self.timeForInit < TIME_INIT_THRESHOLD)) {
                        self.userTrajectoryInfo = [TrajectoryInfo]()
                    } else if (self.isForeground) {
                        let cutIdx = Int(ceil(USER_TRAJECTORY_DIAGONAL*0.2))
                        let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: cutIdx)
                        var isNeedAllClear: Bool = false
                        
                        if (newTraj.count > 1) {
                            for i in 1..<newTraj.count {
                                let diffX = abs(newTraj[i].userX - newTraj[i-1].userX)
                                let diffY = abs(newTraj[i].userY - newTraj[i-1].userY)
                                if (sqrt(diffX*diffX + diffY*diffY) > 3) {
                                    isNeedAllClear = true
                                    break
                                }
                            }
                        }
                        if (isNeedAllClear) {
                            self.userTrajectoryInfo = [TrajectoryInfo]()
                        } else {
                            self.userTrajectoryInfo = newTraj
                        }
                        self.isForeground = false
                    } else {
                        self.userTrajectory.index = unitDRInfo.index
                        self.userTrajectory.length = uvdLength
                        self.userTrajectory.heading = unitDRInfo.heading
                        self.userTrajectory.velocity = unitDRInfo.velocity
                        self.userTrajectory.lookingFlag = unitDRInfo.lookingFlag
                        self.userTrajectory.isIndexChanged = unitDRInfo.isIndexChanged
                        self.userTrajectory.numChannels = bleChannels
                        self.userTrajectory.scc = resultToReturn.scc
                        self.userTrajectory.userBuilding = resultToReturn.building_name
                        self.userTrajectory.userLevel = resultToReturn.level_name
                        if (self.isActiveKf) {
                            self.userTrajectory.userX = self.timeUpdateResult[0]
                            self.userTrajectory.userY = self.timeUpdateResult[1]
                            self.userTrajectory.userHeading = self.timeUpdateResult[2]
                        } else {
                            self.userTrajectory.userX = resultToReturn.x
                            self.userTrajectory.userY = resultToReturn.y
                            self.userTrajectory.userHeading = resultToReturn.absolute_heading
                        }
                        
                        self.userTrajectory.userTuHeading = tuHeading
                        self.userTrajectory.userPmSuccess = isPmSuccess
                        
                        self.userTrajectoryInfo.append(self.userTrajectory)
                        self.accumulateDiagonalAndRemoveOldest(LENGTH_CONDITION: self.USER_TRAJECTORY_DIAGONAL)
                    }
                }
            } else {
                if (self.isNeedTrajInit) {
                    if (self.isPhaseBreak) {
                        let cutIdx = Int(ceil(USER_TRAJECTORY_LENGTH*0.5))
                        let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: cutIdx)
                        var isNeedAllClear: Bool = false
                        
                        if (newTraj.count > 1) {
                            for i in 1..<newTraj.count {
                                let diffX = abs(newTraj[i].userX - newTraj[i-1].userX)
                                let diffY = abs(newTraj[i].userY - newTraj[i-1].userY)
                                if (sqrt(diffX*diffX + diffY*diffY) > 3) {
                                    isNeedAllClear = true
                                    break
                                }
                            }
                        }
                        
                        if (isNeedAllClear) {
                            self.userTrajectoryInfo = [TrajectoryInfo]()
                        } else {
                            self.userTrajectoryInfo = newTraj
                        }
                    } else {
                        self.userTrajectoryInfo = [TrajectoryInfo]()
                    }
                    self.isNeedTrajInit = false
                } else if (!self.isGetFirstResponse && (self.timeForInit < TIME_INIT_THRESHOLD)) {
                    self.userTrajectoryInfo = [TrajectoryInfo]()
                } else if (self.isForeground) {
                    let cutIdx = Int(ceil(USER_TRAJECTORY_LENGTH*0.2))
                    let newTraj = getTrajectoryFromLast(from: self.userTrajectoryInfo, N: cutIdx)
                    var isNeedAllClear: Bool = false
                    
                    if (newTraj.count > 1) {
                        for i in 1..<newTraj.count {
                            let diffX = abs(newTraj[i].userX - newTraj[i-1].userX)
                            let diffY = abs(newTraj[i].userY - newTraj[i-1].userY)
                            if (sqrt(diffX*diffX + diffY*diffY) > 3) {
                                isNeedAllClear = true
                                break
                            }
                        }
                    }
                    
                    if (isNeedAllClear) {
                        self.userTrajectoryInfo = [TrajectoryInfo]()
                    } else {
                        self.userTrajectoryInfo = newTraj
                    }
                    self.isForeground = false
                } else {
                    self.userTrajectory.index = unitDRInfo.index
                    self.userTrajectory.length = uvdLength
                    self.userTrajectory.heading = unitDRInfo.heading
                    self.userTrajectory.velocity = unitDRInfo.velocity
                    self.userTrajectory.lookingFlag = unitDRInfo.lookingFlag
                    self.userTrajectory.isIndexChanged = unitDRInfo.isIndexChanged
                    self.userTrajectory.numChannels = bleChannels
                    self.userTrajectory.scc = resultToReturn.scc
                    self.userTrajectory.userBuilding = resultToReturn.building_name
                    self.userTrajectory.userLevel = resultToReturn.level_name
                    if (self.isActiveKf) {
                        self.userTrajectory.userX = self.timeUpdateResult[0]
                        self.userTrajectory.userY = self.timeUpdateResult[1]
                        self.userTrajectory.userHeading = self.timeUpdateResult[2]
                    } else {
                        self.userTrajectory.userX = resultToReturn.x
                        self.userTrajectory.userY = resultToReturn.y
                        self.userTrajectory.userHeading = resultToReturn.absolute_heading
                    }
                    self.userTrajectory.userTuHeading = tuHeading
                    self.userTrajectory.userPmSuccess = isPmSuccess
                    
                    self.userTrajectoryInfo.append(self.userTrajectory)
                    self.accumulateLengthAndRemoveOldest(isDetermineSpot: self.isDetermineSpot, isUnknownTraj: self.isUnknownTraj, isMovePhase2To4: self.isMovePhase2To4, LENGTH_CONDITION: self.USER_TRAJECTORY_LENGTH)
                }
            }
        }
    }
    
    func makeSearchAreaAndDirection(userTrajectory: [TrajectoryInfo], serverResultBuffer: [FineLocationTrackingFromServer], pastUserTrajectory: [TrajectoryInfo], pastSearchDirection: Int, length: Double, diagonal: Double, mode: String, phase: Int, isKf: Bool, isPhaseBreak: Bool) -> ([Int], [Int], Int, Int) {
        var resultRange: [Int] = []
        var resultDirection: [Int] = [0, 90, 180, 270]
        var tailIndex = 1
        var searchType = 0
        
        var CONDITION: Double = USER_TRAJECTORY_LENGTH
        var conditionForMajorHeadingUse: Double = 10
        if (USER_TRAJECTORY_LENGTH <= 20) {
            conditionForMajorHeadingUse = (USER_TRAJECTORY_LENGTH-5)/2
        }
        let accumulatedValue: Double = length
        let diagonal_length_ratio = diagonal/length
        if (mode == "pdr") {
            CONDITION = USER_TRAJECTORY_DIAGONAL*0.8
            if (!userTrajectory.isEmpty) {
                var uvHeading = [Double]()
                var uvRawHeading = [Double]()
                for value in userTrajectory {
                    uvHeading.append(compensateHeading(heading: value.heading))
                    uvRawHeading.append(value.heading)
                }
                let userBuilding = userTrajectory[userTrajectory.count-1].userBuilding
                let userLevel = userTrajectory[userTrajectory.count-1].userLevel
                var userX = userTrajectory[userTrajectory.count-1].userX
                var userY = userTrajectory[userTrajectory.count-1].userY
                let userH = userTrajectory[userTrajectory.count-1].userHeading
                let RANGE = CONDITION
                
                if (phase < 4) {
                    if (isPhaseBreak && (self.phaseBreakResult.building_name != "" && self.phaseBreakResult.level_name != "")) {
                        userX = self.phaseBreakResult.x
                        userY = self.phaseBreakResult.y
                    }
                    let areaMinMax: [Double] = [userX - RANGE, userY - RANGE, userX + RANGE, userY + RANGE]
                    let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                    resultRange = areaMinMax.map { Int($0) }
                    
                    var searchHeadings: [Double] = []
                    var hasMajorDirection: Bool = false
                    if (accumulatedValue > conditionForMajorHeadingUse) {
                        let ppHeadings = pmCalculator.getPathMatchingHeadings(building: userBuilding, level: userLevel, x: userX, y: userY, heading: userH, RANGE: RANGE, mode: mode)
                        let headingLeastChangeSection = extractSectionWithLeastChange(inputArray: uvRawHeading)
                        if (headingLeastChangeSection.isEmpty) {
                            hasMajorDirection = false
                        } else {
                            let headingForCompensation = headingLeastChangeSection.average - uvRawHeading[0]
                            for ppHeading in ppHeadings {
                                let tailHeading = ppHeading - headingForCompensation
                                searchHeadings.append(compensateHeading(heading: tailHeading))
                            }
                            hasMajorDirection = true
                        }
                    }

                    if (!hasMajorDirection) {
                        searchHeadings = [0, 90, 180, 270]
                        displayOutput.searchType = -1
                    } else {
                        displayOutput.searchType = 5
                    }
                    resultDirection = searchHeadings.map { Int($0) }
                    
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                    
                    let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                    var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)

                    for i in 0..<uvHeading.count {
                        headingFromHead[i] = compensateHeading(heading: uvHeading[i] - 180 + headingCorrectionFromServer)
                    }
                    
                    var trajectoryFromHead = [[Double]]()
                    trajectoryFromHead.append(xyFromHead)
                    for i in (1..<userTrajectory.count).reversed() {
                        let headAngle = headingFromHead[i]
                        xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                        xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                        trajectoryFromHead.append(xyFromHead)
                    }
                    tailIndex = userTrajectory[0].index
                    
                    displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                    displayOutput.userTrajectory = trajectoryFromHead
                    displayOutput.searchArea = searchArea
                    searchType = 5
                } else {
                    tailIndex = userTrajectory[0].index
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    let headInfoHeading = compensateHeading(heading: headInfo.userHeading)
                    
                    let recentServerResult: FineLocationTrackingFromServer = serverResultBuffer[serverResultBuffer.count-1]
                    let propagatedResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: recentServerResult)
                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                    var xyForArea: [Double] = [headInfo.userX, headInfo.userY]
                    if (propagatedResult.0) {
                        xyFromHead = [recentServerResult.x + propagatedResult.1[0], recentServerResult.y + propagatedResult.1[1]]
                        xyForArea = [recentServerResult.x + propagatedResult.1[0], recentServerResult.y + propagatedResult.1[1]]
                    }
                    let headCoord: [Double] = xyFromHead
                    let serverCoord: [Double] = [recentServerResult.x, recentServerResult.y]
                    
                    var hasMajorDirection: Bool = false
                    if (accumulatedValue < 10) {
                        hasMajorDirection = false
                    } else {
                        let ppHeadings = pmCalculator.getPathMatchingHeadings(building: userBuilding, level: userLevel, x: userX, y: userY, heading: userH, RANGE: RANGE, mode: mode)
                        var searchHeadings: [Double] = []
                        var headHeadings: [Double] = []
                        let headingLeastChangeSection = extractSectionWithLeastChange(inputArray: uvRawHeading)
                        if (headingLeastChangeSection.isEmpty) {
                            hasMajorDirection = false
                        } else {
                            let headingForCompensation = uvRawHeading[uvRawHeading.count-1] - headingLeastChangeSection.average
                            for ppHeading in ppHeadings {
                                let headHeading = compensateHeading(heading: ppHeading + headingForCompensation)
                                var diffHeading = abs(headInfoHeading - headHeading)
                                if (diffHeading >= 270 && diffHeading < 360) {
                                    diffHeading = 360 - diffHeading
                                }
                                headHeadings.append(diffHeading)
                            }
                            
                            let minHeading = headHeadings.min() ?? 40
                            if let minIndex = zip(headHeadings.indices, headHeadings).min(by: { $0.1 < $1.1 })?.0 {
                                if (minHeading <= 20) {
                                    let headingForCompensation = headingLeastChangeSection.average - uvRawHeading[0]
                                    let tailHeading = ppHeadings[minIndex] - headingForCompensation
                                    searchHeadings.append(compensateHeading(heading: tailHeading - 5))
                                    searchHeadings.append(compensateHeading(heading: tailHeading))
                                    searchHeadings.append(compensateHeading(heading: tailHeading + 5))
                                    resultDirection = searchHeadings.map { Int($0) }
                                    let isStraight = isTrajectoryStraight(for: uvHeading, size: uvHeading.count, mode: mode, conditionPdr: NUM_STRAIGHT_INDEX_PDR, conditionDr: NUM_STRAIGHT_INDEX_DR)
                                    
                                    let headingCorrectionForTail: Double = tailHeading - uvHeading[0]
                                    var headingFromTail = [Double] (repeating: 0, count: uvHeading.count)
                                    var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                                    for i in 0..<uvHeading.count {
                                        headingFromTail[i] = compensateHeading(heading: uvHeading[i] + headingCorrectionForTail)
                                        headingFromHead[i] = compensateHeading(heading: headingFromTail[i] - 180)
                                    }
//                                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                                    
                                    var trajectoryFromHead = [[Double]]()
                                    trajectoryFromHead.append(xyFromHead)
                                    var trajectoryForArea = [[Double]]()
                                    trajectoryForArea.append(xyForArea)
                                    for i in (1..<userTrajectory.count).reversed() {
                                        let headAngle = headingFromHead[i]
                                        xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                                        xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                                        trajectoryFromHead.append(xyFromHead)
                                        
                                        xyForArea[0] = xyForArea[0] + userTrajectory[i].length*1.2*cos(headAngle*D2R)
                                        xyForArea[1] = xyForArea[1] + userTrajectory[i].length*1.2*sin(headAngle*D2R)
                                        trajectoryForArea.append(xyForArea)
                                    }
                                    
                                    let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)
                                    
                                    let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                                    let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                                    
                                    let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: headCoord, serverCoord: serverCoord, searchType: -1, lengthCondition: USER_TRAJECTORY_DIAGONAL, diagonalLengthRatio: diagonal_length_ratio)
                                    let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                                    resultRange = areaMinMax.map { Int($0) }
                                    hasMajorDirection = true
                                    displayOutput.trajectoryStartCoord = headCoord
                                    displayOutput.userTrajectory = trajectoryFromHead
                                    displayOutput.searchArea = searchArea
                                    displayOutput.searchType = 4
                                    searchType = 4
                                } else {
                                    hasMajorDirection = false
                                }
                            } else {
                                hasMajorDirection = false
                            }
                        }
                    }
                    
                    if (!hasMajorDirection) {
                        let pastTraj = pastUserTrajectory
                        let pastDirection = pastSearchDirection
                        let pastDirectionCompensation = pastDirection - Int(round(pastTraj[0].heading))
                        var pastTrajIndex = [Int]()
                        var pastTrajHeading = [Int]()
                        for i in 0..<pastTraj.count {
                            pastTrajIndex.append(pastTraj[i].index)
                            pastTrajHeading.append(Int(round(pastTraj[i].heading)) + pastDirectionCompensation)
                        }
                        
//                        let isStraight = isTrajectoryStraight(for: uvHeading, size: uvHeading.count, mode: mode, conditionPdr: NUM_STRAIGHT_INDEX_PDR, conditionDr: NUM_STRAIGHT_INDEX_DR)
                        let closestIndex = findClosestValueIndex(to: tailIndex, in: pastTrajIndex)
                        if let headingIndex = closestIndex {
                            resultDirection = [pastTrajHeading[headingIndex], pastTrajHeading[headingIndex]-5, pastTrajHeading[headingIndex]+5]
                            for i in 0..<resultDirection.count {
                                resultDirection[i] = Int(compensateHeading(heading: Double(resultDirection[i])))
                            }
                            
                            let headingCorrectionForTail: Double = Double(pastTrajHeading[headingIndex]) - uvHeading[0]
                            var headingFromTail = [Double] (repeating: 0, count: uvHeading.count)
                            var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                            for i in 0..<uvHeading.count {
                                headingFromTail[i] = uvHeading[i] + headingCorrectionForTail
                                headingFromHead[i] = compensateHeading(heading: headingFromTail[i] - 180)
                            }
                            
                            var trajectoryFromHead = [[Double]]()
                            trajectoryFromHead.append(xyFromHead)
                            for i in (1..<userTrajectory.count).reversed() {
                                let headAngle = headingFromHead[i]
                                xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                                xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                                trajectoryFromHead.append(xyFromHead)
                            }
                            
                            let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)
                            
                            let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                            let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                            
                            let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: headCoord, serverCoord: serverCoord, searchType: -2, lengthCondition: USER_TRAJECTORY_DIAGONAL, diagonalLengthRatio: diagonal_length_ratio)
                            let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                            resultRange = areaMinMax.map { Int($0) }
                            
                            displayOutput.trajectoryStartCoord = headCoord
                            displayOutput.userTrajectory = trajectoryFromHead
                            displayOutput.searchArea = searchArea
                            displayOutput.searchType = 6
                            searchType = 6
                        } else {
                            resultDirection = [pastDirection+5, pastDirection-5, pastDirection]
                            
                            var headingCorrectionForHead: Double = 0
                            let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                            if (!isKf) {
                                headingCorrectionForHead = 0
                            } else {
                                headingCorrectionForHead = headInfoHeading - headInfo.userHeading
                            }
                            
                            var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                            for i in 0..<uvHeading.count {
                                headingFromHead[i] = compensateHeading(heading: (uvHeading[i] + headingCorrectionForHead) - 180 + headingCorrectionFromServer)
                            }

                            var trajectoryFromHead = [[Double]]()
                            trajectoryFromHead.append(xyFromHead)
                            for i in (1..<userTrajectory.count).reversed() {
                                let headAngle = headingFromHead[i]
                                xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                                xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                                trajectoryFromHead.append(xyFromHead)
                            }
                            
                            let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)

                            let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                            let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                            
                            let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: headCoord, serverCoord: serverCoord, searchType: -2, lengthCondition: USER_TRAJECTORY_DIAGONAL, diagonalLengthRatio: diagonal_length_ratio)
                            let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                            resultRange = areaMinMax.map { Int($0) }
                            
                            displayOutput.trajectoryStartCoord = headCoord
                            displayOutput.userTrajectory = trajectoryFromHead
                            displayOutput.searchArea = searchArea
                            displayOutput.searchType = 7
                            searchType = 7
                        }
                    }
                }
                
                if (resultRange.isEmpty) {
                    if (self.preSearchRange.isEmpty) {
                        let userX = userTrajectory[userTrajectory.count-1].userX
                        let userY = userTrajectory[userTrajectory.count-1].userY
                        let RANGE = CONDITION*1.2
                        let areaMinMax = [userX - RANGE, userY - RANGE, userX + RANGE, userY + RANGE]
                        resultRange = areaMinMax.map { Int($0) }
                    } else {
                        let rangeConstant: Int = 10
                        resultRange = [self.preSearchRange[0] - rangeConstant, self.preSearchRange[1] - rangeConstant, self.preSearchRange[2] + rangeConstant, self.preSearchRange[3] + rangeConstant]
                    }
                    
                }
            } else {
                tailIndex = 0
                if (!pastUserTrajectory.isEmpty) {
                    tailIndex = pastUserTrajectory[0].index
                }
                if (resultRange.isEmpty) {
                    if (self.preSearchRange.isEmpty) {
                        let areaMinMax = [10, 10, 90, 90]
                        resultRange = areaMinMax.map { Int($0) }
                    } else {
                        let rangeConstant: Int = 10
                        resultRange = [self.preSearchRange[0] - rangeConstant, self.preSearchRange[1] - rangeConstant, self.preSearchRange[2] + rangeConstant, self.preSearchRange[3] + rangeConstant]
                    }
                }
            }
            
            if (resultDirection.isEmpty) {
                resultDirection = [0, 90, 180, 270]
            }
        } else {
            // DR
            if (!userTrajectory.isEmpty) {
                var uvHeading = [Double]()
                var uvRawHeading = [Double]()
                var uvRawLength = [Double]()
                for value in userTrajectory {
                    uvHeading.append(compensateHeading(heading: value.heading))
                    uvRawHeading.append(value.heading)
                    uvRawLength.append(value.length)
                }
                
                if (phase != 2 && phase < 4) {
                    let userBuilding = userTrajectory[userTrajectory.count-1].userBuilding
                    let userLevel = userTrajectory[userTrajectory.count-1].userLevel
                    var userX = userTrajectory[userTrajectory.count-1].userX
                    var userY = userTrajectory[userTrajectory.count-1].userY
                    let userH = userTrajectory[userTrajectory.count-1].userHeading
                    
                    if (isPhaseBreak && (self.phaseBreakResult.building_name != "" && self.phaseBreakResult.level_name != "")) {
                        userX = self.phaseBreakResult.x
                        userY = self.phaseBreakResult.y
                    }
                    
                    let RANGE = CONDITION*1.2
                    
                    // Search Area
                    let areaMinMax: [Double] = [userX - RANGE, userY - RANGE, userX + RANGE, userY + RANGE]
                    let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                    
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    
                    let tailInfo = userTrajectory[0]
                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                    
                    let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                    
                    var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                    for i in 0..<uvHeading.count {
                        headingFromHead[i] = compensateHeading(heading: uvHeading[i] - 180 + headingCorrectionFromServer)
                    }
                    
                    var trajectoryFromHead = [[Double]]()
                    trajectoryFromHead.append(xyFromHead)
                    for i in (1..<userTrajectory.count).reversed() {
                        let headAngle = headingFromHead[i]
                        xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                        xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                        trajectoryFromHead.append(xyFromHead)
                    }
                    
                    
                    // Add
                    let ppHeadings = pmCalculator.getPathMatchingHeadings(building: userBuilding, level: userLevel, x: userX, y: userY, heading: userH, RANGE: RANGE, mode: mode)
                    var searchHeadings: [Double] = []
                    if (accumulatedValue <= 30) {
                        searchHeadings = ppHeadings
                    } else {
                        let headingLeastChangeSection = extractSectionWithLeastChange(inputArray: uvRawHeading)
                        if (headingLeastChangeSection.isEmpty) {
                            let diffHeadingHeadTail = abs(uvRawHeading[uvRawHeading.count-1] - uvRawHeading[0])
                            if (diffHeadingHeadTail < 5) {
                                for ppHeading in ppHeadings {
                                    let defaultHeading = ppHeading - diffHeadingHeadTail
                                    searchHeadings.append(compensateHeading(heading: defaultHeading))
                                }
                            } else {
                                for ppHeading in ppHeadings {
                                    let defaultHeading = ppHeading - diffHeadingHeadTail
                                    
                                    searchHeadings.append(compensateHeading(heading: defaultHeading - 10))
                                    searchHeadings.append(compensateHeading(heading: defaultHeading))
                                    searchHeadings.append(compensateHeading(heading: defaultHeading + 10))
                                }
                            }
                        } else {
                            let headingForCompensation = headingLeastChangeSection.average - uvRawHeading[0]
                            for ppHeading in ppHeadings {
                                searchHeadings.append(compensateHeading(heading: ppHeading - headingForCompensation))
                            }
                        }
                    }
                    
                    let uniqueSearchHeadings = Array(Set(searchHeadings))
                    
                    resultRange = areaMinMax.map { Int($0) }
                    resultDirection = uniqueSearchHeadings.map { Int($0) }
                    tailIndex = userTrajectory[0].index
                    
                    displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                    displayOutput.userTrajectory = trajectoryFromHead
                    if (phase != 2) {
                        displayOutput.searchArea = searchArea
                    }
                    displayOutput.searchType = -2
                    searchType = -2
                } else if (phase == 2) {
                    let userBuilding = userTrajectory[userTrajectory.count-1].userBuilding
                    let userLevel = userTrajectory[userTrajectory.count-1].userLevel
                    tailIndex = userTrajectory[0].index
                    
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    
                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                    let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                    var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                    for i in 0..<uvHeading.count {
                        headingFromHead[i] = compensateHeading(heading: uvHeading[i] - 180 + headingCorrectionFromServer)
                    }
                    
                    var trajectoryFromHead = [[Double]]()
                    trajectoryFromHead.append(xyFromHead)
                    for i in (1..<userTrajectory.count).reversed() {
                        let headAngle = headingFromHead[i]
                        xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                        xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                        trajectoryFromHead.append(xyFromHead)
                    }
                    
                    displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                    displayOutput.userTrajectory = trajectoryFromHead
                    
                    let diffLength: Double = length - self.accumulatedLengthWhenPhase2
                    var searchRange: [Int] = self.phase2Range
                    if (diffLength >= 15) {
                        var serverPhase2Range = self.phase2Range
                        serverPhase2Range[0] = serverPhase2Range[0] - Int(diffLength/4)
                        serverPhase2Range[1] = serverPhase2Range[1] - Int(diffLength/4)
                        serverPhase2Range[2] = serverPhase2Range[2] + Int(diffLength/4)
                        serverPhase2Range[3] = serverPhase2Range[3] + Int(diffLength/4)
                        searchRange = serverPhase2Range
                    }
                    
                    if (self.phase2ReqCount >= 3) {
                        let centerPhase2Range: [Int] = [Int((self.phase2Range[2]-self.phase2Range[0])/2), Int((self.phase2Range[3]-self.phase2Range[1])/2)]
                        let userX = userTrajectory[userTrajectory.count-1].userX
                        let userY = userTrajectory[userTrajectory.count-1].userY
                        let diffXy: [Int] = [Int(userX) - centerPhase2Range[0], Int(userY) - centerPhase2Range[1]]
                        
                        searchRange[0] = searchRange[0] + diffXy[0]
                        searchRange[1] = searchRange[1] + diffXy[1]
                        searchRange[2] = searchRange[2] + diffXy[0]
                        searchRange[3] = searchRange[3] + diffXy[1]
                    }
                    
                    // Add
                    let resultRange = searchRange.map { Double($0) }
                    let searchArea = getSearchCoordinates(areaMinMax: resultRange, interval: 1.0)
                    displayOutput.searchArea = searchArea
                    
                    var searchHeadings: [Double] = []
                    let ppHeadings = self.phase2Direction.map { Double($0) }
                    if (length >= 40) {
                        let headingLeastChangeSection = extractSectionWithLeastChange(inputArray: uvRawHeading)
                        if (headingLeastChangeSection.isEmpty) {
                            let diffHeadingHeadTail = abs(uvRawHeading[uvRawHeading.count-1] - uvRawHeading[0])
                            for ppHeading in ppHeadings {
                                let defaultHeading = ppHeading - diffHeadingHeadTail
                                searchHeadings.append(compensateHeading(heading: defaultHeading))
                            }
                        } else {
                            let headingForCompensation = headingLeastChangeSection.average - uvRawHeading[0]
                            for ppHeading in ppHeadings {
                                searchHeadings.append(compensateHeading(heading: ppHeading - headingForCompensation))
                            }
                        }
                        displayOutput.searchType = 4
                        searchType = 4
                    } else {
                        searchHeadings = ppHeadings
                        
                        displayOutput.searchType = -1
                        searchType = -1
                    }
                    
                    let uniqueSearchHeadings = Array(Set(searchHeadings))
                    resultDirection = uniqueSearchHeadings.map { Int($0) }
                    
                } else if (phase == 4 && !isKf) {
                    let userBuilding = userTrajectory[userTrajectory.count-1].userBuilding
                    let userLevel = userTrajectory[userTrajectory.count-1].userLevel
                    let userX = userTrajectory[userTrajectory.count-1].userX
                    let userY = userTrajectory[userTrajectory.count-1].userY
                    let userH = userTrajectory[userTrajectory.count-1].userHeading
                    
                    let RANGE = CONDITION
                    
                    // Search Area
                    let areaMinMax: [Double] = [userX - RANGE, userY - RANGE, userX + RANGE, userY + RANGE]
                    let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                    
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    let headInfoHeading = headInfo.userTuHeading
                    var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                    
                    let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                    var headingCorrectionForHead: Double = 0
                    if (!isKf) {
                        headingCorrectionForHead = 0
                    } else {
                        headingCorrectionForHead = headInfoHeading - headInfo.userHeading
                    }
                    
                    var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                    for i in 0..<uvHeading.count {
                        headingFromHead[i] = compensateHeading(heading: (uvHeading[i] + headingCorrectionForHead) - 180 + headingCorrectionFromServer)
                    }
                    
                    var trajectoryFromHead = [[Double]]()
                    trajectoryFromHead.append(xyFromHead)
                    for i in (1..<userTrajectory.count).reversed() {
                        let headAngle = headingFromHead[i]
                        xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                        xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                        trajectoryFromHead.append(xyFromHead)
                    }
                    
                    // Search Direction
                    let ppHeadings = pmCalculator.getPathMatchingHeadings(building: userBuilding, level: userLevel, x: userX, y: userY, heading: userH, RANGE: RANGE, mode: mode)
                    var searchHeadings: [Double] = []
                    for i in 0..<ppHeadings.count {
                        searchHeadings.append(compensateHeading(heading: ppHeadings[i]-10))
                        searchHeadings.append(compensateHeading(heading: ppHeadings[i]))
                        searchHeadings.append(compensateHeading(heading: ppHeadings[i]+10))
                    }
                    
                    resultRange = areaMinMax.map { Int($0) }
                    resultDirection = searchHeadings.map { Int($0) }
                    tailIndex = userTrajectory[0].index
                    
                    displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                    displayOutput.userTrajectory = trajectoryFromHead
                    displayOutput.searchArea = searchArea
                    displayOutput.searchType = -2
                    searchType = -2
                } else {
                    let isStraight = isTrajectoryStraight(for: uvHeading, size: uvHeading.count, mode: mode, conditionPdr: NUM_STRAIGHT_INDEX_PDR, conditionDr: NUM_STRAIGHT_INDEX_DR)
                    let headInfo = userTrajectory[userTrajectory.count-1]
                    let tailInfo = userTrajectory[0]
                    
                    if (isStraight == 1) {
                        // All Straight
                        var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                        
                        let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                        
                        var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                        for i in 0..<uvHeading.count {
                            headingFromHead[i] = compensateHeading(heading: uvHeading[i] - 180 + headingCorrectionFromServer)
                        }
                        
                        // Head 기준 back propagation
                        var trajectoryFromHead = [[Double]]()
                        trajectoryFromHead.append(xyFromHead)
                        for i in (1..<userTrajectory.count).reversed() {
                            let headAngle = headingFromHead[i]
                            xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                            xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                            trajectoryFromHead.append(xyFromHead)
                        }
                        
                        let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)

                        let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                        let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                        
                        let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: [headInfo.userX, headInfo.userY], serverCoord: [0, 0], searchType: isStraight, lengthCondition: USER_TRAJECTORY_LENGTH, diagonalLengthRatio: diagonal_length_ratio)
                        let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                        
                        let searchHeadings: [Double] = [compensateHeading(heading: headingEnd)]
                        
                        resultRange = areaMinMax.map { Int($0) }
                        resultDirection = searchHeadings.map { Int($0) }
                        tailIndex = userTrajectory[0].index
                        
                        displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                        displayOutput.userTrajectory = trajectoryFromHead
                        if (phase != 2) {
                            displayOutput.searchArea = searchArea
                        }
                        displayOutput.searchType = isStraight
                        searchType = isStraight
                    } else if (isStraight == 2) {
                        // Head Straight
                        var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                        
                        let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                        
                        var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                        for i in 0..<uvHeading.count {
                            headingFromHead[i] = uvHeading[i] - 180 + headingCorrectionFromServer
                        }
                        
                        // Head 기준 back propagation
                        var trajectoryFromHead = [[Double]]()
                        trajectoryFromHead.append(xyFromHead)
                        for i in (1..<userTrajectory.count).reversed() {
                            let headAngle = headingFromHead[i]
                            xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                            xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                            trajectoryFromHead.append(xyFromHead)
                        }
                        let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)
                        let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                        let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                        let diffHeading = abs(90 - abs(headingStart - headingEnd))
                        
                        let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: [headInfo.userX, headInfo.userY], serverCoord: [0, 0], searchType: isStraight, lengthCondition: USER_TRAJECTORY_LENGTH, diagonalLengthRatio: diagonal_length_ratio)
                        let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                        var searchHeadings: [Double] = []
                        
                        if (diffHeading < 90) {
                            searchHeadings.append(headingEnd-5)
                            searchHeadings.append(headingEnd)
                            searchHeadings.append(headingEnd+5)
                        } else {
                            searchHeadings.append(headingEnd-10)
                            searchHeadings.append(headingEnd)
                            searchHeadings.append(headingEnd+10)
                        }
                        
                        for i in 0..<searchHeadings.count {
                            searchHeadings[i] = compensateHeading(heading: searchHeadings[i])
                        }
                        
                        resultRange = areaMinMax.map { Int($0) }
                        resultDirection = searchHeadings.map { Int($0) }
                        tailIndex = userTrajectory[0].index
                        
                        displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                        displayOutput.userTrajectory = trajectoryFromHead
                        if (phase != 2) {
                            displayOutput.searchArea = searchArea
                        }
                        displayOutput.searchType = isStraight
                        searchType = isStraight
                    } else if (isStraight == 3) {
                        // Tail Straight
                        var xyFromTail: [Double] = [tailInfo.userX, tailInfo.userY]

                        let headingCorrectionFromServer: Double = tailInfo.userHeading - uvHeading[0]
                        
                        var headingFromTail = [Double] (repeating: 0, count: uvHeading.count)
                        for i in 0..<uvHeading.count {
                            headingFromTail[i] = uvHeading[i] + headingCorrectionFromServer
                        }

                        var trajectoryFromTail = [[Double]]()

                        trajectoryFromTail.append(xyFromTail)
                        for i in 1..<userTrajectory.count {
                            let tailAngle = headingFromTail[i]
                            xyFromTail[0] = xyFromTail[0] + userTrajectory[i].length*cos(tailAngle*D2R)
                            xyFromTail[1] = xyFromTail[1] + userTrajectory[i].length*sin(tailAngle*D2R)
                            trajectoryFromTail.append(xyFromTail)
                        }
                        let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromTail)
                        let headingStart = compensateHeading(heading: headingFromTail[headingFromTail.count-1])
                        let headingEnd = compensateHeading(heading: headingFromTail[0])
                        let diffHeading = abs(90 - abs(headingStart - headingEnd))

                        let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: [headInfo.userX, headInfo.userY], serverCoord: [0, 0], searchType: isStraight, lengthCondition: USER_TRAJECTORY_LENGTH, diagonalLengthRatio: diagonal_length_ratio)
                        let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                        var searchHeadings: [Double] = []
                        
                        if (diffHeading < 90) {
                            searchHeadings.append(headingEnd-5)
                            searchHeadings.append(headingEnd)
                            searchHeadings.append(headingEnd+5)
                        } else {
                            searchHeadings.append(headingEnd-10)
                            searchHeadings.append(headingEnd)
                            searchHeadings.append(headingEnd+10)
                        }


                        for i in 0..<searchHeadings.count {
                            searchHeadings[i] = compensateHeading(heading: searchHeadings[i])
                        }

                        resultRange = areaMinMax.map { Int($0) }
                        resultDirection = searchHeadings.map { Int($0) }
                        tailIndex = userTrajectory[0].index

                        displayOutput.trajectoryStartCoord = [tailInfo.userX, tailInfo.userY]
                        displayOutput.userTrajectory = trajectoryFromTail
                        if (phase != 2) {
                            displayOutput.searchArea = searchArea
                        }
                        displayOutput.searchType = isStraight

                        let diffX = trajectoryFromTail[trajectoryFromTail.count-1][0] - headInfo.userX
                        let diffY = trajectoryFromTail[trajectoryFromTail.count-1][1] - headInfo.userY
                        let diffXY = sqrt(diffX*diffX + diffY*diffY)

                        if (isKf && diffXY <= 30) {
                            searchType = isStraight
                        } else if (diffXY > 30) {
                            searchType = 0
                        } else {
                            searchType = isStraight
                        }
                    } else {
                        // Turn
                        var xyFromHead: [Double] = [headInfo.userX, headInfo.userY]
                        
                        let headingCorrectionFromServer: Double = headInfo.userHeading - uvHeading[uvHeading.count-1]
                        
                        var headingFromHead = [Double] (repeating: 0, count: uvHeading.count)
                        for i in 0..<uvHeading.count {
                            headingFromHead[i] = compensateHeading(heading: uvHeading[i] - 180 + headingCorrectionFromServer)
                        }
                        
                        // Head 기준 back propagation
                        var trajectoryFromHead = [[Double]]()
                        trajectoryFromHead.append(xyFromHead)
                        for i in (1..<userTrajectory.count).reversed() {
                            let headAngle = headingFromHead[i]
                            xyFromHead[0] = xyFromHead[0] + userTrajectory[i].length*cos(headAngle*D2R)
                            xyFromHead[1] = xyFromHead[1] + userTrajectory[i].length*sin(headAngle*D2R)
                            trajectoryFromHead.append(xyFromHead)
                        }
                        let xyMinMax: [Double] = getMinMaxValues(for: trajectoryFromHead)
                        let headingStart = compensateHeading(heading: headingFromHead[headingFromHead.count-1]-180)
                        let headingEnd = compensateHeading(heading: headingFromHead[0]-180)
                        
                        let areaMinMax: [Double] = getSearchAreaMinMax(xyMinMax: xyMinMax, heading: [headingStart, headingEnd], headCoord: [headInfo.userX, headInfo.userY], serverCoord: [0, 0], searchType: isStraight, lengthCondition: USER_TRAJECTORY_LENGTH, diagonalLengthRatio: diagonal_length_ratio)
                        let searchArea = getSearchCoordinates(areaMinMax: areaMinMax, interval: 1.0)
                        let searchHeadings: [Double] = [compensateHeading(heading: headingEnd)]
                        
                        resultRange = areaMinMax.map { Int($0) }
                        resultDirection = searchHeadings.map { Int($0) }
                        tailIndex = userTrajectory[0].index
                        
                        displayOutput.trajectoryStartCoord = [headInfo.userX, headInfo.userY]
                        displayOutput.userTrajectory = trajectoryFromHead
                        if (phase != 2) {
                            displayOutput.searchArea = searchArea
                        }
                        displayOutput.searchType = 0
                        searchType = 0
                    }
                }
                
                if (resultRange.isEmpty) {
                    if (self.preSearchRange.isEmpty) {
                        let userX = userTrajectory[userTrajectory.count-1].userX
                        let userY = userTrajectory[userTrajectory.count-1].userY
                        let RANGE = CONDITION*1.2
                        let areaMinMax = [userX - RANGE, userY - RANGE, userX + RANGE, userY + RANGE]
                        resultRange = areaMinMax.map { Int($0) }
                    } else {
                        let rangeConstant: Int = 10
                        resultRange = [self.preSearchRange[0] - rangeConstant, self.preSearchRange[1] - rangeConstant, self.preSearchRange[2] + rangeConstant, self.preSearchRange[3] + rangeConstant]
                    }
                }
            } else {
                tailIndex = 0
                if (!pastUserTrajectory.isEmpty) {
                    tailIndex = pastUserTrajectory[0].index
                }
                if (resultRange.isEmpty) {
                    if (self.preSearchRange.isEmpty) {
                        let areaMinMax = [10, 10, 90, 90]
                        resultRange = areaMinMax.map { Int($0) }
                    } else {
                        let rangeConstant: Int = 10
                        resultRange = [self.preSearchRange[0] - rangeConstant, self.preSearchRange[1] - rangeConstant, self.preSearchRange[2] + rangeConstant, self.preSearchRange[3] + rangeConstant]
                    }
                }
            }
            
            if (resultDirection.isEmpty) {
                resultDirection = [0, 90, 180, 270]
            }
        }
        
        return (resultRange, resultDirection, tailIndex, searchType)
    }
    
    func isDrBufferStraight(drBuffer: [UnitDRInfo], condition: Double) -> Bool {
        if (drBuffer.count >= DR_BUFFER_SIZE_FOR_STRAIGHT) {
            let firstIndex = drBuffer.count-DR_BUFFER_SIZE_FOR_STRAIGHT
            let firstHeading: Double = drBuffer[firstIndex].heading
            let lastHeading: Double = drBuffer[drBuffer.count-1].heading
            var diffHeading: Double = abs(lastHeading - firstHeading)
            if (diffHeading >= 270 && diffHeading < 360) {
                diffHeading = 360 - diffHeading
            }
            
            if (diffHeading < condition) {
                return true
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    private func processPhase2(currentTime: Int, localTime: String, userTrajectory: [TrajectoryInfo], searchInfo: ([Int], [Int], Int, Int)) {
        let localTime = getLocalTimeString()
    
        var requestScArray: [Double] = [self.scCompensation]
        
        if (self.runMode == "pdr") {
            requestScArray = [1.0]
            let accumulatedDiagnoal = calculateAccumulatedDiagonal(userTrajectory: userTrajectory)
            if (accumulatedDiagnoal < USER_TRAJECTORY_DIAGONAL/2) {
                requestScArray = [1.01]
            } else {
                if (self.isScRequested) {
                    requestScArray = [1.01]
                } else {
                    requestScArray = self.scCompensationArrayPdr
                    self.scRequestTime = currentTime
                    self.isScRequested = true
                }
            }
        } else {
            let accumulatedLength = calculateAccumulatedLength(userTrajectory: userTrajectory)
            if (accumulatedLength < USER_TRAJECTORY_LENGTH/2) {
                requestScArray = [1.01]
            } else {
                if (self.isScRequested) {
                    requestScArray = [1.01]
                } else {
                    requestScArray = self.scCompensationArray
                    self.scRequestTime = currentTime
                    self.isScRequested = true
                }
            }
        }
        var input = FineLocationTracking(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id, building_name: self.currentBuilding, level_name_list: [self.currentLevel], phase: 2, search_range: searchInfo.0, search_direction_list: searchInfo.1, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), sc_compensation_list: requestScArray, tail_index: searchInfo.2)
        self.networkCount += 1
        if (self.regionName != "Korea" && self.deviceModel == "iPhone SE (2nd generation)") {
            input.normalization_scale = 1.01
        }
        NetworkManager.shared.postFLT(url: FLT_URL, input: input, userTraj: userTrajectory, trajType: searchInfo.3, completion: { [self] statusCode, returnedString, inputPhase, inputTraj, inputTrajType in
            if (!returnedString.contains("timed out")) {
                self.networkCount = 0
            }
            if (statusCode == 200 && self.phase == 2) {
                let result = jsonToResult(json: returnedString)
                // Sc Compensation
                if (self.isScRequested) {
                    let compensationCheckTime = abs(result.mobile_time - self.scRequestTime)
                    if (compensationCheckTime < 100) {
                        if (result.scc < 0.55) {
                            self.scCompensationBadCount += 1
                        } else {
                            if (result.scc > 0.6) {
                                let digit: Double = pow(10, 4)
                                self.scCompensation = round((result.sc_compensation*digit)/digit)
                                if (!self.isStartSimulate) {
//                                    unitDRGenerator.setScVelocityScaleFactor(scaleFactor: self.scCompensation)
                                }
                            }
                            self.scCompensationBadCount = 0
                        }
                        
                        if (self.scCompensationBadCount > 1) {
                            self.scCompensationBadCount = 0
                            let resultEstScCompensation = estimateScCompensation(sccResult: result.scc, scResult: result.sc_compensation, scArray: self.scCompensationArray)
                            self.scCompensationArray = resultEstScCompensation
                            self.isScRequested = false
                        }
                    } else if (compensationCheckTime > 3000) {
                        self.isScRequested = false
                    }
                }
                
                if (result.x != 0 && result.y != 0) {
                    let resultPhase = phaseController.controlPhase(serverResultArray: self.serverResultBuffer, drBuffer: self.unitDrBuffer, UVD_INTERVAL: self.UVD_INPUT_NUM, TRAJ_LENGTH: self.USER_TRAJECTORY_LENGTH, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
//                    let resultPhase = phaseController.controlJupiterPhase(serverResult: result, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
                    self.outputResult.phase = self.phase
                    
                    displayOutput.indexRx = result.index
                    displayOutput.scc = result.scc
                    displayOutput.phase = String(resultPhase.0)
                    
                    if (result.mobile_time > self.preOutputMobileTime) {
                        self.accumulateServerResultAndRemoveOldest(serverResult: result)
                        self.pastUserTrajectoryInfo = inputTraj
                        self.pastSearchDirection = result.search_direction
                        let resultHeading = compensateHeading(heading: result.absolute_heading)
                        var resultCorrected = (true, [result.x, result.y, resultHeading, 1.0])
                        if (self.runMode == "pdr") {
                            let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: result.x, y: result.y, heading: resultHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
                            resultCorrected.0 = pathMatchingResult.isSuccess
                            resultCorrected.1 = pathMatchingResult.xyhs
                        } else {
                            let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: result.x, y: result.y, heading: resultHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                            resultCorrected.0 = pathMatchingResult.isSuccess
                            resultCorrected.1 = pathMatchingResult.xyhs
                            
                            let isResultStraight = isResultHeadingStraight(drBuffer: self.unitDrBuffer, result: result)
                            if (!isResultStraight) {
                                resultCorrected.1[2] = result.absolute_heading
                            }
                        }
                        resultCorrected.1[2] = compensateHeading(heading: resultCorrected.1[2])
                        if (resultPhase.0 == 2 && result.scc < 0.25) {
                            self.isNeedTrajInit = true
                            self.phase = 1
                            self.phase2BadCount = 0
                            if (self.isStartSimulate) {
                                self.isPhaseBreakInSimulate = true
                            }
                            if (self.isActiveKf) {
                                self.isPhaseBreak = true
                            }
                        } else if (resultPhase.0 == 2) {
                            self.phase2BadCount += 1
                            if (self.phase2BadCount > 7) {
                                self.isNeedTrajInit = true
                                self.phase = 1
                                if (self.isStartSimulate) {
                                    self.isPhaseBreakInSimulate = true
                                }
                                if (self.isActiveKf) {
                                    self.isPhaseBreak = true
                                }
                                self.phase2BadCount = 0
                            }
                        } else {
                            if (resultPhase.0 == 4) {
                                if (!self.isActiveKf) {
                                    // 최초 Phase 2-> 4 진입
                                    if (self.isIndoor) {
                                        let outputBuilding = self.outputResult.building_name
                                        let outputLevel = self.outputResult.level_name

                                        self.timeUpdateOutput.building_name = outputBuilding
                                        self.timeUpdateOutput.level_name = outputLevel
                                        
                                        self.measurementOutput.building_name = outputBuilding
                                        self.measurementOutput.level_name = outputLevel
                                        
                                        if (!self.isVenusMode) {
                                            self.isActiveKf = true
                                            self.timeUpdateFlag = true
                                            self.isStartKf = true
                                        }
                                    }
                                    
                                    let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: result)
                                    let propagationValues: [Double] = propagationResult.1
                                    if (propagationResult.0) {
                                        var propagatedResult: [Double] = [resultCorrected.1[0]+propagationValues[0] , resultCorrected.1[1]+propagationValues[1], resultCorrected.1[2]+propagationValues[2]]
                                        let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                        propagatedResult = pathMatchingResult.xyhs
                                        propagatedResult[2] = compensateHeading(heading: propagatedResult[2])
                                        
                                        self.timeUpdatePosition.x = propagatedResult[0]
                                        self.timeUpdatePosition.y = propagatedResult[1]
                                        self.timeUpdatePosition.heading = propagatedResult[2]
                                        self.updateHeading = propagatedResult[2]

                                        self.timeUpdateOutput.x = propagatedResult[0]
                                        self.timeUpdateOutput.y = propagatedResult[1]
                                        self.timeUpdateOutput.absolute_heading = propagatedResult[2]

                                        self.measurementPosition.x = propagatedResult[0]
                                        self.measurementPosition.y = propagatedResult[1]
                                        self.measurementPosition.heading = propagatedResult[2]

                                        self.measurementOutput.x = propagatedResult[0]
                                        self.measurementOutput.y = propagatedResult[1]
                                        self.measurementOutput.absolute_heading = propagatedResult[2]

                                        self.outputResult.x = propagatedResult[0]
                                        self.outputResult.y = propagatedResult[1]
                                        self.outputResult.absolute_heading = propagatedResult[2]
                                    } else {
                                        self.timeUpdatePosition.x = resultCorrected.1[0]
                                        self.timeUpdatePosition.y = resultCorrected.1[1]
                                        self.timeUpdatePosition.heading = resultHeading
                                        self.updateHeading = resultHeading

                                        self.timeUpdateOutput.x = resultCorrected.1[0]
                                        self.timeUpdateOutput.y = resultCorrected.1[1]
                                        self.timeUpdateOutput.absolute_heading = resultHeading

                                        self.measurementPosition.x = resultCorrected.1[0]
                                        self.measurementPosition.y = resultCorrected.1[1]
                                        self.measurementPosition.heading = resultHeading

                                        self.measurementOutput.x = resultCorrected.1[0]
                                        self.measurementOutput.y = resultCorrected.1[1]
                                        self.measurementOutput.absolute_heading = resultHeading

                                        self.outputResult.x = resultCorrected.1[0]
                                        self.outputResult.y = resultCorrected.1[1]
                                        self.outputResult.absolute_heading = resultHeading
                                    }
                                    self.phase2BadCount = 0
                                    self.isMovePhase2To4 = true
                                } else {
                                    let trajLength = calculateAccumulatedLength(userTrajectory: self.userTrajectoryInfo)
                                    if (result.scc > 0.6) {
                                        let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: result)
                                        let propagationValues: [Double] = propagationResult.1
                                        if (propagationResult.0) {
                                            var propagatedResult: [Double] = [resultCorrected.1[0]+propagationValues[0] , resultCorrected.1[1]+propagationValues[1], resultCorrected.1[2]+propagationValues[2]]
                                            if (self.runMode == "pdr") {
                                                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 0, range: SQUARE_RANGE)
                                                propagatedResult = pathMatchingResult.xyhs
                                            } else {
                                                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                                propagatedResult = pathMatchingResult.xyhs
                                            }
                                            propagatedResult[2] = compensateHeading(heading: propagatedResult[2])
                                            
                                            self.timeUpdatePosition.x = propagatedResult[0]
                                            self.timeUpdatePosition.y = propagatedResult[1]

                                            self.timeUpdateOutput.x = propagatedResult[0]
                                            self.timeUpdateOutput.y = propagatedResult[1]

                                            self.measurementPosition.x = propagatedResult[0]
                                            self.measurementPosition.y = propagatedResult[1]

                                            self.measurementOutput.x = propagatedResult[0]
                                            self.measurementOutput.y = propagatedResult[1]

                                            self.outputResult.x = propagatedResult[0]
                                            self.outputResult.y = propagatedResult[1]
                                            
                                            if (trajLength >= USER_TRAJECTORY_LENGTH*0.6) {
                                                self.updateHeading = propagatedResult[2]
                                                self.timeUpdatePosition.heading = propagatedResult[2]
                                                self.timeUpdateOutput.absolute_heading = propagatedResult[2]
                                                self.measurementPosition.heading = propagatedResult[2]
                                                self.measurementOutput.absolute_heading = propagatedResult[2]
                                                self.outputResult.absolute_heading = propagatedResult[2]
                                            }
                                        } else {
                                            self.timeUpdatePosition.x = resultCorrected.1[0]
                                            self.timeUpdatePosition.y = resultCorrected.1[1]

                                            self.timeUpdateOutput.x = resultCorrected.1[0]
                                            self.timeUpdateOutput.y = resultCorrected.1[1]

                                            self.measurementPosition.x = resultCorrected.1[0]
                                            self.measurementPosition.y = resultCorrected.1[1]

                                            self.measurementOutput.x = resultCorrected.1[0]
                                            self.measurementOutput.y = resultCorrected.1[1]

                                            self.outputResult.x = resultCorrected.1[0]
                                            self.outputResult.y = resultCorrected.1[1]
                                            
                                            if (trajLength >= USER_TRAJECTORY_LENGTH*0.6) {
                                                self.updateHeading = resultCorrected.1[2]
                                                self.timeUpdatePosition.heading = resultCorrected.1[2]
                                                self.timeUpdateOutput.absolute_heading = resultCorrected.1[2]
                                                self.measurementPosition.heading = resultCorrected.1[2]
                                                self.measurementOutput.absolute_heading = resultCorrected.1[2]
                                                self.outputResult.absolute_heading = resultCorrected.1[2]
                                            }
                                        }
                                    }
                                    self.isMovePhase2To4 = true
                                }
                            }
                            
                            if (self.currentLevel == "0F") {
                                self.isNeedTrajInit = true
                                self.phase = 1
                                if (self.isStartSimulate) {
                                    self.isPhaseBreakInSimulate = true
                                }
                                if (self.isActiveKf) {
                                    self.isPhaseBreak = true
                                }
                            } else {
                                self.phase = resultPhase.0
                            }
                        }
                        self.serverResult[0] = result.x
                        self.serverResult[1] = result.y
                        self.serverResult[2] = result.absolute_heading
                        
                        self.outputResult.scc = result.scc
                        self.outputResult.phase = self.phase
                        if (self.isStartSimulate) {
                            self.resultToReturn.phase = self.phase
                            self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                        } else {
                            self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                        }
                        self.preOutputMobileTime = result.mobile_time
                        self.indexPast = result.index
                    }
                } else {
                    self.phase = 1
                    if (self.isStartSimulate) {
                        self.isPhaseBreakInSimulate = true
                    }
                    self.isNeedTrajInit = true
                }
            } else {
                let log: String = localTime + " , (Jupiter) Error : \(statusCode) Fail to request indoor position in Phase 2 (\(returnedString))"
//                print(log)
            }
        })
    }
    
    private func processPhase3(currentTime: Int, localTime: String, userTrajectory: [TrajectoryInfo], searchInfo: ([Int], [Int], Int, Int)) {
        let localTime = getLocalTimeString()
        self.isSufficientRfd = checkSufficientRfd(userTrajectory: userTrajectory)
        
        var requestScArray: [Double] = [self.scCompensation]
        if (self.runMode == "pdr") {
            requestScArray = [1.0]
            let accumulatedDiagnoal = calculateAccumulatedDiagonal(userTrajectory: userTrajectory)
            if (accumulatedDiagnoal < USER_TRAJECTORY_DIAGONAL/2) {
                requestScArray = [1.01]
            } else {
                if (self.isScRequested) {
                    requestScArray = [1.0]
                } else {
                    requestScArray = self.scCompensationArrayPdr
                    self.scRequestTime = currentTime
                    self.isScRequested = true
                }
            }
        } else {
            let accumulatedLength = calculateAccumulatedLength(userTrajectory: userTrajectory)
            if (accumulatedLength < accumulatedLength/2) {
                requestScArray = [1.01]
            } else {
                if (self.isScRequested) {
                    requestScArray = [1.01]
                } else {
                    requestScArray = [0.8, 1.0]
                    self.scRequestTime = currentTime
                    self.isScRequested = true
                }
            }
        }
        
        if (self.runMode == "pdr") {
            self.currentLevel = removeLevelDirectionString(levelName: self.currentLevel)
        }
        var levelArray = [self.currentLevel]
        let isInLevelChangeArea = self.checkInLevelChangeArea(result: self.lastResult, mode: self.runMode)
        if (isInLevelChangeArea) {
            levelArray = self.makeLevelChangeArray(buildingName: self.currentBuilding, levelName: self.currentLevel, buildingLevel: self.buildingsAndLevels)
        }
        
        if (abs(getCurrentTimeInMillisecondsDouble() - bleManager.bleDiscoveredTime) < 1000*10) || isSimulationMode {
            self.phase2BadCount = 0
            var input = FineLocationTracking(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id, building_name: self.currentBuilding, level_name_list: levelArray, phase: self.phase, search_range: searchInfo.0, search_direction_list: searchInfo.1, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), sc_compensation_list: requestScArray, tail_index: searchInfo.2)
            self.networkCount += 1
            if (self.regionName != "Korea" && self.deviceModel == "iPhone SE (2nd generation)") {
                input.normalization_scale = 1.01
            }
            NetworkManager.shared.postFLT(url: FLT_URL, input: input, userTraj: userTrajectory, trajType: searchInfo.3, completion: { [self] statusCode, returnedString, inputPhase, inputTraj, inputTrajType in
                if (!returnedString.contains("timed out")) {
                    self.networkCount = 0
                }
                if (statusCode == 200) {
                    let result = jsonToResult(json: returnedString)
                    if (result.x != 0 && result.y != 0) {
                        if (self.isScRequested) {
                            let compensationCheckTime = abs(result.mobile_time - self.scRequestTime)
                            if (compensationCheckTime < 100) {
                                if (result.scc < 0.55) {
                                    self.scCompensationBadCount += 1
                                } else {
                                    if (result.scc > 0.6) {
                                        let digit: Double = pow(10, 4)
                                        self.scCompensation = round((result.sc_compensation*digit)/digit)
                                        if (!self.isStartSimulate) {
    //                                        unitDRGenerator.setScVelocityScaleFactor(scaleFactor: self.scCompensation)
                                        }
                                    }
                                    self.scCompensationBadCount = 0
                                }
                                
                                if (self.scCompensationBadCount > 1) {
                                    self.scCompensationBadCount = 0
                                    let resultEstScCompensation = estimateScCompensation(sccResult: result.scc, scResult: result.sc_compensation, scArray: self.scCompensationArray)
                                    self.scCompensationArray = resultEstScCompensation
                                    self.isScRequested = false
                                }
                            } else if (compensationCheckTime > 3000) {
                                self.isScRequested = false
                            }
                        }
                        
                        if (result.mobile_time > self.preOutputMobileTime) {
                            self.accumulateServerResultAndRemoveOldest(serverResult: result)
                            let resultPhase = phaseController.controlPhase(serverResultArray: self.serverResultBuffer, drBuffer: self.unitDrBuffer, UVD_INTERVAL: self.UVD_INPUT_NUM, TRAJ_LENGTH: self.USER_TRAJECTORY_LENGTH, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
    //                        let resultPhase = phaseController.controlJupiterPhase(serverResult: result, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
    //                        self.isPhaseBreak = resultPhase.1
                            self.phaseBreakResult = result
                            if (resultPhase.1) {
                                self.isNeedTrajInit = true
    //                            self.phaseBreakResult = result
                            }
                            
                            let buildingName = result.building_name
                            let levelName = result.level_name
                            if (levelName == "B0") {
                                for i in 0..<self.EntranceNumbers {
                                    let number = i+1
                                    let entranceKey = "\(buildingName)_\(levelName)_\(number)"
                                    if let loadedData = self.EntranceInfo[entranceKey] {
                                    } else {
                                        self.loadEntranceFromUrl(key: entranceKey)
                                    }
                                }
                            }
                            
                            if (!self.isGetFirstResponse) {
                                if (!self.isIndoor && (self.timeForInit >= TIME_INIT_THRESHOLD)) {
                                    if (levelName != "B0") {
                                        self.isGetFirstResponse = true
                                        self.isIndoor = true
                                        self.reporting(input: INDOOR_FLAG)
                                    } else {
                                        for i in 0..<self.EntranceNumbers {
                                            if (!self.isStartSimulate) {
                                                let entranceResult = self.findEntrance(result: result, entrance: i)
                                                if (entranceResult.0 != 0) {
                                                    let entranceKey: String = "\(entranceResult.0)"
                                                    if let velocityScale: Double = self.EntranceScales[entranceKey] {
                                                        self.entranceVelocityScale = velocityScale
                                                    } else {
                                                        self.entranceVelocityScale = 1.0
                                                    }
                                                    self.currentEntrance = "\(result.building_name)_\(result.level_name)_\(entranceResult.0)"
                                                    if (self.networkBadEntrance.contains(self.currentEntrance)) {
                                                        self.isInNetworkBadEntrance = true
                                                    }
                                                    self.currentEntranceLength = entranceResult.1
                                                    self.isGetFirstResponse = true
                                                    self.isStartSimulate = true
                                                    unitDRGenerator.setIsStartSimulate(isStartSimulate: self.isStartSimulate)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                            
                            self.pastUserTrajectoryInfo = inputTraj
                            self.pastSearchDirection = result.search_direction
                            let resultHeading = compensateHeading(heading: result.absolute_heading)
                            var resultCorrected = (true, [result.x, result.y, resultHeading, 1.0])
                            if (self.runMode == "pdr") {
                                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: result.x, y: result.y, heading: result.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
                                resultCorrected.0 = pathMatchingResult.isSuccess
                                resultCorrected.1 = pathMatchingResult.xyhs
                            } else {
                                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: result.x, y: result.y, heading: result.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                resultCorrected.0 = pathMatchingResult.isSuccess
                                resultCorrected.1 = pathMatchingResult.xyhs
                                
                                let isResultStraight = isResultHeadingStraight(drBuffer: self.unitDrBuffer, result: result)
                                if (!isResultStraight) {
                                    resultCorrected.1[2] = result.absolute_heading
                                }
                            }
                            resultCorrected.1[2] = compensateHeading(heading: resultCorrected.1[2])
                            self.serverResult[0] = resultCorrected.1[0]
                            self.serverResult[1] = resultCorrected.1[1]
                            self.serverResult[2] = resultCorrected.1[2]
                            
                            if (!self.isActiveKf) {
                                // Add
                                if (resultPhase.0 == 4) {
                                    if (self.isIndoor) {
                                        let outputBuilding = self.outputResult.building_name
                                        let outputLevel = self.outputResult.level_name
                                        
                                        self.timeUpdateOutput.building_name = outputBuilding
                                        self.timeUpdateOutput.level_name = outputLevel
                                        
                                        self.measurementOutput.building_name = outputBuilding
                                        self.measurementOutput.level_name = outputLevel
                                        
                                        if (!self.isVenusMode) {
                                            self.isActiveKf = true
                                            self.timeUpdateFlag = true
                                            self.isStartKf = true
                                        }
                                    }
                                }
                                
                                if (resultPhase.0 == 4) {
                                    let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: result)
                                    var propagationValues: [Double] = propagationResult.1
                                    if (propagationResult.0) {
                                        var propagatedResult: [Double] = [resultCorrected.1[0]+propagationValues[0] , resultCorrected.1[1]+propagationValues[1], resultCorrected.1[2]+propagationValues[2]]
                                        if (self.runMode == "pdr") {
                                            let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 0, range: SQUARE_RANGE)
                                            propagatedResult = pathMatchingResult.xyhs
                                        } else {
                                            let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                            propagatedResult = pathMatchingResult.xyhs
                                        }
                                        propagatedResult[2] = compensateHeading(heading: propagatedResult[2])
                                        
                                        self.timeUpdatePosition.x = propagatedResult[0]
                                        self.timeUpdatePosition.y = propagatedResult[1]
                                        self.timeUpdatePosition.heading = propagatedResult[2]
                                        self.updateHeading = propagatedResult[2]

                                        self.timeUpdateOutput.x = propagatedResult[0]
                                        self.timeUpdateOutput.y = propagatedResult[1]
                                        self.timeUpdateOutput.absolute_heading = propagatedResult[2]

                                        self.measurementPosition.x = propagatedResult[0]
                                        self.measurementPosition.y = propagatedResult[1]
                                        self.measurementPosition.heading = propagatedResult[2]

                                        self.measurementOutput.x = propagatedResult[0]
                                        self.measurementOutput.y = propagatedResult[1]
                                        self.measurementOutput.absolute_heading = propagatedResult[2]

                                        self.outputResult.x = propagatedResult[0]
                                        self.outputResult.y = propagatedResult[1]
                                        self.outputResult.absolute_heading = propagatedResult[2]
                                    } else {
                                        self.timeUpdatePosition.x = resultCorrected.1[0]
                                        self.timeUpdatePosition.y = resultCorrected.1[1]
                                        self.timeUpdatePosition.heading = result.absolute_heading
                                        self.updateHeading = result.absolute_heading

                                        self.timeUpdateOutput.x = resultCorrected.1[0]
                                        self.timeUpdateOutput.y = resultCorrected.1[1]
                                        self.timeUpdateOutput.absolute_heading = result.absolute_heading

                                        self.measurementPosition.x = resultCorrected.1[0]
                                        self.measurementPosition.y = resultCorrected.1[1]
                                        self.measurementPosition.heading = result.absolute_heading

                                        self.measurementOutput.x = resultCorrected.1[0]
                                        self.measurementOutput.y = resultCorrected.1[1]
                                        self.measurementOutput.absolute_heading = result.absolute_heading

                                        self.outputResult.x = resultCorrected.1[0]
                                        self.outputResult.y = resultCorrected.1[1]
                                        self.outputResult.absolute_heading = result.absolute_heading
                                    }
                                    
                                    if (self.isStartSimulate) {
                                        self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                    } else {
                                        self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                    }
                                }
                                
                                var resultCopy = result
                                
                                let resultLevelName = removeLevelDirectionString(levelName: result.level_name)
                                let currentLevelName = removeLevelDirectionString(levelName: self.currentLevel)
                                
                                let levelArray: [String] = [resultLevelName, currentLevelName]
                                var TIME_CONDITION = VALID_BL_CHANGE_TIME
                                if (levelArray.contains("B0") && levelArray.contains("B2")) {
                                    TIME_CONDITION = VALID_BL_CHANGE_TIME*4
                                }
                                
                                if (result.building_name != self.currentBuilding || resultLevelName != currentLevelName) {
                                    if ((result.mobile_time - self.buildingLevelChangedTime) > TIME_CONDITION) {
                                        if (self.currentBuilding != "" && self.currentLevel != "0F") {
                                            self.buildingLevelChangedTime = currentTime
                                        }
                                        // Building Level 이 바뀐지 10초 이상 지남 -> 서버 결과를 이용해 바뀌어야 한다고 판단
                                        self.currentBuilding = result.building_name
                                        self.currentLevel = removeLevelDirectionString(levelName: result.level_name)
                                    } else {
                                        resultCopy.building_name = self.currentBuilding
                                        resultCopy.level_name = self.currentLevel
                                    }
                                }
                                let finalResult = fromServerToResult(fromServer: resultCopy, velocity: displayOutput.velocity, resultPhase: resultPhase.0)
                                
                                self.flagPast = false
                                self.outputResult = finalResult
                                if (self.isStartSimulate) {
                                    self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                } else {
                                    self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                }
                            } else {
                                // Kalman Filter가 동작 중이면서 위치 요청시 input의 phase 가 1~3 인 경우
                                let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: result)
                                let propagationValues: [Double] = propagationResult.1
                                var propagatedResult: [Double] = [resultCorrected.1[0]+propagationValues[0] , resultCorrected.1[1]+propagationValues[1], resultCorrected.1[2]+propagationValues[2]]
                                let pathMatchingResult = pmCalculator.pathMatching(building: result.building_name, level: result.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                propagatedResult = pathMatchingResult.xyhs
                                propagatedResult[2] = compensateHeading(heading: propagatedResult[2])
                                
                                
                                var tuHeading = compensateHeading(heading: timeUpdatePosition.heading)
                                var muHeading = propagatedResult[2]
                                if (tuHeading >= 270 && (muHeading >= 0 && muHeading < 90)) {
                                    muHeading = muHeading + 360
                                } else if (muHeading >= 270 && (tuHeading >= 0 && tuHeading < 90)) {
                                    tuHeading = tuHeading + 360
                                }
                                
                                if (resultPhase.0 == 4) {
                                    if (pathMatchingResult.isSuccess) {
                                        self.updateAllResult(result: propagatedResult, inputPhase: inputPhase, mode: self.runMode)
                                    } else {
                                        self.updateAllResult(result: resultCorrected.1, inputPhase: inputPhase, mode: self.runMode)
                                    }
                                } else if (resultPhase.0 == 3) {
                                    if (pathMatchingResult.isSuccess) {
                                        self.updateAllResult(result: propagatedResult, inputPhase: inputPhase, mode: self.runMode)
                                    } else {
                                        self.updateAllResult(result: resultCorrected.1, inputPhase: inputPhase, mode: self.runMode)
                                    }
                                }
                                var timUpdateOutputCopy = self.timeUpdateOutput
                                
                                let resultLevelName = removeLevelDirectionString(levelName: result.level_name)
                                let currentLevelName = removeLevelDirectionString(levelName: self.currentLevel)
                                
                                let levelArray: [String] = [resultLevelName, currentLevelName]
                                var TIME_CONDITION = VALID_BL_CHANGE_TIME
                                if (levelArray.contains("B0") && levelArray.contains("B2")) {
                                    TIME_CONDITION = VALID_BL_CHANGE_TIME*4
                                }
                                
                                if (result.building_name != self.currentBuilding || result.level_name != self.currentLevel) {
                                    if ((result.mobile_time - self.buildingLevelChangedTime) > TIME_CONDITION) {
                                        // Building Level 이 바뀐지 10초 이상 지남 -> 서버 결과를 이용해 바뀌어야 한다고 판단
                                        self.currentBuilding = result.building_name
                                        self.currentLevel = removeLevelDirectionString(levelName: result.level_name)
                                        
                                        timUpdateOutputCopy.building_name = result.building_name
                                        timUpdateOutputCopy.level_name = result.level_name
                                    } else {
                                        timUpdateOutputCopy.building_name = self.currentBuilding
                                        timUpdateOutputCopy.level_name = self.currentLevel
                                    }
                                    timUpdateOutputCopy.mobile_time = result.mobile_time
                                }
                                
                                let updatedResult = fromServerToResult(fromServer: timUpdateOutputCopy, velocity: displayOutput.velocity, resultPhase: resultPhase.0)
                                self.timeUpdateOutput = timUpdateOutputCopy
                                
                                self.flagPast = false
                                self.outputResult = updatedResult
                                
                                if (self.isStartSimulate) {
                                    self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                } else {
                                    self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                }
                            }
                            
                            if (self.isVenusMode || !self.lookingState) {
                                self.phase = 1
                                self.outputResult.phase = 1
                                self.outputResult.absolute_heading = 0
                                
                                if (self.isStartSimulate) {
                                    self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                } else {
                                    self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                }
                            } else {
                                self.phase = resultPhase.0
                            }
                            self.indexPast = result.index
                            self.preOutputMobileTime = result.mobile_time
                            
                            displayOutput.indexRx = result.index
                            displayOutput.scc = result.scc
                            displayOutput.phase = String(self.phase)
                        }
                    } else {
                        self.phase = 1
                        self.isNeedTrajInit = true
                    }
                } else {
                    let log: String = localTime + " , (Jupiter) Error : \(statusCode) Fail to request indoor position in Phase 3"
    //                print(log)
                }
            })
        }
    }
    
    private func processPhase4(currentTime: Int, localTime: String, userTrajectory: [TrajectoryInfo], searchInfo: ([Int], [Int], Int, Int)) {
        let localTime = getLocalTimeString()
        self.isSufficientRfd = checkSufficientRfd(userTrajectory: userTrajectory)
        
        self.nowTime = currentTime
        var requestScArray: [Double] = [self.scCompensation]
        
        if (self.runMode == "pdr") {
            self.currentLevel = removeLevelDirectionString(levelName: self.currentLevel)
        }
        var levelArray = [self.currentLevel]
        let isInLevelChangeArea = self.checkInLevelChangeArea(result: self.lastResult, mode: self.runMode)
        if (isInLevelChangeArea) {
            levelArray = self.makeLevelChangeArray(buildingName: self.currentBuilding, levelName: self.currentLevel, buildingLevel: self.buildingsAndLevels)
        }
        
        // 사이즈 검사
        // 3개 -> scCompensation 불가능 -> 여기는 무조건 1개 보냄
        if (self.runMode == "pdr") {
            let accumulatedDiagnoal = calculateAccumulatedDiagonal(userTrajectory: userTrajectory)
            if (accumulatedDiagnoal < USER_TRAJECTORY_DIAGONAL/2) {
                requestScArray = [1.01]
            } else {
                if (self.isScRequested) {
                    requestScArray = [1.01]
                } else {
                    requestScArray = self.scCompensationArrayPdr
                    self.scRequestTime = currentTime
                    self.isScRequested = true
                }
            }
        } else {
            let accumulatedLength = calculateAccumulatedLength(userTrajectory: userTrajectory)
            if (accumulatedLength < accumulatedLength/2) {
                requestScArray = [1.01]
            } else {
                if (isInLevelChangeArea) {
                    requestScArray = [0.8, 1.0]
                } else {
                    if (self.isScRequested) {
                        requestScArray = [1.01]
                    } else {
                        requestScArray = self.scCompensationArray
                        self.scRequestTime = currentTime
                        self.isScRequested = true
                    }
                }
            }
        }
        
        self.sccBadCount = 0
        var input = FineLocationTracking(user_id: self.user_id, mobile_time: currentTime, sector_id: self.sector_id, building_name: self.currentBuilding, level_name_list: levelArray, phase: self.phase, search_range: searchInfo.0, search_direction_list: searchInfo.1, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), sc_compensation_list: requestScArray, tail_index: searchInfo.2)
        self.networkCount += 1
        if (self.regionName != "Korea" && self.deviceModel == "iPhone SE (2nd generation)") {
            input.normalization_scale = 1.01
        }
        NetworkManager.shared.postFLT(url: FLT_URL, input: input, userTraj: userTrajectory, trajType: searchInfo.3, completion: { [self] statusCode, returnedString, inputPhase, inputTraj, inputTrajType in
            if (!returnedString.contains("timed out")) {
                self.networkCount = 0
            }
            if (statusCode == 200) {
                let result = jsonToResult(json: returnedString)
                // Sc Compensation
                if (self.isScRequested) {
                    let compensationCheckTime = abs(result.mobile_time - self.scRequestTime)
                    if (compensationCheckTime < 100) {
                        if (result.scc < 0.55) {
                            self.scCompensationBadCount += 1
                        } else {
                            if (result.scc > 0.6) {
                                let digit: Double = pow(10, 4)
                                self.scCompensation = round((result.sc_compensation*digit)/digit)
                                if (!self.isStartSimulate) {
//                                    unitDRGenerator.setScVelocityScaleFactor(scaleFactor: self.scCompensation)
                                }
                            }
                            self.scCompensationBadCount = 0
                        }

                        if (self.scCompensationBadCount > 1) {
                            self.scCompensationBadCount = 0
                            let resultEstScCompensation = estimateScCompensation(sccResult: result.scc, scResult: result.sc_compensation, scArray: self.scCompensationArray)
                            self.scCompensationArray = resultEstScCompensation
                            self.isScRequested = false
                        }
                    } else if (compensationCheckTime > 3000) {
                        self.isScRequested = false
                    }
                }
                
                if (result.index > self.indexPast) {
                    self.accumulateServerResultAndRemoveOldest(serverResult: result)
                    let resultPhase = phaseController.controlPhase(serverResultArray: self.serverResultBuffer, drBuffer: self.unitDrBuffer, UVD_INTERVAL: self.UVD_INPUT_NUM, TRAJ_LENGTH: self.USER_TRAJECTORY_LENGTH, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
//                    let resultPhase = phaseController.controlJupiterPhase(serverResult: result, inputPhase: inputPhase, mode: self.runMode, isVenusMode: self.isVenusMode)
                    self.pastUserTrajectoryInfo = inputTraj
                    self.pastSearchDirection = result.search_direction
                    if (self.isActiveKf && resultPhase.0 == 4) {
                        if (!(result.x == 0 && result.y == 0) && !self.isDetermineSpot && self.phase != 2) {
                            if (self.isPhaseBreak) {
                                self.kalmanR = 0.5
                                self.headingKalmanR = 1
                                self.SQUARE_RANGE = self.SQUARE_RANGE_SMALL
                                self.isPhaseBreak = false
                            }
                            
                            if (self.isStartKf) {
                                self.isStartKf = false
                            } else {
                                // Measurment Update
                                if (measurementUpdateFlag) {
                                    displayOutput.indexRx = result.index
                                    displayOutput.scc = result.scc
                                    displayOutput.phase = String(self.phase)
                                    // Measurement Update 하기전에 현재 Time Update 위치를 고려
                                    var resultForMu = result
                                    var isNeedCalDhFromUvd: Bool = false
                                    resultForMu.absolute_heading = compensateHeading(heading: resultForMu.absolute_heading)
                                    var resultCorrected = (true, [resultForMu.x, resultForMu.y, resultForMu.absolute_heading, 1.0])
                                    if (self.runMode == "pdr") {
                                        let isResultStraight = isResultHeadingStraight(drBuffer: self.unitDrBuffer, result: result)
                                        var isUseHeading: Bool = false
                                        if (isResultStraight) {
                                            isUseHeading = true
                                        }
                                        let pathMatchingResult = pmCalculator.pathMatching(building: resultForMu.building_name, level: resultForMu.level_name, x: resultForMu.x, y: resultForMu.y, heading: resultForMu.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: isUseHeading, pathType: 0, range: SQUARE_RANGE)
                                        resultCorrected.0 = pathMatchingResult.isSuccess
                                        resultCorrected.1 = pathMatchingResult.xyhs
                                    } else {
                                        let pathMatchingResult = pmCalculator.pathMatching(building: resultForMu.building_name, level: resultForMu.level_name, x: resultForMu.x, y: resultForMu.y, heading: resultForMu.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                                        resultCorrected.0 = pathMatchingResult.isSuccess
                                        resultCorrected.1 = pathMatchingResult.xyhs
                                        
                                        if (inputTrajType == 3) {
                                            let isResultStraight = isResultHeadingStraight(drBuffer: self.unitDrBuffer, result: result)
                                            if (!isResultStraight) {
                                                resultCorrected.1[2] = result.absolute_heading
                                                isNeedCalDhFromUvd = true
                                            }
                                        }
                                    }
                                    
                                    resultCorrected.1[2] = compensateHeading(heading: resultCorrected.1[2])
                                    self.serverResult[0] = resultCorrected.1[0]
                                    self.serverResult[1] = resultCorrected.1[1]
                                    self.serverResult[2] = resultCorrected.1[2]
                                            
                                    let indexBuffer: [Int] = self.uvdIndexBuffer
                                    let uvdHeadingBuffer: [Double] = self.uvdHeadingBuffer
                                    let tuBuffer: [[Double]] = self.tuResultBuffer
                                            
                                    var currentTuResult = self.currentTuResult
                                    var pastTuResult = self.pastTuResult
                                            
                                    var dx: Double = 0
                                    var dy: Double = 0
                                    var dh: Double = 0
                                            
                                    if (currentTuResult.mobile_time != 0 && pastTuResult.mobile_time != 0) {
                                        if let idx = indexBuffer.firstIndex(of: result.index) {
                                            var isNeedUvdPropagation: Bool = false
                                            if (self.runMode == "pdr") {
                                                let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: result)
                                                if (propagationResult.0) {
                                                    dx = propagationResult.1[0]
                                                    dy = propagationResult.1[1]
                                                    dh = propagationResult.1[2]
                                                    isNeedUvdPropagation = true
                                                } else {
                                                    isNeedUvdPropagation = false
                                                }
                                            } else {
                                                isNeedUvdPropagation = false
                                            }
                                            
                                            if (!isNeedUvdPropagation) {
                                                dx = currentTuResult.x - tuBuffer[idx][0]
                                                dy = currentTuResult.y - tuBuffer[idx][1]
                                                currentTuResult.absolute_heading = compensateHeading(heading: currentTuResult.absolute_heading)
                                                let tuBufferHeading = compensateHeading(heading: tuBuffer[idx][2])
                                                
                                                if (isNeedCalDhFromUvd) {
                                                    dh = uvdHeadingBuffer[uvdHeadingBuffer.count-1] - uvdHeadingBuffer[idx]
                                                } else {
                                                    dh = currentTuResult.absolute_heading - tuBufferHeading
                                                }
                                            }
                                            
                                            self.usedUvdIndex = idx
                                            self.isNeedUvdIndexBufferClear = true
                                        } else {
                                            dx = currentTuResult.x - pastTuResult.x
                                            dy = currentTuResult.y - pastTuResult.y
                                            currentTuResult.absolute_heading = compensateHeading(heading: currentTuResult.absolute_heading)
                                            pastTuResult.absolute_heading = compensateHeading(heading: pastTuResult.absolute_heading)
                                                    
                                            dh = currentTuResult.absolute_heading - pastTuResult.absolute_heading
                                        }
                                                
                                        resultForMu.x = resultCorrected.1[0] + dx
                                        resultForMu.y = resultCorrected.1[1] + dy
                                        if (self.isNeedHeadingCorrection) {
                                            resultForMu.absolute_heading = resultCorrected.1[2] + dh
                                        } else {
                                            resultForMu.absolute_heading = resultForMu.absolute_heading + dh
                                        }
                                        resultForMu.absolute_heading = compensateHeading(heading: resultForMu.absolute_heading)
                                    }
                                            
                                    let muOutput = measurementUpdate(timeUpdatePosition: timeUpdatePosition, serverOutputHat: resultForMu, serverResult: result, originalResult: resultCorrected.1, isNeedHeadingCorrection: self.isNeedHeadingCorrection, mode: self.runMode)
                                    var muResult = fromServerToResult(fromServer: muOutput, velocity: displayOutput.velocity, resultPhase: resultPhase.0)
                                    muResult.mobile_time = result.mobile_time
                                            
                                    let resultLevelName = removeLevelDirectionString(levelName: result.level_name)
                                    let currentLevelName = removeLevelDirectionString(levelName: self.currentLevel)
                                            
                                    let levelArray: [String] = [resultLevelName, currentLevelName]
                                    var TIME_CONDITION = VALID_BL_CHANGE_TIME
                                    if (levelArray.contains("B0") && levelArray.contains("B2")) {
                                        TIME_CONDITION = VALID_BL_CHANGE_TIME*4
                                    }
                                            
                                    if (result.building_name != self.currentBuilding || resultLevelName != currentLevelName) {
                                        if ((result.mobile_time - self.buildingLevelChangedTime) > TIME_CONDITION) {
                                            if (self.currentBuilding != "" && self.currentLevel != "0F") {
                                                self.buildingLevelChangedTime = currentTime
                                            }
                                            // Building Level 이 바뀐지 10초 이상 지남 -> 서버 결과를 이용해 바뀌어야 한다고 판단
                                            self.currentBuilding = result.building_name
                                            self.currentLevel = removeLevelDirectionString(levelName: result.level_name)
                                                    
                                            muResult.building_name = result.building_name
                                            muResult.level_name = result.level_name
                                        } else {
                                            muResult.building_name = self.currentBuilding
                                            muResult.level_name = self.currentLevel
                                        }
                                    }
                                            
                                    self.flagPast = false
                                    self.outputResult = muResult
                                    if (self.isStartSimulate) {
                                        self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                    } else {
                                        self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                                    }
                                    timeUpdatePositionInit(serverOutput: muOutput)
                                }
                            }
                        } else {
                            if (result.x == 0 && result.y == 0) {
                                self.isNeedTrajInit = true
                                self.isPhaseBreak = true
                                self.phase = 1
                            }
                        }
                    } else {
                        if (self.isActiveKf) {
                            self.SQUARE_RANGE = self.SQUARE_RANGE_LARGE
                            self.kalmanR = 0.01
                            self.headingKalmanR = 0.01
                            self.phaseBreakResult = result
                        }
                        self.isNeedTrajInit = true
                        self.isPhaseBreak = resultPhase.1
                    }
                    self.phase = resultPhase.0
                    self.indexPast = result.index
                }
                self.preOutputMobileTime = result.mobile_time
            } else {
                let log: String = localTime + " , (Jupiter) Error : \(statusCode) Fail to request indoor position in Phase 4"
                print(log)
            }
        })
    }
    
    @objc func osrTimerUpdate() {
        let currentTime = getCurrentTimeInMilliseconds()
        var isRunOsr: Bool = true
        if (self.isGetFirstResponse && !self.isInNetworkBadEntrance) {
            if (self.runMode != "pdr") {
                if (self.phase == 4) {
                    let isInLevelChangeArea = self.checkInLevelChangeArea(result: self.jupiterResult, mode: self.runMode)
                    if (!isInLevelChangeArea) {
                        isRunOsr = false
                    }
                }
                
                if (isRunOsr) {
                    let input = OnSpotRecognition(user_id: self.user_id, mobile_time: currentTime, normalization_scale: self.normalizationScale, device_min_rss: Int(self.deviceMinRss), standard_min_rss: Int(self.standardMinRss))
                    NetworkManager.shared.postOSR(url: OSR_URL, input: input, completion: { [self] statusCode, returnedString in
                        if (statusCode == 200) {
                            let result = decodeOSR(json: returnedString)
                            if (result.building_name != "" && result.level_name != "") {
                                let isOnSpot = isOnSpotRecognition(result: result, level: self.currentLevel)
                                if (isOnSpot.isOn) {
                                    let levelDestination = isOnSpot.levelDestination + isOnSpot.levelDirection
                                    determineSpotDetect(result: result, lastSpotId: self.lastOsrId, levelDestination: levelDestination, currentTime: currentTime)
                                }
                            }
                        }
                    })
                }
            }
        } else {
            self.travelingOsrDistance = 0
        }
        
        
        if (self.networkCount >= 5 && NetworkCheck.shared.isConnectedToInternet()) {
            self.reporting(input: NETWORK_WAITING_FLAG)
        }
        
        if (NetworkCheck.shared.isConnectedToInternet()) {
            self.isNetworkConnectReported = false
        } else {
            if (!self.isNetworkConnectReported) {
                self.isNetworkConnectReported = true
                print(getLocalTimeString() + " , (Jupiter) Network : Connection Lost")
                self.reporting(input: NETWORK_CONNECTION_FLAG)
            }
        }
    }
    
    func isOnSpotRecognition(result: OnSpotRecognitionResult, level: String) -> (isOn: Bool, levelDestination: String, levelDirection: String) {
        let localTime = getLocalTimeString()
        var isOn: Bool = false
        let building_name = result.building_name
        let level_name = result.level_name
        let linked_level_name = result.linked_level_name
        
        let levelArray: [String] = [level_name, linked_level_name]
        var levelDestination: String = ""

        if (linked_level_name == "") {
            isOn = false
            return (isOn, levelDestination, "")
        } else {
            if (level_name == linked_level_name) {
                isOn = false
                return (isOn, "", "")
            }
            
            if (self.currentLevel == "") {
                isOn = false
                return (isOn, "", "")
            }
            
            // Normal OSR
            let currentLevel: String = level
            let levelNameCorrected: String = removeLevelDirectionString(levelName: currentLevel)
            for i in 0..<levelArray.count {
                if levelArray[i] != levelNameCorrected {
                    levelDestination = levelArray[i]
                    isOn = true
                }
            }
            
            // Up or Down Direction
            let currentLevelNum: Int = getLevelNumber(levelName: currentLevel)
            let destinationLevelNum: Int = getLevelNumber(levelName: levelDestination)
            let levelDirection: String = checkLevelDirection(currentLevel: currentLevelNum, destinationLevel: destinationLevelNum)
            
            return (isOn, levelDestination, levelDirection)
        }
    }
    
    func determineSpotDetect(result: OnSpotRecognitionResult, lastSpotId: Int, levelDestination: String, currentTime: Int) {
        let localTime = getLocalTimeString()
        var spotDistance = result.spot_distance
        if (spotDistance == 0) {
            spotDistance = DEFAULT_SPOT_DISTANCE
        }
        
        let levelArray: [String] = [result.level_name, result.linked_level_name]
        var TIME_CONDITION = VALID_BL_CHANGE_TIME
        if (levelArray.contains("B0") && levelArray.contains("B2")) {
            TIME_CONDITION = VALID_BL_CHANGE_TIME*3
        }
        
        if (result.spot_id != lastSpotId) {
            // Different Spot Detected
            let resultLevelName: String = removeLevelDirectionString(levelName: levelDestination)
            if (result.building_name != self.currentBuilding || resultLevelName != self.currentLevel) {
                if ((result.mobile_time - self.buildingLevelChangedTime) > TIME_CONDITION) {
                    // Building Level 이 바뀐지 7초 이상 지남 -> 서버 결과를 이용해 바뀌어야 한다고 판단
                    self.currentBuilding = result.building_name
                    self.currentLevel = levelDestination
                    self.timeUpdateOutput.building_name = result.building_name
                    self.timeUpdateOutput.level_name = levelDestination
                    self.measurementOutput.building_name = result.building_name
                    self.measurementOutput.level_name = levelDestination
                    self.outputResult.level_name = levelDestination

                    self.phase2Range = result.spot_range
                    if (levelDestination.contains("_D")) {
                        self.phase2Direction = result.spot_direction_up
                    } else {
                        self.phase2Direction = result.spot_direction_down
                    }
                    
                    self.currentSpot = result.spot_id
                    self.lastOsrId = result.spot_id
                    self.travelingOsrDistance = 0
                    self.buildingLevelChangedTime = currentTime
                    
                    self.isDetermineSpot = true
                    self.spotCutIndex = self.determineSpotCutIndex(entranceString: self.currentEntrance)
                    self.isNeedRemovePhase2To4Trajectroy = true
                    
                    if (self.isStartSimulate) {
                        self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                    } else {
                        self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                    }
                }
            }
            
            self.preOutputMobileTime = currentTime
        } else {
            // Same Spot Detected
            if (self.travelingOsrDistance >= spotDistance) {
                let resultLevelName: String = removeLevelDirectionString(levelName: levelDestination)
                if (result.building_name != self.currentBuilding || resultLevelName != self.currentLevel) {
                    if ((result.mobile_time - self.buildingLevelChangedTime) > TIME_CONDITION) {
                        // Building Level 이 바뀐지 7초 이상 지남 -> 서버 결과를 이용해 바뀌어야 한다고 판단
                        self.currentBuilding = result.building_name
                        self.currentLevel = levelDestination
                        self.timeUpdateOutput.building_name = result.building_name
                        self.timeUpdateOutput.level_name = levelDestination
                        self.measurementOutput.building_name = result.building_name
                        self.measurementOutput.level_name = levelDestination
                        self.outputResult.level_name = levelDestination
                        
                        self.phase2Range = result.spot_range
                        if (levelDestination.contains("_D")) {
                            self.phase2Direction = result.spot_direction_up
                        } else {
                            self.phase2Direction = result.spot_direction_down
                        }
                        
                        self.currentSpot = result.spot_id
                        self.lastOsrId = result.spot_id
                        self.travelingOsrDistance = 0
                        self.buildingLevelChangedTime = currentTime
                        
                        self.isDetermineSpot = true
                        self.spotCutIndex = self.determineSpotCutIndex(entranceString: self.currentEntrance)
                        self.isNeedRemovePhase2To4Trajectroy = true
                        
                        if (self.isStartSimulate) {
                            self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                        } else {
                            self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
                        }
                    }
                }
                self.preOutputMobileTime = currentTime
            }
        }
    }
    
    func getLevelNumber(levelName: String) -> Int {
        let levelNameCorrected: String = removeLevelDirectionString(levelName: levelName)
        if (levelNameCorrected[levelNameCorrected.startIndex] == "B") {
            // 지하
            let levelTemp = levelNameCorrected.substring(from: 1, to: levelNameCorrected.count-1)
            var levelNum = Int(levelTemp) ?? 0
            levelNum = (-1*levelNum)-1
            return levelNum
        } else {
            // 지상
            let levelTemp = levelNameCorrected.substring(from: 0, to: levelNameCorrected.count-2)
            var levelNum = Int(levelTemp) ?? 0
            levelNum = levelNum+1
            return levelNum
        }
    }
    
    func checkInEntranceLevel(result: FineLocationTrackingResult, isGetFirstResponse: Bool, isStartSimulate: Bool) -> Bool {
        if (!isGetFirstResponse) {
            return true
        }
        
        if (isStartSimulate) {
            return true
        }
        
        let lastResult = result
        
        let buildingName = lastResult.building_name
        let levelName = removeLevelDirectionString(levelName: result.level_name)
        
        if (levelName == "B0") {
            return true
        } else {
            let key = "\(buildingName)_\(levelName)"
            guard let entranceArea: [[Double]] = EntranceArea[key] else {
                return false
            }
            
            for i in 0..<entranceArea.count {
                if (!entranceArea[i].isEmpty) {
                    let xMin = entranceArea[i][0]
                    let yMin = entranceArea[i][1]
                    let xMax = entranceArea[i][2]
                    let yMax = entranceArea[i][3]
                    
                    if (lastResult.x >= xMin && lastResult.x <= xMax) {
                        if (lastResult.y >= yMin && lastResult.y <= yMax) {
                            return true
                        }
                    }
                }
                
            }
            return false
        }
    }
    
    func checkInLevelChangeArea(result: FineLocationTrackingResult, mode: String) -> Bool {
        if (mode == "pdr") {
            return false
        }
        
        let lastResult = result
        
        let buildingName = lastResult.building_name
        let levelName = removeLevelDirectionString(levelName: result.level_name)

        let key = "\(buildingName)_\(levelName)"
        guard let levelChangeArea: [[Double]] = LevelChangeArea[key] else {
            return false
        }
        
        for i in 0..<levelChangeArea.count {
            if (!levelChangeArea[i].isEmpty) {
                let xMin = levelChangeArea[i][0]
                let yMin = levelChangeArea[i][1]
                let xMax = levelChangeArea[i][2]
                let yMax = levelChangeArea[i][3]
                
                if (lastResult.x >= xMin && lastResult.x <= xMax) {
                    if (lastResult.y >= yMin && lastResult.y <= yMax) {
                        return true
                    }
                }
            }
        }

        return false
    }
    
    func makeLevelChangeArray(buildingName: String, levelName: String, buildingLevel: [String:[String]]) -> [String] {
        let inputLevel = levelName
        var levelArrayToReturn: [String] = [levelName]
        
        if (inputLevel.contains("_D")) {
            let levelCandidate = inputLevel.replacingOccurrences(of: "_D", with: "")
            levelArrayToReturn = [inputLevel, levelCandidate]
        } else {
            let levelCandidate = inputLevel + "_D"
            levelArrayToReturn = [inputLevel, levelCandidate]
        }
        
        if (!buildingLevel.isEmpty) {
            guard let levelList: [String] = buildingLevel[buildingName] else {
                return levelArrayToReturn
            }
            
            var newArray = [String]()
            for i in 0..<levelArrayToReturn.count {
                let levelName: String = levelArrayToReturn[i]
                if (levelList.contains(levelName)) {
                    newArray.append(levelName)
                }
            }
            levelArrayToReturn = newArray
        }
        
        return levelArrayToReturn
    }
    
    func postParam(sector_id: Int, normailzationScale: Double) {
        let localTime = getLocalTimeString()
        
        let input = JupiterParamPost(device_model: self.deviceModel, os_version: self.deviceOsVersion, sector_id: sector_id, normalization_scale: normailzationScale)
        NetworkManager.shared.postJupiterParam(url: NS_URL, input: input, completion: { statusCode, returnedString in
            if (statusCode == 200) {
                print(localTime + " , (Jupiter) Success : Save Jupiter Param \(normailzationScale)")
            } else {
                print(localTime + " , (Jupiter) Warnings : Save Jupiter Param ")
            }
        })
    }
    
    func postReport(report: Int) {
        if (self.isSaveFlag) {
            let reportInput = MobileReport(user_id: self.user_id, mobile_time: getCurrentTimeInMilliseconds(), report: report)
            NetworkManager.shared.postMobileReport(url: MT_URL, input: reportInput, completion: { [self] statusCode, returnedStrig in
                if (statusCode == 200) {
                    let localTime = getLocalTimeString()
                    let log: String = localTime + " , (Jupiter) Success : Record Mobile Report \(report)"
//                    print(log)
                }
            })
        }
    }
    
    func estimateScCompensation(sccResult: Double, scResult: Double, scArray: [Double]) -> [Double] {
        let newScArray: [Double] = scArray
        
        return newScArray
    }
    
    
    @objc func collectTimerUpdate() {
        self.collectData = sensorManager.collectData
        
        let localTime = getLocalTimeString()
        let validTime = self.BLE_VALID_TIME
        let currentTime = getCurrentTimeInMilliseconds()
        let bleDictionary: [String: [[Double]]]? = bleManager.bleDictionary
        if let bleData = bleDictionary {
            let trimmedResult = trimBleForCollect(bleData: bleData, nowTime: getCurrentTimeInMillisecondsDouble(), validTime: validTime)
            let bleAvg = avgBleData(bleDictionary: trimmedResult)
            let bleRaw = latestBleData(bleDictionary: trimmedResult)
            
            sensorManager.collectData.time = currentTime
            sensorManager.collectData.bleRaw = bleRaw
            sensorManager.collectData.bleAvg = bleAvg
        } else {
            let log: String = localTime + " , (Jupiter) Warnings : Fail to get recent ble"
            print(log)
        }
        
        if (isStartFlag) {
            unitDRInfo = unitDRGenerator.generateDRInfo(sensorData: sensorManager.sensorData)
        }
        
        sensorManager.collectData.isIndexChanged = false
        if (unitDRInfo.isIndexChanged) {
            sensorManager.collectData.isIndexChanged = unitDRInfo.isIndexChanged
            sensorManager.collectData.index = unitDRInfo.index
            sensorManager.collectData.length = unitDRInfo.length
            sensorManager.collectData.heading = unitDRInfo.heading
            sensorManager.collectData.lookingFlag = unitDRInfo.lookingFlag
        }
    }
    
    private func parseEntrance(data: String) -> ([String], [[Double]]) {
        var entracneLevelArray = [String]()
        var entranceArray = [[Double]]()
        
        let entranceString = data.components(separatedBy: .newlines)
        for i in 0..<entranceString.count {
            if (entranceString[i] != "") {
                let lineData = entranceString[i].components(separatedBy: ",")
                
                let entrance: [Double] = [(Double(lineData[1])!), (Double(lineData[2])!), (Double(lineData[3])!)]
                
                entracneLevelArray.append(lineData[0])
                entranceArray.append(entrance)
            }
        }
        
        return (entracneLevelArray, entranceArray)
    }
    
    private func findEntrance(result: FineLocationTrackingFromServer, entrance: Int) -> (Int, Int) {
        var entranceNumber: Int = 0
        var entranceLength: Int = 0
        
        let buildingName = result.building_name
        let levelName = removeLevelDirectionString(levelName: result.level_name)
        
        let resultPm = pmCalculator.pathMatching(building: buildingName, level: levelName, x: result.x, y: result.y, heading: result.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 1, range: SQUARE_RANGE)
        
        let coordX = resultPm.xyhs[0]
        let coordY = resultPm.xyhs[1]
        
        var resultCopy = result
        resultCopy.x = coordX
        resultCopy.y = coordY
        
        if (levelName == "B0") {
            let number = entrance+1
            
            let key = "\(buildingName)_\(levelName)_\(number)"
            
            guard let entranceInfo: [[Double]] = self.EntranceInfo[key] else {
                return (entranceNumber, entranceLength)
            }
            
            var column1Min = Double.infinity
            var column1Max = -Double.infinity

            for row in entranceInfo {
                let value = row[0]
                column1Min = min(column1Min, value)
                column1Max = max(column1Max, value)
            }

            var column2Min = Double.infinity
            var column2Max = -Double.infinity

            for row in entranceInfo {
                let value = row[1]
                column2Min = min(column2Min, value)
                column2Max = max(column2Max, value)
            }

            let xMin = column1Min
            let xMax = column1Max
            let yMin = column2Min
            let yMax = column2Max

            if (coordX >= xMin && coordX <= xMax) {
                if (coordY >= yMin && coordY <= yMax) {
                    entranceNumber = number
                    entranceLength = entranceInfo.count
                }
            }
        }
        
        return (entranceNumber, entranceLength)
    }
    
    
    private func simulateEntrance(originalResult: FineLocationTrackingResult, runMode: String, currentEntranceIndex: Int) -> FineLocationTrackingResult {
        var result = originalResult
        
        result.index = self.unitDrInfoIndex
        result.mode = runMode
        
        guard let entranceLevelInfo: [String] = self.EntranceLevelInfo[self.currentEntrance] else {
            return result
        }
        
        guard let entranceInfo: [[Double]] = self.EntranceInfo[self.currentEntrance] else {
            return result
        }
        
        result.level_name = entranceLevelInfo[currentEntranceIndex]
        result.x = entranceInfo[currentEntranceIndex][0]
        result.y = entranceInfo[currentEntranceIndex][1]
        result.absolute_heading = entranceInfo[currentEntranceIndex][2]
        
        return result
    }
    
    private func findClosestSimulation(originalResult: FineLocationTrackingResult, currentEntranceIndex: Int) -> Bool {
        var isFindClosestSimulation: Bool = false
        
        let userX = originalResult.x
        let userY = originalResult.y
        let userH = originalResult.absolute_heading
        
        guard let entranceInfo: [[Double]] = self.EntranceInfo[self.currentEntrance] else {
            return isFindClosestSimulation
        }
        
        for i in currentEntranceIndex..<entranceInfo.count {
            let entranceX = entranceInfo[i][0]
            let entranceY = entranceInfo[i][1]
            let entracneH = entranceInfo[i][2]
            
            let diffX = userX - entranceX
            let diffY = userY - entranceY
            var diffH = compensateHeading(heading: (userH - entracneH))
            if (diffH >= 270) {
                diffH = 360 - diffH
            }
            let diffXy = sqrt(diffX*diffX + diffY*diffY)
            if (diffXy <= 10 && diffH <= 30) {
                isFindClosestSimulation = true
            }
        }
        
        return isFindClosestSimulation
    }
    
    private func findMatchedSimulation(originalResult: FineLocationTrackingResult) -> Bool {
        var isFindMatchedSimulation: Bool = false
        
        let userX = originalResult.x
        let userY = originalResult.y
        let userH = originalResult.absolute_heading
        
        guard let entranceInfo: [[Double]] = self.EntranceInfo[self.currentEntrance] else {
            return isFindMatchedSimulation
        }
        
        guard let entranceLevelInfo: [String] = self.EntranceLevelInfo[self.currentEntrance] else {
            return isFindMatchedSimulation
        }
        
        for i in 0..<entranceInfo.count {
            let entranceLevel: String = entranceLevelInfo[i]
            if (entranceLevel != "B0") {
                let entranceX = entranceInfo[i][0]
                let entranceY = entranceInfo[i][1]
                let entracneH = entranceInfo[i][2]
                
                let diffX = userX - entranceX
                let diffY = userY - entranceY
                var diffH = compensateHeading(heading: (userH - entracneH))
                if (diffH >= 270) {
                    diffH = 360 - diffH
                }
                let diffXy = sqrt(diffX*diffX + diffY*diffY)
                if (diffXy <= 10 && diffH <= 30) {
                    isFindMatchedSimulation = true
                }
            }
        }
        
        return isFindMatchedSimulation
    }
    
    private func determineSpotCutIndex(entranceString: String) -> Int {
        var cutIndex: Int = 15
        if (entranceString == "COEX_B0_3" || entranceString == "COEX_B0_4") {
            cutIndex = 1
        }
        return cutIndex
    }
    
    private func updateAllResult(result: [Double], inputPhase: Int, mode: String) {
        self.timeUpdatePosition.x = result[0]
        self.timeUpdatePosition.y = result[1]
        
        self.timeUpdateOutput.x = result[0]
        self.timeUpdateOutput.y = result[1]
        
        self.measurementPosition.x = result[0]
        self.measurementPosition.y = result[1]
        
        self.measurementOutput.x = result[0]
        self.measurementOutput.y = result[1]
        
        self.outputResult.x = result[0]
        self.outputResult.y = result[1]
        
        if (mode == "pdr") {
            self.timeUpdatePosition.heading = result[2]
            self.timeUpdateOutput.absolute_heading = result[2]
            self.measurementPosition.heading = result[2]
            self.measurementOutput.absolute_heading = result[2]
            self.outputResult.absolute_heading = result[2]
        } else {
            var accumulatedLength = 0.0
            for userTrajectory in self.userTrajectoryInfo {
                accumulatedLength += userTrajectory.length
            }
            
            if (accumulatedLength > USER_TRAJECTORY_LENGTH*0.4 && inputPhase != 1) {
                self.timeUpdatePosition.heading = result[2]
                self.timeUpdateOutput.absolute_heading = result[2]
                self.measurementPosition.heading = result[2]
                self.measurementOutput.absolute_heading = result[2]
                self.outputResult.absolute_heading = result[2]
            }
        }
        
        if (isStartSimulate) {
            self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
        } else {
            self.resultToReturn = self.makeOutputResult(input: self.outputResult, isPast: self.flagPast, runMode: self.runMode, isVenusMode: self.isVenusMode)
        }
    }
    
    private func determineIsOutdoor(lastResult: FineLocationTrackingResult, currentTime: Double, inFailCondition: Bool) -> Bool {
        let isInEntranceMatchingArea = pmCalculator.checkInEntranceMatchingArea(x: lastResult.x, y: lastResult.y, building: lastResult.building_name, level: lastResult.level_name)
        
        let diffEntranceWardTime = currentTime - self.lastScannedEntranceOuterWardTime
        if (lastResult.building_name != "" && lastResult.level_name == "B0") {
            return true
        } else if (isInEntranceMatchingArea.0) {
            return true
        } else if (diffEntranceWardTime <= 30*1000) {
            return true
        } else {
            // 3min
            if (inFailCondition) {
                if (self.timeFailRF >= SLEEP_THRESHOLD_RF) {
                    self.timeActiveRF = self.timeFailRF
                    self.timeFailRF = 0
                    return true
                }
            } else {
                if (self.timeActiveRF >= SLEEP_THRESHOLD_RF*6*3) {
                    return true
                }
            }
        }
        return false
    }
    
    

    func checkHeadingCorrection(buffer: [Double]) -> Bool {
        if (buffer.count >= HEADING_BUFFER_SIZE) {
            let firstHeading: Double = buffer.first ?? 0.0
            let lastHeading: Double = buffer.last ?? 10.0
            self.headingBuffer.removeFirst()

            let diffHeadingLastFirst: Double = abs(lastHeading - firstHeading)
            if (diffHeadingLastFirst < 5.0) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    func setModeParam(mode: String, phase: Int) {
        if (mode == "pdr") {
            self.requestIndex = self.requestIndexPdr
            self.USER_TRAJECTORY_LENGTH = self.USER_TRAJECTORY_DIAGONAL
            self.kalmanR = 2 // 0.5
            self.INIT_INPUT_NUM = 3
            self.VALUE_INPUT_NUM = 6
            self.SQUARE_RANGE = self.SQUARE_RANGE_SMALL
            
            if (phase == 4) {
                self.UVD_INPUT_NUM = self.VALUE_INPUT_NUM
                self.INDEX_THRESHOLD = 21
            } else {
                self.UVD_INPUT_NUM = self.INIT_INPUT_NUM
                self.INDEX_THRESHOLD = 11
            }
        } else if (mode == "dr") {
            self.requestIndex = self.requestIndexDr
            self.USER_TRAJECTORY_LENGTH = self.USER_TRAJECTORY_LENGTH_ORIGIN
            self.kalmanR = 2
            self.INIT_INPUT_NUM = 5
            self.VALUE_INPUT_NUM = UVD_BUFFER_SIZE
            self.SQUARE_RANGE = self.SQUARE_RANGE_LARGE
            
            if (phase == 4) {
                self.UVD_INPUT_NUM = self.VALUE_INPUT_NUM
                self.INDEX_THRESHOLD = (UVD_INPUT_NUM*2)+1
            } else {
                self.UVD_INPUT_NUM = self.INIT_INPUT_NUM
                self.INDEX_THRESHOLD = UVD_INPUT_NUM+1
            }
        }
        self.requestIndex = self.UVD_INPUT_NUM
    }
    
    // Kalman Filter
    func timeUpdatePositionInit(serverOutput: FineLocationTrackingFromServer) {
        timeUpdateOutput = serverOutput
        if (!measurementUpdateFlag) {
            timeUpdatePosition = KalmanOutput(x: Double(timeUpdateOutput.x), y: Double(timeUpdateOutput.y), heading: timeUpdateOutput.absolute_heading)
            timeUpdateFlag = true
        } else {
            timeUpdatePosition = KalmanOutput(x: measurementPosition.x, y: measurementPosition.y, heading: updateHeading)
        }
    }
    
    func timeUpdate(length: Double, diffHeading: Double, mobileTime: Int, isNeedHeadingCorrection: Bool, drBuffer: [UnitDRInfo], runMode: String) -> FineLocationTrackingFromServer {
        updateHeading = timeUpdatePosition.heading + diffHeading
        
        var tuScale = 1.0
        if (runMode == "pdr" && self.scCompensation > 1.0) {
            tuScale = self.scCompensation
        }
        let dx = length*cos(updateHeading*D2R)*tuScale
        let dy = length*sin(updateHeading*D2R)*tuScale
        
        timeUpdatePosition.x = timeUpdatePosition.x + dx
        timeUpdatePosition.y = timeUpdatePosition.y + dy
        timeUpdatePosition.heading = updateHeading
        
        var timeUpdateCopy = timeUpdatePosition
        let levelName = removeLevelDirectionString(levelName: timeUpdateOutput.level_name)
        let compensatedHeading = compensateHeading(heading: timeUpdateCopy.heading)
        if (runMode != "pdr") {
            var correctedTuCopy = (true, [timeUpdateCopy.x, timeUpdateCopy.y, timeUpdateCopy.heading, 1.0])
            let pathMatchingResult = pmCalculator.pathMatching(building: timeUpdateOutput.building_name, level: levelName, x: timeUpdateCopy.x, y: timeUpdateCopy.y, heading: compensatedHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)

            correctedTuCopy.0 = pathMatchingResult.isSuccess
            correctedTuCopy.1 = pathMatchingResult.xyhs
            correctedTuCopy.1[2] = compensateHeading(heading: correctedTuCopy.1[2])
            if (correctedTuCopy.0) {
                timeUpdateCopy.x = correctedTuCopy.1[0]
                timeUpdateCopy.y = correctedTuCopy.1[1]
                if (isNeedHeadingCorrection) {
                    timeUpdateCopy.heading = correctedTuCopy.1[2]
                }
                timeUpdatePosition = timeUpdateCopy
            } else {
                correctedTuCopy.0 = pathMatchingResult.0
                correctedTuCopy.1 = pathMatchingResult.1

                timeUpdateCopy.x = correctedTuCopy.1[0]
                timeUpdateCopy.y = correctedTuCopy.1[1]
                timeUpdatePosition = timeUpdateCopy
            }
        } else {
            let isDrStraight: Bool = isDrBufferStraight(drBuffer: drBuffer, condition: 60.0)
            let diffTrajMatchingIndex = drBuffer[drBuffer.count-1].index - self.trajMatchingIndex
            if ((self.unitDrInfoIndex%2) == 0 && !isDrStraight && diffTrajMatchingIndex > 7) {
                self.trajMatchingIndex = drBuffer[drBuffer.count-1].index
                let drBufferForPathMatching = Array(drBuffer.suffix(DR_BUFFER_SIZE_FOR_STRAIGHT))
                let pathTrajMatchingResult = pmCalculator.extendedPathTrajectoryMatching(building: timeUpdateOutput.building_name, level: levelName, x: timeUpdateCopy.x, y: timeUpdateCopy.y, heading: compensatedHeading, pastResult: self.jupiterResult, drBuffer: drBufferForPathMatching, HEADING_RANGE: HEADING_RANGE, pathType: 0, mode: self.runMode, range: 5)
                if (pathTrajMatchingResult.isSuccess) {
                    timeUpdatePosition.x = timeUpdatePosition.x*0.5 + pathTrajMatchingResult.xyd[0]*0.5
                    timeUpdatePosition.y = timeUpdatePosition.y*0.5 + pathTrajMatchingResult.xyd[1]*0.5
                    displayOutput.trajectoryPm = pathTrajMatchingResult.minTrajectory
                    displayOutput.trajectoryOg = pathTrajMatchingResult.minTrajectoryOriginal
                } else {
                    displayOutput.trajectoryPm = [[0,0]]
                    displayOutput.trajectoryOg = [[0,0]]
                }
            } else {
                let isDrVeryStraight: Bool = isDrBufferStraight(drBuffer: drBuffer, condition: 10.0)
                if (isDrVeryStraight) {
                    var correctedTuCopy = (true, [timeUpdateCopy.x, timeUpdateCopy.y, timeUpdateCopy.heading, 1.0])
                    let pathMatchingResult = pmCalculator.pathMatching(building: timeUpdateOutput.building_name, level: levelName, x: timeUpdateCopy.x, y: timeUpdateCopy.y, heading: compensatedHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 0, range: SQUARE_RANGE)

                    correctedTuCopy.0 = pathMatchingResult.isSuccess
                    correctedTuCopy.1 = pathMatchingResult.xyhs
                    correctedTuCopy.1[2] = compensateHeading(heading: correctedTuCopy.1[2])
                    if (correctedTuCopy.0) {
                        timeUpdateCopy.x = correctedTuCopy.1[0]
                        timeUpdateCopy.y = correctedTuCopy.1[1]
                        timeUpdateCopy.heading = correctedTuCopy.1[2]
                        timeUpdatePosition = timeUpdateCopy
                    } else {
                        correctedTuCopy.0 = pathMatchingResult.0
                        correctedTuCopy.1 = pathMatchingResult.1

                        timeUpdateCopy.x = correctedTuCopy.1[0]
                        timeUpdateCopy.y = correctedTuCopy.1[1]
                        timeUpdatePosition = timeUpdateCopy
                    }
                }
                displayOutput.trajectoryPm = [[0,0]]
                displayOutput.trajectoryOg = [[0,0]]
            }
        }
        
        kalmanP += kalmanQ
        headingKalmanP += headingKalmanQ
        
        timeUpdateOutput.x = timeUpdatePosition.x
        timeUpdateOutput.y = timeUpdatePosition.y
        timeUpdateOutput.absolute_heading = timeUpdatePosition.heading
        timeUpdateOutput.mobile_time = mobileTime
        
        measurementUpdateFlag = true
        
        return timeUpdateOutput
    }
    
    func measurementUpdate(timeUpdatePosition: KalmanOutput, serverOutputHat: FineLocationTrackingFromServer, serverResult: FineLocationTrackingFromServer, originalResult: [Double], isNeedHeadingCorrection: Bool, mode: String) -> FineLocationTrackingFromServer {
        var serverOutputHatCopy = serverOutputHat
        serverOutputHatCopy.absolute_heading = compensateHeading(heading: serverOutputHatCopy.absolute_heading)
        
        // ServerOutputHat을 맵매칭
        var serverOutputHatCopyMm = (true, [serverOutputHatCopy.x, serverOutputHatCopy.y, serverOutputHatCopy.absolute_heading, 1.0])
        if (self.runMode == "pdr") {
            let pathMatchingResult = pmCalculator.pathMatching(building: serverOutputHatCopy.building_name, level: serverOutputHatCopy.level_name, x: serverOutputHatCopy.x, y: serverOutputHatCopy.y, heading: serverOutputHatCopy.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
            serverOutputHatCopyMm.0 = pathMatchingResult.isSuccess
            serverOutputHatCopyMm.1 = pathMatchingResult.xyhs
        } else {
            let pathMatchingResult = pmCalculator.pathMatching(building: serverOutputHatCopy.building_name, level: serverOutputHatCopy.level_name, x: serverOutputHatCopy.x, y: serverOutputHatCopy.y, heading: serverOutputHatCopy.absolute_heading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
            serverOutputHatCopyMm.0 = pathMatchingResult.isSuccess
            serverOutputHatCopyMm.1 = pathMatchingResult.xyhs
        }
        serverOutputHatCopyMm.1[2] = compensateHeading(heading: serverOutputHatCopyMm.1[2])
        
        var serverOutputHatMm: FineLocationTrackingFromServer = serverOutputHatCopy
        var timeUpdateHeadingCopy = compensateHeading(heading: timeUpdatePosition.heading)
        
        if (serverOutputHatCopyMm.0) {
            serverOutputHatMm.x = serverOutputHatCopyMm.1[0]
            serverOutputHatMm.y = serverOutputHatCopyMm.1[1]
            if (isNeedHeadingCorrection) {
                serverOutputHatMm.absolute_heading = serverOutputHatCopyMm.1[2]
            } else {
                serverOutputHatMm.absolute_heading = serverOutputHatCopy.absolute_heading
            }
        } else {
            serverOutputHatMm.absolute_heading = originalResult[2]
        }
        
        if (timeUpdateHeadingCopy >= 270 && (serverOutputHatMm.absolute_heading >= 0 && serverOutputHatMm.absolute_heading < 90)) {
            serverOutputHatMm.absolute_heading = serverOutputHatMm.absolute_heading + 360
        } else if (serverOutputHatMm.absolute_heading >= 270 && (timeUpdateHeadingCopy >= 0 && timeUpdateHeadingCopy < 90)) {
            timeUpdateHeadingCopy = timeUpdateHeadingCopy + 360
        }
        
        measurementOutput = serverOutputHatMm
        
        kalmanK = kalmanP / (kalmanP + kalmanR)
        headingKalmanK = headingKalmanP / (headingKalmanP + headingKalmanR)
        
        measurementPosition.x = timeUpdatePosition.x + kalmanK * (Double(serverOutputHatMm.x) - timeUpdatePosition.x)
        measurementPosition.y = timeUpdatePosition.y + kalmanK * (Double(serverOutputHatMm.y) - timeUpdatePosition.y)
        updateHeading = timeUpdateHeadingCopy + headingKalmanK * (serverOutputHatMm.absolute_heading - timeUpdateHeadingCopy)
        updateHeading = compensateHeading(heading: updateHeading)
        
        measurementOutput.x = measurementPosition.x
        measurementOutput.y = measurementPosition.y
        kalmanP -= kalmanK * kalmanP
        headingKalmanP -= headingKalmanK * headingKalmanP
        
        var measurementOutputCorrected = (true, [measurementOutput.x, measurementOutput.y, updateHeading, 1.0])
        if (self.runMode == "pdr") {
            let pathMatchingResult = pmCalculator.pathMatching(building: measurementOutput.building_name, level: measurementOutput.level_name, x: measurementOutput.x, y: measurementOutput.y, heading: updateHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
            measurementOutputCorrected.0 = pathMatchingResult.isSuccess
            measurementOutputCorrected.1 = pathMatchingResult.xyhs
        } else {
            let pathMatchingResult = pmCalculator.pathMatching(building: measurementOutput.building_name, level: measurementOutput.level_name, x: measurementOutput.x, y: measurementOutput.y, heading: updateHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
            measurementOutputCorrected.0 = pathMatchingResult.isSuccess
            measurementOutputCorrected.1 = pathMatchingResult.xyhs
        }
        measurementOutputCorrected.1[2] = compensateHeading(heading: measurementOutputCorrected.1[2])
        
        if (measurementOutputCorrected.0) {
            let diffX = timeUpdatePosition.x - measurementOutputCorrected.1[0]
            let diffY = timeUpdatePosition.y - measurementOutputCorrected.1[1]
            let diffXY = sqrt(diffX*diffX + diffY*diffY)
            
            var tuHeading = compensateHeading(heading: timeUpdatePosition.heading)
            var muHeading = compensateHeading(heading: measurementOutputCorrected.1[2])
            if (tuHeading >= 270 && (muHeading >= 0 && muHeading < 90)) {
                muHeading = muHeading + 360
            } else if (muHeading >= 270 && (tuHeading >= 0 && tuHeading < 90)) {
                tuHeading = tuHeading + 360
            }
            let diffH = abs(tuHeading-muHeading)
            
            if (diffXY > 30 || diffH > HEADING_RANGE) {
                let propagationResult = propagateUsingUvd(drBuffer: self.unitDrBuffer, result: serverResult)
                let propagationValues: [Double] = propagationResult.1
                if (propagationResult.0) {
                    var propagatedResult: [Double] = [originalResult[0]+propagationValues[0] , originalResult[1]+propagationValues[1], originalResult[2]+propagationValues[2]]
                    if (self.runMode == "pdr") {
                        let pathMatchingResult = pmCalculator.pathMatching(building: serverResult.building_name, level: serverResult.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
                        propagatedResult = pathMatchingResult.xyhs
                    } else {
                        let pathMatchingResult = pmCalculator.pathMatching(building: serverResult.building_name, level: serverResult.level_name, x: propagatedResult[0], y: propagatedResult[1], heading: propagatedResult[2], isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: true, pathType: 1, range: SQUARE_RANGE)
                        propagatedResult = pathMatchingResult.xyhs
                    }
                    propagatedResult[2] = compensateHeading(heading: propagatedResult[2])
                    measurementOutputCorrected.1 = propagatedResult
                } else {
                    measurementOutputCorrected.1 = [timeUpdatePosition.x, timeUpdatePosition.y, compensateHeading(heading: timeUpdatePosition.heading)]
                }
                
                // Use Server Result
                self.timeUpdatePosition.x = measurementOutputCorrected.1[0]
                self.timeUpdatePosition.y = measurementOutputCorrected.1[1]
                self.timeUpdatePosition.heading = measurementOutputCorrected.1[2]
                
                measurementOutput.x = measurementOutputCorrected.1[0]
                measurementOutput.y = measurementOutputCorrected.1[1]
                measurementOutput.absolute_heading = measurementOutputCorrected.1[2]
                updateHeading = measurementOutputCorrected.1[2]
                
                backKalmanParam()
            } else {
                self.timeUpdatePosition.x = measurementOutputCorrected.1[0]
                self.timeUpdatePosition.y = measurementOutputCorrected.1[1]
                
                measurementOutput.x = measurementOutputCorrected.1[0]
                measurementOutput.y = measurementOutputCorrected.1[1]
                
                if (isNeedHeadingCorrection) {
                    self.timeUpdatePosition.heading = measurementOutputCorrected.1[2]
                    measurementOutput.absolute_heading = measurementOutputCorrected.1[2]
                    updateHeading = measurementOutputCorrected.1[2]
                } else {
                    if (mode == "pdr") {
                        self.timeUpdatePosition.heading = measurementOutputCorrected.1[2]
                        measurementOutput.absolute_heading = measurementOutputCorrected.1[2]
                        updateHeading = measurementOutputCorrected.1[2]
                    } else {
                        self.timeUpdatePosition.heading = timeUpdateHeadingCopy
                        measurementOutput.absolute_heading = timeUpdateHeadingCopy
                        updateHeading = timeUpdateHeadingCopy
                    }
                }
                saveKalmanParam()
            }
        } else {
            var measurementOutputCorrected = (true, [measurementOutput.x, measurementOutput.y, updateHeading, 1.0])
            if (self.runMode == "pdr") {
                let pathMatchingResult = pmCalculator.pathMatching(building: measurementOutput.building_name, level: measurementOutput.level_name, x: measurementOutput.x, y: measurementOutput.y, heading: updateHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 0, range: SQUARE_RANGE)
                measurementOutputCorrected.0 = pathMatchingResult.isSuccess
                measurementOutputCorrected.1 = pathMatchingResult.xyhs
            } else {
                let pathMatchingResult = pmCalculator.pathMatching(building: measurementOutput.building_name, level: measurementOutput.level_name, x: measurementOutput.x, y: measurementOutput.y, heading: updateHeading, isPast: false, HEADING_RANGE: HEADING_RANGE, isUseHeading: false, pathType: 1, range: SQUARE_RANGE)
                measurementOutputCorrected.0 = pathMatchingResult.isSuccess
                measurementOutputCorrected.1 = pathMatchingResult.xyhs
            }
            measurementOutputCorrected.1[2] = compensateHeading(heading: measurementOutputCorrected.1[2])
            
            // Use Server Result
            self.timeUpdatePosition.x = measurementOutputCorrected.1[0]
            self.timeUpdatePosition.y = measurementOutputCorrected.1[1]
            self.timeUpdatePosition.heading = measurementOutputCorrected.1[2]
            
            measurementOutput.x = measurementOutputCorrected.1[0]
            measurementOutput.y = measurementOutputCorrected.1[1]
            measurementOutput.absolute_heading = measurementOutputCorrected.1[2]
            updateHeading = measurementOutputCorrected.1[2]
            
            backKalmanParam()
        }
        
        return measurementOutput
    }
    
    func saveKalmanParam() {
        self.pastKalmanP = self.kalmanP
        self.pastKalmanQ = self.kalmanQ
        self.pastKalmanR = self.kalmanR
        self.pastKalmanK = self.kalmanK
        
        self.pastHeadingKalmanP = self.headingKalmanP
        self.pastHeadingKalmanQ = self.headingKalmanQ
        self.pastHeadingKalmanR = self.headingKalmanR
        self.pastHeadingKalmanK = self.headingKalmanK
    }
    
    func backKalmanParam() {
        self.kalmanP = self.pastKalmanP
        self.kalmanQ = self.pastKalmanQ
        self.kalmanR = self.pastKalmanR
        self.kalmanK = self.pastKalmanK
        
        self.headingKalmanP = self.pastHeadingKalmanP
        self.headingKalmanQ = self.pastHeadingKalmanQ
        self.headingKalmanR = self.pastHeadingKalmanR
        self.headingKalmanK = self.pastHeadingKalmanK
    }
    
    func setValidTime(mode: String) {
        if (mode == "dr") {
            self.BLE_VALID_TIME = 1000
        } else {
            self.BLE_VALID_TIME = 1500
        }
    }
    
    func checkSolutionValidity(reportFlag: Int, reportTime: Double, isIndoor: Bool) -> (Bool, Int, String) {
        var isValid: Bool = false
        var validFlag: Int = 0
        var validMessage: String = "Valid"
        let currentTime = getCurrentTimeInMillisecondsDouble()
        
        if (isIndoor) {
            let diffTime = (currentTime - reportTime)*1e-3
            if (NetworkCheck.shared.isConnectedToInternet()) {
                switch (reportFlag) {
                case -1:
                    isValid = true
                    validFlag = VALID_SOLUTION
                    validMessage = "Valid"
                case 2:
                    // 1. 시간 체크
                    // 2. 3초 지났으면 BLE 꺼진거 체크
                    // 3. BLE 여전히 꺼져 있으며 pastReportTime 값 업데이트
                    // 4. 아니면 valid하다고 바꿈
                    if (diffTime > 3) {
                        if (bleManager.bluetoothReady) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = INVALID_BLE
                            validMessage = "BLE is off"
                            self.pastReportTime = currentTime
                        }
                    } else {
                        validFlag = INVALID_BLE
                        validMessage = "BLE is off"
                    }
                case 3:
                    validFlag = INVALID_VENUS
                    validMessage = "Providing BLE only mode solution"
                case 4:
                    // 1. 시간 체크
                    // 2. 3초 지났으면 Valid로 수정
                    if (diffTime > 3) {
                        isValid = true
                        validFlag = VALID_SOLUTION
                        validMessage = "Valid"
                        self.pastReportFlag = -1
                    } else {
                        validFlag = RECOVERING_SOLUTION
                        validMessage = "Recently start to provide jupiter mode solution"
                    }
                case 5:
                    // 1. 시간 체크
                    // 2. 10초 지났으면 Valid로 수정
                    if (diffTime > 5) {
                        if (self.networkCount > 1) {
                            validFlag = INVALID_NETWORK
                            validMessage = "Newtwork status is bad"
                        } else {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        }
                    } else {
                        validFlag = INVALID_NETWORK
                        validMessage = "Newtwork status is bad"
                    }
                case 6:
                    // 1. 시간 체크
                    // 2. 3초 지났으면 네트워크 끊긴거 체크
                    // 3. 네트워크 여전히 꺼져 있으며 pastReportTime 값 업데이트
                    // 4. 아니면 valid하다고 바꿈
                    if (diffTime > 3) {
                        if (NetworkCheck.shared.isConnectedToInternet()) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = INVALID_NETWORK
                            validMessage = "Newtwork connection lost"
                            self.pastReportTime = currentTime
                        }
                    } else {
                        validFlag = INVALID_NETWORK
                        validMessage = "Newtwork connection lost"
                    }
                case 7:
                    validFlag = INVALID_STATE
                    validMessage = "Solution in background is invalid"
                case 8:
                    // 1. 시간 체크
                    // 2. 3초 지났으면 Valid로 수정
                    if (bleManager.bluetoothReady) {
                        if (diffTime > 3) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = RECOVERING_SOLUTION
                            validMessage = "Recently in foreground"
                        }
                    } else {
                        validFlag = INVALID_BLE
                        validMessage = "BLE is off"
                        self.pastReportFlag = 2
                        self.pastReportTime = currentTime
                    }
                case 9:
                    if (bleManager.bluetoothReady) {
                        if (diffTime > 5) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = RECOVERING_SOLUTION
                            validMessage = "Recently BLE is on"
                        }
                    } else {
                        validFlag = INVALID_BLE
                        validMessage = "BLE is off"
                        self.pastReportFlag = 2
                        self.pastReportTime = currentTime
                    }
                case 11:
                    // BLE_SCAN_STOP
                    if (bleManager.bluetoothReady) {
                        if (diffTime > 5) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = INVALID_BLE
                            validMessage = "BLE scanning has problem"
                        }
                    } else {
                        validFlag = INVALID_BLE
                        validMessage = "BLE is off"
                        self.pastReportFlag = 2
                        self.pastReportTime = currentTime
                    }
                case 12:
                    // BLE_ERROR_FLAG
                    if (bleManager.bluetoothReady) {
                        if (diffTime > 5) {
                            isValid = true
                            validFlag = VALID_SOLUTION
                            validMessage = "Valid"
                            self.pastReportFlag = -1
                        } else {
                            validFlag = INVALID_BLE
                            validMessage = "BLE trimming has problem"
                        }
                    } else {
                        validFlag = INVALID_BLE
                        validMessage = "BLE is off"
                        self.pastReportFlag = 2
                        self.pastReportTime = currentTime
                    }
                default:
                    isValid = true
                    validFlag = VALID_SOLUTION
                    validMessage = "Valid"
                }
            } else {
                validFlag = INVALID_NETWORK
                validMessage = "Newtwork connection lost"
                self.pastReportFlag = 6
                self.pastReportTime = currentTime
            }
        } else {
            validFlag = INVALID_OUTDOOR
            validMessage = "Solution in outdoor is invalid"
        }
        
        return (isValid, validFlag, validMessage)
    }
}
