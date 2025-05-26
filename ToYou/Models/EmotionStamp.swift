//
//  EmotionStamp.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

struct EmotionStamp {
    let emotion: String
    let image: UIImage
    let label: String
    let color: UIColor
    let result: String
}

extension EmotionStamp {
    static func dummy() -> [EmotionStamp] {
        return [
            EmotionStamp(emotion: "HAPPY", image: .happyStamp, label: "더없이 행복한 하루였어요", color: .yellow01, result: "너무 행복한 날이었나봐요!\n이 소중한 순간을 꼭 기록해봐요"),
            EmotionStamp(emotion: "EXCITED", image: .excitedStamp, label: "들뜨고 흥분돼요", color: .blue01, result: "좋은 기분이네요!\n이 기분을 느끼면서 즐겨보세요"),
            EmotionStamp(emotion: "NORMAL", image: .normalStamp, label: "평범한 하루였어요", color: .purple01, result: "가끔은 아무 생각 없는 게 좋죠"),
            EmotionStamp(emotion: "WORRIED", image: .nervousStamp, label: "생각이 많아지고 불안해요", color: .green01, result: "그런 날도 있죠.\n차근차근 풀어나갈 수 있을 거예요"),
            EmotionStamp(emotion: "ANGRY", image: .angryStamp, label: "부글부글 화가 나요", color: .red02, result: "화가 나는 날도 있죠.\n함께 해결책을 찾아봐요")
        ]
    }
}
