//
//  HomeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    var homeEmotionString = ""
    var cardId: Int?
    let homeView = HomeView()
    
    let notificationVC = NotificationViewController()
    let notificationViewModel = NotificationViewModel() // 생성과 동시에 알림을 가져온다.
    let emotionWarningVC = EmotionWarningPopupViewController()
    
    var delegate: NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true
        
        // 알림 뷰컨 설정
        notificationVC.configure(notificationViewModel, delegate: self)
        setAction()
        getAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAPI()
    }
    
    // MARK: - function
    private func setView(emotionString: String) {
        guard let emotion = Emotion(rawValue: emotionString) else { return }
        
        homeView.commentLabel.text = emotion.emotionExplanation()
        homeView.dateBackView.backgroundColor = emotion.pointColor()
        homeView.emotionImage.image = emotion.emotionBubble()
        homeView.backgroundColor = emotion.pointColor()
    }
    
    private func getAPI() {
        print("HomeAPI")
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        print(accessToken)
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        AF.request("https://to-you.store/users/home", method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: HomeResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    
                    if let emotion = value.result.emotion {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = true
                        self.homeEmotionString = emotion
                        self.cardId = value.result.cardId
                        self.setView(emotionString: emotion)
                    } else {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = false
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    // MARK: - action
    private func setAction() {
        homeView.emotionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionSelect)))
        homeView.mailBoxImage.addTarget(self, action: #selector(diaryCardSelect), for: .touchUpInside)
        homeView.alertButton.addTarget(self, action: #selector(alertSelect), for: .touchUpInside)
        homeView.emotionImage.isUserInteractionEnabled = true
        homeView.mailBoxImage.isUserInteractionEnabled = true
    }
    
    @objc
    private func emotionSelect(sender: UITapGestureRecognizer) {
        if !(homeEmotionString == "") {
            emotionWarningVC.modalPresentationStyle = .overFullScreen
            emotionWarningVC.modalTransitionStyle = .crossDissolve
            self.present(emotionWarningVC, animated: false)
        } else {
            let emotionVC = EmotionViewController()
            emotionVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(emotionVC, animated: true)
        }
    }
    
    @objc
    private func diaryCardSelect(sender: UITapGestureRecognizer) {
        if let id = cardId {
            let previewVC = DiaryCardPreviewController()
            previewVC.emotion = Emotion(rawValue: homeEmotionString) ?? .NORMAL
            previewVC.hidesBottomBarWhenPushed = true
            previewVC.setCardId(id)
            previewVC.isEditMode = true
            self.navigationController?.pushViewController(previewVC, animated: true)
        } else {
            let diaryVC = DiaryCardSelectViewController()
            diaryVC.emotion = Emotion(rawValue: homeEmotionString) ?? .NORMAL
            diaryVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(diaryVC, animated: true)
        }
    }
    
    @objc
    private func alertSelect() {
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
}

extension HomeViewController: NotificationViewControllerDelegate {
    
    func friendRequestAccepted() {
        if let _ = delegate {
            self.delegate?.friendRequestAccepted()
        }
    }
    
    func configure(delegate: NotificationViewControllerDelegate) {
        self.delegate = delegate
    }
        
}
