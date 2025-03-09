//
//  FriendRecordListCell.swift
//  ToYou
//
//  Created by 김미주 on 10/03/2025.
//

import UIKit

class FriendRecordListCell: UICollectionViewCell {
    static let identifier = "FriendRecordListCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let emotionImage = UIImageView().then {
        $0.image = .normalStamp
        $0.contentMode = .scaleAspectFit
    }
    
    private let nameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
        $0.textColor = .black04
    }
    
    // MARK: - function
    private func setView() {
        [ emotionImage, nameLabel ].forEach { addSubview($0) }
        
        emotionImage.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.height.equalTo(46)
        }
        
        nameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emotionImage.snp.bottom).offset(5)
        }
    }
}
