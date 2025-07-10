//
//  NotificationViewModel.swift
//  ToYou
//
//  Created by 이승준 on 7/10/25.
//

import Combine
import Alamofire

final class NotificationViewModel: ObservableObject {
    @Published var notificationData: [NotificationData] = []
    @Published var friendRequestData: [FriendRequestData] = []
    
    init() {
        getNotificationList()
        getFriendRequestList()
    }
    
    func fetchAllData() {
        getNotificationList()
        getFriendRequestList()
    }
    
    func getNotificationList(_ firstTry: Bool = true) {
        NotificationNetworkService.getNotificationList { [weak self] response in
            switch response {
            case .success(let success):
                switch success.code {
                case NotificationCode.COMMON200.rawValue :
                    print("#getNotificationList succeed \(success.result?.alarmList ?? [])")
                    self?.notificationData = success.result?.alarmList ?? []
                case NotificationCode.JWT400.rawValue :
                    print("#getNotificationList jwt expired \(success.message)")
                    if firstTry {
                        AuthAPIService.reissueRefreshToken { result in
                            switch result {
                            case .success:
                                self?.getNotificationList(false)
                            case .expired, .error :
                                RootViewControllerService.toLoginViewController()
                            }
                        }
                    } else {
                        RootViewControllerService.toLoginViewController()
                    }
                default:
                    print("#getNotificationList undefinded code \(success.code)")
                }
            case .failure(let failure):
                print("#getNotificationList", failure)
            }
        }
    }
    
    func removeNotification(_ firstTry: Bool = true, index: Int) {
        NotificationNetworkService.removeNotification(index: index) { [weak self] response in
            switch response {
            case .success(let success):
                switch success.code {
                case NotificationCode.COMMON200.rawValue :
                    print("#removeNotification succeed \(success.message)")
                    self?.notificationData.remove(at: index)
                case NotificationCode.JWT400.rawValue :
                    print("#removeNotification jwt expired \(success.message)")
                    if firstTry {
                        AuthAPIService.reissueRefreshToken { result in
                            switch result {
                            case .success:
                                self?.removeNotification(false, index: index)
                            case .expired, .error :
                                RootViewControllerService.toLoginViewController()
                            }
                        }
                    } else {
                        RootViewControllerService.toLoginViewController()
                    }
                default:
                    print("#removeNotification undefinded code \(success.code)")
                }
            case .failure(let failure):
                print("#removeNotification", failure)
            }
        }
    }
    
    func getFriendRequestList(_ firstTry: Bool = true) {
        NotificationNetworkService.getFriendRequestList { [weak self] response in
            switch response {
            case .success(let success):
                switch success.code {
                case NotificationCode.COMMON200.rawValue :
                    print("#getFriendRequestList succeed \(success.result?.senderInfos ?? [])")
                    self?.friendRequestData = success.result?.senderInfos ?? []
                case NotificationCode.JWT400.rawValue :
                    print("#getFriendRequestList jwt expired \(success.message)")
                    if firstTry {
                        AuthAPIService.reissueRefreshToken { result in
                            switch result {
                            case .success:
                                self?.getFriendRequestList(false)
                            case .expired, .error :
                                RootViewControllerService.toLoginViewController()
                            }
                        }
                    } else {
                        RootViewControllerService.toLoginViewController()
                    }
                default:
                    print("#getFriendRequestList undefinded code \(success.code)")
                }
            case .failure(let failure):
                print("#getFriendRequestList", failure)
            }
        }
    }
    
}


enum NotificationNetworkService {
    
    static func getNotificationList(completion: @escaping(Result<ToYouResponse<NotificationResult>, AFError>) -> Void) {
        let url = K.URLString.baseURL + "/alarms"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [ "accept" : " ", "Authorization": "Bearer " + accessToken]
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ToYouResponse<NotificationResult>.self) { response in
            completion(response.result)
        }
    }
    
    static func removeNotification(index: Int, completion: @escaping(Result<ToYouResponse<EmptyResult>, AFError>) -> Void) {
        let url = K.URLString.baseURL + "/alarms/\(NotificationAPIService100.shared.notificationData[index].alarmId!)"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [ "accept" : " ", "Authorization": "Bearer " + accessToken ]
        AF.request(url, method: .delete, headers: headers).responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            completion(response.result)
        }
    }
    
    static func getFriendRequestList(completion: @escaping(Result<ToYouResponse<FriendRequestResult>, AFError>) -> Void) {
        let url = K.URLString.baseURL + "/friends/requests"
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [ "accept" : " ", "Authorization": "Bearer " + accessToken ]
        AF.request(url, method: .get, headers: headers).responseDecodable(of: ToYouResponse<FriendRequestResult>.self) { response in
            completion(response.result)
        }
    }
    
}
