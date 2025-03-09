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
    
    private let tutorialImages: [UIImage] = [
        .tutorial1, .tutorial2, .tutorial3, .tutorial4, .tutorial5
    ]
    
    private lazy var pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.numberOfPages = 5
        $0.direction = .leftToRight
        $0.backgroundColor = .clear
    }
    
    private lazy var tutorialImageCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: view.window?.windowScene?.screen.bounds.width ?? 0, height: view.window?.windowScene?.screen.bounds.height ?? 0)
        layout.minimumLineSpacing = 0
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .blue03
        cv.isPagingEnabled = true
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        cv.bouncesHorizontally = false
        
        cv.register(TutorialCell.self, forCellWithReuseIdentifier: TutorialCell.identifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var skipButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    private lazy var startButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setCollectionConstraints()
        setSkipButton()
        setButtonAction()
    }
    
    private func setCollectionConstraints() {
        self.view.addSubview(tutorialImageCollectionView)
        
        tutorialImageCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func setPageControlConstraints() {
        self.view.addSubview(pageControl)
        
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(30)
        }
    }
    
    private func setSkipButton() {
        self.view.addSubview(skipButton)
        self.view.addSubview(startButton)
        
        skipButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(100)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        startButton.snp.makeConstraints { make in
            make.height.equalTo(70)
            make.width.equalTo(150)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-30)
        }
    }
    
}

extension TutorialViewController {
    func setButtonAction() {
        skipButton.addTarget(self, action: #selector(skipOrStartPressed), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(skipOrStartPressed), for: .touchUpInside)
    }
    
    @objc func skipOrStartPressed() {
        RootViewControllerService.toLoginViewController()
        UserDefaults.standard.set(true, forKey: K.Key.tutorial)
    }
}

extension TutorialViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tutorialImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TutorialCell.identifier, for: indexPath) as! TutorialCell
        cell.configure(image: tutorialImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == tutorialImages.count - 1 {
            startButton.isEnabled = true
        } else {
            startButton.isEnabled = false
        }
    }
}

extension TutorialViewController: UIScrollViewDelegate {
    private func setupScrollView() {
        let scrollView = UIScrollView(frame: view.bounds).then {
            $0.delegate = self
            $0.isScrollEnabled = true
            $0.isPagingEnabled = true
            
            $0.bouncesHorizontally = false
            $0.bouncesVertically = false
            
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
        }
        
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

import SwiftUI
#Preview{
    TutorialViewController()
}
