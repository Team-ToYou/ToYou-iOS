//
//  BaseViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

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
