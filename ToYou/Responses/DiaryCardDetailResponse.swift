//
//  DiaryCardResponse.swift
//  ToYou
//
//  Created by 김미주 on 6/16/25.
//

import Foundation

struct DiaryCardDetailResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DiaryCardDetailResult
}

struct DiaryCardDetailResult: Decodable {
    let date: String
    let receiver: String
    let emotion: String
    let exposure: Bool
    let questionList: [DiaryCardQuestion]
}

struct DiaryCardQuestion: Decodable {
    let questionId: Int
    let content: String
    let questionType: String
    let questioner: String
    let answer: String
    let answerOption: [String]
}
