//
//  EmotionViewController.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

class EmotionViewController: UIViewController {
    let emotionView = EmotionView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emotionView
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        emotionView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
