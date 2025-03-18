//
//  AppDelegate.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Firebase
import UserNotifications
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        
        // 앱 실행 시 사용자에게 알림 허용 권한을 받음
        UNUserNotificationCenter.current().delegate = self
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound] // 필요한 알림 권한을 설정
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        
        // UNUserNotificationCenterDelegate를 구현한 메서드를 실행시킴
        application.registerForRemoteNotifications()
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    // 백그라운드에서 푸시 알림을 탭했을 때 실행
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    // Foreground(앱 켜진 상태)에서도 알림 오는 설정
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.list, .banner, .sound, .badge])
    }
}

extension AppDelegate: MessagingDelegate {
    
    // 토큰의 갱신이 일어났을 때, 호출되는 함수
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            if let savedToken = KeychainService.get(key: K.Key.fcmToken),  savedToken != fcmToken { // 저장되어있는 것과 달라야 한다.
                updateTokenToServer(fcmToken)
            } else {
                if KeychainService.add(key: K.Key.fcmToken, value: fcmToken) {
                    print("FCMToken saved successfully in Keychain")
                }
                sendTokenToServer(fcmToken)
            }
        }
    }
    
    // 1. 토큰을 서버에 전송 => 성공 시, 로컬에도 저장
    func sendTokenToServer(_ token: String) {
        let tail = "/fcm/token"
        let url = K.URLString.baseURL + tail
        let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NDEzNTQyMTAsImV4cCI6MTc0MjU2MzgxMCwic3ViIjoiMyIsImlkIjozLCJjYXRlZ29yeSI6ImFjY2VzcyJ9.7l3IQYZQ3cgZcB15Sp1B_UoEsw8qnvXnFWh82I95Jn0"
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        print("token : ", token)
        let parameters = ["token": token]
        
        // JSONEncoding 사용하기
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: FCMResponse.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    
                } else {
                    print("\(tail) send API 오류: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("\(tail) send 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    // 2. 토큰 값을 갱신
    func updateTokenToServer(_ token: String) {
        // guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let tail = "/fcm/token"
        let url = K.URLString.baseURL + tail
        let accessToken = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NDEzNTQyMTAsImV4cCI6MTc0MjU2MzgxMCwic3ViIjoiMyIsImlkIjozLCJjYXRlZ29yeSI6ImFjY2VzcyJ9.7l3IQYZQ3cgZcB15Sp1B_UoEsw8qnvXnFWh82I95Jn0"
        let headers: HTTPHeaders = [
                "accept": "*/*",
                "Authorization": accessToken,
                "Content-Type": "application/json"
            ]
        let parameters = ["token" : token]
        AF.request(url,
                   method: .patch,
                   parameters: parameters,
                   encoding: JSONEncoding.default,
                   headers: headers)
        .responseDecodable(of: FCMResponse.self) { response in
            // 서버 응답 상태 코드 확인
            if let statusCode = response.response?.statusCode {
                print("상태 코드: \(statusCode)")
            }
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    if KeychainService.update(key: K.Key.fcmToken, value: token) {
                        print("FCMToken updated successfully in Keychain")
                    }
                } else {
                    print("\(tail) patch API 오류: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("\(tail) patch 요청 실패: \(error.localizedDescription)")
            }
        }
    }
}
