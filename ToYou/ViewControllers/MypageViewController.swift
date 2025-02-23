//
//  ProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class MyPageViewController: UIViewController {
    
    let myPageView = MyPageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = myPageView
    }
    
    
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
