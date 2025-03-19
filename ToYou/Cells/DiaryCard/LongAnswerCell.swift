//
//  LongAnswerCell.swift
//  ToYou
//
//  Created by 김미주 on 3/19/25.
//

import UIKit

class LongAnswerCell: UICollectionViewCell {
    static let identifier = "LongAnswerCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let questionLabel = UILabel().then {
        $0.text = "요즘 어떻게 지내?"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.numberOfLines = 3
    }
    
    private let textField = CustomAnswerView(isLongAnswer: true)
    
    private let fromLabel = UILabel().then {
        $0.text = "From. 미주"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
    }
    
    // MARK: - function
    private func setView() {
        [
            questionLabel, textField, fromLabel
        ].forEach {
            addSubview($0)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        textField.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(6.3)
            $0.left.equalTo(questionLabel.snp.left).offset(2)
            $0.right.equalToSuperview()
            $0.height.equalTo(171)
        }
        
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(textField.snp.bottom).offset(4.3)
            $0.right.equalToSuperview()
        }
    }
}
