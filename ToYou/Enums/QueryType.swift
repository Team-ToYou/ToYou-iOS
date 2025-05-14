//
//  QueryType.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import Foundation

enum QueryType: String, Codable {
    case OPTIONAL, SHORT_ANSWER, LONG_ANSWER
    
    func title() -> String {
        switch self {
        case .OPTIONAL:
            return "선택형"
        case .SHORT_ANSWER:
            return "단답형"
        case .LONG_ANSWER:
            return "장문형"
        }
    }
    
    func subTitle() -> String {
        switch self {
        case .OPTIONAL:
            return "(보기를 만들 수 있어요)"
        case .SHORT_ANSWER:
            return "(간단하게 물어보세요)"
        case .LONG_ANSWER:
            return "(긴 답변을 원해요)"
        }
    }
}
