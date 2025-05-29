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
        NotificationData(alarmId: 0, content: "준환 친구요청 알림", nickname: "준환", alarmType: .FRIEND_REQUEST_ACCEPTED),
        NotificationData(alarmId: 1, content: "승원 친구요청 알림", nickname: "승원", alarmType: .FRIEND_REQUEST_ACCEPTED),
        NotificationData(alarmId: 2, content: "미주가 질문을 보냄", nickname: "미주", alarmType: .NEW_QUESTION),
    ]
    var friendRequestData: [FriendRequestData] = []
    
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
                    print("#NotificationAPIService.swift getNotificationList success")
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
    case COMMON200, JWT401
}

struct FriendRequestResult: Codable {
    let senderInfos: [FriendRequestData]?
}

struct FriendRequestData: Codable {
    let userId: Int?
    let nickname: String?
}
