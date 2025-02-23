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
        buttonSetup()
    }
    
    private func buttonSetup() {
        loginView.appleLoginView.addTarget(self, action: #selector(signinApple), for: .touchUpInside)
    }
    
    @objc
    private func signinApple() {
        print("Sign in with Apple Pressed")
        stackView()
    }
    
    private func stackView() {
        let stackView = PolicyAgreementViewController()
        navigationController?.pushViewController(stackView, animated: true)
    }
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
