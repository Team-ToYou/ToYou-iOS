//
//  QueryType.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import Foundation

enum QueryType {
    case selection, short, long
    
    func title() -> String {
        switch self {
        case .selection:
            return "선택형"
        case .short:
            return "단답형"
        case .long:
            return "장문형"
        }
    }
    
    func subTitle() -> String {
        switch self {
        case .selection:
            return "(보기를 만들 수 있어요)"
        case .short:
            return "(간단하게 물어보세요)"
        case .long:
            return "(긴 답변을 원해요)"
        }

    }
}
