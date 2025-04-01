//
//  ToYouResponse.swift
//  ToYou
//
//  Created by 이승준 on 3/21/25.
//

struct ToYouResponse<T: Codable> : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: T?
}

struct ToYouResponseWithoutResult : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

struct ToYouErrorResponse : Codable {
    let isSuccess: Bool
    let code: String
    let message: String
}

struct ToYou400ErrorResponse: Codable {
    let type: String
    let title: String
    let status: Int
    let detail: String
    let instance: String
}

struct EmptyResult: Codable {}
