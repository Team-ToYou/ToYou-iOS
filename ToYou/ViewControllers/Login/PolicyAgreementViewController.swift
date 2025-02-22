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
    
    
}

extension PolicyAgreementViewController {
    func setButtonActions() {
        policyAgreementView.popUpViewButton.addTarget(self, action: #selector(popStack), for: .touchUpInside)
        policyAgreementView.nextButton.addTarget(self, action: #selector(goToNext), for: .touchUpInside)
        policyAgreementView.agreeAllButton.addTarget(self, action: #selector(agreeAllPressed), for: .touchUpInside)
        policyAgreementView.over14Button.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.policyAgreeButton.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.privacyAgreeButton.addTarget(self, action: #selector(checkBoxPressed(_ :)), for: .touchUpInside)
        policyAgreementView.goPolicyDetail.addTarget(self, action: #selector(goPolicyDetailPressed(_ :)), for: .touchUpInside)
        policyAgreementView.goPrivacyDetail.addTarget(self, action: #selector(goPrivacyDetailPressed(_ :)), for: .touchUpInside)
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
    private func goPolicyDetailPressed(_ sender: UIButton) {
        print("goPolicyDetailPressed")
    }
    
    @objc
    private func goPrivacyDetailPressed(_ sender: UIButton) {
        print("goPrivacyDetailPressed")
    }
    
    private func isAllchecked()  {
        if policyAgreementView.over14Button.isMarked() &&
        policyAgreementView.policyAgreeButton.isMarked() &&
            policyAgreementView.privacyAgreeButton.isMarked()
        {
            policyAgreementView.nextButton.isEnable(true)
            policyAgreementView.agreeAllButton.checked()
        } else {
            policyAgreementView.nextButton.isEnable(false)
            policyAgreementView.agreeAllButton.notChecked()
        }
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
