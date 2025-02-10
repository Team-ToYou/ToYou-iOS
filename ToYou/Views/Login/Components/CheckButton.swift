//
//  CheckButton.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit

class CheckButton: UIButton {
    
    private var toggle: Bool = false
    
    private lazy var mainLabel = UILabel().then {
        $0.text = "중복확인"
        $0.font = UIFont(name: K.Font.s_core_regular , size: 12)
        $0.textColor = .black01
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
        
    private func addComponents() {
        self.addSubview(mainLabel)
        
        self.backgroundColor = .background
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(80)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    public func available() {
        mainLabel.textColor = .black04
        self.backgroundColor = .red02
        self.toggle = true
    }
    
    public func notAvailable() {
        mainLabel.textColor = .black01
        self.backgroundColor = .background
        self.toggle = false
    }
    
    public func toggleState() {
        if self.toggle {
            self.notAvailable()
        } else {
            self.available()
        }
    }
    
    public func isAvailable() -> Bool {
        return toggle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
