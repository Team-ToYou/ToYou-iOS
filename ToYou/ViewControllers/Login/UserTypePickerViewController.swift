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
        userTypePiverView.nextButton.addTarget(self, action: #selector(changeRootToHomeVC), for: .touchUpInside)
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
    private func changeRootToHomeVC() {
        RootViewControllerService.toBaseViewController()
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
        dismiss(animated: false)
    }

}

//MARK: API
extension UserTypePickerViewController {
    // 이전 뷰컨에서 정보를 받아옴
    public func configure( checked: Bool, userNickname: String ) {
        self.isMarketingAgreementChecked = checked
        self.userNickname = userNickname
    }
    
    private func signUp() {
        
    }
    
}

import SwiftUI
#Preview {
    UserTypePickerViewController()
}
