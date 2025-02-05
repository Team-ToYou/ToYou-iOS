//
//  SocialLoginButton.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import SnapKit
import SnapKit

class AppleLoginButton: UIButton {
    
    private var nameLabel = UILabel().then { label in
        label.font = UIFont(name: K.Font.s_core_medium, size: 14.5)
        label.frame = CGRect(x: 0, y: 0, width: 272, height: 23)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Apple로 로그인 하기"
    }
    
    private var logoImageView = UIImageView().then { image in
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "apple.logo")
        image.tintColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 7
        self.backgroundColor = .black04
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.addSubview(nameLabel)
        self.addSubview(logoImageView)
        self.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        
        nameLabel.snp.makeConstraints{ make in
            make.center.equalToSuperview()
            make.width.equalTo(140)
        }
        
        logoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(13)
            make.width.height.equalTo(23)
        }
    }
    
    func configure(name: String, logo: UIImage, backgroundColor: UIColor) {
        self.nameLabel.text = name
        self.logoImageView.image = logo
        self.backgroundColor = backgroundColor
    }

}
