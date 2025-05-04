//
//  userAPIService.swift
//  ToYou
//
//  Created by 이승준 on 5/4/25.
//

import Foundation
import Alamofire

extension APIService {
    static func isUserFinishedSignUp(completion: @escaping (Bool) -> Void) {
        let url = K.URLString.baseURL + "/users/mypage"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseDecodable(of: ToYouResponse<MyPageResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.result?.nickname != nil &&
                    apiResponse.result?.status != nil
                {
                    completion(true)
                } else {
                    completion(false)
                }
            case .failure(let error):
                print("get userInfo error: ", error)
            }
        }
    }
}
