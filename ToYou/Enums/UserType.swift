//
//  UserType.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import Foundation

enum UserType: String {
    case student, college, office , ect
    
    func rawValueForAPI() -> String {
        switch self {
        case .student:
            return "STUDENT"
        case .college:
            return "COLLEGE"
        case .office:
            return "OFFICE"
        case .ect:
            return "ETC"
        }
    }
}
