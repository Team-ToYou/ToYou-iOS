//
//  NotificationService.swift
//  ToYou
//
//  Created by 이승준 on 5/30/25.
//

import Alamofire
import Foundation

final class NotificationAPIService {
    
    static let shared = NotificationAPIService()
    
    var notificationData: [NotificationData] = [
//        NotificationData(alarmId: 0, content: "승원님이 친구 요청을 수락했습니다", nickname: "승원", alarmType: .FRIEND_REQUEST_ACCEPTED),
//        NotificationData(alarmId: 1, content: "준환님이 친구 요청을 수락했습니다", nickname: "준환", alarmType: .FRIEND_REQUEST_ACCEPTED),
//        NotificationData(alarmId: 2, content: "미주가 질문을 보냄", nickname: "미주", alarmType: .NEW_QUESTION),
    ]
    var friendRequestData: [FriendRequestData] = [
//        FriendRequestData(userId: 0, nickname: "태연"),
//        FriendRequestData(userId: 1, nickname: "정모"),
    ]
    
    static func getNotificationList(completion: @escaping(NotificationCode) -> Void) {
        let url = K.URLString.baseURL + "/alarms"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseDecodable(of: ToYouResponse<NotificationResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case NotificationCode.COMMON200.rawValue :
                    self.shared.notificationData = apiResponse.result?.alarmList ?? []
                    print("#NotificationAPIService.swift getNotificationList success \(apiResponse.result?.alarmList ?? []) ")
                case NotificationCode.JWT400.rawValue :
                    RootViewControllerService.toLoginViewController()
                    print("#NotificationAPIService.swift getNotificationList JWT400")
                default :
                    print("""
                      #NotificationAPIService.swift getNotificationList exception code: 
                      \(apiResponse.code)
                      """)
                }
            case .failure(let error):
                print("""
                      #NotificationAPIService.swift getNotificationList error: 
                      \(error)
                      """)
            }
        }
    }
    
    static func removeNotification(index: Int, completion: @escaping(NotificationCode) -> Void) {
        let url = K.URLString.baseURL + "/alarms/\(NotificationAPIService.shared.notificationData[index].alarmId!)"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .delete,
            headers: headers
        ).responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let value) :
                switch value.code {
                case NotificationCode.COMMON200.rawValue:
                    NotificationAPIService.shared.notificationData.remove(at: index)
                    completion(.COMMON200)
                case NotificationCode.JWT400.rawValue:
                    RootViewControllerService.toLoginViewController()
                default:
                    break
                }
            case .failure(let error):
                print("""
                      #NotificationAPIService.swift removeNotification error: 
                      \(error)
                      """)
            }
        }
    }
    
    static func getFriendRequestList(completion: @escaping(NotificationCode) -> Void) {
        let url = K.URLString.baseURL + "/friends/requests"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept" : " ",
            "Authorization": "Bearer " + accessToken,
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        ).responseDecodable(of: ToYouResponse<FriendRequestResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                switch apiResponse.code {
                case NotificationCode.COMMON200.rawValue :
                    self.shared.friendRequestData = apiResponse.result?.senderInfos ?? []
                    print("#NotificationAPIService.swift getFriendRequestList success")
                case NotificationCode.JWT400.rawValue :
                    RootViewControllerService.toLoginViewController()
                    print("#NotificationAPIService.swift getFriendRequestList JWT400")
                default :
                    print("""
                      #NotificationAPIService.swift getFriendRequestList exception code: 
                      \(apiResponse.code)
                      """)
                }
            case .failure(let error):
                print("""
                      #NotificationAPIService.swift getFriendRequestList error: 
                      \(error)
                      """)
            }
        }
    }
    
}

struct NotificationResult: Codable {
    let alarmList: [NotificationData]?
}

struct NotificationData: Codable {
    let alarmId: Int?
    let content: String?
    let nickname: String?
    let alarmType: AlarmType?
}

enum NotificationCode: String {
    case COMMON200, JWT400
}

struct FriendRequestResult: Codable {
    let senderInfos: [FriendRequestData]?
}

struct FriendRequestData: Codable {
    let userId: Int?
    let nickname: String?
}
