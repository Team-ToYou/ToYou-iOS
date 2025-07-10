//
//  NicknameViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit
import Alamofire

class NicknameViewController: UIViewController {
    
    private let nicknameView = NicknameView()
    private var isMarketingAgreementChecked: Bool = true
    private var appleAuth: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = nicknameView
        self.setButtonActions()
        self.nicknameView.nicknameTextField.delegate = self
        self.nicknameView.nicknameTextField.becomeFirstResponder()
        hideKeyboardWhenTappedAround()
    }
    
}

//MARK: Set Button Actions
extension NicknameViewController {
    
    private func setButtonActions() {
        nicknameView.navigationBar.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        nicknameView.overlappedCheck.addTarget(self, action: #selector(checkOverlapped), for: .touchUpInside)
        nicknameView.nextButton.addTarget(self, action: #selector(stackView), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false)
    }
    
    @objc
    private func textFieldDidChanged(_ sender: UITextField) {
        if let textCount = sender.text?.count {
            if textCount == 0 {
                nicknameView.defaultState()
            } else if textCount < 16 {
                nicknameView.properTextLength()
            } else {
                nicknameView.textLengthWarning()
            }
            nicknameView.maxTextLength.text = "(\(textCount)/15)"
        } else {
            nicknameView.defaultState()
        }
    }
    
    @objc
    private func checkOverlapped() {
        let tail = "/users/nickname/check"
        let url = K.URLString.baseURL + tail + "?nickname=\(nicknameView.nicknameTextField.text!)"
        let headers: HTTPHeaders = [
            "accept": "*/*",
        ]
        AF.request(
            url,
            method: .get,
            headers: headers
        )
        .responseDecodable(of: ToYouResponse<NicknameCheckResult>.self) { response in
            switch response.result {
            case .success(_):
                if response.value!.result!.exists { // true => 사용 불가능한 닉네임
                    self.nicknameView.unsatisfiedNickname()
                } else {
                    self.nicknameView.satisfiedNickname()
                }
            case .failure(let error):
                print("\(url) get 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    @objc
    private func stackView() {
        let stackVC = UserTypePickerViewController()
        stackVC.configure(checked: isMarketingAgreementChecked, userNickname: nicknameView.nicknameTextField.text!)
        stackVC.modalPresentationStyle = .overFullScreen
        present(stackVC, animated: false)
    }
    
}

extension NicknameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 중복확인 API 연결
        nicknameView.nicknameTextField.resignFirstResponder()
        return true
    }
    
    func configure(check: Bool) {
        isMarketingAgreementChecked = check
    }
    
}

import SwiftUI
#Preview{
    NicknameViewController()
}
