//
//  MyDiaryCardResponse.swift
//  ToYou
//
//  Created by 김미주 on 5/12/25.
//

import Foundation

struct MyDiaryCardResponse: Decodable {
    let isSuccess: Bool
    let result: MyDiaryCardResponseResult
}

struct MyDiaryCardResponseResult: Decodable {
    let cardList: [MyDiaryCardItem]
}

struct MyDiaryCardItem: Decodable {
    let cardId: Int
    let emotion: String
    let date: String
}
