//
//  fcmRsponses.swift
//  ToYou
//
//  Created by 이승준 on 3/17/25.
//

import Foundation

// 응답 구조체 정의
struct FCMResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: EmptyResult?
}

// 빈 결과를 위한 타입
struct EmptyResult: Codable {}
