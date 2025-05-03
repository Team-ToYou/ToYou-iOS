//
//  authApiService.swift
//  ToYou
//
//  Created by 이승준 on 4/26/25.
//

import Alamofire
import Foundation

enum ReissueCode: String {
    case success = "COMMON200"
    case error = "JWT400"
    case expired = "JWT401"
}

class APIService {
    static func reissueRefreshToken( completion: @escaping(ReissueCode) -> Void) {
        guard let refreshToken = KeychainService.get(key: K.Key.refreshToken) else {
            completion(.error);
            return
        } // 없는 토큰은 무효한 토큰과 마찬가지
        let tail = "/auth/reissue"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "refreshToken": refreshToken,
            "Content-Type": "application/json",
        ]
        AF.request(
            url,
            method: .post,
            headers: headers,
        ).responseDecodable(of: ToYouResponse<ReissueResult>.self) { response in
            // 헤더에서 토큰 추출 및 출력
            if let httpResponse = response.response {
                if let accessToken = httpResponse.headers["access_token"] {
                    let _ = KeychainService.update(key: K.Key.accessToken, value: accessToken)
                }
                if let refreshToken = httpResponse.headers["refresh_token"] {
                    let _ = KeychainService.update(key: K.Key.refreshToken, value: refreshToken)
                }
            }
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case ReissueCode.success.rawValue:
                    completion(.success)
                case ReissueCode.expired.rawValue:
                    // error, expired 모두 login으로 이동해야함, 내부에서 구현.
                    // why? 여러 곳에서 쓰일것이고 공통된 동작을 할 것이기 때문에 동작을 여기서 미리 지정해도 괜찮다.
                    RootViewControllerService.toLoginViewController()
                    completion(.expired)
                default: // 다른 모든 경우는 error 처리
                    RootViewControllerService.toLoginViewController()
                    completion(.error)
                }
            case .failure(let error): // 이 에러는 서버에러일 수 있어서, 어떤 동작을 해야할지 생각해볼 필요가 있음
                print("reissue error", error)
                completion(.error)
            }
        }
    }
    
    struct ReissueResult: Codable {
        let refreshToken: String?
        let accessToken: String?
    }
    
    static func loginWithApple(authorizationCode: String, completion: @escaping(Bool) -> Void) {
        let tail = "/auth/apple"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "authorizationCode": authorizationCode
        ]
        // JSONEncoding 사용하기
        AF.request(url,
                   method: .post,
                   headers: headers)
        .responseDecodable(of: ToYouResponse<AppleLoginResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    let accessToken = apiResponse.result!.accessToken
                    let refreshToken = apiResponse.result!.refreshToken
                    print("accessToken  \(accessToken)")
                    print("refreshToken \(refreshToken)")
                    let _ = KeychainService.add(key: K.Key.accessToken, value: accessToken)
                    let _ = KeychainService.add(key: K.Key.refreshToken, value: refreshToken)
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let error):
                completion(false)
                print("\(tail) send 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    struct AppleLoginResult: Codable {
        let isUser: Bool?
        let accessToken: String
        let refreshToken: String
    }
    
    enum AUTHCode: String {
        case invalidToken = "OAUTH401", success = "COMMON200"
    }
}
