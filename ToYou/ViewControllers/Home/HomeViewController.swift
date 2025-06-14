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
    let homeView = HomeView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true
        
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
                    
                    if value.result.emotion == nil {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = false
                    } else {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = true
                        self.homeEmotionString = value.result.emotion!
                        let emotion = value.result.emotion
                        self.setView(emotionString: emotion!)
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
        let emotionVC = EmotionViewController()
        emotionVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(emotionVC, animated: true)
    }
    
    @objc
    private func diaryCardSelect(sender: UITapGestureRecognizer) {
        let diaryVC = DiaryCardSelectViewController()
        diaryVC.emotion = Emotion(rawValue: homeEmotionString) ?? .NORMAL
        diaryVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(diaryVC, animated: true)
    }
    
    @objc
    private func alertSelect() {
        self.navigationController?.pushViewController(NotificationViewController(), animated: true)
    }
    
}
