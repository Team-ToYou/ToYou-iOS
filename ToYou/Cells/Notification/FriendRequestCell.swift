//
//  FriendRequestCell.swift
//  ToYou
//
//  Created by 이승준 on 5/31/25.
//

import UIKit

class FriendRequestCell: UITableViewCell {
    
    static let identifier = "FriendRequestCell"
    public var data: FriendRequestData?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 11)
        $0.textColor = .black
    }
    
    private lazy var friendRequestButton = FriendStateButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = .clear
        
        self.addSubview(titleLabel)
        self.addSubview(friendRequestButton)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
        friendRequestButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-22)
        }
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ data: FriendRequestData) {
        self.data = data
        guard let nickname = data.nickname else {
            titleLabel.text = "찾을 수 없는 유저로부터의 친구요청"
            return
        }
        
        titleLabel.text = nickname + "님이 친구요청을 보냈습니다."
    }
    
}

