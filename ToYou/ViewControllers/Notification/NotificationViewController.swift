//
//  NotificationViewController.swift
//  ToYou
//
//  Created by 이승준 on 5/27/25.
//

import UIKit

class NotificationViewController: UIViewController {
    
    let notificationView = NotificationView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notificationView.notificationCollectionView.delegate = self
        notificationView.notificationCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("100")
        notificationView.setConstraints()
        self.view = notificationView
    }
    
}

extension NotificationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == notificationView.notificationCollectionView { // CollectionVeiw가 두 개
            return NotificationAPIService.shared.notificationData.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == notificationView.notificationCollectionView {
            let data = NotificationAPIService.shared.notificationData[indexPath.row]
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NotificationCell.identifier, for: indexPath) as! NotificationCell
            cell.configure(data)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    
}

import SwiftUI
#Preview {
    NotificationViewController()
}
