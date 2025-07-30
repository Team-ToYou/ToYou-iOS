//
//  SetNotificationViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit
import UserNotifications

class SetNotificationViewController: UIViewController, UNUserNotificationCenterDelegate {
    
    private let setNotificationView = SetNotificationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = setNotificationView
        self.setupButtonActions()
        self.navigationController?.isNavigationBarHidden = true
        UNUserNotificationCenter.current().delegate = self
        fcmViewModel.checkNotificationPermission { status in
            switch status {
            case .notDetermined:
                break
            case .allowed:
                self.setNotificationView.toggle.isOn = true
            case .denied:
                self.setNotificationView.toggle.isOn = false
            }
        }
        fcmViewModel.checkAndRequestNotificationPermission(vc: self)
    }
    
    private func setupButtonActions() {
        setNotificationView.navigationBar.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        setNotificationView.toggle.addTarget(self, action: #selector(toggleNotificationState), for: .valueChanged)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func toggleNotificationState() {
        switch setNotificationView.toggle.isOn {
        case true: // false -> true로 바뀜
            fcmViewModel.postFCMTokenToServer() { code in
                switch code {
                case .COMMON200:
                    fcmViewModel.defaults.set(true, forKey: K.Key.isNotificationAllowed)
                default :
                    break
                }
            }
        case false: // false로 바뀜
            fcmViewModel.deleteUserFCMToken() { code in
                switch code {
                case .COMMON200:
                    fcmViewModel.defaults.set(false, forKey: K.Key.isNotificationAllowed)
                default :
                    break
                }
            }
            
        }
    }

}


