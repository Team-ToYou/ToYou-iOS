//
//  LoginViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    private let loginView = LoginView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = loginView
    }
    
    private func buttonSetup() {
        
    }
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
