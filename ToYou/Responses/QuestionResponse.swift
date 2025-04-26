//
//  QuestionResponse.swift
//  ToYou
//
//  Created by 김미주 on 3/31/25.
//

import Foundation

struct QuestionResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: QuestionListResult
}

struct QuestionListResult: Codable {
    let questionList: [Question]
}

struct Question: Codable {
    let questionId: Int
    let content: String
    let questionType: QuestionType
    let questioner: String
    let answerOption: [String]?
}

enum QuestionType: String, Codable {
    case long = "LONG_ANSWER"
    case short = "SHORT_ANSWER"
    case optional = "OPTIONAL"
}
