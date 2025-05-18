//
//  queryApiService.swift
//  ToYou
//
//  Created by 이승준 on 5/12/25.
//

import Alamofire

struct QueryParameter {
    var targetId: Int?
    var content: String?
    var questionType: QueryType.RawValue?
    var anonymous: Bool?
    var answerOptionList: [String]?
}

enum QueryCode: String {
    case COMMON200, AUTH400, USER401, QUESTION400, QUESTION401,ERROR500
}

struct QueryPostResult: Codable {
    let myName: String?
}

class QueryApiService {
    var queryParamter = QueryParameter(targetId: nil, content: nil, questionType: nil, anonymous: nil, answerOptionList: nil)
    static var shared = QueryApiService()
    
    static func setTargetId(_ targetId: Int) {
        QueryApiService.shared.queryParamter.targetId = targetId
    }
    
    static func setContent(_ content: String) {
        QueryApiService.shared.queryParamter.content = content
    }
    
    static func setQuestionType(_ type: QueryType) {
        QueryApiService.shared.queryParamter.questionType = type.rawValue
        switch type {
        case .OPTIONAL:
            QueryApiService.shared.queryParamter.answerOptionList = ["1번 선택지", "2번 선택지"]
        case .SHORT_ANSWER, .LONG_ANSWER:
            QueryApiService.shared.queryParamter.answerOptionList = nil
        }
    }
    
    static func setAnonymous(_ anonymous: Bool) {
        QueryApiService.shared.queryParamter.anonymous = anonymous
    }
    
    static func updateQueryOptionList(at: Int, to: String) {
        if let _ = QueryApiService.shared.queryParamter.answerOptionList {
            QueryApiService.shared.queryParamter.answerOptionList![at] = to
        }
    }
    
    static func removeQueryOption(at: Int) {
        QueryApiService.shared.queryParamter.answerOptionList?.remove(at: at)
    }
    
    static func addQueryOption(_ option: String) {
        if let _ = QueryApiService.shared.queryParamter.answerOptionList {
            QueryApiService.shared.queryParamter.answerOptionList!.append(option)
        } else {
            QueryApiService.shared.queryParamter.answerOptionList = [option]
        }
    }
    
    static func postQuestion(completion: @escaping(QueryCode) -> Void) {
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        let tail = "/questions"
        let url = K.URLString.baseURL + tail
        let headers: HTTPHeaders = [
            "accept": "*/*",
            "Authorization": "Bearer \(accessToken)",
            "Content-Type": "application/json"
        ]
        let parameters: [String: Any] = [
            "targetId": QueryApiService.shared.queryParamter.targetId ?? -1,
            "content": QueryApiService.shared.queryParamter.content ?? "",
            "questionType": QueryApiService.shared.queryParamter.questionType ?? QueryType.SHORT_ANSWER.rawValue,
            "anonymous": QueryApiService.shared.queryParamter.anonymous ?? false,
            "answerOptionList": QueryApiService.shared.queryParamter.answerOptionList
        ]
        AF.request(
            url,
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
        ).responseDecodable( of: ToYouResponse<QueryPostResult>.self ) { response in
            switch response.result {
                case .success(let value):
                    print("post \(tail) success: \(value)")
                    print("code \(value.code)")
                    switch value.code {
                    case QueryCode.COMMON200.rawValue :
                        completion(.COMMON200)
                    case QueryCode.AUTH400.rawValue:
                        completion(.AUTH400)
                    case QueryCode.USER401.rawValue:
                        completion(.USER401)
                    case QueryCode.QUESTION400.rawValue:
                        completion(.QUESTION400)
                    case QueryCode.QUESTION401.rawValue:
                        completion(.QUESTION401)
                    default:
                        print("post \(tail) exception code error: \(value.code)")
                        completion(.ERROR500)
                    }
                case .failure(let error):
                    print("post \(tail) failure: \(error)")
                    completion(.ERROR500)
            }
        }
        
        QueryApiService.shared.queryParamter = QueryParameter(targetId: nil, content: nil, questionType: nil, anonymous: nil, answerOptionList: nil)
    }
    
}
