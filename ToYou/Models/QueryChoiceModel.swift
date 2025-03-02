//
//  QueryChoiceModel.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import Foundation

class QueryChoiceModel {
    static var shared: [String] = ["짜장면", "짬뽕"]
    
    static func update(at: Int, to: String) {
        shared[at] = to
    }
}
