//
//  UserAPIService.swift
//  ToYou
//
//  Created by 이승준 on 5/22/25.
//

import Alamofire
import Combine

final class UsersAPIService {
    
    static var myPageInfo: MyPageResult?
    
    static func fetchUserInfo() {
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
                print(apiResponse)
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

enum UserCode: String {
    case success = "COMMON200"
    case invalidToken = "JWT400"
}
