//
//  UserTypeButton.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit

class UserTypeButton: UIButton {
    
    private var toggle: Bool = false
    private var userType: UserType?
    
    private lazy var mainLabel = UILabel().then {
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addComponents()
    }
    
    private func addComponents() {
        self.addSubview(mainLabel)
        
        self.backgroundColor = .white
        self.clipsToBounds = true
        self.layer.cornerRadius = 6
        self.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
    }
    
    public func configure(userType: UserType) {
        switch userType {
        case .student:
            mainLabel.text = "중·고등학생"
        case .college:
            mainLabel.text = "대학생"
        case .office:
            mainLabel.text = "직장인"
        case .ect:
            mainLabel.text = "기타"
        }
        self.userType = userType
    }
    
    public func selectedView() {
        self.backgroundColor = .red01
        self.toggle = true
    }
    
    public func notSelectedView() {
        self.backgroundColor = .white
        self.toggle = false
    }
    
    public func toggleState() {
        if self.toggle {
            self.notSelectedView()
        } else {
            self.selectedView()
        }
    }
    
    public func isSelected() -> Bool {
        return toggle
    }
    
    public func returnUserType() -> UserType? {
        return userType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
