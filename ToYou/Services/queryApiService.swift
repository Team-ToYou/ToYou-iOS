//
//  queryApiService.swift
//  ToYou
//
//  Created by 이승준 on 5/12/25.
//

import Alamofire

struct QueryParamter {
    var targetId: Int?
    var content: String?
    var questionType: QueryType.RawValue?
    var anonymous: Bool?
    var answerOptionList: [String]?
}

enum QueryCode: String {
    case COMMON200
}

class QueryApiService {
    var queryParamter = QueryParamter(targetId: nil, content: nil, questionType: nil, anonymous: nil, answerOptionList: ["선택 1", "선택 2", "선택 3"])
    static var shared = QueryApiService()
    
    static func setTargetId(_ targetId: Int) {
        QueryApiService.shared.queryParamter.targetId = targetId
    }
    
    static func setContent(_ content: String) {
        QueryApiService.shared.queryParamter.content = content
    }
    
    static func setQuestionType(_ type: QueryType) {
        QueryApiService.shared.queryParamter.questionType = type.rawValue
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
    
    static func postQuestion() {
        
    }
    
}
