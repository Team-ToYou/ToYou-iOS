//
//  SelectQuestionCell.swift
//  ToYou
//
//  Created by 김미주 on 14/03/2025.
//

import UIKit

class SelectQuestionCell: UICollectionViewCell {
    static let identifier = "SelectQuestionCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    public let checkboxButton = CheckBoxButtonVer02().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let questionLabel = UILabel().then {
        $0.text = "요즘 어떻게 지내?"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.textAlignment = .left
        $0.numberOfLines = 3
    }
    
    private let optionStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    private let fromLabel = UILabel().then {
        $0.text = "From. 미주"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-2ExtraLight", size: 11)
    }
    
    // MARK: - function
    private func setView() {
        [
            checkboxButton, questionLabel, optionStackView, fromLabel
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
            $0.left.equalToSuperview()
            $0.width.equalTo(172)
        }
        
        optionStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(6.3)
            $0.left.equalTo(questionLabel.snp.left).offset(2)
            $0.right.equalToSuperview()
        }
        
        fromLabel.snp.makeConstraints {
            $0.top.equalTo(optionStackView.snp.bottom).offset(7.5)
            $0.right.equalToSuperview()
        }
    }
    
    func setQuestion(content: String, options: [String], questioner: String) {
        self.questionLabel.text = content
        self.fromLabel.text = "From. \(questioner)"

        // 기존 옵션 제거
        optionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 옵션 추가
        for option in options {
            let backView = UIView().then {
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 5.3
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.borderWidth = 0
            }
            
            let optionLabel = UILabel().then {
                $0.text = option
                $0.textColor = .black04
                $0.font = UIFont(name: "S-CoreDream-3Light", size: 11)
            }
            
            backView.addSubview(optionLabel)
            optionStackView.addArrangedSubview(backView)
            
            backView.snp.makeConstraints {
                $0.height.equalTo(25.6)
            }
            
            optionLabel.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.left.equalToSuperview().offset(7.7)
            }
        }
    }
}

extension SelectQuestionCell: QuestionSelectable {}
