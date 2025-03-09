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
        stackView()
    }
    
    private func stackView() {
        let stackVC = PolicyAgreementViewController()
        stackVC.modalPresentationStyle = .overFullScreen
        present(stackVC, animated: false)
    }
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
