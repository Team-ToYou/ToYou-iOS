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
    var isBottomSheetExpanded = false // 바텀시트
    
    let notificationVC = NotificationViewController()
    let notificationViewModel = NotificationViewModel() // 생성과 동시에 알림을 가져온다.
    let emotionWarningVC = EmotionWarningPopupViewController()
    
    var delegate: NotificationViewControllerDelegate?
    
    // 바텀시트용
    var cards: [DiaryCard] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = homeView
        navigationController?.navigationBar.isHidden = true
        
        // 알림 VC 설정
        notificationVC.configure(notificationViewModel, delegate: self)
        setDate(date: Date())
        setAction()
        getAPI()
        setDelegate()
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
    
    private func setDate(date: Date) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        homeView.dateLabel.text = dateFormatter.string(from: date)
    }
    
    private func getAPI() {
        print("HomeAPI")
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let url = "\(K.URLString.baseURL)/users/home"
        let yesterdayUrl = "\(K.URLString.baseURL)/diarycards/yesterday"
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: HomeResponse.self) { response in
                switch response.result {
                case .success(let value):
                    print(value)
                    let num = value.result.questionNum
                    
                    if let emotion = value.result.emotion {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = true
                        self.homeEmotionString = emotion
                        self.cardId = value.result.cardId
                        self.setView(emotionString: emotion)
                    } else {
                        self.homeView.mailBoxImage.isUserInteractionEnabled = false
                    }

                    // 우체통 이미지 변경
                    if num == 0 {
                        self.homeView.mailBoxImage.setImage(.mailboxEmpty, for: .normal)
                    } else if num < 5 {
                        self.homeView.mailBoxImage.setImage(.mailboxSingle, for: .normal)
                    } else {
                        self.homeView.mailBoxImage.setImage(.mailboxFull, for: .normal)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        
        AF.request(yesterdayUrl, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: BottomSheetResponse.self) { response in
                switch response.result {
                case .success(let value):
                    self.cards = value.result.cards
                    self.homeView.bottomSheetView.collectionView.reloadData()
                    
                    // 카드 여부 => 아이콘, 텍스트 보이게
                    let isEmpty = self.cards.isEmpty
                    self.homeView.bottomSheetView.iconImage.isHidden = !isEmpty
                    self.homeView.bottomSheetView.noCardLabel.isHidden = !isEmpty
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    private func setDelegate() {
        homeView.bottomSheetView.collectionView.dataSource = self
        homeView.bottomSheetView.collectionView.delegate = self
    }
    
    // MARK: - action
    private func setAction() {
        homeView.emotionImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(emotionSelect)))
        homeView.mailBoxImage.addTarget(self, action: #selector(diaryCardSelect), for: .touchUpInside)
        homeView.alertButton.addTarget(self, action: #selector(alertSelect), for: .touchUpInside)
        homeView.emotionImage.isUserInteractionEnabled = true
        homeView.mailBoxImage.isUserInteractionEnabled = true
        
        // 바텀시트
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(bottomSheetTap))
        tapGesture.cancelsTouchesInView = false
        homeView.bottomSheetView.backgroundView.addGestureRecognizer(tapGesture)
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
            previewVC.isPreviewMode = true
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
    
    @objc
    private func bottomSheetTap() {
        isBottomSheetExpanded.toggle()
        
        let expandedOffset = homeView.safeAreaInsets.top + 75 // 올렸을 때
        let collapsedOffset = UIScreen.main.bounds.height - (68+50) // 내렸을 때
        
        homeView.bottomSheetTopConstraint?.update(offset: isBottomSheetExpanded ? expandedOffset : collapsedOffset)
        
        UIView.animate(withDuration: 0.3, delay: 0, options: [.curveEaseInOut], animations: {
            self.view.layoutIfNeeded()
        })
    }
}

// MARK: - extension
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

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomSheetCell.identifier, for: indexPath) as? BottomSheetCell else {
            return UICollectionViewCell()
        }
        
        let card = cards[indexPath.item]
        cell.configure(with: card)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    // 셀 사이즈
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 164.77, height: 290)
    }

    // 셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 21
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedCard = cards[indexPath.item]
        
        let detailVC = CalendarDetailViewController()
        detailVC.cardId = selectedCard.cardId
        detailVC.emotion = Emotion(rawValue: selectedCard.cardContent.emotion) ?? .NORMAL
        detailVC.isFriend = true // 친구 모드
        
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

import SwiftUI

#Preview {
    HomeViewController()
}
