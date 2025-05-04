//
//  Emotion.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

enum Emotion: String, Codable {
    
    case ANGRY, WORRIED, EXCITED, HAPPY, NROMAL
    
    func stampImage() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryStamp
        case .WORRIED:
            return .worriedStamp
        case .EXCITED:
            return .excitedStamp
        case .HAPPY:
            return .happyStamp
        case .NROMAL:
            return .normalStamp
        }
    }
    
    func emotionExplanation() -> String {
        switch self {
        case .ANGRY:
            return "부글부글 화가 나요"
        case .WORRIED:
            return "생각이 많아지고 불안해요"
        case .EXCITED:
            return "들뜨고 흥분돼요"
        case .HAPPY:
            return "더없이 행복한 하루였어요"
        case .NROMAL:
            return "평범한 하루였어요"
        }
    }
    
    func faceImage() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryFace
        case .WORRIED:
            return .worriedFace
        case .EXCITED:
            return .excitedFace
        case .HAPPY:
            return .happyFace
        case .NROMAL:
            return .normalFace
        }
    }
    
    func messageBubble() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryStateBubble
        case .WORRIED:
            return .worriedStateBubble
        case .EXCITED:
            return .excitedStateBubble
        case .HAPPY:
            return .happyStateBubble
        case .NROMAL:
            return .normalStateBubble
        }
    }
    
}


