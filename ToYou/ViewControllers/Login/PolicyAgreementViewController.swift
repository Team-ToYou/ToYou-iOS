//
//  SignInCheckBoxViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class PolicyAgreementViewController: UIViewController {
    
    let policyAgreementView = PolicyAgreementView()
    
    let policyLinkWebVC = PrivacyPolicyWebVC()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = policyAgreementView
        self.navigationController?.isNavigationBarHidden = true
        self.setButtonActions()
        policyLinkWebVC.modalPresentationStyle = .overFullScreen
    }
    
}

extension PolicyAgreementViewController {
    func setButtonActions() {
        policyAgreementView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        policyAgreementView.nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        policyAgreementView.agreeAllButton.addTarget(self, action: #selector(agreeAllPressed), for: .touchUpInside)
        policyAgreementView.over14Button.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.policyAgreeButton.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.privacyAgreeButton.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.goTermsOfUse.addTarget(self, action: #selector(goToPolicyWebView(_ :)), for: .touchUpInside)
        policyAgreementView.goPrivacyDetail.addTarget(self, action: #selector(goToPolicyWebView(_ :)), for: .touchUpInside)
    }
    
    @objc
    private func agreeAllPressed() {
        if policyAgreementView.agreeAllButton.isChecked {
            policyAgreementView.agreeAllButton.toggle()
            policyAgreementView.over14Button.notChecked()
            policyAgreementView.policyAgreeButton.notChecked()
            policyAgreementView.privacyAgreeButton.notChecked()
        } else {
            policyAgreementView.agreeAllButton.toggle()
            policyAgreementView.over14Button.checked()
            policyAgreementView.policyAgreeButton.checked()
            policyAgreementView.privacyAgreeButton.checked()
        }
        isAllchecked()
    }
    
    @objc
    private func checkBoxPressed(_ sender: CheckBoxButton) {
        if sender.isMarked() {
            sender.notChecked()
        } else {
            sender.checked()
        }
        isAllchecked()
    }
    
    @objc
    private func goToPolicyWebView(_ sender: UIButton) {
        policyLinkWebVC.modalPresentationStyle = .popover
        present(policyLinkWebVC, animated: true)
    }
    
    private func isAllchecked()  {
        if policyAgreementView.over14Button.isMarked() &&
        policyAgreementView.policyAgreeButton.isMarked() &&
            policyAgreementView.privacyAgreeButton.isMarked()
        {
            policyAgreementView.nextButton.available()
            policyAgreementView.agreeAllButton.checked()
        } else {
            policyAgreementView.nextButton.unavailable()
            policyAgreementView.agreeAllButton.notChecked()
        }
    }
    
    @objc
    private func goToNext() {
        let nickNameVC = NicknameViewController()
        nickNameVC.modalPresentationStyle = .overFullScreen
        present(nickNameVC, animated: false)
    }
    
    @objc
    private func popStack() {
        dismiss(animated: false)
    }
}
