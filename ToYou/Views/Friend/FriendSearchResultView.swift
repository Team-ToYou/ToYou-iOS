//
//  FriendSearchResultView.swift
//  ToYou
//
//  Created by 이승준 on 2/26/25.
//

import UIKit


class FriendSearchResultView: UIView {
    
    private var currentState: FriendSearchResultEnum?
    
    private lazy var mainFrame = UIView()
    
    private lazy var friendResultFrame = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var profileImage = UIImageView().then {
        $0.image = .defaultStamp
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nicknameLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.s_core_regular, size: 12)
        $0.textColor = .black04
    }
    
    public lazy var stateButton = FriendStateButton()
    
    private lazy var warningFrame = UIView().then {
        $0.backgroundColor = .white
    }
    
    private lazy var warningLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 12)
        $0.textColor = .black01
    }
    
    private lazy var unhappyImage = UIImageView().then {
        $0.image = .unhappyIcon
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.47
        addMainframe()
        addFriendComponents()
        addWarningComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendSearchResultView {
    
    private func addMainframe() {
        self.addSubview(mainFrame)
        
        mainFrame.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addFriendComponents() {
        mainFrame.addSubview(friendResultFrame)
        
        friendResultFrame.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        friendResultFrame.addSubview(nicknameLabel)
        friendResultFrame.addSubview(profileImage)
        friendResultFrame.addSubview(stateButton)

        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
            make.height.equalTo(34)
            make.width.equalTo(31)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(profileImage.snp.trailing).offset(11.05)
        }
        
        stateButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(19.94)
            make.height.equalTo(19.25)
            make.width.equalTo(47.06)
        }
        
        friendResultFrame.isHidden = true
    }
    
    private func addWarningComponents() {
        mainFrame.addSubview(warningFrame)
        
        warningFrame.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        warningFrame.addSubview(unhappyImage)
        warningFrame.addSubview(warningLabel)
        
        unhappyImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(13.07)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-5.4)
        }
        
        warningFrame.isHidden = true
    }
    
}

extension FriendSearchResultView {
    
    public func configure( emotion: Emotion?, nickname: String, state: FriendSearchResultEnum) {
        friendResultFrame.isHidden = false
        warningFrame.isHidden = false
        nicknameLabel.text = nickname
        switch state {
        case .canRequest:
            mainFrame.bringSubviewToFront(friendResultFrame)
            stateButton.configure(state: state)
        case .cancelRequire:
            mainFrame.bringSubviewToFront(friendResultFrame)
            stateButton.configure(state: state)
        case .alreadyFriend:
            mainFrame.bringSubviewToFront(friendResultFrame)
            stateButton.configure(state: state)
        case .sentRequestToMe:
            mainFrame.bringSubviewToFront(friendResultFrame)
            stateButton.configure(state: state)
        case .notExist:
            mainFrame.bringSubviewToFront(warningFrame)
            warningLabel.text = "찾으시는 닉네임이 존재하지 않아요. 다시 입력해주세요"
        case .couldNotSendToMe:
            mainFrame.bringSubviewToFront(warningFrame)
            warningLabel.text = "스스로에게 요청할 수 없습니다. 다시 입력해주세요"
        case .networkError:
            mainFrame.bringSubviewToFront(warningFrame)
            warningLabel.text = "네트워크 에러가 발생했어요."
        }
        
        if let _ = emotion {
            profileImage.image = emotion?.stampImage()
        }
        
        currentState = state
    }
}

import SwiftUI
#Preview {
    FriendsViewController()
}
