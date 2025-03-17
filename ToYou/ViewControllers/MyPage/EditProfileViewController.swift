//
//  EditProfileViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit

class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = editProfileView
        
        self.editProfileView.nicknameTextField.delegate = self
        self.editProfileView.scrollView.delegate = self
        
        self.setbasicButtonActions()
        self.setNicknameActions()
        self.setUserTypeButtonActions()
        self.hideKeyboardWhenTappedAround()
        editProfileView.configure(nickname: "Rudy", userType: .college)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        editProfileView.configure()
    }
    
}

// MARK: Button Actions
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
        print("confirmed")
    }
}

// MARK: Nickname Editing
extension EditProfileViewController {
    
    private func setNicknameActions() {
        editProfileView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChanged(_ :)), for: .editingChanged)
        editProfileView.overlappedCheck.addTarget(self, action: #selector(checkOverlapped), for: .touchUpInside)
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
    private func checkOverlapped() { // 중복 확인
        if true {
            editProfileView.satisfiedNickname()
        } else {
            editProfileView.unsatisfiedNickname()
        }
    }
    
}

extension EditProfileViewController: UIScrollViewDelegate {
    
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // 중복확인 API 연결
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
            editProfileView.ectButton
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
            editProfileView.ectButton
        ]
        
        if editProfileView.isNicknameChecked && editProfileView.returnUserType()! != sender.returnUserType()! {
            editProfileView.completeButton.available()
        }
        
        for btn in buttons {
            if btn == sender {
                btn.selectedView()
            } else {
                btn.notSelectedView()
            }
        }
        
    }

}

import SwiftUI
#Preview {
    EditProfileViewController()
}
