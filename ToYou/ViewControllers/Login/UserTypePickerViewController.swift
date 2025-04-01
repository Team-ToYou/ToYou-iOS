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
    private var isMarketingAgreementChecked: Bool = true
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
    public func configure(checked: Bool, userNickname: String ) {
        self.isMarketingAgreementChecked = checked
        self.userNickname = userNickname
    }
    
    @objc
    private func signUp() {
        let tail = "/auth/signup/apple"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "adConsent": isMarketingAgreementChecked,
            "nickname": userNickname,
            "status": selectedType!.rawValueForAPI()
        ]
        
        // Debugging: Generate and print curl command
        print(generateCurlCommand(url: url, headers: headers, parameters: parameters))
        
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: ToYouResponseWithoutResult.self) { response in
            switch response.result {
            case .success(let response):
                print(response.message)
                RootViewControllerService.toBaseViewController()
            case .failure(let error):
                print(response)
                print("\(url) post 요청 실패: \(error.localizedDescription)")
            }
        }
        .responseDecodable(of: ToYou400ErrorResponse.self) { response in
            switch response.result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    // Function to generate a curl command for debugging
    private func generateCurlCommand(url: String, headers: HTTPHeaders, parameters: [String: Any]) -> String {
        var curlCommand = "curl -X POST \\\n '\(url)'"
        
        // Add headers to the curl command
        for data in headers {
            curlCommand += " \\\n  -H '\(data.name): \(data.value)'"
        }
        
        // Add JSON-encoded parameters to the curl command
        if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            curlCommand += " \\\n  -d '\(jsonString)'"
        }
        
        return curlCommand
    }
}

import SwiftUI
#Preview {
    UserTypePickerViewController()
}
