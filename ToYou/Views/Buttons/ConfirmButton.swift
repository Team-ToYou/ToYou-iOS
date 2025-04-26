//
//  BottomConfirmButtonView.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit
import SnapKit
import Then

class ConfirmButton: UIButton {
    
    private lazy var mainLabel = UILabel().then {
        $0.text = "다음"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 15)
        $0.textColor = .black01
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        self.layer.cornerRadius = 7
        self.backgroundColor = .gray00
        self.isEnabled = false
        addComponents()
    }
    
    private func addComponents() {
        
        self.snp.makeConstraints { make in
            make.height.equalTo(43)
        }
        
        self.addSubview(mainLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    public func configure(labelText: String) {
        mainLabel.text = labelText
    }
    
    public func availableForSendQuery() {
        mainLabel.textColor = .black04
        self.backgroundColor = .gray00
        self.isEnabled = true
    }
    
    public func available() {
        mainLabel.textColor = .black04
        self.backgroundColor = .black01
        self.isEnabled = true
    }
    
    public func unavailable() {
        mainLabel.textColor = .black01
        self.backgroundColor = .gray00
        self.isEnabled = false
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
