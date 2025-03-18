//
//  LoginViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import AuthenticationServices

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
        print("Apple Login Tapped")
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.fullName, .email,] // 사용자에게 제공받을 정보를 선택 (이름 및 이메일)

        let controller = ASAuthorizationController(authorizationRequests: [requset])
        controller.delegate = self                    // 로그인 정보 관련 대리자 설정
        controller.presentationContextProvider = self // 인증창을 보여주기 위해 대리자 설정
        controller.performRequests()                  // 로그인창 띄우기
    }
    
    private func signupVC() {
        let signupVC = PolicyAgreementViewController()
        signupVC.modalPresentationStyle = .overFullScreen
        present(signupVC, animated: false)
        stackView()
    }
    
    private func stackView() {
        let stackVC = PolicyAgreementViewController()
        stackVC.modalPresentationStyle = .overFullScreen
        present(stackVC, animated: false)
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                print("authorizationCode: \(authorizationCode)")
                print("identityToken: \(identityToken)")
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
            
            print("useridentifier: \(userIdentifier)")
            print("fullName: \(fullName)")
            print("email: \(email)")
            
            // 첫 회원일 시, 회원가입 화면으로 이동
            signupVC()
            
            // 기존 유저일 시, 홈화면으로 이동
            // RootViewControllerService.toBaseViewController()
            
        case let passwordCredential as ASPasswordCredential:
            print("passwordCredential: \(passwordCredential)")
            
        default:
            break
        }
    }
    
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
