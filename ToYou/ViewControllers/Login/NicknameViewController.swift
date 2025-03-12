//
//  NicknameViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class NicknameViewController: UIViewController {
    
    let nicknameView = NicknameView()
    
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
        nicknameView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
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
        if true {
            nicknameView.satisfiedNickname()
        } else {
            nicknameView.unsatisfiedNickname()
        }
    }
    
    @objc
    private func stackView() {
        let stackVC = UserTypePickerViewController()
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
    
}

import SwiftUI
#Preview{
    NicknameViewController()
}
