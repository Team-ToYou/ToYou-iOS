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
    
    func emotionBubble() -> UIImage {
        switch self {
        case .ANGRY:
            return .angryBubble
        case .NERVOUS:
            return .nervousBubble
        case .EXCITED:
            return .excitedBubble
        case .HAPPY:
            return .happyBubble
        case .NORMAL:
            return .normalBubble
        }
    }
    
    func mainColor() -> UIColor {
        switch self {
        case .ANGRY:
            return .red00
        case .NERVOUS:
            return .green00
        case .EXCITED:
            return .blue00
        case .HAPPY:
            return .yellow00
        case .NORMAL:
            return .purple00
        }
    }
    
    func pointColor() -> UIColor {
        switch self {
        case .ANGRY:
            return .red01
        case .NERVOUS:
            return .green01
        case .EXCITED:
            return .blue01
        case .HAPPY:
            return .yellow01
        case .NORMAL:
            return .purple01
        }
    }
    
}


