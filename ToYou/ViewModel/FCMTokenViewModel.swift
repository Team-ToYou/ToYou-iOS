//
//  FCMTokenViewModel.swift
//  ToYou
//
//  Created by 이승준 on 7/12/25.
//

import Alamofire

let fcmViewModel = FCMTokenViewModel.shared

final class FCMTokenViewModel {
    
    static let shared = FCMTokenViewModel()
    
    func uploadFCMTokenToServer(completion: @escaping (FCMCode) -> Void) {
        FCMTokenNetworkService.uploadFCMTokenToServer { response in
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
                    print("fcm post 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("fcm post API 에러: \(error.localizedDescription)")
                completion(.COMMON500)
            }
        }
    }
    
    func getUserFCMToken(userId: Int , completion: @escaping (FCMCode, [String]?) -> Void) {
        FCMTokenNetworkService.getUserFCMTokenById(userId: userId) { response in
            switch response.result {
            case .success(let apiResponse) :
                let code = apiResponse.code
                switch code {
                case FCMCode.COMMON200.rawValue :
                    print("#getUserFCMToken get token from userId \(userId) 요청 성공")
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
                    print("#getUserFCMToken get token from userId \(userId) 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("#getUserFCMToken get token from userId \(userId) API 오류: \(error.localizedDescription)")
                completion(.COMMON500, nil)
            }
    }
    
}

    func deleteUserFCMToken(completion: @escaping (FCMCode) -> Void) {
        FCMTokenNetworkService.deleteMyFCMToken{ response in
            switch response.result {
            case .success(let apiResponse) :
                let code = apiResponse.code
                switch code {
                case FCMCode.COMMON200.rawValue :
                    let _ = KeychainService.delete(key: K.Key.fcmToken)
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
                    print("fcm delete 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("fcm delete API 오류: \(error.localizedDescription)")
                completion(.COMMON500)
            }
        }
    }
    
    func sendSingleFCMMessage(to token: String, requestType: FCMRequestType, completion: @escaping (FCMCode) -> Void) {
        FCMTokenNetworkService.sendSingleFCMMessage(to: token, requestType: requestType) { response in
            switch response.result {
            case .success(let apiResponse) :
                let code = apiResponse.code
                switch code {
                case FCMCode.COMMON200.rawValue :
                    let _ = KeychainService.delete(key: K.Key.fcmToken)
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
                    print("send single fcm message 요청 실패: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("#sendSingleFCMMessage Failed to \(token), error code : \(error)")
            }
        }
    }
    
    func sendFCMMessage(to userId: Int, requestType: FCMRequestType, completion: @escaping (FCMCode) -> Void) {
        self.getUserFCMToken(userId: userId) { code, list in
            print("userId: \(userId) fcm tokens: \(list ?? ["empty"])" )
            switch code {
            case .COMMON200:
                if let list {
                    for fcmToken in list {
                        self.sendSingleFCMMessage(to: fcmToken, requestType: requestType) { code in
                        print(code)
                        }
                    }
                } else { // fcm token이 없는 경우
                    print("user \(userId) has no fcm token")
                }
            case .JWT400:
                RootViewControllerService.toLoginViewController()
            default :
                print("#sendFCMMessage Failed Code \(code)")
            }
        }
    }
    
}

enum FCMTokenNetworkService {
    static func uploadFCMTokenToServer(completion: @escaping (DataResponse<ToYouResponseWithoutResult, AFError>) -> Void) {
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
        .responseDecodable(of: ToYouResponseWithoutResult.self, completionHandler: completion)
    }
    
    static func getUserFCMTokenById(userId: Int, completion: @escaping (DataResponse<ToYouResponse<FCMTokenResult>, AFError>) -> Void) {
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
        .responseDecodable(of: ToYouResponse<FCMTokenResult>.self, completionHandler: completion)
    }
    
    static func deleteMyFCMToken(completion: @escaping (DataResponse<ToYouResponseWithoutResult, AFError>) -> Void) {
        let tail = "/fcm/token"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken)  else { return }
        guard let fcmToken = KeychainService.get(key: K.Key.fcmToken)  else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = ["token" : fcmToken]
        AF.request(url,
                   method: .delete,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: ToYouResponseWithoutResult.self, completionHandler: completion)
    }
    
    static func sendSingleFCMMessage(to token: String, requestType: FCMRequestType, completion: @escaping (DataResponse<ToYouResponseWithoutResult, AFError>)-> Void) {
        var title = ""
        var body = ""
        guard let userInfo = UserViewModel.userInfo else {
            print("#sendSingleFCMMessage 사용자 정보 조회 실패")
            RootViewControllerService.toLoginViewController()
            return
        }
        guard let userName = userInfo.nickname else {
            print("#sendSingleFCMMessage 사용자 정보 안의 내용에서 nil 발견")
            return
        }
        // 사용자 이름 저장해둔 곳
        switch requestType {
        case .FriendRequest:
            title = "친구 요청"
            body = "\(userName)님이 친구 요청을 보냈습니다."
        case .FriendRequestAccepted:
            title = "친구 요청 승인"
            body = "\(userName)님이 친구 요청을 승인하셨습니다."
        case .Query:
            title = "질문 생성"
            body = "\(userName)님이 질문을 보냈습니다."
        }
        
        let tail = "/fcm/send"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken)  else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "token" : token,
            "title" : title,
            "body" : body
        ]
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding : JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: ToYouResponseWithoutResult.self, completionHandler: completion)
    }
}

enum FCMRequestType {
    case FriendRequest, FriendRequestAccepted, Query
}

enum FCMCode: String {
    case COMMON200
    case JWT400
    case FCM400 // 유효하지 않은 토큰인 경우
    case FCM401 // 해당 토큰 정보가 존재하지 않는 경우
    case FCM402 // 해당 유저의 토큰이 아닌 경우
    case FCM403 // 이미 존재하는 토큰 정보 (다른 유저가 가지고 있을 수 있다.)
    case COMMON500 // 서버 에러
}

struct FCMTokenResult: Codable {
    let token: [String]?
}
