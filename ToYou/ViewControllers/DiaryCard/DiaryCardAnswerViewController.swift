//
//  DiaryCardAnswerViewController.swift
//  ToYou
//
//  Created by 김미주 on 18/03/2025.
//

import UIKit

class DiaryCardAnswerViewController: UIViewController {
    let diaryCardAnswerView = DiaryCardAnswerView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardAnswerView
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardAnswerView.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
