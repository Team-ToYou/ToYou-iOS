//
//  EmotionWarningPopupViewController.swift
//  ToYou
//
//  Created by 김미주 on 7/7/25.
//

import UIKit

class EmotionWarningPopupViewController: UIViewController {
    private let emotionWarningPopupView = ConfirmPopupView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = emotionWarningPopupView
        
        emotionWarningPopupView.configure(title: "감정은 하루에 한 번만\n선택할 수 있어요", confirmText: "확인")
        
        emotionWarningPopupView.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        // 팝오버의 배경뷰에 제스처 추가
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapConfirmButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // popover.frameView 영역을 터치했는지 확인
        if !emotionWarningPopupView.mainFrame.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }

}
