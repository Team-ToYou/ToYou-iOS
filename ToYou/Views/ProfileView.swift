//
//  ProfileView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class ProfileView: UIView {
    
    private let label = UILabel().then {
        $0.text = "Profile"
        $0.font = .systemFont(ofSize: 20)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        self.addComponents()
    }
    
    private func addComponents() {
        self.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


