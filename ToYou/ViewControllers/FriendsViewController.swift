//
//  LetterComposeViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class FriendsViewController: UIViewController {
    
    let friendsView = FriendsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = friendsView
        friendsView.friendsCollectionView.delegate = self
        friendsView.friendsCollectionView.dataSource = self
    }
    
}

extension FriendsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return FriendsModel.dummies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsCollectionViewCell.identifier, for: indexPath) as! FriendsCollectionViewCell
        cell.configure(nickname: FriendsModel.dummies[indexPath.row].nickname,
                      emotion: FriendsModel.dummies[indexPath.row].emotion)
        return cell
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
