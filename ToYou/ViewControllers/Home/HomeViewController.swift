//
//  HomeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    let homeView = HomeView()
    let notificationVC = NotificationViewController()
    
    var delegate: NotificationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true

        setAction()
        getAPI()
        getNotifications() // 알림 정보 가져오기
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAPI()
    }
    
    // MARK: - function
    private func setView(emotion: String) {
        let item = Home.dummy().first { $0.emotion == emotion }
        
        if let item = item {
            homeView.commentLabel.text = item.comment
            homeView.dateBackView.backgroundColor = item.color
            homeView.emotionImage.image = item.bubble
            homeView.backgroundColor = item.color
        }
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
                    
                    let emotion = value.result.emotion
                    self.setView(emotion: emotion)
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    // MARK: - action
    private func setAction() {
        homeView.emotionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionSelect)))
        homeView.mailBoxImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(diaryCardSelect)))
        homeView.alertButton.addTarget(self, action: #selector(alertSelect), for: .touchUpInside)
        homeView.emotionImage.isUserInteractionEnabled = true
        homeView.mailBoxImage.isUserInteractionEnabled = true
    }
    
    @objc
    private func emotionSelect(sender: UITapGestureRecognizer) {
        let emotionVC = EmotionViewController()
        emotionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(emotionVC, animated: true)
    }
    
    @objc
    private func diaryCardSelect(sender: UITapGestureRecognizer) {
        let diaryVC = DiaryCardSelectViewController()
        diaryVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    @objc
    private func alertSelect() {
        notificationVC.configure(delegate: self)
        self.navigationController?.pushViewController(notificationVC, animated: true)
    }
    
    private func getNotifications() {
        NotificationAPIService.getNotificationList { _ in }
        NotificationAPIService.getFriendRequestList { _ in }
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
