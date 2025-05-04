//
//  Emotion.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

enum Emotion: String, Codable {
    
    case angry, worried, excited, happy, normal
    
    func stampImage() -> UIImage {
        switch self {
        case .angry:
            return .angryStamp
        case .worried:
            return .worriedStamp
        case .excited:
            return .excitedStamp
        case .happy:
            return .happyStamp
        case .normal:
            return .normalStamp
        }
    }
    
    func emotionExplanation() -> String {
        switch self {
        case .angry:
            return "부글부글 화가 나요"
        case .worried:
            return "생각이 많아지고 불안해요"
        case .excited:
            return "들뜨고 흥분돼요"
        case .happy:
            return "더없이 행복한 하루였어요"
        case .normal:
            return "평범한 하루였어요"
        }
    }
    
    func faceImage() -> UIImage {
        switch self {
        case .angry:
            return .angryFace
        case .worried:
            return .worriedFace
        case .excited:
            return .excitedFace
        case .happy:
            return .happyFace
        case .normal:
            return .normalFace
        }
    }
    
    func messageBubble() -> UIImage {
        switch self {
        case .angry:
            return .angryStateBubble
        case .worried:
            return .worriedStateBubble
        case .excited:
            return .excitedStateBubble
        case .happy:
            return .happyStateBubble
        case .normal:
            return .normalStateBubble
        }
    }
    
}


