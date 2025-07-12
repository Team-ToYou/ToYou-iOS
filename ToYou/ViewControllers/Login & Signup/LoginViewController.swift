//
//  LoginViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import AuthenticationServices
import Alamofire

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
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.fullName,] // 사용자에게 제공받을 정보를 선택 (이름 및 이메일)
        
        let controller = ASAuthorizationController(authorizationRequests: [requset])
        controller.delegate = self                    // 로그인 정보 관련 대리자 설정
        controller.presentationContextProvider = self // 인증창을 보여주기 위해 대리자 설정
        controller.performRequests()                  // 로그인창 띄우기
    }
    
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let _ = String(data: identityToken, encoding: .utf8) {
                AuthAPIService.loginWithApple(authorizationCode: authCodeString) { result in
                    switch result {
                    case true:
                        AuthAPIService.isUserFinishedSignUp() { code in
                            switch code {
                            case .finished:
                                //로그인 성공
                                
                                RootViewControllerService.toBaseViewController()
                            case .notFinished:
                                RootViewControllerService.toSignUpViewController()
                            case .expired:
                                RootViewControllerService.toLoginViewController()
                            case .error:
                                break
                            }
                        }
                    case false:
                        print("로그인 실패")
                        break
                    }
                }
            }
        case let passwordCredential as ASPasswordCredential:
            print("passwordCredential: \(passwordCredential)")
        default:
            break
        }
    }
}
