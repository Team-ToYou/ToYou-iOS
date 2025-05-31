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
    
    static func deleteFriend(friendId: Int, completion: @escaping (FriendCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let tail = "/friends"
        let url = K.URLString.baseURL + tail
        let parameters: [String: Any] = [
            "userId": friendId
        ]
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
        ).responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case FriendCode.COMMON200.rawValue:
                    completion(.COMMON200)
                case FriendCode.JWT400.rawValue:
                    RootViewControllerService.toLoginViewController()
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
    
    
}
