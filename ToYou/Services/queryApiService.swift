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
    var queryParamter = QueryParamter(targetId: nil, content: nil, questionType: nil, anonymous: nil)
    static var shared = QueryApiService()
    
    static func setTargetId(_ targetId: Int) {
        QueryApiService.shared.queryParamter.targetId = targetId
    }
    
    static func setContent(_ content: String) {
        QueryApiService.shared.queryParamter.content = content
    }
    
    static func postQuestion() {
        
    }
    
}
