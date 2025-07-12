//
//  FCMTokenViewModel.swift
//  ToYou
//
//  Created by 이승준 on 7/12/25.
//

import Alamofire

final class FCMTokenViewModel {
    
    static let shared = FCMTokenViewModel()
    
    func uploadFCMTokenToServer(completion: @escaping (FCMCode) -> Void) {
        let tail = "/fcm/token"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken)  else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        guard let fcmToken = KeychainService.get(key: K.Key.fcmToken) else { return }
        let parameters: [String: Any] = ["token" : fcmToken]
        
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: ToYouResponseWithoutResult.self) { response in
            switch response.result {
            case .success(let apiResponse) :
                let code = apiResponse.code
                switch code {
                case FCMCode.COMMON200.rawValue :
                    completion(.COMMON200)
                case FCMCode.FCM400.rawValue :
                    completion(.FCM400)
                case FCMCode.FCM401.rawValue :
                    completion(.FCM401)
                case FCMCode.FCM402.rawValue :
                    completion(.FCM402)
                case FCMCode.FCM403.rawValue :
                    completion(.FCM403)
                default:
                    completion(.COMMON500)
                }
                if code != FCMCode.COMMON200.rawValue {
                    print("\(tail) patch 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("\(tail) patch API 에러: \(error.localizedDescription)")
                completion(.COMMON500)
            }
        }
    }
    
    static func getUserFCMToken(userId: Int , completion: @escaping (FCMCode, [String]?) -> Void) {
        let tail = "/fcm/token?userId=\(userId)"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken)  else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        AF.request(url,
           method: .get,
           encoding: JSONEncoding.default,
           headers: headers)
        .responseDecodable(of: ToYouResponse<FCMTokenResult>.self) { response in
            switch response.result {
            case .success(let apiResponse) :
                let code = apiResponse.code
                switch code {
                case FCMCode.COMMON200.rawValue :
                    print("#getUserFCMToken \(tail) get token from userId \(userId) 요청 성공")
                    completion(.COMMON200, apiResponse.result?.token)
                case FCMCode.FCM400.rawValue :
                    completion(.FCM400, nil)
                case FCMCode.FCM401.rawValue :
                    completion(.FCM401, nil)
                case FCMCode.FCM402.rawValue :
                    completion(.FCM402, nil)
                case FCMCode.FCM403.rawValue :
                    completion(.FCM403, nil)
                default:
                    completion(.COMMON500, nil)
                }
                if code != FCMCode.COMMON200.rawValue {
                    print("#getUserFCMToken \(tail) get token from userId \(userId) 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("#getUserFCMToken \(tail) get token from userId \(userId) API 오류: \(error.localizedDescription)")
                completion(.COMMON500, nil)
            }
        }
        
    }

    
}
