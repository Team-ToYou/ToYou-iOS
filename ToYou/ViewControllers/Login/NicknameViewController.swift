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
    
    func setButtonActions() {
        nicknameView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
}
