//
//  Home.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

struct Home {
    let emotion: String?
    let comment: String?
    let bubble: UIImage
    let color: UIColor
}

extension Home {
    static func dummy() -> [Home] {
        return [
            Home(emotion: "HAPPY", comment: "더 없이 행복한 하루였어요", bubble: .happyBubble, color: .yellow01),
            Home(emotion: "EXCITED", comment: "들뜨고 흥분돼요", bubble: .excitedBubble, color: .blue01),
            Home(emotion: "NORMAL", comment: "평범한 하루였어요", bubble: .normalBubble, color: .purple01),
            Home(emotion: "NERVOUS", comment: "생각이 많아지고 불안해요", bubble: .nervousBubble, color: .green01),
            Home(emotion: "ANGRY", comment: "부글부글 화가 나요", bubble: .angryBubble, color: .red01)
        ]
    }
}
