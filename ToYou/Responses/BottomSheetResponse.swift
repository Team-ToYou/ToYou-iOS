//
//  BottomSheetResponse.swift
//  ToYou
//
//  Created by 김미주 on 7/20/25.
//

import Foundation

struct BottomSheetResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: BottomSheetResult
}

struct BottomSheetResult: Codable {
    let cards: [DiaryCard]
}

struct DiaryCard: Codable {
    let cardId: Int
    let cardContent: DiaryCardContent
}

struct DiaryCardContent: Codable {
    let date: String
    let receiver: String
    let emotion: String
    let exposure: Bool
    let questionList: [DiaryQuestion]
}

struct DiaryQuestion: Codable {
    let questionId: Int
    let content: String
    let questionType: String
    let questioner: String
    let answer: String
    let answerOption: [String]
}
