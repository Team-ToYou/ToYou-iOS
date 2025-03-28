//
//  UserType.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import Foundation

enum UserType: String {
    case school, college, office , etc
    
    func rawValueForAPI() -> String {
        switch self {
        case .school:
            return "SCHOOL"
        case .college:
            return "COLLEGE"
        case .office:
            return "OFFICE"
        case .etc:
            return "ETC"
        }
    }
}
