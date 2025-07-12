//
//  UserAPIService.swift
//  ToYou
//
//  Created by 이승준 on 5/22/25.
//

import Alamofire
import Foundation

final class UsersAPIService {
    
    static var myPageInfo: MyPageResult?
    
    static func userInfoFetched()  {
        NotificationCenter.default.post(name: NSNotification.Name("UserInfoFetched"), object: nil)
    }
    
    static func fetchUserInfo(completion: @escaping(UserCode) -> Void) {
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
                let code = apiResponse.code
                switch code {
                case UserCode.success.rawValue :
                    self.myPageInfo = apiResponse.result
                    self.userInfoFetched()
                    completion(.success)
                case UserCode.expired.rawValue:
                    RootViewControllerService.toLoginViewController()
                    completion(.expired)
                default:
                    completion(.error)
                }
            case .failure(let error):
                completion(.error)
                print(error)
            }
        }
    }
    
}

enum UserCode: String {
    case success = "COMMON200"
    case expired = "JWT400"
    case error = "COMMON500"
}
