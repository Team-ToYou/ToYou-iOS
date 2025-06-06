//
//  DiaryCardAnswerCell.swift
//  ToYou
//
//  Created by 김미주 on 4/26/25.
//

import UIKit

class DiaryCardAnswerCell: UITableViewCell {
    static let identifier = "DiaryCardAnswerCell"

    // MARK: - init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - layout
    private let questionLabel = UILabel().then {
        $0.text = "질문"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 18)
        $0.textColor = .black04
        $0.numberOfLines = 2
    }
    
    private let answerStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fillEqually
        $0.spacing = 21
    }
    
    private let space = UIView().then {
        $0.backgroundColor = .clear
    }
    
    // MARK: - function
    private func setView() {
        [questionLabel, answerStackView, space].forEach { addSubview($0) }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview()
        }
        
        answerStackView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
        }
        
        space.snp.makeConstraints {
            $0.top.equalTo(answerStackView.snp.bottom)
            $0.height.equalTo(21.3)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    func configure(question: String, answers: [String], selectedIndex: Int?, emotion: Emotion) {
        questionLabel.text = question
        
        answerStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        answerStackView.alignment = answers.count == 1 ? .leading : .fill
        answerStackView.distribution = answers.count == 1 ? .fill : .fillEqually
        
        for (index, answerText) in answers.enumerated() {
            let backView = UIView().then {
                $0.backgroundColor = (index == selectedIndex) ? emotion.pointColor() : .white
                $0.layer.cornerRadius = 5.33
            }
            
            let label = UILabel().then {
                $0.text = answerText
                $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 18)
                $0.textColor = .black04
                $0.numberOfLines = 0
                $0.textAlignment = answers.count == 1 ? .left : .center
            }
            
            backView.addSubview(label)
            
            label.snp.makeConstraints {
                $0.horizontalEdges.equalToSuperview().inset(17)
                $0.top.equalToSuperview().offset(4.4)
                $0.bottom.equalToSuperview().offset(-6.5)
            }
            
            answerStackView.addArrangedSubview(backView)
        }
    }
}
