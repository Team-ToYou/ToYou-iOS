//
//  Font.swift
//  ToYou
//
//  Created by 김미주 on 9/19/25.
//

import SwiftUI

extension Font {
    // MARK: - Gangwon
    enum Gangwon {
        case medium
        
        var value: String {
            switch self {
            case .medium:
                return "GangwonEduHyeonokT_OTFMedium"
            }
        }
    }
    
    static func ganwon(type: Gangwon, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    static var gangwon15: Font {
        return ganwon(type: .medium, size: 15)
    }
    
    static var gangwon16: Font {
        return ganwon(type: .medium, size: 16)
    }
    
    static var gangwon10: Font {
        return ganwon(type: .medium, size: 10)
    }
    
    static var gangwon18: Font {
        return ganwon(type: .medium, size: 18)
    }
    
    static var gangwon20: Font {
        return ganwon(type: .medium, size: 20)
    }
    
    static var gangwon22: Font {
        return ganwon(type: .medium, size: 22)
    }
    
    static var gangwon25: Font {
        return ganwon(type: .medium, size: 25)
    }
    
    static var gangwon30: Font {
        return ganwon(type: .medium, size: 30)
    }
    
    // MARK: - SCore
    enum SCore {
        case extralight
        case light
        case regular
        case medium
        
        var value: String {
            switch self {
            case .extralight:
                return "S-CoreDream-2ExtraLight"
            case .light:
                return "S-CoreDream-3Light"
            case .regular:
                return "S-CoreDream-4Regular"
            case .medium:
                return "S-CoreDream-5Medium"
            }
        }
    }
    
    static func s_core(type: SCore, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    
    // ExtraLight
    static var SCoreExtraLight10: Font {
        return s_core(type: .extralight, size: 10)
    }
    
    static var SCoreExtraLight11: Font {
        return s_core(type: .extralight, size: 11)
    }
    
    // Light
    static var SCoreLight8: Font {
        return s_core(type: .light, size: 8)
    }
    
    static var SCoreLight10: Font {
        return s_core(type: .light, size: 10)
    }
    
    static var SCoreLight12: Font {
        return s_core(type: .light, size: 12)
    }
    
    // Regular
    static var SCoreRegular10: Font {
        return s_core(type: .regular, size: 10)
    }
    
    static var SCoreRegular12: Font {
        return s_core(type: .regular, size: 12)
    }
    
    static var SCoreRegular15: Font {
        return s_core(type: .regular, size: 15)
    }
    
    static var SCoreRegular16: Font {
        return s_core(type: .regular, size: 16)
    }
    
    static var SCoreRegular17: Font {
        return s_core(type: .regular, size: 17)
    }
    
    // Medium
    static var SCoreMedium13: Font {
        return s_core(type: .medium, size: 13)
    }
    
    static var SCoreMedium15: Font {
        return s_core(type: .medium, size: 15)
    }
    
    static var SCoreMedium17: Font {
        return s_core(type: .medium, size: 17)
    }
    
    static var SCoreMedium18: Font {
        return s_core(type: .medium, size: 18)
    }
    
    static var SCoreMedium20: Font {
        return s_core(type: .medium, size: 20)
    }
}
