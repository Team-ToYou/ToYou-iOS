//
//  BottomSheetCell.swift
//  ToYou
//
//  Created by 김미주 on 7/19/25.
//

import UIKit

class BottomSheetCell: UICollectionViewCell {
    static let identifier = "BottomSheetCell"
    
    // MARK: - layout
    private let diaryCardContainer = UIView()

    private let diaryCard = MyDiaryCard(
        frame: .zero,
        emotion: .HAPPY
    ).then {
        $0.isUserInteractionEnabled = false
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 18)
        $0.textColor = .black04
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
        diaryCard.lockButton.isHidden = true // 잠금버튼 안 보이게
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - function
    private func setView() {
        // 카드 뷰 축소 (0.5배)
        diaryCard.transform = CGAffineTransform(scaleX: 0.47, y: 0.47)
        
        contentView.addSubview(diaryCardContainer)
        diaryCardContainer.addSubview(diaryCard)
        contentView.addSubview(nicknameLabel)
        
        diaryCard.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350.43)
            $0.height.equalTo(605)
        }
        
        diaryCardContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(164.77)
            $0.height.equalTo(284.47)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(diaryCardContainer.snp.bottom).offset(4)
        }
    }
    
    func configure(with card: DiaryCard) {
        let dateString = formatDate(card.cardContent.date)
        let emotion = Emotion(rawValue: card.cardContent.emotion) ?? .NORMAL

        nicknameLabel.text = card.cardContent.receiver

        // 질문과 답변을 튜플로 구성
        let qaPairs = card.cardContent.questionList.map { question in
            (
                question: question.content,
                answers: question.answerOption.isEmpty ? [question.answer] : question.answerOption,
                selectedIndex: question.answerOption.firstIndex(of: question.answer)
            )
        }

        diaryCard.configurePreview(nickname: card.cardContent.receiver, date: dateString, emotion: emotion, qaPairs: qaPairs)
    }

    private func formatDate(_ input: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"

        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyyMMdd"

        if let date = inputFormatter.date(from: input) {
            return outputFormatter.string(from: date)
        } else {
            return input
        }
    }
}

import SwiftUI
#Preview {
    BottomSheetCell()
}
