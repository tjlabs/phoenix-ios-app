

public class NetworkManager {
    static let shared = NetworkManager()
    
    let TIMEOUT_VALUE_PUT: Double = 5.0
    let TIMEOUT_VALUE_POST: Double = 5.0
    
    let rcSession1: URLSession
    let rcSession2: URLSession
    let rcSession3: URLSession
    var rcSessionCount: Int = 0
    
    var rcSessions = [URLSession]()
    init() {
        let rcConfig = URLSessionConfiguration.default
        rcConfig.timeoutIntervalForResource = TIMEOUT_VALUE_POST
        rcConfig.timeoutIntervalForRequest = TIMEOUT_VALUE_POST
        self.rcSession1 = URLSession(configuration: rcConfig)
        self.rcSession2 = URLSession(configuration: rcConfig)
        self.rcSession3 = URLSession(configuration: rcConfig)
        self.rcSessions.append(self.rcSession1)
        self.rcSessions.append(self.rcSession2)
        self.rcSessions.append(self.rcSession3)
    }
    
    func initailze() {
        self.rcSessionCount = 0
        self.rcSessions = [URLSession]()
    }
    
    func postPhoenixRecord(url: String, input: [PhoenixRecord], completion: @escaping (Int, String) -> Void) {
        // [http 비동기 방식을 사용해서 http 요청 수행 실시]
        let urlComponents = URLComponents(string: url)
        var requestURL = URLRequest(url: (urlComponents?.url)!)
        
        requestURL.httpMethod = "POST"
        let encodingData = JSONConverter.encodeJson(param: input)
        if (encodingData != nil) {
            requestURL.httpBody = encodingData
            requestURL.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            
            print("")
            print("====================================")
            print("POST Phoenix Record URL :: ", url)
            print("POST Phoenix Record 데이터 :: ", input)
            print("====================================")
            print("")
            
            let rcSession = self.rcSessions[self.rcSessionCount%3]
            self.rcSessionCount+=1
            let dataTask = rcSession.dataTask(with: requestURL, completionHandler: { (data, response, error) in
                
                // [error가 존재하면 종료]
                guard error == nil else {
                    if let timeoutError = error as? URLError, timeoutError.code == .timedOut {
                        DispatchQueue.main.async {
                            completion(timeoutError.code.rawValue, error?.localizedDescription ?? "timed out")
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(500, error?.localizedDescription ?? "Fail")
                        }
                    }
                    return
                }
                
                // [status 코드 체크 실시]
                let successsRange = 200..<300
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, successsRange.contains(statusCode)
                else {
                    DispatchQueue.main.async {
                        completion(500, (response as? HTTPURLResponse)?.description ?? "Fail")
                    }
                    return
                }
                
                // [response 데이터 획득]
                let resultCode = (response as? HTTPURLResponse)?.statusCode ?? 500 // [상태 코드]
                guard let resultLen = data else {
                    DispatchQueue.main.async {
                        completion(500, (response as? HTTPURLResponse)?.description ?? "Fail")
                    }
                    return
                }
                let resultData = String(data: resultLen, encoding: .utf8) ?? "" // [데이터 확인]
                
                // [콜백 반환]
                DispatchQueue.main.async {
                    completion(resultCode, resultData)
                }
            })
            
            // [network 통신 실행]
            dataTask.resume()
        } else {
            DispatchQueue.main.async {
                completion(500, "Fail to encode")
            }
        }
    }
}
