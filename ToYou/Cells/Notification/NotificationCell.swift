//
//  NotificationCell.swift
//  ToYou
//
//  Created by 이승준 on 5/30/25.
//

import UIKit

class NotificationCell: UICollectionViewCell {
    
    static let identifier = "NotificationCell"
    public var data: NotificationData?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 11)
        $0.textColor = .black
    }
    
    private lazy var detailImage = UIImageView().then {
        $0.image = .goDetail
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.addSubview(titleLabel)
        self.backgroundColor = .white
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ data: NotificationData) {
        self.data = data
        titleLabel.text = data.content
        
        if data.alarmType == .NEW_QUESTION {
            self.addSubview(detailImage)
            detailImage.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().inset(24)
                make.height.equalTo(50)
                make.width.equalTo(25)
            }
        }
    }
    
}


import SwiftUI
#Preview {
    NotificationViewController()
}
