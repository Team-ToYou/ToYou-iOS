//
//  SetNotificationViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit
import UserNotifications

class SetNotificationViewController: UIViewController {
    
    private let setNotificationView = SetNotificationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = setNotificationView
        self.setupButtonActions()
        self.navigationController?.isNavigationBarHidden = true
        checkNotificationAuthorizationStatus()
    }
    
    private func setupButtonActions() {
        setNotificationView.navigationBar.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        setNotificationView.toggle.addTarget(self, action: #selector(toggleNotificationState), for: .valueChanged)
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func toggleNotificationState() {
        switch setNotificationView.toggle.isOn {
        case true: // false -> true로 바뀜
            print("false -> true")
        case false: // false로 바뀜
            print("true -> false")
        }
    }
    
    func checkNotificationAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                DispatchQueue.main.async {
                    self.setNotificationView.toggle.isOn = true
                }
                print("알림 허용됨")
                // 알림을 사용할 수 있습니다.
            case .denied:
                self.requestNotificationAuthorization()
                DispatchQueue.main.async {
                    self.setNotificationView.toggle.isOn = false
                }
                print("알림 거부됨")
                // 사용자에게 알림 설정 화면으로 이동하도록 안내합니다.
            case .notDetermined:
                self.requestNotificationAuthorization()
                print("알림 권한 미결정")
                // 사용자에게 알림 권한을 요청합니다.
            case .provisional:
                DispatchQueue.main.async {
                    self.setNotificationView.toggle.isOn = true
                }
                print("프로비저널 알림 허용됨")
                // 제한적인 알림을 사용할 수 있습니다.
            case .ephemeral:
                DispatchQueue.main.async {
                    self.setNotificationView.toggle.isOn = true
                }
                print("임시 알림 허용됨")
                // 특정 조건에서만 알림을 사용할 수 있습니다.
            @unknown default:
                DispatchQueue.main.async {
                    self.setNotificationView.toggle.isOn = false
                }
                print("알 수 없는 알림 상태")
            }
        }
    }
    
    func requestNotificationAuthorization() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { (granted, error) in
                if let error = error {
                    print("알림 권한 요청 중 오류 발생: \(error.localizedDescription)")
                }
                if granted {
                    print("알림 권한 허용됨")
                    // 알림을 사용할 수 있습니다.
                } else {
                    print("알림 권한 거부됨")
                    // 사용자에게 알림 설정 화면으로 이동하도록 안내합니다.
                }
            }
        )
    }

}


