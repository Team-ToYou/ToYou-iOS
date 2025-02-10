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
        self.setButtonActions()
    }
    
    func setButtonActions() {
        userTypePiverView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
}
