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
//    var emotion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true
        
//        setView(emotion: emotion)
        setAction()
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
        // 임시 accessToken
        let token = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE3NDI4MTA1MTIsImV4cCI6MTc0NDAyMDExMiwic3ViIjoiMiIsImlkIjoyLCJjYXRlZ29yeSI6ImFjY2VzcyJ9.P07B0Yl4RZk0TGuIYOrw2LQndsFY3XysjbliOoX7IxE"
        
        let headers: HTTPHeaders = [
            "Authorization": token
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
    
}
