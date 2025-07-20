//
//  EditProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit
import Alamofire
import Combine

class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    var refreshMyPage: ((String) -> Void)?
    var cancellables: [AnyCancellable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
        self.navigationController?.navigationBar.isHidden = true
        
        self.editProfileView.nicknameTextField.delegate = self
        self.editProfileView.scrollView.delegate = self
        
        self.setbasicButtonActions()
        self.setNicknameActions()
        self.setUserTypeButtonActions()
        self.hideKeyboardWhenTappedAround()
        
        self.subscribe()
        editProfileView.configure(result: UserViewModel.userInfo!)
    }
    
    func subscribe() {
        UserViewModel.defaultMode()
        UserViewModel.$isChangeable
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isChangeable in
                switch isChangeable {
                case true:
                    self?.editProfileView.completeButton.available()
                case false:
                    self?.editProfileView.completeButton.unavailable()
                }
            }
            .store(in: &cancellables)
        UserViewModel.$userInfo
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                if let userInfo = userInfo {
                    self?.editProfileView.configure(result: userInfo)
                }
            }
            .store(in: &cancellables)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editProfileView.setConstraints()
    }
    
}

// MARK: Confirm Button Actions
extension EditProfileViewController {
    private func setbasicButtonActions() {
        editProfileView.navigationBar.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        editProfileView.completeButton.addTarget(self, action: #selector(comfirmChange), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func comfirmChange() {
        UserViewModel.userInfo!.nickname = UserViewModel.newNickName
        UserViewModel.updateUserInfo()
        UserViewModel.defaultMode()
        self.navigationController?.popViewController(animated: true)
    }
    
}

// MARK: Nickname Editing
extension EditProfileViewController {
    
    private func setNicknameActions() {
        editProfileView.navigationBar.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
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
        checkNicknameValidation()
    }
    
    private func checkNicknameValidation() {
        UserViewModel.checkNickNameAvailability(self.editProfileView.nicknameTextField.text!) { response in
            switch response {
            case .available:
                self.editProfileView.satisfiedNickname()
            case .unavailable:
                self.editProfileView.unsatisfiedNickname()
            }
        }
    }
    
}

// MARK: Nickname 완료 버튼 -> 중복 호출
extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.checkNicknameValidation()
        editProfileView.nicknameTextField.resignFirstResponder()
        return true
    }
}

// MARK: Change New User Type
extension EditProfileViewController {
    
    func setUserTypeButtonActions() {
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
                UserViewModel.changeUserType(to: sender.returnUserType())
            } else {
                btn.notSelectedView()
            }
        }
    }
}

extension EditProfileViewController: UIScrollViewDelegate {
    
}

import SwiftUI
#Preview {
    EditProfileViewController()
}
