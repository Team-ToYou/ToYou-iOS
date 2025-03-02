//
//  SendQueryViewController.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class SendQueryViewController: UIViewController {
    
    private let sendQueryView = SendQueryView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = sendQueryView
        setButtonAction()
    }
    
    private func setButtonAction() {
        sendQueryView.popUpViewButton.addTarget(self, action: #selector(popupVC), for: .touchUpInside)
        sendQueryView.checkBoxButton.addTarget(self, action: #selector(toggleCheckbox(_ :)), for: .touchUpInside)
        sendQueryView.confirmButton.addTarget(self, action: #selector(sendQuery), for: .touchUpInside)
    }
    
    @objc
    private func popupVC() {
        dismiss(animated: false, completion: nil)
    }
    
    @objc
    private func toggleCheckbox(_ sender: CheckBoxButtonVer02) {
        sender.toggle()
    }
    
    @objc
    private func sendQuery() {
        
        let tempVC = CompleteToSendQueryVC()
        tempVC.modalPresentationStyle = .overFullScreen
        
        present(tempVC, animated: false) {
            // 1초 후 실행
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                // 모든 모달 뷰 컨트롤러 닫기
                self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
            }
        }
    }
    
}

import SwiftUI
#Preview{
    SendQueryViewController()
}
