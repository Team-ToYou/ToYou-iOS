//
//  FCMViewModel(Local).swift
//  ToYou
//
//  Created by 이승준 on 7/15/25.
//

import Foundation
import NotificationCenter

extension FCMTokenViewModel {
    
    func checkNotificationPermission(completion: @escaping (NotificationPermissionStatus) -> Void) {
        switch defaults.value(forKey: K.Key.isNotificationAllowed) as! Bool? {
        case .none: // 사용자가 처음 앱을 사용한 경우 or 알림 여부를 결정하지 않은 경우
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .denied : // 거절한 경우
                    self.defaults.set(false, forKey: K.Key.isNotificationAllowed)
                    completion(.denied)
                case .notDetermined : // 결정하지 않은 경우
                    self.defaults.set(nil, forKey: K.Key.isNotificationAllowed)
                    completion(.notDetermined)
                default : // 허락한 경우
                    self.defaults.set(true, forKey: K.Key.isNotificationAllowed)
                    completion(.allowed)
                    return
                }
            }
        case true: // 사용자가 알림을 허용한 경우
            completion(.allowed)
        case false: // 사용자가 알림을 거부한 경우
            completion(.denied)
        case .some(_):
            print("\(K.Key.isNotificationAllowed)에서 Bool 형태가 아닌 자료형이 들어왔습니다.")
        }
    }
    
    func checkAndRequestNotificationPermission(vc: UIViewController) {
        let center = UNUserNotificationCenter.current()
        
        center.getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                switch settings.authorizationStatus {
                case .notDetermined:
                    self?.requestNotificationPermission(vc: vc)
                case .denied:
                    self?.showGoToSettingsAlert(vc: vc)
                case .authorized, .provisional, .ephemeral:
                    print("알림이 이미 허용되어 있습니다.")
                @unknown default:
                    break
                }
            }
        }
    }
    
    private func requestNotificationPermission(vc: UIViewController) {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .sound, .badge]) { [weak self] granted, error in
            DispatchQueue.main.async {
                if granted {
                    print("알림 권한 허용됨")
                    UIApplication.shared.registerForRemoteNotifications()
                } else {
                    print("알림 권한 거부됨")
                    self?.showGoToSettingsAlert(vc: vc)
                }
            }
        }
    }
    
    private func showGoToSettingsAlert(vc: UIViewController) {
        let alert = UIAlertController(
            title: "알림 권한",
            message: "설정에서 알림을 허용하시겠습니까?",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "설정", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
            UIApplication.shared.open(settingsUrl)
        })
        
        alert.addAction(UIAlertAction(title: "나중에", style: .cancel))
        
        vc.present(alert, animated: true)
    }
    
}
