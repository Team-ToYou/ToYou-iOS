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
        size.height = 94
        return size
    }
}

class BaseViewController: UITabBarController {
    private lazy var homeVC = HomeViewController()
    private lazy var letterComposeVC = LetterComposeViewController()
    private lazy var calendarVC = CalendarViewController()
    private lazy var profileVC = ProfileViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBarItems()
        setupTabBar()
        
        self.viewControllers = [homeVC, letterComposeVC, calendarVC, profileVC]
    }
    
    override func loadView() {
        super.loadView()
        setValue(CustomTabBar(), forKey: "tabBar")
    }
    
    private func setupTabBarItems() {
        let iconSize = CGSize(width: 24, height: 24)
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        homeVC.tabBarItem = createTabBarItem(title: "", image: .homeIcon, tag: 0, size: iconSize, insets: insets)
        letterComposeVC.tabBarItem = createTabBarItem(title: "", image: .pencilLineIcon, tag: 1, size: iconSize, insets: insets)
        calendarVC.tabBarItem = createTabBarItem(title: "", image: .calendarIcon, tag: 2, size: iconSize, insets: insets)
        profileVC.tabBarItem = createTabBarItem(title: "", image: .profileIcon, tag: 3, size: iconSize, insets: insets)
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
