//
//  HomeResponse.swift
//  ToYou
//
//  Created by 김미주 on 3/26/25.
//

import Foundation

struct HomeResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: HomeResult
}

struct HomeResult: Decodable {
    let nickname: String?
    let emotion: String
    let questionNum: Int
    let cardId: Int?
    let uncheckedAlarm: Bool
}
