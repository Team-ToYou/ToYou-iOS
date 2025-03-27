//
//  UserTypePickerViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit
import Alamofire

class UserTypePickerViewController: UIViewController {

    private let userTypePiverView = UserTypePickerView()
    private var isMarketingAgreementChecked: Bool = false
    private var userNickname: String = ""
    private var appleAuth: String = ""
    private var selectedType: UserType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = userTypePiverView
        self.navigationController?.isNavigationBarHidden = true
        self.setButtonActions()
    }
    
}

//MARK: Button Actions
extension UserTypePickerViewController {
    func setButtonActions() {
        userTypePiverView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        userTypePiverView.nextButton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        let buttons = [
            userTypePiverView.studentButton,
            userTypePiverView.collegeButton,
            userTypePiverView.workerButton,
            userTypePiverView.ectButton
        ]
        for btn in buttons {
            btn.addTarget(self, action: #selector(selectUserType(_ :)), for: .touchUpInside)
        }
    }
    
    @objc
    private func selectUserType(_ sender: UserTypeButton) {
        let buttons = [
            userTypePiverView.studentButton,
            userTypePiverView.collegeButton,
            userTypePiverView.workerButton,
            userTypePiverView.ectButton
        ]
        
        for btn in buttons {
            if btn == sender {
                btn.selectedView()
                userTypePiverView.nextButton.available()
                self.selectedType = btn.returnUserType()
            } else {
                btn.notSelectedView()
            }
        }
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false)
    }

}

//MARK: API
extension UserTypePickerViewController {
    // 이전 뷰컨에서 정보를 받아옴
    public func configure(appleAuth: String, checked: Bool, userNickname: String ) {
        self.appleAuth = appleAuth
        self.isMarketingAgreementChecked = checked
        self.userNickname = userNickname
    }
    
    @objc
    private func signUp() {
        let tail = "/auth/signup/apple"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "authorizationCode": appleAuth,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "adConsent": isMarketingAgreementChecked,
            "nickname": userNickname,
            "status": selectedType!.rawValueForAPI()
        ]
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            headers: headers
        )
        // .validate(statusCode: 200..<300)
        .responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(let apiResponse):
                
            case .failure(let error):
                print("\(url) post 요청 실패: \(error.localizedDescription)")
            }
        }
        .responseDecodable(of: ToYouErrorResponse.self) { response in
            switch response.result {
            case .success(let response):
                print("\(response)")
            case .failure(let error):
                print("\(url) post 요청 실패: \(error.localizedDescription)")
            }
        }
        
        struct EmptyResult: Codable {
            
        }
    }
    
}

import SwiftUI
#Preview {
    UserTypePickerViewController()
}
