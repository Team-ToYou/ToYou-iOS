//
//  SetNotificationViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit

class SetNotificationViewController: UIViewController {
    
    private let setNotificationView = SetNotificationView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = setNotificationView
        self.setupButtonActions()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setupButtonActions() {
        setNotificationView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false, completion: nil)
    }

}


