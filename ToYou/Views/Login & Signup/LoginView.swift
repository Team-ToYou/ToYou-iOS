//
//  LoginView.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import SnapKit
import Then

class LoginView: UIView {
    
    private lazy var backroundImage = UIImageView().then {
        $0.image = .splash
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var appleLoginView = AppleLoginButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
    
    private func addComponents() {
        self.addSubview(backroundImage)
        self.addSubview(appleLoginView)
        
        backroundImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        appleLoginView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(K.BottomButtonConstraint.leadingTrailing)
            make.bottom.equalToSuperview().inset(K.BottomButtonConstraint.bottomPadding)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
