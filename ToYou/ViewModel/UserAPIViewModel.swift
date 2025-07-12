//
//  UserViewModel.swift
//  ToYou
//
//  Created by 이승준 on 6/30/25.
//

import Combine
import Alamofire

final class UserAPIViewModel: ObservableObject {
    
    @Published var userInfo: MyPageResult?
    @Published var isLoading: Bool = false
    private var cancellables: Set<AnyCancellable> = []
    
    static let shared = UserAPIViewModel()
    
    func fetchUser( retry: Bool = false, completion: @escaping(UserCode) -> Void) {
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
        ).responseDecodable(of: ToYouResponse<MyPageResult>.self) { [weak self] response in
            switch response.result {
            case .success(let apiResponse):
                let code = apiResponse.code
                switch code {
                case UserCode.success.rawValue :
                    self?.userInfo = apiResponse.result
                    completion(.success)
                case UserCode.expired.rawValue: // access token이 만료된 경우
                    if !retry { // refresh token을 통해 재발급 시도
                        AuthAPIService.reissueRefreshToken { [weak self] code in
                            switch code {
                            case .success:
                                self?.fetchUser(retry: true) { [weak self] code in
                                    switch code {
                                    case .success:
                                        self?.userInfo = apiResponse.result
                                    case .expired:
                                        completion(.expired)
                                    case .error:
                                        print("fetch user info error")
                                        completion(.error)
                                    }
                                }
                            case .expired:
                                completion(.expired)
                            case .error:
                                print("reissue token error")
                                completion(.error)
                            }
                        }
                    }
                    completion(.expired)
                default:
                    print("fetch user info error")
                    completion(.error)
                }
            case .failure(let error):
                completion(.error)
                print(error)
            }
        }
    }
}
