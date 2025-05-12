//
//  MaxLengthWarningPopUpVC.swift
//  ToYou
//
//  Created by 이승준 on 5/12/25.
//

import UIKit

class MaxLengthWarningPopUpVC: UIViewController {
    
    private let maxLengthWarningView = ConfirmPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = maxLengthWarningView
        maxLengthWarningView.configure(title: "작성 가능한 글자\n수를 초과 하셨습니다.", confirmText: "확인")
        maxLengthWarningView.confirmButton.addTarget(self, action: #selector(didTapConfirmButton), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        // 팝오버의 배경뷰에 제스처 추가
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func didTapConfirmButton() {
        self.dismiss(animated: true)
    }
    
    @objc
    private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // popover.frameView 영역을 터치했는지 확인
        if !maxLengthWarningView.mainFrame.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
    
}
