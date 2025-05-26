//
//  LogoutPopupVC.swift
//  ToYou
//
//  Created by 이승준 on 2/24/25.
//

import UIKit
import Alamofire

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
        
        FCMTokenApiService.delete { code in
            if code == .COMMON200 { // 삭제 성공
                
            } else { // FCM 토큰 삭제 실패
                return // 함수를 종료하고 실채했다는 메시지를 띄워야 한다
            }
        }
        
        let url = K.URLString.baseURL + "/auth/logout/apple"
        guard let refreshToken = KeychainService.get(key: K.Key.refreshToken) else { return }
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer " + refreshToken,
            "Content-Type": "application/json"
        ]
        AF.request(
            url,
            method: .post,
            headers: headers
        ).responseDecodable(of: ToYouResponse<EmptyResult>.self) { response in
            switch response.result {
            case .success(_):
                self.dismiss(animated: true, completion: nil)
                RootViewControllerService.toLoginViewController()
                let _ = KeychainService.deleteAll()
            case .failure(let error):
                print("\(url) post 요청 실패: \(error.localizedDescription)")
            }
        }
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
