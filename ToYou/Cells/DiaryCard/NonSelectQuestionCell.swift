//
//  nonSelectQuestionCell.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class NonSelectQuestionCell: UICollectionViewCell {
    static let identifier = "NonSelectQuestionCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    public let checkboxButton = CheckBoxButtonVer02()
    
    private let questionLabel = UILabel().then {
        $0.text = "요즘 어떻게 지내?"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.textAlignment = .center
        $0.numberOfLines = 3
    }
    
    private let fromLabel = UILabel().then {
        $0.text = "From. 미주"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
    }
    
    // MARK: - function
    private func setView() {
        [
            checkboxButton, questionLabel, fromLabel
        ].forEach {
            addSubview($0)
        }
        
        checkboxButton.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(22.4)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(checkboxButton.snp.bottom).offset(12)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(170)
        }
        
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
    }
    
    func setQuestion(content: String, questioner: String) {
        self.questionLabel.text = content
        self.fromLabel.text = "From. \(questioner)"
    }
}
