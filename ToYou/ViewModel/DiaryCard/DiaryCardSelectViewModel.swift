//
//  DiaryCardSelectViewModel.swift
//  ToYou
//
//  Created by 김미주 on 9/19/25.
//

import Foundation

class DiaryCardSelectViewModel: ObservableObject {
    @Published var questions: [Question] = [
        Question(questionId: 1, content: "요즘 어떻게 지내?1", questionType: .long, questioner: "미주", answerOption: nil),
        Question(questionId: 2, content: "요즘 어떻게 지내?2", questionType: .long, questioner: "미주", answerOption: nil),
        Question(questionId: 3, content: "요즘 어떻게 지내?3", questionType: .short, questioner: "미주", answerOption: nil),
        Question(questionId: 4, content: "요즘 어떻게 지내?4", questionType: .short, questioner: "미주", answerOption: nil),
        Question(questionId: 5, content: "요즘 어떻게 지내?5", questionType: .short, questioner: "미주", answerOption: nil),
        Question(questionId: 6, content: "요즘 어떻게 지내?6", questionType: .optional, questioner: "미주", answerOption: ["옵션 예시 1", "옵션 예시 2", "옵션 예시 3"]),
        Question(questionId: 7, content: "요즘 어떻게 지내?7", questionType: .optional, questioner: "미주", answerOption: ["옵션 예시 1", "옵션 예시 2"]),
    ]
    
    // 선택 토글
    func toggleSelection(for question: Question) {
        if let index = questions.firstIndex(where: { $0.questionId == question.questionId }) {
            questions[index].isSelected.toggle()
        }
    }
}
