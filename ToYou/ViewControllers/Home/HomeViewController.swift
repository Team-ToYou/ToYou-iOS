//
//  HomeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class HomeViewController: UIViewController {
    let homeView = HomeView()
//    var emotion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true
        
//        setView(emotion: emotion)
        setAction()
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
