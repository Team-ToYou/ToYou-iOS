//
//  NotificationCell.swift
//  ToYou
//
//  Created by 이승준 on 5/30/25.
//

import UIKit

class NotificationCell: UITableViewCell {
    
    static let identifier = "NotificationCell"
    public var data: NotificationData?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 12)
        $0.textColor = .black
    }
    
    private lazy var detailImage = UIImageView().then {
        $0.image = .goDetail
        $0.contentMode = .scaleAspectFit
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.contentView.addSubview(titleLabel)
        self.backgroundColor = .clear
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
    }
        
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 5.5, left: 0, bottom: 5.5, right: 0))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ data: NotificationData) {
        self.data = data
        titleLabel.text = data.content
        
        if data.alarmType == .NEW_QUESTION {
            self.contentView.addSubview(detailImage)
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
