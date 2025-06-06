//
//  ChangeRootVC.swift
//  ToYou
//
//  Created by 이승준 on 2/28/25.
//

import UIKit

class RootViewControllerService {
    private static let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    
    static func toBaseViewController() {
        sceneDelegate?.changeRootViewController(BaseViewController(), animated: false)
    }
    
    static func toLoginViewController() {
        sceneDelegate?.changeRootViewController(LoginViewController(), animated: false)
    }
    
    static func toSignUpViewController() {
        sceneDelegate?.changeRootViewController(PolicyAgreementViewController(), animated: false)
    }
    
    static func toTutorialViewController() {
        sceneDelegate?.changeRootViewController(TutorialViewController(), animated: false)
    }
}
