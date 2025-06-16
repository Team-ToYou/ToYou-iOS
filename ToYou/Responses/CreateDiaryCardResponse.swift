//
//  CreateDiaryCardResponse.swift
//  ToYou
//
//  Created by 김미주 on 5/5/25.
//

struct CreateDiaryCardResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: DiaryCardResult?
}

struct DiaryCardResult: Decodable {
    let cardId: Int
}
