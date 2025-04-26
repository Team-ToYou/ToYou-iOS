//
//  K.swift
//  ToYou
//
//  Created by 이승준 on 2/5/25.
//

import UIKit

struct K {
    struct Font {
        static let s_core_extraLight = "S-CoreDream-2ExtraLight"
        static let s_core_light = "S-CoreDream-3Light"
        static let s_core_regular = "S-CoreDream-4Regular"
        static let s_core_medium = "S-CoreDream-5Medium"
        static let gangwonEduHyeonokT_OTFMedium = "GangwonEduHyeonokT_OTFMedium"
    }
    
    struct BottomButtonConstraint {
        static let leadingTrailing: CGFloat = 32
        static let bottomPadding: CGFloat = 40
    }
    
    struct URLString {
        static let baseURL = "https://to-you.store"
        
        // 약관, 피드백, 질문 링크
        static let privacyPolicyLink = "https://sumptuous-metacarpal-d3a.notion.site/1437c09ca64e80fb88f6d8ab881ffee3?pvs=74"
        static let sendFeedbackLink = "https://forms.gle/fJweAP16cT4Tc3cA6"
        static let sendQueryLink = "http://pf.kakao.com/_xiuPIn/chat"
    }
    
    struct Key {
        static let accessToken = "accessToken"
        static let refreshToken = "refreshToken"
        static let tutorial = "Tutorial" // 튜토리얼을 했는지 안했는지 확인하기 위함
        static let fcmToken = "fcmToken" // FCM 토큰 키
    }
    
}
