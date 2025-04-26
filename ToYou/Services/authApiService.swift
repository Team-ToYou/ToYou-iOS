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
            print(100)
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
                    completion(.expired)
                default: // 다른 모든 경우는 error 처리
                    completion(.error)
                }
                
            case .failure(let error):
                print("reissue error", error)
                completion(.error)
            }
        }
    }
    
    struct ReissueResult: Codable {
        let refreshToken: String?
        let accessToken: String?
    }
}
