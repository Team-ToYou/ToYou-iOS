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
    }
}
