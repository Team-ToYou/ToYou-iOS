//
//  LetterComposeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class FriendsViewController: UIViewController {
    
    let friendsView = FriendsView()
    let disconnectPopupVC = DisconnectFriendPopupVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = friendsView
        disconnectPopupVC.modalPresentationStyle = .overFullScreen
        
        friendsView.friendsCollectionView.delegate = self
        friendsView.friendsCollectionView.dataSource = self
        
        hideKeyboardWhenTappedAround()
    }
    
}

extension FriendsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendsModel.dummies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let data = FriendsModel.dummies[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCollectionViewCell.identifier, for: indexPath) as! FriendsCollectionViewCell
        cell.configure(friend: data, delegate: self)
        return cell
    }
}

extension FriendsViewController: FriendCollectionViewCellDelegate {
    
    func sendQuery(to friend: FriendInfo) {
        let selectQueryVC = SelectQueryViewController()
        selectQueryVC.modalPresentationStyle = .overFullScreen
        selectQueryVC.configure(by: friend)
        present(selectQueryVC, animated: true)
    }
    
    func disconnect(with friend: FriendInfo) {
        present(disconnectPopupVC, animated: false)
        
        disconnectPopupVC.completionHandler = { data in
            if data {
                // 친구 삭제 진행
                print("\(friend.nickname)을 삭제합니다.")
            } else {
                print("\(friend.nickname)을 삭제를 취소합니다.")
            }
        }
    }
    
}

// 레이아웃 델리게이트 추가
extension FriendsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 20, right: 0)
    }
}

import SwiftUI
#Preview {
    FriendsViewController()
}
