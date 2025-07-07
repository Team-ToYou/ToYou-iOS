//
//  DiaryCardDeletePopupViewController.swift
//  ToYou
//
//  Created by 김미주 on 6/23/25.
//

import UIKit
import Alamofire

class DiaryCardDeletePopupViewController: UIViewController {
    var completionHandler: ((Bool) -> Void)?
    private let diaryCardDeletePopupView = BinarySelectionPopupView()
    
    var cardId: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = diaryCardDeletePopupView
        diaryCardDeletePopupView.configure(title: "정말 일기카드를\n삭제하시겠습니까?",
                                  leftConfirmText: "취소", leftTextColor: .black04,
                                  rightConfirmText: "삭제", rightTextColor: .red01)
        
        setAction()
    }
    
    // MARK: - action
    private func setAction() {
        diaryCardDeletePopupView.leftConfirmButton.addTarget(self, action: #selector(popView), for: .touchUpInside)
        diaryCardDeletePopupView.rightConfirmButton.addTarget(self, action: #selector(deleteDiaryCard), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleGrayAreaTap(_:)))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func deleteDiaryCard() {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let url = "\(K.URLString.baseURL)/diarycards/\(cardId!)"
        let headers: HTTPHeaders = ["Authorization": "Bearer \(accessToken)"]
        
        AF.request(url, method: .delete, headers: headers)
            .validate()
            .responseDecodable(of: DiaryCardDeleteResponse.self) { response in
                switch response.result {
                case .success(let result):
                    if result.isSuccess {
                        print("삭제 성공")
                        self.completionHandler?(true)
                    } else {
                        print("삭제 실패: \(result.message)")
                        self.completionHandler?(false)
                    }
                case .failure(let error):
                    print("네트워크 에러: \(error.localizedDescription)")
                    self.completionHandler?(false)
                }
            }
        
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func popView() {
        completionHandler?(false)
        dismiss(animated: false, completion: nil)
    }
    
    @objc private func handleGrayAreaTap(_ gesture: UITapGestureRecognizer) {
        let location = gesture.location(in: view)
        if !diaryCardDeletePopupView.mainFrame.frame.contains(location) {
            completionHandler?(false)
            dismiss(animated: false, completion: nil)
        }
    }
}
