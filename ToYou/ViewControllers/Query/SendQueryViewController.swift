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
        QueryAPIService.setAnonymous(sender.isChecked)
        // 선택 되었으면 익명, true
    }
    
    @objc
    private func sendQuery() {
        QueryAPIService.postQuestion { code in
            switch code {
            case .COMMON200:
                self.sendSuccess()
                fcmViewModel.sendFCMMessage(to: QueryAPIService.shared.queryParamter.targetId!, requestType: .Query) { code in
                    switch code {
                    case .COMMON200:
                        print("#SendQueryViewController #sendQuery Message Sent Successfully")
                    default :
                        print("#SendQueryViewController sendQuery Message Send Failed Code : \(code)")
                        break
                    }
                }
                QueryAPIService.shared.queryParamter = QueryParameter(targetId: nil, content: nil, questionType: nil, anonymous: nil, answerOptionList: nil)
            case .AUTH400:
                break
            case .USER401:
                break
            case .QUESTION400:
                break
            case .QUESTION401:
                break
            case .ERROR500:
                break
            }
        }
    }
    
    private func sendSuccess() {
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
