//
//  revokePopupVC.swift
//  ToYou
//
//  Created by 이승준 on 2/24/25.
//

import UIKit

class RevokePopupVC: UIViewController {

    private let revokePopupView = BinarySelectionWithMessagePopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = revokePopupView
        revokePopupView.configure(mainTitle: "정말 탈퇴하시겠습니까?",
                                  subTitle: "작성하신 일기카드가 모두\n삭제되며 복구할 수 없어요",
                                  leftConfirmText: "탈퇴하기", leftTextColor: .red02,
                                  rightConfirmText: "취소", rightTextColor: .black04)
        revokePopupView.leftConfirmButton.addTarget(self, action: #selector(revoke), for: .touchUpInside)
        revokePopupView.rightConfirmButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        // 팝오버의 배경뷰에 제스처 추가
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func revoke() {
        // 회원탈퇴 동작
    }
    
    @objc
    private func popView() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // popover.frameView 영역을 터치했는지 확인
        if !revokePopupView.mainFrame.frame.contains(location) {
            dismiss(animated: true, completion: nil)
        }
    }
}
