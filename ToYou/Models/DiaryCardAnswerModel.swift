//
//  DiaryCardAnswerModel.swift
//  ToYou
//
//  Created by 김미주 on 4/28/25.
//

import Foundation

struct DiaryCardAnswerModel {
    let questionId: Int
    let question: String
    let answers: [String]
    let selectedIndex: Int?
}
