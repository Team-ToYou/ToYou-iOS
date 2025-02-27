//
//  FriendsTableViewCell.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import UIKit

class FriendsCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FriendsCollectionViewCell"
    
    private lazy var profileImage = UIImageView().then {
        $0.image = .defaultStamp
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var nicknameLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.s_core_regular, size: 12)
        $0.textColor = .black04
    }
    
    private lazy var emotionLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium , size: 12)
        $0.textColor = .black04
    }
    
    public lazy var sendMessageButton = UIButton().then {
        $0.setImage(.paperplane, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    public lazy var deleteFriendButton = UIButton().then {
        $0.setImage(.trashcan, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.67
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(nickname: String, emotion: Emotion?) {
        nicknameLabel.text = nickname
        if let _ = emotion {
            profileImage.image = emotion!.stampImage()
            emotionLabel.text = emotion!.emotionExplanation()
        }
    }
    
    private func addComponents() {
        self.addSubview(profileImage)
        self.addSubview(nicknameLabel)
        self.addSubview(emotionLabel)
        self.addSubview(sendMessageButton)
        self.addSubview(deleteFriendButton)
        
        profileImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17.84)
            make.height.equalTo(34)
            make.width.equalTo(31)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-5)
            make.leading.equalTo(profileImage.snp.trailing).offset(7.22)
        }
        
        emotionLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameLabel.snp.bottom).offset(0)
            make.leading.equalTo(nicknameLabel)
        }
        
        deleteFriendButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.centerY.equalToSuperview()
        }
        
        sendMessageButton.snp.makeConstraints { make in
            make.trailing.equalTo(deleteFriendButton.snp.leading).inset(-13)
            make.centerY.equalToSuperview()
        }
    }

}

import SwiftUI
#Preview {
    FriendsViewController()
}
