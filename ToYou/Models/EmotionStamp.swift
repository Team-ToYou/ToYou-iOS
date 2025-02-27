//
//  EmotionStamp.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

struct EmotionStamp {
    let image: UIImage
    let label: String
}

extension EmotionStamp {
    static func dummy() -> [EmotionStamp] {
        return [
            EmotionStamp(image: .happyStamp, label: "더없이 행복한 하루였어요"),
            EmotionStamp(image: .excitedStamp, label: "들뜨고 흥분돼요"),
            EmotionStamp(image: .normalStamp, label: "평범한 하루였어요"),
            EmotionStamp(image: .worriedStamp, label: "생각이 많아지고 불안해요"),
            EmotionStamp(image: .angryStamp, label: "부글부글 화가 나요")
        ]
    }
}
