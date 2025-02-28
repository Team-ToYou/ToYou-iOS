//
//  DeleteFriendPopupVC.swift
//  ToYou
//
//  Created by 이승준 on 2/28/25.
//

import UIKit

class DisconnectFriendPopupVC: UIViewController {
    
    var completionHandler: ((Bool) -> Void)?
    
    private let deleteFriendPopupView = BinarySelectionPopupView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = deleteFriendPopupView
        deleteFriendPopupView.leftConfirmButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        deleteFriendPopupView.rightConfirmButton.addTarget(self, action: #selector(deleteFriend), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        // 팝오버의 배경뷰에 제스처 추가
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc
    private func deleteFriend() {
        completionHandler?(true)
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func popView() {
        completionHandler?(false)
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        // popover.frameView 영역을 터치했는지 확인
        if !deleteFriendPopupView.mainFrame.frame.contains(location) {
            completionHandler?(false)
            dismiss(animated: false, completion: nil)
        }
    }

    
}
