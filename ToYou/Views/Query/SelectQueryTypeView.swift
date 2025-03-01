//
//  SelectQueryTypeView.swift
//  ToYou
//
//  Created by 이승준 on 2/28/25.
//

import UIKit

class SelectQueryTypeView: UIView {
    
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
    
    private lazy var selectionFrame = UIView()
    
    private lazy var queryTypeSelectionBubble = UIImageView().then {
        $0.image = .mainMessageBubble
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    public lazy var selectionQueryTypeButton = QueryTypeButton()
    public lazy var shortQueryTypeButton = QueryTypeButton()
    public lazy var longQueryTypeButton = QueryTypeButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackgroundAndBasicButtons()
        self.setTitleComponents()
        self.setEmotionStateBubbleConstraints()
        self.setQueryTypeSelectionConstraints()
    }
    
    private func setQueryTypeSelectionConstraints() {
        self.addSubview(selectionFrame)
        
        selectionFrame.snp.makeConstraints { make in
            make.top.equalTo(emotionStateBubble.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(98)
        }
        
        selectionFrame.addSubview(queryTypeSelectionBubble)
        
        queryTypeSelectionBubble.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectionQueryTypeButton.configure(type: .selection)
        shortQueryTypeButton.configure(type: .short)
        longQueryTypeButton.configure(type: .long)
        
        selectionFrame.addSubview(selectionQueryTypeButton)
        selectionFrame.addSubview(shortQueryTypeButton)
        selectionFrame.addSubview(longQueryTypeButton)
        
        selectionQueryTypeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.leading.equalToSuperview().offset(27)
            make.width.equalTo(70)
            make.height.equalTo(76)
        }
        
        shortQueryTypeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.centerX.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(76)
        }
        
        longQueryTypeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(11)
            make.trailing.equalToSuperview().inset(27)
            make.width.equalTo(70)
            make.height.equalTo(76)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(as emotion: Emotion?) {
        emotionStateBubble.configure(as: emotion)
    }
    
}

import SwiftUI
#Preview {
    SelectQueryViewController()
}
