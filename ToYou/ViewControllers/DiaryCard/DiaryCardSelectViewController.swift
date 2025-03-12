//
//  DiaryCardSelectViewController.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class DiaryCardSelectViewController: UIViewController {
    let diaryCardSelectView = DiaryCardSelectView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardSelectView
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardSelectView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }

}
