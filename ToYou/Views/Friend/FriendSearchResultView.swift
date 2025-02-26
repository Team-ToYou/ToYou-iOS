//
//  FriendSearchResultView.swift
//  ToYou
//
//  Created by 이승준 on 2/26/25.
//

import UIKit

class FriendSearchResultView: UIView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendSearchResultView {
    
    public func configure(type: FriendSearchViewEnum) {
        switch type {
        case .clear:
            
        case .require:
            
        case .cancelRequire:
            
        case .alreadyFriend:
            
        case .acceptRequire:
            
        case .notExist:
            
        case .couldNotSendToMe:
            
        }
    }
    
    enum FriendSearchViewEnum {
        case clear, require, cancelRequire, alreadyFriend, acceptRequire, notExist, couldNotSendToMe
    }
}
