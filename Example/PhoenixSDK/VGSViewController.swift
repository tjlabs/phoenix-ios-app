
import UIKit
import SnapKit
import PhoenixSDK
import Lottie

class VGSViewController: UIViewController, KNNaviView_GuideStateDelegate, KNNaviView_StateDelegate, KNGuidance_GuideStateDelegate, KNGuidance_RouteGuideDelegate, KNGuidance_VoiceGuideDelegate, KNGuidance_SafetyGuideDelegate, KNGuidance_LocationGuideDelegate, KNGuidance_CitsGuideDelegate {
    
    static let identifier = "VGSViewController"
    
    func guidance(_ aGuidance: KNGuidance, didUpdateCitsGuide aCitsGuide: KNGuide_Cits) {
        self.naviView.guidance(aGuidance, didUpdateCitsGuide: aCitsGuide)
    }
    
    func guidance(_ aGuidance: KNGuidance, didUpdate aLocationGuide: KNGuide_Location) {
        var isCurLocExist: Bool = false
        if let curLocation = aLocationGuide.location {
//            print(getLocalTimeString() + " , (Phoenix) : locPos = \(curLocation.pos)")
            if let curLatLon = convertKATECToWGS84(pos: curLocation.pos) {
                let longitude: Double = curLatLon.x
                let latitude: Double = curLatLon.y
                self.phoenixData.longitude = longitude
                self.phoenixData.latitude = latitude
//                print(getLocalTimeString() + " , (Phoenix) : Lat Lon (KM) = \(latitude) , \(longitude)")
                isCurLocExist = true
            }
        }
        
        if !isCurLocExist {
            let longitude: Double = aLocationGuide.gpsMatched.pos.x
            let latitude: Double = aLocationGuide.gpsMatched.pos.y
            self.phoenixData.longitude = longitude
            self.phoenixData.latitude = latitude
//            print(getLocalTimeString() + " , (Phoenix) : Lat Lon (GPS) = \(latitude) , \(longitude)")
        }
        let speed: Int32 = aLocationGuide.gpsMatched.speed
        let heading: Int32 = aLocationGuide.gpsMatched.angle
        self.phoenixData.velocity = speed == -1 ? 0.0 : Double(speed)
        self.phoenixData.absolute_heading = heading == -1 ? 0.0 : Double(heading)
//        print(getLocalTimeString() + " , (Phoenix) : speed = \(aLocationGuide.gpsMatched.speed)")
        
        self.naviView.guidance(aGuidance, didUpdate: aLocationGuide)
    }
    
    func guidance(_ aGuidance: KNGuidance, didUpdateSafetyGuide aSafetyGuide: KNGuide_Safety) {
        self.naviView.guidance(aGuidance, didUpdateSafetyGuide: aSafetyGuide)
    }
    
    func guidance(_ aGuidance: KNGuidance, didUpdateAroundSafeties aSafeties: [KNSafety]?) {
        self.naviView.guidance(aGuidance, didUpdateAroundSafeties: aSafeties)
    }
    
    func guidance(_ aGuidance: KNGuidance, shouldPlayVoiceGuide aVoiceGuide: KNGuide_Voice, replaceSndData aNewData: AutoreleasingUnsafeMutablePointer<NSData?>!) -> Bool {
        return naviView.guidance(aGuidance, shouldPlayVoiceGuide: aVoiceGuide, replaceSndData: aNewData)
    }
    
    func guidance(_ aGuidance: KNGuidance, willPlayVoiceGuide aVoiceGuide: KNGuide_Voice) {
        self.naviView.guidance(aGuidance, willPlayVoiceGuide: aVoiceGuide)
    }
    
    func guidance(_ aGuidance: KNGuidance, didFinishPlayVoiceGuide aVoiceGuide: KNGuide_Voice) {
        self.naviView.guidance(aGuidance, didFinishPlayVoiceGuide: aVoiceGuide)
    }
    
    func guidance(_ aGuidance: KNGuidance, didUpdateRouteGuide aRouteGuide: KNGuide_Route) {
        self.naviView.guidance(aGuidance, didUpdateRouteGuide: aRouteGuide)
    }
    
    func guidanceGuideStarted(_ aGuidance: KNGuidance) {
        self.naviView.guidanceGuideStarted(aGuidance)
        print(PhoenixSDK.getLocalTimeString() + " , (Phoenix) Route Guide : Start " , aGuidance)
    }
    
    func guidanceGuideEnded(_ aGuidance: KNGuidance) {
        self.naviView.guidanceGuideEnded(aGuidance, isShowDriveResultDialog: true)
    }
    
    func guidanceCheckingRouteChange(_ aGuidance: KNGuidance) {
        self.naviView.guidanceCheckingRouteChange(aGuidance)
    }
    
    func guidanceOut(ofRoute aGuidance: KNGuidance) {
        self.naviView.guidanceOut(ofRoute: aGuidance)
    }
    
    func guidanceRouteChanged(_ aGuidance: KNGuidance, from aFromRoute: KNRoute, from aFromLocation: KNLocation, to aToRoute: KNRoute, to aToLocation: KNLocation, reason aChangeReason: KNGuideRouteChangeReason) {
        self.naviView.guidanceRouteChanged(aGuidance)
    }
    
    func guidanceRouteUnchanged(_ aGuidance: KNGuidance) {
        self.naviView.guidanceRouteUnchanged(aGuidance)
    }
    
    func guidance(_ aGuidance: KNGuidance, routeUnchangedWithError aError: KNError) {
        self.naviView.guidance(aGuidance, routeUnchangedWithError: aError)
    }
    
    func guidance(_ aGuidance: KNGuidance, didUpdate aRoutes: [KNRoute], multiRouteInfo aMultiRouteInfo: KNMultiRouteInfo?) {
        var remainingTime: Int32 = 0
        for route in aRoutes {
            remainingTime += route.totalTime
            print(getLocalTimeString() + " , (Phoenix) : Route = \(route) // Time = \(route.totalTime)")
        }
        self.phoenixData.remaining_time = Int(remainingTime)
        self.naviView.guidance(aGuidance, didUpdate: aRoutes, multiRouteInfo: aMultiRouteInfo)
    }
    
    func naviViewDidUpdateSndVolume(_ aVolume: Float) {}
    func naviViewDidUpdateUseDarkMode(_ aDarkMode: Bool) {}
    func naviViewDidUpdateMapCameraMode(_ aMapViewCameraMode: MapViewCameraMode) {}
    func naviViewDidMenuItem(withId aId: Int32, toggle aToggle: Bool) {}
    func naviViewScreenState(_ aKNNaviViewState: KNNaviViewState) {}
    func naviViewPopupOpenCheck(_ aOpen: Bool) {}
    func naviViewIsArrival(_ aIsArrival: Bool) {}
    func naviViewGuideEnded(_ aNaviView: KNNaviView) {}
    func naviViewGuideState(_ aGuideState: KNGuideState) {}
    
    var vgsTimer: DispatchSourceTimer?
    let TIMER_INTERVAL: TimeInterval = 1 // 1s
    
    var userInfo = UserInfo(name: "", company: "", carNumber: "")
    var destinationInfo = DestinationInfo(name: "", address: "", coord: DestinationCoord(latitude: 0.0, longitude: 0.0))
    var kakaoApiKey: String = ""
    var routePriority: KNRoutePriority = .time
    var routeAvoidOption: KNRouteAvoidOption = .none
    var routeGuidance = KNGuidance()
    var isGuideEnded: Bool = false
    var volume: Float = 1.0
    
    let serviceManager = PhoenixServiceManager()
    var isServiceGranted: Bool = false
    
    // Phoenix Record
    var phoenixIndex: Int = 0
    var phoenixData = PhoenixRecord(user_id: "", company: "", car_number: "", mobile_time: 0, index: 0, latitude: 0, longitude: 0, remaining_time: 0, velocity: 0, sector_id: 0, building_name: "", level_name: "", x: 0, y: 0, absolute_heading: 0, is_indoor: false)
    var phoenixRecords = [PhoenixRecord]()
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var destinationNameLabel: UILabel!
    @IBOutlet weak var guideLabel: UILabel!
    @IBOutlet weak var rqAuthButton: UIButton!
    
    private lazy var darkView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0.5
        return view
    }()

    var naviView = KNNaviView.init()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("(Phoenix) Info : User = \(userInfo)")
        setPhoenixData(userInfo: self.userInfo)
        authKNSDK(completion: { [self] knError in
            if (knError == nil) {
                setupViews()
                setDrive(destinationInfo: self.destinationInfo)
            } else {
                print("(Phoenix) Error : \(String(describing: knError))")
            }
        })
    }
    
    private func setupViews() {
        topView.backgroundColor = .clear
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = .systemGray6
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        setButtonEnable(state: false)
        
        // Add the views to the main view
//        self.view.addSubview(topView)
//        self.view.addSubview(bottomView)
//
//        NSLayoutConstraint.activate([
//            // Top view constraints
//            topView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            topView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            topView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            topView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7),
//            
//            // Bottom view constraints
//            bottomView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            bottomView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            bottomView.topAnchor.constraint(equalTo: topView.bottomAnchor),
//            bottomView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
//            bottomView.snp.makeConstraints{ make in
//
//            }
//        ])
    }
    
    
    private func authKNSDK(completion: @escaping (KNError?) -> Void) {
        if let apiKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_API_KEY") as? String {
            self.kakaoApiKey = apiKey
        }
        KNSDK.sharedInstance()?.initialize(withAppKey: self.kakaoApiKey, clientVersion: "1.0", userKey: userInfo.name) { knError in
            completion(knError)
        }
    }
    
    private func setDrive(destinationInfo: DestinationInfo) {
        DispatchQueue.main.async { [self] in
            destinationNameLabel.text = destinationInfo.name
            destinationNameLabel.textColor = .systemCyan
        }
        // 시작 점은 TJLABS 회사 위치
        let latitude_start = 37.495758
        let longitude_start = 127.038249
        let name_start = "Start Point"
        
        // 도착 점은 COEX
//        let latitude_goal = 37.513109
//        let longitude_goal = 127.058375
//        let address_goal = "Goal Address"
        let latitude_goal = destinationInfo.coord.latitude
        let longitude_goal = destinationInfo.coord.longitude
        let name_goal = destinationInfo.name
        
        let vias: [KNPOI] = []
        
        guard let sdkInstance = KNSDK.sharedInstance() else {
            print("(Phoenix) Error : Failed to get SDK instance")
            return
        }
        
        var startCoord: [Int32] = [0, 0]
        if let startKATEC = convertWGS84ToKATEC(lon: longitude_start, lat: latitude_start) {
            print("(Phoenix) start KATEC = \(startKATEC)")
            startCoord[0] = startKATEC.x
            startCoord[1] = startKATEC.y
        }
        var goalCoord: [Int32] = [0, 0]
        if let goalKATEC = convertWGS84ToKATEC(lon: longitude_goal, lat: latitude_goal) {
            print("(Phoenix) goal KATEC = \(goalKATEC)")
            goalCoord[0] = goalKATEC.x
            goalCoord[1] = goalKATEC.y
        }

        let start = KNPOI(name: name_start, x: startCoord[0], y: startCoord[1])
        let goal = KNPOI(name: name_goal, x: goalCoord[0], y: goalCoord[1])
        
        sdkInstance.makeTrip(withStart: start, goal: goal, vias: vias) { [self] (aError, aTrip) in
            if let error = aError {
                // 경로 생성 실패
                print("(Phoenix) Failed to create trip : \(String(describing: aError))")
            } else if let trip = aTrip {
                // 경로 생성 성공
                print("(Phoenix) Trip created successfully : \(trip)")
                self.requestRoute(for: trip)
            }
        }
    }
    
    private func requestRoute(for trip: KNTrip) {
        trip.route(with: routePriority, avoidOptions: routeAvoidOption.rawValue) { [weak self] (aError, aRoutes) in
            guard let self = self else { return }
            if let error = aError {
                // 경로 요청 실패
                print("(Phoenix) Failed to request route : \(String(describing: aError))")
            } else if let routes = aRoutes {
                // 경로 요청 성공
                print("(Phoenix) Routes requested successfully : \(routes)")
                if let guidance = KNSDK.sharedInstance()?.sharedGuidance() {
                    // 각 가이던스 델리게이트 등록
                    guidance.guideStateDelegate = self
                    guidance.routeGuideDelegate = self
                    guidance.voiceGuideDelegate = self
                    guidance.safetyGuideDelegate = self
                    guidance.locationGuideDelegate = self
                    guidance.citsGuideDelegate = self
                    self.routeGuidance = guidance
                    
                    // 주행 UI 생성
                    naviView = KNNaviView(guidance: guidance, trip: trip, routeOption: routePriority, avoidOption: routeAvoidOption.rawValue)
                    naviView.frame = topView.bounds
//                    naviView.frame = self.view.bounds
                    naviView.guideStateDelegate = self
                    naviView.stateDelegate = self
                    naviView.sndVolume(self.volume)
                    topView.addSubview(naviView)
//                    self.view.addSubview(naviView)
                    
                    serviceManager.startService(id: userInfo.name, company: userInfo.company, car_number: userInfo.carNumber)
                    bottomView.isHidden = false
                    startTimer()
                } else {
                    print("(Phoenix) Error : Cannot get shared guidance")
                }
            }
        }
    }
    
    private func convertWGS84ToKATEC(lon: Double, lat: Double) -> IntPoint? {
        let katecCoord = KNSDK.sharedInstance()?.convertWGS84ToKATEC(withLongitude: lon, latitude: lat)
        return katecCoord
    }
    
    private func convertKATECToWGS84(pos: DoublePoint) -> DoublePoint? {
        let wgs84Coord = KNSDK.sharedInstance()?.convertKATECToWGS84With(x: Int32(pos.x), y: Int32(pos.y))
        return wgs84Coord
    }
    
    @objc func runVgsTimer() {
        if !isServiceGranted {
            isServiceGranted = serviceManager.requestAuth()
        } else {
            if !isGuideEnded {
                setButtonEnable(state: true)
                isGuideEnded = true
            }
        }
        self.postPhoenixRecords()
    }
    
    func startTimer() {
        if (self.vgsTimer == nil) {
            let queueVgsTimer = DispatchQueue(label: Bundle.main.bundleIdentifier! + ".vgsTimer")
            self.vgsTimer = DispatchSource.makeTimerSource(queue: queueVgsTimer)
            self.vgsTimer!.schedule(deadline: .now(), repeating: self.TIMER_INTERVAL)
            self.vgsTimer!.setEventHandler(handler: self.runVgsTimer)
            self.vgsTimer!.resume()
        }
    }
    
    func stopTimer() {
        self.vgsTimer?.cancel()
        self.vgsTimer = nil
    }
    
    @IBAction func tapRqAuthButton(_ sender: UIButton) {
        stopTimer()
        serviceManager.stopService()
        setProgressMovingImg(completion: { [self] isEnd, returnedString in
            if (isEnd) {
                // Go To Service VC
                goToJupiterServiceVC(userInfo: userInfo, phoenixData: phoenixData)
            }
        })
    }
    
    private func setButtonEnable(state: Bool) {
        DispatchQueue.main.async { [self] in
            if state {
                rqAuthButton.isEnabled = true
                rqAuthButton.backgroundColor = .systemCyan
                rqAuthButton.tintColor = .systemCyan
                rqAuthButton.shadowColor = .systemGray
                rqAuthButton.shadowOpacity = 1.0
                rqAuthButton.layer.shadowRadius = 6
                rqAuthButton.layer.shadowOffset = CGSize(width: 3, height: 3)
            } else {
                rqAuthButton.isEnabled = false
                rqAuthButton.backgroundColor = .systemGray4
                rqAuthButton.tintColor = .systemGray4
            }
        }
    }

    func setProgressMovingImg(completion: @escaping (Bool, String) -> Void) {
        let animation = LottieAnimation.named("progressingMovingImgBlue")
        let animationView = LottieAnimationView(animation: animation)
        self.view.addSubview(darkView)
        self.view.addSubview(animationView)
        animationView.center = self.view.center
        animationView.contentMode = .scaleAspectFill
        
        darkView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        animationView.snp.makeConstraints { make in
            make.height.equalTo(200)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.trailing.equalToSuperview()
        }
        
        animationView.play{ (finish) in
            self.naviView.removeFromSuperview()
            self.darkView.removeFromSuperview()
            animationView.removeFromSuperview()
            completion(true, "Animation End")
        }
    }
    
    private func setPhoenixData(userInfo: UserInfo) {
        self.phoenixData.user_id = userInfo.name
        self.phoenixData.company = userInfo.company
        self.phoenixData.car_number = userInfo.carNumber
    }
    
    private func postPhoenixRecords() {
        if phoenixData.longitude != 0 && phoenixData.latitude != 0 {
            self.phoenixData.mobile_time = getCurrentTimeInMillisecondsDouble()
            self.phoenixIndex += 1
            self.phoenixData.index = self.phoenixIndex
            print(getLocalTimeString() + " , (Phoenix) : Data = \(self.phoenixData)")
            NetworkManager.shared.postPhoenixRecord(url: RECORD_URL, input: [phoenixData], completion: { [self] statusCode, returnedString in
                if statusCode == 200 {
                    print(getLocalTimeString() + " , (Phoenix) Record Success : \(statusCode) , \(returnedString)")
                } else {
                    print(getLocalTimeString() + " , (Phoenix) Record Error : \(statusCode) , \(returnedString)")
                }
            })
        }
    }
    
    private func goToJupiterServiceVC(userInfo: UserInfo, phoenixData: PhoenixRecord) {
        guard let serviceVC = self.storyboard?.instantiateViewController(withIdentifier: JupiterServiceViewController.identifier) as? JupiterServiceViewController else { return }
        serviceVC.userInfo = userInfo
        serviceVC.phoenixData = phoenixData
        
        self.navigationController?.pushViewController(serviceVC, animated: true)
    }
}
