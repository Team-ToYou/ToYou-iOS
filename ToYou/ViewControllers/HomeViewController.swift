//
//  HomeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class HomeViewController: UIViewController {
    let homeVeiw = HomeView()
    let emotion = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeVeiw
        navigationController?.navigationBar.isHidden = true
        
        setView(emotion: emotion)
    }
    
    private func setView(emotion: String) {
        let item = Home.dummy().first { $0.emotion == emotion }
        
        if let item = item {
            homeVeiw.commentLabel.text = item.comment
            homeVeiw.dateBackView.backgroundColor = item.color
            homeVeiw.emotionImage.image = item.bubble
            homeVeiw.backgroundColor = item.color
        }
    }
    
}

import SwiftUI
#Preview(body: {
    HomeViewController()
})
