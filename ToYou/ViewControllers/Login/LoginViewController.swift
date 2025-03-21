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
        print("Apple Login Tapped")
        let provider = ASAuthorizationAppleIDProvider()
        let requset = provider.createRequest()
        requset.requestedScopes = [.fullName, .email,] // 사용자에게 제공받을 정보를 선택 (이름 및 이메일)

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
                loginWithApple(authorizationCode: authCodeString)
                print("authCodeString: \(authCodeString)")
                print("identifyTokenString: \(identifyTokenString)")
            }
        case let passwordCredential as ASPasswordCredential:
            print("passwordCredential: \(passwordCredential)")
            
        default:
            break
        }
    }
}

extension LoginViewController {
    
    func loginWithApple(authorizationCode: String) {
        let tail = "/auth/apple"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "authorizationCode": authorizationCode
        ]
        
        // JSONEncoding 사용하기
        AF.request(url,
                   method: .post,
                   headers: headers)
        .responseDecodable(of: ToYouResponse<AppleLoginResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                if apiResponse.isSuccess {
                    // 기존 가입한 유저가 다시 로그인한 경우
                    if let accessToken = apiResponse.result?.access_token, let refreshToken = apiResponse.result?.refresh_token {
                        // accessToken과 refreshToken을 저장
                        let _ = KeychainService.add(key: K.Key.accessToken, value: accessToken)
                        let _ = KeychainService.add(key: K.Key.refreshToken, value: refreshToken)
                        RootViewControllerService.toBaseViewController()
                    } else { // 처음 로그인한 유저, 가입 절차로 넘어감
                        let policyVC = PolicyAgreementViewController()
                        policyVC.modalPresentationStyle = .overFullScreen
                        self.present(policyVC, animated: false)
                    }
                } else {
                    print("\(tail) send API 오류: \(apiResponse.code) - \(apiResponse.message)")
                }
            case .failure(let error):
                print("\(tail) send 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    struct AppleLoginResult: Codable {
        let access_token: String
        let refresh_token: String
    }
    
}

import SwiftUI
#Preview {
    LoginViewController()
}
