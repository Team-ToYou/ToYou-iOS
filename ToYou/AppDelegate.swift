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
//    
//    // 토큰의 갱신이 일어났을 때, 호출되는 함수
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
//        if let token = KeychainService.get(key: K.Key.fcmToken) { // 이미 token이 로컬에 저장되어 있는 경우
//            updateTokenToServer(token)
//        } else { // 토큰이 저장 X, (처음 앱을 연 경우)
//            if let token = fcmToken {
//                sendTokenToServer(token)
//            } else { // 예외처리, fcmToken이 nil인 경우
//                
//            }
//        }
//    }
    
    // 1. 토큰을 서버에 전송 => 성공 시, 로컬에도 저장
//    func sendTokenToServer(_ token: String) {
//        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
//        
//        let parameters [""]
//        
//        AF.request(K.URLString.baseURL + "/fcm/send",
//                   method: .post,
//                   parameters: ,
//                   headers: ["accept": "*/*"])
//    }
//    
//    // 2. 토큰 값을 갱신
//    func updateTokenToServer(_ token: String) {
//        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
//        
//        
//    }
}
