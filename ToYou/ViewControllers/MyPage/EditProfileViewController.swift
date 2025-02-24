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
        self.setupButtonActions()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupButtonActions() {
        editProfileView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: false)
    }

}
