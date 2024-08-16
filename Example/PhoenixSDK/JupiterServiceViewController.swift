
import UIKit
import SnapKit
import JupiterSDK
import Charts

class JupiterServiceViewController: UIViewController, Observer {
    static let identifier = "JupiterServiceViewController"
    
    func update(result: JupiterSDK.FineLocationTrackingResult) {
        DispatchQueue.main.async { [self] in
            if result.building_name != "" && result.level_name != "" {
//                print(getLocalTimeString() + " , (Jupiter) Result : \(result)")
                
                jupiterDisplay.building = result.building_name
                jupiterDisplay.level = result.level_name
                jupiterDisplay.absolute_heading = result.absolute_heading
                jupiterDisplay.velocity = result.velocity
                jupiterDisplay.x = result.x
                jupiterDisplay.y = result.y
                jupiterDisplay.isIndoor = result.isIndoor
                
//                jupiterDisplay.building = "COEX"
//                jupiterDisplay.level = "B2"
//                jupiterDisplay.heading = 90
//                jupiterDisplay.x = 100
//                jupiterDisplay.y = 200
//                jupiterDisplay.isIndoor = true
            }
        }
    }
    
    func report(flag: Int) {
        print(getLocalTimeString() + " , (Jupiter) Report")
    }
    
    var userInfo = UserInfo(name: "", company: "", carNumber: "")
    var phoenixData = PhoenixRecord(user_id: "", company: "", car_number: "", mobile_time: 0, index: 0, latitude: 0, longitude: 0, remaining_time: 0, velocity: 0, sector_id: 0, building_name: "", level_name: "", x: 0, y: 0, absolute_heading: 0, is_indoor: false)
    let jupiterServiceManager = ServiceManager()
    var sector_id: Int = 6
    var mode: String = "auto"
    var jupiterDisplay = JupiterDisplay()
    var PathPixel = [String: [[Double]]]()
    var chartLimits = [String: [Double]]()
    var isArrived: Bool = false
    var arrivalXY: [Double] = [40, 334]  // [40, 329] // Test [200, 468]
    
    // Building & level
    var buildingLevelInfo = [String: [String]]()
    var pastBuilding: String = ""
    var pastLevel: String = ""
    var currentBuilding: String = ""
    var currentLevel: String = ""
    
    // Timer
    var jupiterTimer: DispatchSourceTimer?
    var phoenixTimer: DispatchSourceTimer?
    let TIMER_INTERVAL: TimeInterval = 1/5 // second
    let POST_TIMER_INTERVAL: TimeInterval = 1
    var timeStack: TimeInterval = 0
    
    // View
    @IBOutlet weak var levelImageView: UIImageView!
    @IBOutlet weak var scatterChart: ScatterChartView!
    var headingImage = UIImage(named: "heading")
    
    private lazy var initView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.alpha = 0.6
        return view
    }()
    
    var initLabel = UILabel().then {
        $0.text = "서비스 구역에 진입 중입니다."
        $0.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        $0.textAlignment = .center
        $0.textColor = .black
    }
    let stringProgressing: [String] = [".", "..", "...", "....", "....."]
    var progressingIdx: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        headingImage = headingImage?.resize(newWidth: 20)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setChartLimit()
        setDarkView()
        setSectorInfo()
        jupiterServiceManager.addObserver(self)
        setJupiterService()
    }
    
    private func setSectorInfo() {
        buildingLevelInfo["COEX"] = ["B0", "B2"]
        buildingLevelInfo["S3"] = ["7F"]
        
        for (key, value) in self.buildingLevelInfo {
            let buildingName = key
            let levelNameList = value
            for levelName in levelNameList {
                let key: String = "\(buildingName)_\(levelName)"
                let pathPixel = loadPathPixel(fileName: key)
                if (!pathPixel.isEmpty) {
                    PathPixel[key] = pathPixel
//                    print(getLocalTimeString() + " , (PathPixel) : \(key)")
//                    print(getLocalTimeString() + " , (PathPixel) : \(pathPixel)")
                }
            }
        }
    }
    
    private func setChartLimit() {
        // xMin xMax yMin yMax
        chartLimits["COEX_B0"] = [-17, 298.5, -38, 559] // COEX B0 : 6.0 , 294.0, 3.0, 469.0
        chartLimits["COEX_B2"] = [-17, 298.5, -38, 559]  // COEX B2 : 6.0 , 294.0, 3.0, 469.0
        chartLimits["S3_7F"] = [0, 0, 0, 0] // S3 7F : 6.0 , 294.0, 3.0, 469.0
    }
    
    private func setJupiterService() {
        jupiterServiceManager.setSimulationMode(flag: false, bleFileName: "ble_coex04.csv", sensorFileName: "sensor_coex04.csv")
        jupiterServiceManager.startService(id: userInfo.name, sector_id: sector_id, service: "FLT", mode: mode, completion: { [self] isSuccess, returnedString in
            if isSuccess {
                startTimer()
                print(returnedString)
            }
        })
    }
    
    private func loadPathPixel(fileName: String) -> [[Double]] {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "csv") else { return [[Double]]() }
        let rpXY:[[Double]] = parsePathPixel(url: URL(fileURLWithPath: path))
        return rpXY
    }
    
    private func parsePathPixel(url:URL) -> [[Double]] {
        var rpXY = [[Double]]()
        var rpX = [Double]()
        var rpY = [Double]()
        
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}) {
                for item in dataArr {
                    let rp: [String] = item
                    if (rp.count >= 2) {
                        if (self.mode == "pdr") {
                            guard let x: Double = Double(rp[1]) else { return [[Double]]() }
                            guard let y: Double = Double(rp[2].components(separatedBy: "\r")[0]) else { return [[Double]]() }
                            
                            rpX.append(x)
                            rpY.append(y)
                        } else {
                            let pathType = Int(rp[0])
                            if (pathType == 1) {
                                guard let x: Double = Double(rp[1]) else { return [[Double]]() }
                                guard let y: Double = Double(rp[2].components(separatedBy: "\r")[0]) else { return [[Double]]() }
                                
                                rpX.append(x)
                                rpY.append(y)
                            }
                        }
                    }
                }
            }
            rpXY = [rpX, rpY]
        } catch {
            print("Error reading .csv file")
        }
        return rpXY
    }
    
    private func loadLevel(building: String, level: String, flag: Bool, completion: @escaping (UIImage?, Error?) -> Void) {
        let urlString: String = "https://storage.googleapis.com/\(IMAGE_URL)/map/\(6)/\(building)_\(level).png"
        if let urlLevel = URL(string: urlString) {
            let cacheKey = NSString(string: urlString)
            
            if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) {
                completion(cachedImage, nil)
            } else {
                let task = URLSession.shared.dataTask(with: urlLevel) { (data, response, error) in
                    if let error = error {
                        completion(nil, error)
                    }
                    
                    if let data = data, let httpResponse = response as? HTTPURLResponse,
                       httpResponse.statusCode == 200 {
                        DispatchQueue.main.async {
                            ImageCacheManager.shared.setObject(UIImage(data: data)!, forKey: cacheKey)
                            completion(UIImage(data: data), nil)
                        }
                    } else {
                        completion(nil, error)
                    }
                }
                task.resume()
            }
        } else {
            completion(nil, nil)
        }
    }
    
    private func displayLevelImage(building: String, level: String, flag: Bool) {
        self.loadLevel(building: building, level: level, flag: flag, completion: { [self] data, error in
            DispatchQueue.main.async {
                if (data != nil) {
                    // 빌딩 -> 층 이미지가 있는 경우
                    self.levelImageView.isHidden = false
                    self.levelImageView.image = data
                } else {
                    // 빌딩 -> 층 이미지가 없는 경우
                    if (flag) {
                        self.levelImageView.isHidden = false
                        self.levelImageView.image = UIImage(named: "emptyLevel")
                    } else {
                        self.scatterChart.isHidden = true
                        self.levelImageView.isHidden = true
                    }
                    
                }
            }
        })
    }
    
    private func drawResultWithPP(flag: Bool, XY: [Double], RP_X: [Double], RP_Y: [Double], heading: Double, limits: [Double], isIndoor: Bool) {
        var chartData = ScatterChartData()
        var set0 = ScatterChartDataSet()
        var set1 = ScatterChartDataSet()
        var set2 = ScatterChartDataSet()
        var xAxisValue = [Double]()
        var yAxisValue = [Double]()
        if flag {
            xAxisValue = RP_X
            yAxisValue = RP_Y
            let values0 = (0..<xAxisValue.count).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: xAxisValue[i], y: yAxisValue[i])
            }
            
            set0 = ScatterChartDataSet(entries: values0, label: "PP")
            set0.drawValuesEnabled = false
            set0.setScatterShape(.square)
//            set0.setColor(UIColor.yellow)
            set0.setColor(UIColor.systemOrange)
            set0.scatterShapeSize = 4
            
            let endX: [Double] = [40]
            let endY: [Double] = [329]
            let values1 = (0..<endX.count).map { (i) -> ChartDataEntry in
                return ChartDataEntry(x: endX[i], y: endY[i])
            }
            
            set1 = ScatterChartDataSet(entries: values1, label: "End")
            set1.drawValuesEnabled = false
            set1.setScatterShape(.circle)
            set1.setColor(UIColor.black)
            set1.scatterShapeSize = 26
            
            set2 = ScatterChartDataSet(entries: values1, label: "End")
            set2.drawValuesEnabled = false
            set2.setScatterShape(.circle)
            set2.setColor(UIColor.systemRed)
            set2.scatterShapeSize = 18
        }
        
        var valueColor = UIColor.systemRed
        if (!isIndoor) {
            valueColor = UIColor.systemGray
        } else {
            valueColor = UIColor.systemRed
        }

        let valuesUser = (0..<1).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: XY[0], y: XY[1])
        }
        let setUser = ScatterChartDataSet(entries: valuesUser, label: "USER")
        setUser.drawValuesEnabled = false
        setUser.setScatterShape(.circle)
        setUser.setColor(valueColor)
        setUser.scatterShapeSize = 16
        
        if flag {
            chartData.append(set0)
            chartData.append(set1)
            chartData.append(set2)
        }
        chartData.append(setUser)
        chartData.setDrawValues(false)
        
        // Heading
        let point = scatterChart.getPosition(entry: ChartDataEntry(x: XY[0], y: XY[1]), axis: .left)
        let imageView = UIImageView(image: headingImage!.rotate(degrees: -heading+90))
        imageView.frame = CGRect(x: point.x - 15, y: point.y - 15, width: 30, height: 30)
        imageView.contentMode = .center
        imageView.tag = 100
        if let viewWithTag = scatterChart.viewWithTag(100) {
            viewWithTag.removeFromSuperview()
        }
        scatterChart.addSubview(imageView)
        
        let chartFlag: Bool = false
        scatterChart.isHidden = false
        
        let xMin = xAxisValue.min() ?? 0
        let xMax = xAxisValue.max() ?? 0
        let yMin = yAxisValue.min() ?? 0
        let yMax = yAxisValue.max() ?? 0
        
//        print("\(currentBuilding) \(currentLevel) MinMax : \(xMin) , \(xMax), \(yMin), \(yMax)")
//        print("\(currentBuilding) \(currentLevel) Limits : \(limits[0]) , \(limits[1]), \(limits[2]), \(limits[3])")
        
        // Configure Chart
        if ( limits[0] == 0 && limits[1] == 0 && limits[2] == 0 && limits[3] == 0 ) {
            scatterChart.xAxis.axisMinimum = xMin - 5
            scatterChart.xAxis.axisMaximum = xMax + 5
            scatterChart.leftAxis.axisMinimum = yMin - 5
            scatterChart.leftAxis.axisMaximum = yMax + 5
        } else {
            scatterChart.xAxis.axisMinimum = limits[0]
            scatterChart.xAxis.axisMaximum = limits[1]
            scatterChart.leftAxis.axisMinimum = limits[2]
            scatterChart.leftAxis.axisMaximum = limits[3]
        }
        
        scatterChart.xAxis.drawGridLinesEnabled = chartFlag
        scatterChart.leftAxis.drawGridLinesEnabled = chartFlag
        scatterChart.rightAxis.drawGridLinesEnabled = chartFlag
        
        scatterChart.xAxis.drawAxisLineEnabled = chartFlag
        scatterChart.leftAxis.drawAxisLineEnabled = chartFlag
        scatterChart.rightAxis.drawAxisLineEnabled = chartFlag
        
        scatterChart.xAxis.centerAxisLabelsEnabled = chartFlag
        scatterChart.leftAxis.centerAxisLabelsEnabled = chartFlag
        scatterChart.rightAxis.centerAxisLabelsEnabled = chartFlag
        
        scatterChart.xAxis.drawLabelsEnabled = chartFlag
        scatterChart.leftAxis.drawLabelsEnabled = chartFlag
        scatterChart.rightAxis.drawLabelsEnabled = chartFlag
        
        scatterChart.legend.enabled = chartFlag
        scatterChart.data = chartData
    }
    
    func updateDisplay(data: JupiterDisplay, flag: Bool) {
        let userXY: [Double] = [data.x, data.y]
        let heading: Double = data.absolute_heading
        let isIndoor = data.isIndoor
        
        if (data.building != "") {
            currentBuilding = data.building
            if data.level != "" {
                currentLevel = data.level
            }
        }
        
        if (pastBuilding != currentBuilding || pastLevel != currentLevel) {
            displayLevelImage(building: currentBuilding, level: currentLevel, flag: flag)
        }
        
        let key = "\(currentBuilding)_\(currentLevel)"
        let condition: ((String, [[Double]])) -> Bool = { $0.0.contains(key) }
        let limits: [Double] = chartLimits[key] ?? [0, 0, 0, 0]
        
        let pp: [[Double]] = PathPixel[key] ?? [[Double]]()
        if (PathPixel.contains(where: condition)) {
            if pp.isEmpty {
                scatterChart.isHidden = true
            } else {
                drawResultWithPP(flag: flag, XY: userXY, RP_X: pp[0], RP_Y: pp[1], heading: heading, limits: limits, isIndoor: isIndoor)
            }
        }
    }
    
    func startTimer() {
        if (jupiterTimer == nil) {
            let queueTimer = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".jupiterTimer")
            self.jupiterTimer = DispatchSource.makeTimerSource(queue: queueTimer)
            self.jupiterTimer!.schedule(deadline: .now(), repeating: TIMER_INTERVAL)
            self.jupiterTimer!.setEventHandler(handler: self.timerUpdate)
            self.jupiterTimer!.resume()
            
        }
        
        if (phoenixTimer == nil) {
            let queueTimer = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".jupiterTimer")
            self.phoenixTimer = DispatchSource.makeTimerSource(queue: queueTimer)
            self.phoenixTimer!.schedule(deadline: .now(), repeating: POST_TIMER_INTERVAL)
            self.phoenixTimer!.setEventHandler(handler: self.phoenixTimerUpdate)
            self.phoenixTimer!.resume()
            
        }
    }
    
    func stopTimer() {
        self.jupiterTimer?.cancel()
        self.jupiterTimer = nil
    }
    
    @objc func timerUpdate() {
        let timeStamp = getCurrentTimeInMillisecondsDouble()
        DispatchQueue.main.async { [self] in
            var ppFlag: Bool = false
            timeStack += TIMER_INTERVAL
            if timeStack >= 1 {
                timeStack = 0
                progressingIdx += 1
                if (progressingIdx > stringProgressing.count-1) {
                    progressingIdx = 0
                }
            }
            let strToAdd = stringProgressing[progressingIdx]
            let progressingText = "서비스 구역에 진입 중입니다" + strToAdd
            if self.jupiterDisplay.level == "B2" {
                ppFlag = true
                self.initView.isHidden = true
                self.initLabel.isHidden = true
            } else {
                self.initLabel.text = progressingText
            }
            updateDisplay(data: self.jupiterDisplay, flag: ppFlag)
            if !isArrived {
                self.isArrived = checkArrival(userXY: [self.jupiterDisplay.x, self.jupiterDisplay.y])
            } else {
                jupiterServiceManager.stopService()
                self.showArriveDialog()
            }
        }
    }
    
    @objc func phoenixTimerUpdate() {
        if (self.jupiterDisplay.isIndoor) {
            self.phoenixData.remaining_time = 0
            self.phoenixData.mobile_time = getCurrentTimeInMillisecondsDouble()
            self.phoenixData.index += 1
            self.phoenixData.sector_id = self.sector_id
            self.phoenixData.building_name = self.jupiterDisplay.building
            self.phoenixData.level_name = self.jupiterDisplay.level
            self.phoenixData.x = Int(self.jupiterDisplay.x)
            self.phoenixData.y = Int(self.jupiterDisplay.y)
            self.phoenixData.absolute_heading = self.jupiterDisplay.absolute_heading
            self.phoenixData.velocity = self.jupiterDisplay.velocity
            self.phoenixData.is_indoor = self.jupiterDisplay.isIndoor
            NetworkManager.shared.postPhoenixRecord(url: RECORD_URL, input: [phoenixData], completion: { [self] statusCode, returnedString in
                if statusCode == 200 {
                    print(getLocalTimeString() + " , (Phoenix) Record Success Indoor : \(statusCode) , \(returnedString)")
                } else {
                    print(getLocalTimeString() + " , (Phoenix) Record Error Indoor : \(statusCode) , \(returnedString)")
                }
            })
        }
    }
    
    private func setDarkView() {
        self.view.addSubview(initView)
        self.view.addSubview(initLabel)
        initView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        initLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
    }
    
    private func checkArrival(userXY: [Double]) -> Bool {
        let diffX = userXY[0] - self.arrivalXY[0]
        let diffY = userXY[1] - self.arrivalXY[1]
        let diffXY = sqrt(diffX*diffX + diffY*diffY)
//        print(getLocalTimeString() + " , (Phoenix) checkArrival : userXY = \(userXY) // arrivalXY = \(arrivalXY) // diffX = \(diffX) // diffY = \(diffY) // dist = \(diffXY)")
        return diffXY < 5 ? true : false
    }
    
    private func showArriveDialog() {
        showPopUp(title: "목적지에 도착했습니다",
                  leftActionTitle: "취소",
                  rightActionTitle: "확인")
    }
}
