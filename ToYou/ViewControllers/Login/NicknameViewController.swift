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
    }
    
}

//MARK: Set Button Actions
extension NicknameViewController {
    
    private func setButtonActions() {
        nicknameView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        nicknameView.nicknameTextField.addTarget(self, action: #selector(textFieldDidChanacge(_ :)), for: .editingChanged)
        nicknameView.overlappedCheck.addTarget(self, action: #selector(checkOverlapped), for: .touchUpInside)
    }
    
    @objc
    private func textFieldDidChanacge(_ sender: UITextField) {
        if let textCount = sender.text?.count {
            if textCount == 0 {
                nicknameView.defaultState()
            } else if textCount < 16 {
                nicknameView.properTextLength()
            }else {
                nicknameView.textLengthWarning()
            }
            nicknameView.maxTextLength.text = "(\(textCount)/15)"
        } else {
            nicknameView.defaultState()
        }
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func checkOverlapped() {
        if true {
            nicknameView.satisfiedNickname()
        } else {
            nicknameView.unsatisfiedNickname()
        }
    }

}

import SwiftUI
#Preview{
    NicknameViewController()
}
