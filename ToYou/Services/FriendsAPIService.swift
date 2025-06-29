//
//  FriendInfo.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import Foundation
import Alamofire

struct FriendInfo: Codable {
    let userId: Int
    let nickname: String
    let emotion: Emotion?
    let ment: String?
}

struct FriendsListResult: Codable {
    let friendList: [FriendInfo]
}

enum FriendCode: String {
    case COMMON200, JWT400, ERROR500, FRIEND401
}

class FriendsAPIService {
    static var data: [FriendInfo] = []
    
    static func fetchList(completion: @escaping (FriendCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let tail = "/friends"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)"
        ]
        AF.request(
            url,
            method: .get,
            encoding: JSONEncoding.default,
            headers: headers
        ).responseDecodable(of: ToYouResponse<FriendsListResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case FriendCode.COMMON200.rawValue:
                    if let list = apiResponse.result?.friendList {
                        print("/friends get success", list)
                        data = list
                    }
                    print("/friends get success, no cell")
                    completion(.COMMON200)
                case FriendCode.JWT400.rawValue:
                    completion(.JWT400)
                case FriendCode.ERROR500.rawValue:
                    completion(.ERROR500)
                default:
                    completion(.ERROR500)
                }
            case .failure(let error):
                print("/friends .get : \(error)")
                completion(.ERROR500)
            }
        }
    }
    
    static func acceptRequest(friendId: Int, completion: @escaping (FriendCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let url = K.URLString.baseURL + "/friends/requests/approve"
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "userId": friendId
        ]
        AF.request(
            url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
        ).responseDecodable(of: ToYouResponse<RequestFriendResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case "COMMON200":
                    completion(.COMMON200)
                case "JWT400":
                    RootViewControllerService.toLoginViewController()
                    completion(.JWT400)
                default:
                    print("""
                          Exception Code \(apiResponse.code)
                          \(apiResponse)
                          """)
                    break
                }
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    static func deleteFriend(
            friendId: Int,
            isRetry: Bool = false,
            completion: @escaping (FriendCode) -> Void
        ) {
            guard let accessToken = KeychainService.get(key: K.Key.accessToken) else {
                RootViewControllerService.toLoginViewController()
                completion(.JWT400)
                return
            }

            let tail = "/friends"
            let url  = K.URLString.baseURL + tail
            let parameters: [String: Any] = ["userId": friendId]
            let headers: HTTPHeaders = [
                "accept": "*/*",
                "Authorization": "Bearer \(accessToken)"
            ]

            AF.request(
                url,
                method: .delete,
                parameters: parameters,
                encoding: JSONEncoding.default,
                headers: headers
            )
            .responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in

                switch response.result {

                // -----------------------------
                // MARK: 네트워크 통신 성공
                // -----------------------------
                case .success(let apiResponse):
                    switch apiResponse.code {

                    // 정상 삭제
                    case FriendCode.COMMON200.rawValue:
                        completion(.COMMON200)

                    // 토큰 만료(JWT400)
                    case FriendCode.JWT400.rawValue:
                        if isRetry == false {
                            AuthAPIService.reissueRefreshToken { reissueCode in
                                switch reissueCode {
                                case .success:
                                    deleteFriend(
                                        friendId: friendId,
                                        isRetry: true,
                                        completion: completion
                                    )
                                case .expired, .error:
                                    RootViewControllerService.toLoginViewController()
                                    completion(.JWT400)
                                }
                            }
                        } else {
                            // 이미 한 번 재시도했음에도 JWT400 → 로그인 화면 이동
                            RootViewControllerService.toLoginViewController()
                            completion(.JWT400)
                        }
                    case FriendCode.ERROR500.rawValue:
                        completion(.ERROR500)
                    default:
                        completion(.ERROR500)
                    }

                // -----------------------------
                // MARK: 네트워크 통신 실패
                // -----------------------------
                case .failure(let error):
                    print("/friends .delete : \(error)")
                    completion(.ERROR500)
                }
            }
        }
    
    
}
