//
//  DiaryCardPreviewController.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit

class DiaryCardPreviewController: UIViewController {
    let diaryCardPreview = DiaryCardPreview()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardPreview
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardPreview.backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
