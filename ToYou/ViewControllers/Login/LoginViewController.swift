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
        //로그인 성공
        switch authorization.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            // You can create an account in your system.
            // let userIdentifier = appleIDCredential.user
            // let fullName = appleIDCredential.fullName
            // let email = appleIDCredential.email
            
            if  let authorizationCode = appleIDCredential.authorizationCode,
                let identityToken = appleIDCredential.identityToken,
                let authCodeString = String(data: authorizationCode, encoding: .utf8),
                let _ = String(data: identityToken, encoding: .utf8) {
                loginWithApple(authorizationCode: authCodeString)
                print("authCodeString: \(authCodeString)")
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
                    if let loginResult = apiResponse.result {
                        print("is New? \(loginResult.isUser)")
                        let accessToken = loginResult.accessToken
                        let refreshToken = loginResult.refreshToken
                        print("accessToken  \(accessToken)")
                        print("refreshToken \(refreshToken)")
                        let _ = KeychainService.add(key: K.Key.accessToken, value: accessToken)
                        let _ = KeychainService.add(key: K.Key.refreshToken, value: refreshToken)
                        if loginResult.isUser!  { // 기존 가입한 유저가 다시 로그인한 경우
                            RootViewControllerService.toBaseViewController()
                        } else { // 처음 로그인한 유저, 가입 절차로 넘어감
                            let policyVC = PolicyAgreementViewController()
                            policyVC.configure(appletAuth: authorizationCode)
                            policyVC.modalPresentationStyle = .overFullScreen
                            self.present(policyVC, animated: false)
                        }
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
        let isUser: Bool?
        let accessToken: String
        let refreshToken: String
    }
    
    
    
}
