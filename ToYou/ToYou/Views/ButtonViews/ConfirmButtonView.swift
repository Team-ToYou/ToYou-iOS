//
//  BottomConfirmButtonView.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import SnapKit
import Then

class ConfirmButtonView: UIButton {
    
    private lazy var mainLabel = UILabel().then {
        $0.text = "다음"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 15)
        $0.textColor = .black04
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black01
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        addComponents()
    }
    
    private func addComponents() {
        self.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(labelText: String) {
        mainLabel.text = labelText
    }
    
    public func isEnable(_ state: Bool) {
        switch state {
        case true:
            mainLabel.textColor = .black04
            self.backgroundColor = .black01
        case false:
            mainLabel.textColor = .black01
            self.backgroundColor = .gray00
        }
        self.isEnabled = state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
