//
//  TutorialViewController.swift
//  ToYou
//
//  Created by 이승준 on 3/2/25.
//

import UIKit
import SnapKit
import Then

class TutorialViewController: UIViewController {
    
    private lazy var pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 5
        $0.direction = .leftToRight
        $0.backgroundColor = .clear
    }
    
    private lazy var scrollView = UIScrollView(frame: view.bounds).then {
        $0.isScrollEnabled = true
        $0.bouncesHorizontally = false
        $0.bouncesVertically = false
        $0.isPagingEnabled = true
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
        $0.showsLargeContentViewer = false
    }
    
    private lazy var skipButton = UIButton().then {
        $0.backgroundColor = .red02
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupScrollView()
        setupButtons()
    }
    
    private func setupButtons() {
        scrollView.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.width.equalTo(177)
            make.height.equalTo(144)
        }
        
        skipButton.addTarget(self, action: #selector(skipTutorial), for: .touchUpInside)
    }
    
    @objc
    private func skipTutorial() {
        print("skip")
        // UserDefaults에 저장
        
        // Root 변환
        
    }
    
    private func setupScrollView() {
        self.view.addSubview(scrollView)
        let tutorialImages: [UIImage] = [
            .tutorial1, .tutorial2, .tutorial3, .tutorial4, .tutorial5
            ]
        let screenWidth = view.window?.windowScene?.screen.bounds.width ?? 0
        let screenHeight = view.window?.windowScene?.screen.bounds.height ?? 0
        
        scrollView.contentSize = CGSize(
            width: screenWidth * CGFloat(5),
            height: scrollView.frame.height
        )
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        for (index, image) in tutorialImages.enumerated() {
            let imageView = UIImageView(frame: CGRect(
                x: screenWidth * CGFloat(index),
                y: 0,
                width: screenWidth,
                height: screenHeight
            ))
            imageView.image = image
            imageView.contentMode = .scaleAspectFill
            scrollView.addSubview(imageView)
        }
    }
    
}

extension TutorialViewController: UIScrollViewDelegate {
    
}

import SwiftUI
#Preview{
    TutorialViewController()
}
