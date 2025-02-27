//
//  LogoutPopupVC.swift
//  ToYou
//
//  Created by 이승준 on 2/24/25.
//

import UIKit

class LogoutPopupVC: UIViewController {

    private let logoutPopupView = BinarySelectionPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = logoutPopupView
        logoutPopupView.configure(title: "정말 로그아웃하시겠어요?",
                                  leftConfirmText: "취소", leftTextColor: .black04,
                                  rightConfirmText: "로그아웃", rightTextColor: .red01)
        logoutPopupView.leftConfirmButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        logoutPopupView.rightConfirmButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        // 팝오버의 배경뷰에 제스처 추가
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func logout() {
        // 로그아웃 동작
    }
    
    @objc
    private func popView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // popover.frameView 영역을 터치했는지 확인
        if !logoutPopupView.mainFrame.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
}
