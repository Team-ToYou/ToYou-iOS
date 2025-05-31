//
//  FriendRequestCell.swift
//  ToYou
//
//  Created by 이승준 on 5/31/25.
//

import UIKit

protocol FriendRequestDelegate {
    func acceptFriendRequest( friend: FriendRequestData )
}

class FriendRequestCell: UITableViewCell {
    
    static let identifier = "FriendRequestCell"
    public var data: FriendRequestData?
    public var delegate: FriendRequestDelegate?
    
    private lazy var titleLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 11)
        $0.textColor = .black
    }
    
    public lazy var friendRequestButton = FriendStateButton()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.backgroundColor = .white
        
        self.addSubview(titleLabel)
        self.addSubview(friendRequestButton)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
        friendRequestButton.configure(state: .sentRequestToMe)
        friendRequestButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(19.94)
            make.height.equalTo(19.25)
            make.width.equalTo(47.06)
        }
        self.friendRequestButton.addTarget(self, action: #selector(handleAcceptRequest), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(_ data: FriendRequestData, delegate: FriendRequestDelegate) {
        self.delegate = delegate
        self.data = data
        guard let nickname = data.nickname else {
            titleLabel.text = "찾을 수 없는 유저로부터의 친구요청"
            return
        }
        titleLabel.text = nickname + "님이 친구요청을 보냈습니다."
    }
    
}

extension FriendRequestCell {
    
    @objc
    private func handleAcceptRequest() {
        delegate?.acceptFriendRequest(friend: data!)
    }
}
