//
//  EditProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit
import Alamofire

class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    var myPageInfo: MyPageResult?
    var refreshMyPage: ((String) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
        
        self.editProfileView.nicknameTextField.delegate = self
        self.editProfileView.scrollView.delegate = self
        
        self.setbasicButtonActions()
        self.setNicknameActions()
        self.setUserTypeButtonActions()
        self.hideKeyboardWhenTappedAround()
    }
    
    public func configure(myPageInfo: MyPageResult) {
        self.myPageInfo = myPageInfo
        editProfileView.configure(result: myPageInfo)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editProfileView.setConstraints()
    }
    
}

// MARK: Confirm Button Actions
extension EditProfileViewController {
    private func setbasicButtonActions() {
        editProfileView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        editProfileView.completeButton.addTarget(self, action: #selector(comfirmChange), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func comfirmChange() {
        if editProfileView.isNicknameChecked { // 변경된 닉네임이 확인된 경우
            patchNickname()
        }
        if editProfileView.newUserType != editProfileView.originalUserType { // 유저 타입이 다른 경우
            patchUerType()
        }
    }
    
    private func patchNickname() {
        let tail = "/users/nickname"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "nickname": editProfileView.newNickname!
        ]
        URLSession.generateCurlCommand(url: url, method: .patch, headers: headers, parameters: parameters)
        AF.request(
            url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: ToYouResponseWithoutResult.self) { response in
            switch response.result {
            case .success(_):
                self.refreshMyPage?(self.editProfileView.newNickname!)
                self.editProfileView.updatedNickname()
                self.editProfileView.resetNickname()
                self.editProfileView.completeButton.unavailable()
            case .failure(let error):
                print("\(url) patch 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
    private func patchUerType() {
        let tail = "/users/status"
        let url = K.URLString.baseURL + tail
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + accessToken,
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "status": editProfileView.newUserType!.rawValueForAPI()
        ]
        URLSession.generateCurlCommand(url: url, method: .patch, headers: headers, parameters: parameters)
        AF.request(
            url,
            method: .patch,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers
        )
        .responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(_):
                self.editProfileView.resetUserType()
                self.editProfileView.completeButton.unavailable()
                self.editProfileView.updateNewUserType()
            case .failure(let error):
                print("\(url) patch 요청 실패: \(error.localizedDescription)")
            }
        }

    }
    
}

// MARK: Nickname Editing
extension EditProfileViewController {
    
    private func setNicknameActions() {
        editProfileView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        editProfileView.overlappedCheck.addTarget(self, action: #selector(checkOverlappedPressed), for: .touchUpInside)
    }
    
    @objc
    private func textFieldDidChanged(_ sender: UITextField) {
        editProfileView.isNicknameChecked = false
        if let textCount = sender.text?.count {
            if textCount == 0 {
                editProfileView.defaultState()
            } else if textCount < 16 {
                editProfileView.properTextLength()
            } else {
                editProfileView.textLengthWarning()
            }
            editProfileView.maxTextLength.text = "(\(textCount)/15)"
        } else { // text == nil
            editProfileView.defaultState()
        }
    }
    
    @objc
    private func checkOverlappedPressed() { // 중복 확인
        checkOverlapped()
        editProfileView.checkAnyInfoChanged()
    }
    
    private func checkOverlapped() {
        let tail = "/users/nickname/check"
        let url = K.URLString.baseURL + tail + "?nickname=\(editProfileView.nicknameTextField.text!)"
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
                    self.editProfileView.unsatisfiedNickname()
                    self.editProfileView.isNicknameChecked = false
                } else {
                    self.editProfileView.satisfiedNickname()
                    self.editProfileView.isNicknameChecked = true
                    self.editProfileView.newNickname = self.editProfileView.nicknameTextField.text
                }
            case .failure(let error):
                print("\(url) get 요청 실패: \(error.localizedDescription)")
            }
        }
    }
    
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkOverlapped()
        editProfileView.checkAnyInfoChanged()
        editProfileView.nicknameTextField.resignFirstResponder()
        return true
    }
}

// MARK: Change New User Type
extension EditProfileViewController {
    
    func setUserTypeButtonActions() {
        editProfileView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        let buttons = [
            editProfileView.studentButton,
            editProfileView.collegeButton,
            editProfileView.workerButton,
            editProfileView.etcButton
        ]
        for btn in buttons {
            btn.addTarget(self, action: #selector(selectUserType(_ :)), for: .touchUpInside)
        }
    }
    
    @objc
    private func selectUserType(_ sender: UserTypeButton) {
        let buttons = [
            editProfileView.studentButton,
            editProfileView.collegeButton,
            editProfileView.workerButton,
            editProfileView.etcButton
        ]
        for btn in buttons {
            if btn == sender {
                btn.selectedView()
                editProfileView.newUserType = sender.returnUserType()
            } else {
                btn.notSelectedView()
            }
        }
        editProfileView.checkAnyInfoChanged()
    }
}

extension EditProfileViewController: UIScrollViewDelegate {
    
}

import SwiftUI
#Preview {
    EditProfileViewController()
}
