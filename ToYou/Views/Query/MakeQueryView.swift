//
//  MakeQueryView.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class MakeQueryView: UIView {
    
    public var queryType: QueryType?
    public var maxLength: Int = 0
    
    // MARK: Background & NavigationTop
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var popUpViewButton = UIButton().then {
        $0.setImage(.popUpIcon , for: .normal)
    }
    
    public lazy var confirmButton = ConfirmButton()
    
    private lazy var mainTitleLabel = UILabel().then {
        $0.text = "질문하기"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 17)
        $0.textColor = .black04
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = "질문 내용을 입력해주세요."
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = .black02
    }
    
    // 내용 작성 공간
    private lazy var emotionStateBubble = EmotionStateBubble()
    
    private lazy var bubbleFrame = UIView()
    
    private lazy var mainBubbleImage = UIImageView().then {
        $0.image = .mainMessageBubble
        $0.contentMode = .scaleToFill
        $0.isUserInteractionEnabled = true
    }
    
    public lazy var textCount = UILabel().then {
        $0.text = "(0/\(maxLength))"
        $0.font = UIFont(name: K.Font.s_core_extraLight, size: 10)
        $0.textColor = .black00
    }
    
    public lazy var textView = UITextView().then {
        $0.font = UIFont(name: K.Font.s_core_extraLight, size: 14)
        $0.textColor = .black04
        $0.backgroundColor = .white
    }
    
    public lazy var choicesCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10 // 셀 간 간격
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 68, height: 36)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(QueryChoiceCollectionViewCell.self, forCellWithReuseIdentifier: QueryChoiceCollectionViewCell.identifier)
        cv.showsVerticalScrollIndicator = false
        return cv
    }()
    
    public lazy var addQueryChoiceButton = UIButton().then {
        $0.backgroundColor = .white
        $0.setImage(.plus, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 5.31
        
        $0.imageView?.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(25)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackgroundAndBasicButtons()
        self.setTitleComponents()
        self.setEmotionStateBubbleConstraints()
        self.setTextViewBubble()
        self.setChoiceViewConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
 
extension MakeQueryView {
    
    public func shortQueryMode() {
        self.maxLength = 50
        textCount.text = "(0/\(maxLength))"
        choicesCollection.isHidden = true
        addQueryChoiceButton.isHidden = true
    }
    
    public func longQueryMode() {
        self.maxLength = 150
        textCount.text = "(0/\(maxLength))"
        choicesCollection.isHidden = true
        addQueryChoiceButton.isHidden = true
    }
    
    public func selectionMode() {
        self.maxLength = 50
        textCount.text = "(0/\(maxLength))"
        choicesCollection.isHidden = false
        addQueryChoiceButton.isHidden = false
    }
    
    private func setChoiceViewConstraints() {
        self.addSubview(choicesCollection)
        self.addSubview(addQueryChoiceButton)
        
        choicesCollection.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-35)
            make.top.equalTo(bubbleFrame.snp.bottom).offset(15)
            make.height.equalTo(82)
        }
        
        addQueryChoiceButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().offset(-35)
            make.top.equalTo(choicesCollection.snp.bottom).offset(15)
            make.height.equalTo(36)
        }
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
            make.top.equalTo(popUpViewButton.snp.bottom).offset(25)
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
        case .OPTIONAL:
            print("view mode is selection")
        case .SHORT_ANSWER:
            print("view mode is short")
        case .LONG_ANSWER:
            print("view mode is long")
        }
    }
    
    
}

import SwiftUI
#Preview{
    MakeQueryViewController()
}
