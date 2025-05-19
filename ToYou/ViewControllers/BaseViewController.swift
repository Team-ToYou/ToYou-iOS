//
//  BaseViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Firebase
import Alamofire

class CustomTabBar: UITabBar {
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = 68
        return size
    }
}

class BaseViewController: UITabBarController {
    
    let homeVC = UINavigationController(rootViewController: HomeViewController())
    
    let friendsVC = FriendsViewController()
    
    let calendarVC = CalendarViewController()

    let myPageVC = MyPageViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarItems()
        setupTabBar()
        self.viewControllers = [homeVC, friendsVC, calendarVC, myPageVC]
        
        // 파이어베이스 Meesaging 설정
        Messaging.messaging().delegate = self
    }
    
    override func loadView() {
        super.loadView()
        setValue(CustomTabBar(), forKey: "tabBar")
    }
    
    private func setupTabBarItems() {
        let size: CGFloat = 1.75
        let iconSizeForHome = CGSize(width: 12 * size, height: 12 * size)
        let iconSize = CGSize(width: 15 * size, height: 15 * size)
        let iconSizeForMyPage = CGSize(width: 16 * size, height: 16 * size)
        
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        homeVC.tabBarItem = createTabBarItem(title: "", image: .home, tag: 0, size: iconSizeForHome, insets: insets)
        friendsVC.tabBarItem = createTabBarItem(title: "", image: .pencil, tag: 1, size: iconSize, insets: insets)
        calendarVC.tabBarItem = createTabBarItem(title: "", image: .calendar, tag: 2, size: iconSize, insets: insets)
        myPageVC.tabBarItem = createTabBarItem(title: "", image: .user, tag: 3, size: iconSizeForMyPage, insets: insets)
    }
    
    private func createTabBarItem(title: String, image: UIImage, tag: Int, size: CGSize, insets: UIEdgeInsets) -> UITabBarItem {
        let resizedImage = image.withRenderingMode(.alwaysOriginal)
            .resizableImage(withCapInsets: .zero, resizingMode: .stretch)
            .resized(to: size)
        
        let tabBarItem = UITabBarItem(title: title, image: resizedImage, tag: tag)
        tabBarItem.imageInsets = insets
        return tabBarItem
    }
    
    private func setupTabBar() {
        // 선택 아이템 색상
        tabBar.tintColor = .black04
        tabBar.unselectedItemTintColor = .gray00
        
        // 배경 색상
        tabBar.backgroundColor = .white
        
        // 테두리
        tabBar.layer.borderWidth = 1.07
        tabBar.layer.borderColor = UIColor.background.cgColor
    }
    
}

extension BaseViewController : MessagingDelegate {
    // 토큰의 갱신이 일어났을 때, 호출되는 함수
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let fcmToken = fcmToken {
            var method:  HTTPMethod = .post
            if let _ = KeychainService.get(key: K.Key.fcmToken) { // FCM 토큰이 저장 되어 있는 경우
                method = .patch
            }
            FCMTokenApiService.uploadFCMTokenToServer(mode: method, fcmToken) { code in
                switch code {
                case .COMMON200: // FCM 토큰 로컬에 저장
                    let _ = KeychainService.add(key: K.Key.fcmToken, value: fcmToken)
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

extension UIImage {
    func resized(to size: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { _ in
            draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

import SwiftUI
#Preview {
    BaseViewController()
}
