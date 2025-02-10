//
//  SignInCheckBoxViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class PolicyAgreementViewController: UIViewController {
    
    let policyAgreementView = PolicyAgreementView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = policyAgreementView
        self.navigationController?.isNavigationBarHidden = true
        self.setButtonActions()
    }
    
    func setButtonActions() {
        policyAgreementView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        policyAgreementView.nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
    }
    
    @objc
    private func goToNext() {
        let nickNameVC = NicknameViewController()
        navigationController?.pushViewController(nickNameVC, animated: true)
    }
    
    @objc
    private func popStack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
