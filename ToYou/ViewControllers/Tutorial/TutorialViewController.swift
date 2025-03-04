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
        $0.delegate = self
        $0.isScrollEnabled = true
        $0.isPagingEnabled = true
        
        $0.bouncesHorizontally = false
        $0.bouncesVertically = false
        
        $0.showsHorizontalScrollIndicator = false
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var skipButton = UIButton().then {
        $0.backgroundColor = .red02
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupScrollView()
    }
    
    private func setSkipButton() {
        self.view.addSubview(skipButton)
        
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
    }
    
    private func setupScrollView() {
        let tutorialImages: [UIImage] = [
            .tutorial1, .tutorial2, .tutorial3, .tutorial4, .tutorial5
        ]
        
        let screenWidth = view.window?.windowScene?.screen.bounds.width ?? 0
        let screenHeight = view.window?.windowScene?.screen.bounds.height ?? 0
        
        scrollView.contentSize = CGSize(
            width: screenWidth * CGFloat(tutorialImages.count),
            height: screenHeight
        )
        
        self.view.addSubview(scrollView)
        
        for (index, image) in tutorialImages.enumerated() {
            let imageView = UIImageView(frame: CGRect(
                x: screenWidth * CGFloat(index),
                y: 0,
                width: screenWidth,
                height: screenHeight
            ))
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
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
