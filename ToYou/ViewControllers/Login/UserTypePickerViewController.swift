//
//  UserTypePickerViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit

class UserTypePickerViewController: UIViewController {

    let userTypePiverView = UserTypePickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = userTypePiverView
        self.navigationController?.isNavigationBarHidden = true
        self.setButtonActions()
    }
    
    func setButtonActions() {
        userTypePiverView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
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
            } else {
                btn.notSelectedView()
            }
        }
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
}

import SwiftUI
#Preview {
    UserTypePickerViewController()
}
