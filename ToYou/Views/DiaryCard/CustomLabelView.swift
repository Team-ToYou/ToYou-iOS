//
//  CustomLabelView.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class CustomLabelView: UIView {
    private var text: String
    private var isLight: Bool
    
    // MARK: - init
    init(text: String, isLight: Bool) {
        self.text = text
        self.isLight = isLight
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private lazy var label = UILabel().then {
        $0.text = text
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.textColor = isLight ? .black04 : .white
        $0.textAlignment = .center
        
        $0.backgroundColor = isLight ? .white : .black04
        $0.layer.cornerRadius = 12
        $0.clipsToBounds = true
    }

    // MARK: - function
    private func setView() {
        addSubview(label)
        
        label.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalTo(60)
            $0.height.equalTo(24)
        }
    }
}
