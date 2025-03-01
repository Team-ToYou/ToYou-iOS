//
//  FriendInfo.swift
//  ToYou
//
//  Created by 이승준 on 2/27/25.
//

import Foundation

struct FriendInfo {
    let nickname: String
    let emotion: Emotion?
}

class FriendsModel {
    static let dummies: [FriendInfo] = [
        FriendInfo(nickname: "민준", emotion: .happy),
        FriendInfo(nickname: "서연", emotion: .excited),
        FriendInfo(nickname: "도윤", emotion: .normal),
        FriendInfo(nickname: "지민", emotion: .worried),
        FriendInfo(nickname: "예준", emotion: .angry),
        FriendInfo(nickname: "하은", emotion: nil),
        FriendInfo(nickname: "주원", emotion: .normal),
        FriendInfo(nickname: "소율", emotion: .excited),
        FriendInfo(nickname: "지호", emotion: .worried),
        FriendInfo(nickname: "수아", emotion: .angry),
        FriendInfo(nickname: "현우", emotion: .happy),
        FriendInfo(nickname: "지윤", emotion: .normal),
        FriendInfo(nickname: "준서", emotion: .excited),
        FriendInfo(nickname: "하린", emotion: .worried),
        FriendInfo(nickname: "건우", emotion: nil),
        FriendInfo(nickname: "소민", emotion: .happy),
        FriendInfo(nickname: "태민", emotion: .normal),
        FriendInfo(nickname: "예린", emotion: .excited),
        FriendInfo(nickname: "우진", emotion: .worried),
        FriendInfo(nickname: "민서", emotion: .angry)
    ]
}
