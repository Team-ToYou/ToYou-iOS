//
//  FriendDiaryCardResponse.swift
//  ToYou
//
//  Created by 김미주 on 5/19/25.
//

import Foundation

// year - month
struct FriendCardCountResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FriendCardCountResult
}

struct FriendCardCountResult: Decodable {
    let cardList: [FriendCardCount]
}

struct FriendCardCount: Decodable {
    let cardNum: Int
    let date: String // "yyyy-MM-dd"
}

// year - month - day
struct FriendDiaryCardResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: FriendDiaryCardResult
}

struct FriendDiaryCardResult: Decodable {
    let cardList: [FriendDiaryCard]
}

struct FriendDiaryCard: Decodable {
    let cardId: Int
    let nickname: String
    let emotion: String
    let date: String?
}
