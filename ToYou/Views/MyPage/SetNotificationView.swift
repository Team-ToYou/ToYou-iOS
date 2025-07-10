//
//  SetNotificationUIView.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit

class SetNotificationView: UIView {
    
    public lazy var navigationBar = CustomNavigationBar()
    
    private lazy var mainFrame = UIView()
    
    public lazy var toggle = UISwitch().then {
        $0.onTintColor = .red02
    }
    
    private lazy var mainLabel = UILabel().then {
        $0.text = "일기카드 작성 알림 받기"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 16)
        $0.textColor = .black04
    }
    
    private lazy var subLabel = UILabel().then {
        $0.text = "알림은 매일 23시에 전송됩니다."
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black01
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.signUpTopTitleComponents()
        self.addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SetNotificationView {
    
    private func signUpTopTitleComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.configure(with: "알림 설정")
        navigationBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func addComponents() {
        self.addSubview(mainFrame)
        mainFrame.addSubview(mainLabel)
        mainFrame.addSubview(subLabel)
        mainFrame.addSubview(toggle)
        
        mainFrame.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.trailing.equalToSuperview().inset(38)
            make.height.equalTo(40)
            make.top.equalTo(navigationBar.dividerLine.snp.bottom).offset(40)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
        }
        
        subLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(5)
        }
        
        toggle.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
        }
        
    }

}

import SwiftUI
#Preview {
    SetNotificationViewController()
}
