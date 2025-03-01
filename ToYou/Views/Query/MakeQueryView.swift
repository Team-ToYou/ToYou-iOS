//
//  MakeQueryView.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class MakeQueryView: UIView {
    
    // MARK: Background & NavigationTop
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var popUpViewButton = UIButton().then {
        $0.setImage(.popUpIcon , for: .normal)
    }
    
    public lazy var confirmButton = ConfirmButtonView()
    
    private lazy var mainTitleLabel = UILabel().then {
        $0.text = "질문하기"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 17)
        $0.textColor = .black04
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = "질문 유형을 선택해주세요"
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = .black02
    }
    
    private lazy var emotionStateBubble = EmotionStateBubble()
    
    private lazy var bubbleFrame = UIView()
    
    private lazy var mainBubbleImage = UIImageView().then {
        $0.image = .mainMessageBubble
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    public lazy var textCount = UILabel().then {
        $0.text = "(0/50)"
        $0.font = UIFont(name: K.Font.s_core_extraLight, size: 10)
        $0.textColor = .black00
    }
    
    public lazy var textView = UITextView().then {
        $0.font = UIFont(name: K.Font.s_core_extraLight, size: 14)
        $0.textColor = .black04
        $0.backgroundColor = .white
    }
    
    // 선택형: 2개 ~3개만 필요
    // 최소한 2개는 필요?
    
    // 1. CollectionView로 구현
    // 2. 야매로 구현 => X
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackgroundAndBasicButtons()
        self.setTitleComponents()
        self.setEmotionStateBubbleConstraints()
        self.setTextViewBubble()
    }
    
    private func setTextViewBubble() {
        self.addSubview(bubbleFrame)
        
        bubbleFrame.snp.makeConstraints { make in
            make.top.equalTo(emotionStateBubble.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(98)
        }
        
        bubbleFrame.addSubview(mainBubbleImage)
        bubbleFrame.addSubview(textCount)
        bubbleFrame.addSubview(textView)
        
        mainBubbleImage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        textCount.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(18)
            make.bottom.equalToSuperview().inset(5)
        }
        
        textView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(8)
            make.bottom.equalTo(textCount.snp.top).inset(-8)
        }
    }
    
    private func setEmotionStateBubbleConstraints() {
        self.addSubview(emotionStateBubble)
        
        emotionStateBubble.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(divider.snp.bottom).offset(10)
            make.height.equalTo(31)
        }
    }
    
    private func setTitleComponents() {
        self.addSubview(mainTitleLabel)
        self.addSubview(subTitleLabel)
        self.addSubview(divider)
        
        mainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(popUpViewButton.snp.bottom).offset(75)
            make.leading.equalToSuperview().offset(40)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(40)
        }
        
        divider.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(7)
            make.leading.trailing.equalToSuperview().inset(36)
            make.height.equalTo(1)
        }
    }
    
    private func setupBackgroundAndBasicButtons() {
        self.addSubview(paperBackground)
        self.addSubview(popUpViewButton)
        self.addSubview(confirmButton)
        
        paperBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        popUpViewButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(17)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.height.width.equalTo(20)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalToSuperview().inset(70)
        }
    }

    public func configure(as emotion: Emotion?) {
        emotionStateBubble.configure(as: emotion)
    }
    
    public func setQueryType(queryType: QueryType) {
        switch queryType {
        case .selection:
            print("view mode is selection")
        case .short:
            print("view mode is short")
        case .long:
            print("view mode is long")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
