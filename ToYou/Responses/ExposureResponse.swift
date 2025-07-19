//
//  ExposureResponse.swift
//  ToYou
//
//  Created by 김미주 on 7/20/25.
//

import Foundation

struct ExposureResponse: Decodable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: ExposureResult?
}

struct ExposureResult: Decodable {
    let exposure: Bool
}
