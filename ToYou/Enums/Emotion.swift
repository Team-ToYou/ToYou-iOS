//
//  Emotion.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

enum Emotion: String, Codable {
    
    case ANGRY, NERVOUS, EXCITED, HAPPY, NORMAL
    
    func stampImage() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryStamp
        case .NERVOUS:
            return .nervousStamp
        case .EXCITED:
            return .excitedStamp
        case .HAPPY:
            return .happyStamp
        case .NORMAL:
            return .normalStamp
        }
    }
    
    func emotionExplanation() -> String {
        switch self {
        case .ANGRY:
            return "부글부글 화가 나요"
        case .NERVOUS:
            return "생각이 많아지고 불안해요"
        case .EXCITED:
            return "들뜨고 흥분돼요"
        case .HAPPY:
            return "더없이 행복한 하루였어요"
        case .NORMAL:
            return "평범한 하루였어요"
        }
    }
    
    func faceImage() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryFace
        case .NERVOUS:
            return .nervousFace
        case .EXCITED:
            return .excitedFace
        case .HAPPY:
            return .happyFace
        case .NORMAL:
            return .normalFace
        }
    }
    
    func messageBubble() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryStateBubble
        case .NERVOUS:
            return .nervousStateBubble
        case .EXCITED:
            return .excitedStateBubble
        case .HAPPY:
            return .happyStateBubble
        case .NORMAL:
            return .normalStateBubble
        }
    }
    
}


