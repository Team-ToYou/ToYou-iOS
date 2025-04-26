//
//  ToYouResponse.swift
//  ToYou
//
//  Created by 이승준 on 3/21/25.
//
import Alamofire
import Foundation

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

extension URLSession {
    static func generateCurlCommand(url: String, method: HTTPMethod , headers: HTTPHeaders, parameters: [String: Any]?) {
        var methodString: String = ""
        switch method {
        case .get:
            methodString = "GET"
        case .delete:
            methodString = "DELETE"
        case .post:
            methodString = "POST"
        case .put:
            methodString = "PUT"
        case .get:
            methodString = "GET"
        case .patch:
            methodString = "PATCH"
        default :
            break
        }
        
        var curlCommand = "curl -X '\(methodString)' \\\n '\(url)'"
        
        for data in headers {
            curlCommand += " \\\n  -H '\(data.name): \(data.value)'"
        }
        
        if let parameters = parameters {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                curlCommand += " \\\n  -d '\(jsonString)'"
            }
        }
        
        print(curlCommand)
    }
}
