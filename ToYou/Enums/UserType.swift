//
//  UserType.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import Foundation

enum UserType: String, Codable {
    case SCHOOL, COLLEGE, OFFICE , ETC
    
    func rawValueForAPI() -> String {
        switch self {
        case .SCHOOL:
            return "SCHOOL"
        case .COLLEGE:
            return "COLLEGE"
        case .OFFICE:
            return "OFFICE"
        case .ETC:
            return "ETC"
        }
    }
}
