//
//  MyPage.swift
//  ToYou
//
//  Created by 이승준 on 4/3/25.
//

import Foundation

struct MyPageResult: Codable {
    let userId: Int?
    let nickname: String?
    let friendNum: Int?
    let status: UserType?
}
