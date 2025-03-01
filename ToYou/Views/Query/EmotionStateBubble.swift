//
//  EmotionStateBubble.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class EmotionStateBubble: UIView {
    
    private lazy var messageBubbleImage = UIImageView().then {
        $0.image = .defaultStateBubble
        $0.contentMode = .scaleToFill
    }

    private lazy var contentLabel = UILabel().then {
        $0.text = "친구가 아직 감정우표를 선택하지 않았어요"
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 16)
        $0.textColor = .black04
    }
    
    private lazy var faceImage = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addComponents()
    }
    
    private func addComponents() {
        self.addSubview(messageBubbleImage)
        self.addSubview(contentLabel)
        self.addSubview(faceImage)
        
        messageBubbleImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(17)
        }
        
        faceImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(contentLabel.snp.trailing).offset(7)
        }
    }
    
    public func configure(as type: Emotion?) {
        if let type {
            messageBubbleImage.image = type.messageBubble()
            contentLabel.text = type.emotionExplanation()
            faceImage.image = type.faceImage()
        } else {
            messageBubbleImage.image = .defaultStateBubble
            contentLabel.text = "친구가 아직 감정우표를 선택하지 않았어요"
            faceImage.image = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
