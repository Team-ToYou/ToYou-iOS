//
//  QueryTypeButton.swift
//  ToYou
//
//  Created by 이승준 on 2/28/25.
//

import UIKit

class QueryTypeButton: UIButton {
    
    private var toggle: Bool = false
    public var queryType: QueryType?
    
    private lazy var stampImageView = UIImageView().then {
        $0.image = .unselectedSoullessStamp
        $0.contentMode = .scaleAspectFit
        $0.isUserInteractionEnabled = false
    }
    
    private lazy var mainLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 16)
        $0.textColor = .black00
    }
    
    private lazy var subLabel = UILabel().then {
        $0.text = " "
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 13) // 1차 QA +2
        $0.textColor = .black00
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addComponents() {
        self.backgroundColor = .clear
        self.snp.makeConstraints { make in
            make.width.equalTo(70)
            make.height.equalTo(76)
        }
        
        self.addSubview(stampImageView)
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        
        stampImageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.height.equalTo(45)
            make.width.equalTo(42)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(subLabel.snp.top)
        }
        
        subLabel.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
        }
        
    }
    
    public func configure(type: QueryType) {
        queryType = type
        mainLabel.text = type.title()
        subLabel.text = type.subTitle()
    }
    
    public func selected() {
        toggle = true
        stampImageView.image = .selectedSoullessStamp
        mainLabel.textColor = .black04
        subLabel.textColor = .black04
    }
    
    public func unselected() {
        toggle = false
        stampImageView.image = .unselectedSoullessStamp
        mainLabel.textColor = .black00
        subLabel.textColor = .black00
    }
    
    public func isSelected() -> Bool {
        return toggle
    }
    
}

import SwiftUI
#Preview {
    QueryTypeViewController()
}
