//
//  ChangeRootVC.swift
//  ToYou
//
//  Created by 이승준 on 2/28/25.
//

import UIKit

class RootViewControllerService {
    private static let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
    private static var isTransitioning = false
    
    static func toBaseViewController() {
        guard !isTransitioning else { return }
        isTransitioning = true
        DispatchQueue.main.async {
            sceneDelegate?.changeRootViewController(BaseViewController(), animated: false)
            isTransitioning = false
        }
    }
    
    static func toLoginViewController() {
        guard !isTransitioning else { return }
        isTransitioning = true
        DispatchQueue.main.async {
            sceneDelegate?.changeRootViewController(LoginViewController(), animated: false)
            isTransitioning = false
        }
    }
    
    static func toSignUpViewController() {
        guard !isTransitioning else { return }
        isTransitioning = true
        DispatchQueue.main.async {
            sceneDelegate?.changeRootViewController(PolicyAgreementViewController(), animated: false)
            isTransitioning = false
        }
    }
    
    static func toTutorialViewController() {
        guard !isTransitioning else { return }
        isTransitioning = true
        DispatchQueue.main.async {
            sceneDelegate?.changeRootViewController(TutorialViewController(), animated: false)
            isTransitioning = false
        }
    }
}
