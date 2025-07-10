//
//  SettingCustomButtons.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit
import SnapKit
import Then

class SettingCustomButton: UIButton {
    
    private lazy var mainTitle = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_regular, size: 13)
        $0.textColor = .black04
    }
    
    private lazy var arrowImage = UIImageView().then {
        $0.image = .goDetail
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var versionLabel = UILabel().then {
        $0.text = "1.0"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 11)
        $0.textColor = .black04
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        addComponents()
    }
    
    private func addComponents() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 11
        
        self.addSubview(mainTitle)
        self.addSubview(arrowImage)
        
        self.snp.makeConstraints { make in
            make.height.equalTo(63)
        }
        
        mainTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(18)
        }
        
        arrowImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
            make.width.height.equalTo(34)
        }
    }
    
    public func configure(title: String) {
        mainTitle.text = title
    }
    
    public func versionButton() {
        arrowImage.isHidden = true
        self.addSubview(versionLabel)
        
        versionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(26)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

import SwiftUI
#Preview {
    MyPageViewController()
}
