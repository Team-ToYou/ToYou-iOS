//
//  CustomAnswerView.swift
//  ToYou
//
//  Created by 김미주 on 3/19/25.
//

import UIKit

class CustomAnswerView: UIView {
    private var isLongAnswer: Bool // 장문형 여부
    private var maxLength: Int { return isLongAnswer ? 200 : 50 } // 글자 수 제한
    
    weak var delegate: AnswerInputDelegate?
    
    // MARK: - init
    init(isLongAnswer: Bool) {
        self.isLongAnswer = isLongAnswer
        super.init(frame: .zero)
        setView()
        textView.delegate = self
        updatePlaceholder()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let backView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5.3
    }
    
    private let textView = UITextView().then {
        $0.text = "답변을 입력해주세요."
        $0.textColor = .black00
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 12)
        $0.backgroundColor = .clear
    }
    
    private let countLabel = UILabel().then {
        $0.text = "(0/200)"
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 9)
        $0.textColor = .black00
    }
    
    // MARK: - function
    private func updatePlaceholder() {
        textView.text = "답변을 입력해주세요." // 기본값
        textView.textColor = .lightGray
        countLabel.text = "(0/\(maxLength))"
    }
    
    public func getText() -> String {
        return textView.text == "답변을 입력해주세요." ? "" : textView.text
    }
    
    private func updateCharacterCount() {
        countLabel.text = "(\(textView.text.count)/\(maxLength))"
    }
    
    private func setView() {
        [ backView, textView, countLabel ].forEach { addSubview($0) }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        textView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(6)
            $0.bottom.equalTo(countLabel.snp.top).offset(-10)
        }
        
        countLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(6)
            $0.bottom.equalToSuperview().inset(8)
        }
        
        updateCharacterCount()
    }
}

// MARK: - extension
extension CustomAnswerView: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let maxLength = self.maxLength
        if textView.text.count > maxLength {
            textView.text = String(textView.text.prefix(maxLength))
        }
        countLabel.text = "(\(textView.text.count)/\(maxLength))"
        
        delegate?.didUpdateAnswerState()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "답변을 입력해주세요." {
            textView.text = ""
            textView.textColor = .black04
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "답변을 입력해주세요."
            textView.textColor = .black00
        }
    }
}
