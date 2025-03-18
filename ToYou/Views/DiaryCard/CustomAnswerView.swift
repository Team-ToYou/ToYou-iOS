//
//  CustomAnswerView.swift
//  ToYou
//
//  Created by 김미주 on 3/19/25.
//

import UIKit

class CustomAnswerView: UIView {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5.3
    }
    
    private let textField = UITextView().then {
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 11)
        $0.backgroundColor = .clear
    }
    
    private let count = UILabel().then {
        $0.text = "(0/200)"
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 9)
        $0.textColor = .black00
    }
    
    // MARK: - function
    private func setView() {
        [ backView, textField, count ].forEach { addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.horizontalEdges.equalToSuperview().inset(6)
            $0.bottom.equalTo(count.snp.top).offset(-10)
        }
        
        count.snp.makeConstraints {
            $0.right.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().inset(8)
        }
    }
}
