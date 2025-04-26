//
//  FriendStateButton.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import UIKit

class FriendStateButton: UIButton {
    
    private lazy var stateLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 11)
        $0.textColor = .black04
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = 10.69
        
        self.addSubview(stateLabel)
        stateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(state: FriendSearchResultEnum) {
        switch state {
        case .canRequest:
            stateLabel.text = "친구 요청"
            self.backgroundColor = .gray00
        case .cancelRequire:
            stateLabel.text = "취소하기"
            self.backgroundColor = .red01
        case .alreadyFriend:
            stateLabel.text = "친구"
            self.backgroundColor = .gray00
        case .sentRequestToMe:
            stateLabel.text = "친구 수락"
            self.backgroundColor = .gray00
        case .notExist:
            stateLabel.text = " "
            self.backgroundColor = .white
        case .couldNotSendToMe:
            stateLabel.text = " "
            self.backgroundColor = .white
        case .networkError:
            stateLabel.text = " "
            self.backgroundColor = .white
        }
    }
    
}
