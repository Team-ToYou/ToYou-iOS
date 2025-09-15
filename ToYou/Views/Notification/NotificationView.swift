//
//  NotificationView.swift
//  ToYou
//
//  Created by 이승준 on 5/27/25.
//

import UIKit

class NotificationView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()
    
    private lazy var friendRequestLabel = getTitleLabel("친구 요청")
    private lazy var noFriendRequestView = getNothingMessage("새로운 친구 요청이 없어요")
    
    public lazy var friendTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 64 //Minimum height
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.register(FriendRequestCell.self, forCellReuseIdentifier: FriendRequestCell.identifier)
    }
    
    private lazy var notificationLabel = getTitleLabel("전체 알림")
    private lazy var noNotificationView = getNothingMessage("새로운 알림이 없어요")
    
    public lazy var notificationTableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = 84 //Minimum height
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.identifier)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        setConstraints()
    }
    
    public func noFriendRequestMode() {
        noFriendRequestView.isHidden = false
    }
    
    public func hasFriendRequestMode() {
        noFriendRequestView.isHidden = true
    }
    
    public func noNotificationMode() {
        noNotificationView.isHidden = false
    }
    
    public func hasNotificationMode() {
        noNotificationView.isHidden = true
    }
        
    public func setConstraints() {
        signUpTopTitleComponents()
        setFriendRequestComponents()
        setNotificationComponents()
    }
    
    private func setFriendRequestComponents() {
        self.addSubview(friendRequestLabel)
        self.addSubview(noFriendRequestView)
        self.addSubview(friendTableView)
        
        friendRequestLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(navigationBar.dividerLine.snp.bottom).offset(56)
        }
        
        noFriendRequestView.snp.makeConstraints { make in
            make.top.equalTo(friendRequestLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        friendTableView.snp.makeConstraints { make in
            make.top.equalTo(friendRequestLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(64)
        }
    }
    
    private func setNotificationComponents() {
        self.addSubview(notificationLabel)
        self.addSubview(noNotificationView)
        self.addSubview(notificationTableView)
        
        notificationLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(navigationBar.dividerLine.snp.bottom).offset(214.47)
        }
        
        noNotificationView.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(36)
        }
        
        notificationTableView.snp.makeConstraints { make in
            make.top.equalTo(notificationLabel.snp.bottom).offset(11)
            make.leading.trailing.equalToSuperview().inset(36)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom)
        }
        
    }
    
    private func signUpTopTitleComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.configure(with: "알림")
        navigationBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func getTitleLabel(_ text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textColor = .black
            $0.font = UIFont(name: K.Font.s_core_regular, size: 17)
        }
    }
    
    private func getNothingMessage(_ text: String) -> UILabel {
        return UILabel().then {
            $0.text = text
            $0.textAlignment = .center
            $0.textColor = .black
            $0.backgroundColor = .white
            $0.font = UIFont(name: K.Font.s_core_regular, size: 13)
            $0.clipsToBounds = true
            $0.layer.cornerRadius = 10
            
            $0.snp.makeConstraints { make in
                make.height.equalTo(64)
            }
        }
    }
    
    private func getCollectionView() -> UICollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 11 // 셀 간 간격
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 72, height: 64) // 크기
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.isScrollEnabled = false
        cv.backgroundColor = .clear
        cv.register(NotificationCell.self, forCellWithReuseIdentifier: NotificationCell.identifier)
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        return cv
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
#Preview {
    NotificationViewController()
}
