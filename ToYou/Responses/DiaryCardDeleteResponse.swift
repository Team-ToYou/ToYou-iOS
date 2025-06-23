//
//  DiaryCardDeleteResponse.swift
//  ToYou
//
//  Created by 김미주 on 6/23/25.
//

struct DiaryCardDeleteResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
}
