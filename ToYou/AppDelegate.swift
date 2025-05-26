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

extension AppDelegate : MessagingDelegate {
    // 토큰의 갱신이 일어났을 때, 호출되는 함수
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            print("fcm token ", fcmToken)
            var method:  HTTPMethod = .post
            if let _ = KeychainService.get(key: K.Key.fcmToken) { // FCM 토큰이 저장 되어 있는 경우
                method = .patch
            }
            FCMTokenApiService.uploadFCMTokenToServer(mode: method, fcmToken) { code in
                switch code {
                case .COMMON200: // FCM 토큰 로컬에 저장
                    let _ = KeychainService.add(key: K.Key.fcmToken, value: fcmToken)
                case .JWT400:
                    RootViewControllerService.toLoginViewController()
                case .FCM400: // 유효하지 않은 FCM 토큰 => 진짜 어떻게 대응하냐...
                    break
                case .FCM401: // 해당 토큰 정보가 존재하지 않는다.
                    // 토큰 재발급을 받아야 한다
                    break
                case .FCM402: // 해당 유저의 토큰이 아닌 경우 (한 기기에서 A 유저가 로그아웃 하고 B 유저가 로그인 한 경우)
                    // 로그아웃, 회원탈퇴 시, 반드시 서버에서 FCM 토큰을 삭제해주어야 한다.
                    break
                case .FCM403: //
                    break
                case .COMMON500: // 서버에러, 네트워크 에러 발생, 앱을 여는 순간에 어떤 피드백을 보여줄 것인가?
                    break
                }
            }
        }
    }
}
