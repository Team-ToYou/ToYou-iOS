//
//  ProfileView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import SnapKit
import Then

class MyPageView: UIView {
    
    private lazy var backgroundImage = UIImageView().then {
        $0.image = .paperTexture
    }
    
    private lazy var mainLabel = UILabel().then {
        $0.text = "마이페이지"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 16)
        $0.textColor = .black04
    }
    
    private lazy var profileFrame = UIView()
    
    private lazy var profileImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .defaultProfile
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 26
    }
    
    private lazy var nicknameLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 24)
        $0.textColor = .black04
    }
    
    private lazy var friendsLabel = UILabel().then {
        $0.text = "친구 명"
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 18)
        $0.textAlignment = .center
        $0.textColor = .black04
    }
    
    public lazy var editProfileDetailButton = UIButton().then {
        $0.setImage(.goDetail, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    private lazy var mainStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 20
    }
    
    public lazy var notificationSetButton = SettingCustomButton()
    public lazy var sendFeedbackButton = SettingCustomButton()
    public lazy var sendQueryButton = SettingCustomButton()
    public lazy var policyButton = SettingCustomButton()
    public lazy var versionLabel = SettingCustomButton()
    
    private lazy var accountFrame = UIView()
    
    public lazy var revokeButton = UIButton().then {
        $0.backgroundColor = .gray00
        $0.setTitle("회원탈퇴", for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 18)
        $0.setTitleColor(.black04, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17.5
    }
    
    public lazy var logoutButton = UIButton().then {
        $0.backgroundColor = .gray00
        $0.setTitle("로그아웃", for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 18)
        $0.setTitleColor(.black04, for: .normal)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 17.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // self.translatesAutoresizingMaskIntoConstraints = false // 임시 너비 제약조건 제거를 통해 leading.trailing 을 동시에 실행했을 때, 발생하는 경고 삭제
        self.backgroundColor = .background
        self.addBasicComponents()
        self.addProfileComponents()
        self.addButtonStack()
        self.addAccountRelatedComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageView {
    
    public func configure(nickname: String, friends: Int) {
        nicknameLabel.text = nickname
        friendsLabel.text = "친구 \(friends)먕"
    }
    
}

extension MyPageView {
    
    private func addAccountRelatedComponents() {
        self.addSubview(accountFrame)
        accountFrame.addSubview(logoutButton)
        accountFrame.addSubview(revokeButton)
        
        accountFrame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainStack.snp.bottom).offset(50)
            make.height.equalTo(35)
            make.width.equalTo(238)
        }
        
        revokeButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.leading.top.equalToSuperview()
        }
        
        logoutButton.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.trailing.top.equalToSuperview()
        }
        
    }
    
    private func addButtonStack() {
        self.addSubview(mainStack)
        
        mainStack.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(37)
            make.trailing.equalToSuperview().offset(-37)//.priority(.high) // 우선순위 조정
            make.top.equalTo(profileFrame.snp.bottom).offset(21)
        }
        
        mainStack.addArrangedSubview(notificationSetButton)
        mainStack.addArrangedSubview(sendFeedbackButton)
        mainStack.addArrangedSubview(sendQueryButton)
        mainStack.addArrangedSubview(policyButton)
        mainStack.addArrangedSubview(versionLabel)
        
        notificationSetButton.configure(title: "알림 설정")
        sendFeedbackButton.configure(title: "의견 보내기")
        sendQueryButton.configure(title: "문의하기")
        policyButton.configure(title: "약관 및 정책")
        versionLabel.configure(title: "서비스 버전")
        versionLabel.versionButton()
    }
    
    private func addBasicComponents() {
        self.addSubview(backgroundImage)
        self.addSubview(mainLabel)
        
        backgroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(10)
        }
    }
    
    private func addProfileComponents() {
        self.addSubview(profileFrame)
        profileFrame.addSubview(profileImage)
        profileFrame.addSubview(nicknameLabel)
        profileFrame.addSubview(friendsLabel)
        profileFrame.addSubview(editProfileDetailButton)
        
        profileFrame.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(37)
            make.height.equalTo(52)
            make.top.equalTo(mainLabel.snp.bottom).offset(30)
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.height.equalTo(52)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        friendsLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
        }
        
        editProfileDetailButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(6)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(54)
        }
        
        editProfileDetailButton.imageView?.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
    }
}

import SwiftUI
#Preview {
    MyPageViewController()
}
