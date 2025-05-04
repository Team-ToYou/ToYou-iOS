//
//  SelectAnswerCell.swift
//  ToYou
//
//  Created by 김미주 on 3/19/25.
//

import UIKit

class SelectAnswerCell: UICollectionViewCell {
    static let identifier = "SelectAnswerCell"
    
    private var selectedOptionIndex: Int? = nil
    weak var delegate: AnswerInputDelegate?
    
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
    
    // MARK: - action
    @objc private func optionTapped(_ sender: UITapGestureRecognizer) {
        guard let selectedView = sender.view else { return }
        selectedOptionIndex = selectedView.tag
        delegate?.didUpdateAnswerState()
        
        // 옵션 텍스트
        let options: [String] = optionStackView.arrangedSubviews.compactMap { view in
            (view.subviews.first as? UILabel)?.text
        }

        // 질문 텍스트, 질문자
        let content = questionLabel.text ?? ""
        let questioner = fromLabel.text?.replacingOccurrences(of: "From. ", with: "") ?? ""
        
        setQuestion(content: questionLabel.text ?? "", options: options, questioner: questioner, delegate: delegate!)
    }
    
    // MARK: - function
    private func setView() {
        [
            questionLabel, optionStackView, fromLabel
        ].forEach {
            addSubview($0)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview()
            $0.width.equalTo(170)
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
    
    func setQuestion(content: String, options: [String], questioner: String, delegate: AnswerInputDelegate) {
        self.delegate = delegate
        self.questionLabel.text = content
        self.fromLabel.text = "From. \(questioner)"

        // 기존 옵션 제거
        optionStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }

        // 새로운 옵션 추가
        for (index, option) in options.enumerated() {
            let backView = UIView().then {
                $0.backgroundColor = .white
                $0.layer.cornerRadius = 5.3
                $0.layer.borderColor = UIColor.clear.cgColor
                $0.layer.borderWidth = 0
                $0.tag = index
                $0.isUserInteractionEnabled = true
            }
            
            let tap = UITapGestureRecognizer(target: self, action: #selector(optionTapped(_:)))
            backView.addGestureRecognizer(tap)
            
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
            
            if index == selectedOptionIndex {
                backView.layer.borderColor = UIColor.black.cgColor
                backView.layer.borderWidth = 1
            }
        }
    }
    
    public func isOptionSelected() -> Bool {
        return selectedOptionIndex != nil
    }

}
