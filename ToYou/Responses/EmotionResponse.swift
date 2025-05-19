//
//  EmotionResponse.swift
//  ToYou
//
//  Created by 김미주 on 3/26/25.
//

import Foundation

struct EmotionResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmotionEmptyResult?
}

struct EmotionEmptyResult: Decodable {}
