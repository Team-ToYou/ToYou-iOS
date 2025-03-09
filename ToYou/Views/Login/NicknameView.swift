//
//  NicknameView.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class NicknameView: UIView {
    
    // MARK: Main Components
    private lazy var mainLabel = UILabel().then {
        $0.text = "투유에서 사용할 닉네임을 알려주세요."
        $0.font = UIFont(name: K.Font.s_core_regular , size: 16)
        $0.textColor = .black04
    }
    
    public lazy var nicknameTextField = UITextField().then {
        $0.placeholder = "닉네임을 입력해주세요"
        $0.textColor = .black04
        $0.tintColor = .black01
        $0.font = UIFont(name: K.Font.s_core_light, size: 15)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7
        
        $0.enablesReturnKeyAutomatically = false
        $0.autocapitalizationType = .none
        $0.autocorrectionType = .no
        $0.spellCheckingType = .no
    }
    
    private lazy var warningLabel = UILabel().then {
        $0.text = "중복된 닉네임인지 확인해주세요."
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    public lazy var maxTextLength = UILabel().then {
        $0.text = "(0/15)"
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .gray00
    }
    
    public lazy var overlappedCheck = CheckButton()
    
    // MARK: Background & NavigationTop
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var popUpViewButton = UIButton().then {
        $0.setImage(.popUpIcon , for: .normal)
    }
    
    private lazy var signUpLabel = UILabel().then {
        $0.text = "회원가입"
        $0.textColor = .black04
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
    }
    
    private lazy var signUpTopLine = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    public lazy var nextButton = ConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackground()
        self.signUpTopTitleComponents()
        self.addComponents()
        self.setUpNextButton()
        self.addLeftViewInTextField()
        overlappedCheck.unavailable()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NicknameView {
    public func defaultState() {
        warningLabel.text = "중복된 닉네임인지 확인해주세요."
        warningLabel.textColor = .black04
        nextButton.unavailable()
        overlappedCheck.unavailable()
    }
    
    public func properTextLength() {
        warningLabel.text = "중복된 닉네임인지 확인해주세요."
        warningLabel.textColor = .black04
        overlappedCheck.available()
        nextButton.unavailable()
    }
    
    public func satisfiedNickname() {
        warningLabel.text = "사용 가능한 닉네임입니다."
        warningLabel.textColor = .red02
        nextButton.available()
    }
    
    public func unsatisfiedNickname() {
        warningLabel.text = "이미 사용 중인 닉네임입니다."
        warningLabel.textColor = .red02
        nextButton.unavailable()
        overlappedCheck.unavailable()
    }
    
    public func textLengthWarning() {
        warningLabel.text = "15자 이내로 입력해주세요."
        warningLabel.textColor = .black04
        overlappedCheck.unavailable()
        nextButton.unavailable()
    }
}

extension NicknameView {
    
    private func addComponents() {
        self.addSubview(mainLabel)
        self.addSubview(nicknameTextField)
        nicknameTextField.addSubview(maxTextLength)
        self.addSubview(overlappedCheck)
        self.addSubview(warningLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(signUpTopLine).offset(96)
        }
        
        overlappedCheck.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-22)
            make.top.equalTo(mainLabel.snp.bottom).offset(10)
        }
        
        nicknameTextField.setPlaceholder(text: "닉네임을 입력해주세요", color: .gray00)
        
        nicknameTextField.snp.makeConstraints { make in
            make.centerY.equalTo(overlappedCheck.snp.centerY)
            make.trailing.equalTo(overlappedCheck.snp.leading).offset(-11)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(40)
        }
        
        maxTextLength.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(9)
            make.leading.equalToSuperview().offset(20)
        }
        
    }
    
    private func setupBackground() {
        self.addSubview(paperBackground)
        
        paperBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func signUpTopTitleComponents() {
        self.addSubview(popUpViewButton)
        self.addSubview(signUpLabel)
        self.addSubview(signUpTopLine)
        
        signUpLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(19)
            make.centerX.equalToSuperview()
        }
        
        popUpViewButton.snp.makeConstraints { make in
            make.centerY.equalTo(signUpLabel.snp.centerY)
            make.leading.equalToSuperview().offset(17)
            make.height.width.equalTo(23)
        }
        
        signUpTopLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(signUpLabel.snp.bottom).offset(13)
        }
    }
    
    private func setUpNextButton() {
        self.addSubview(nextButton)
        
        nextButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(K.BottomButtonConstraint.leadingTrailing)
            make.bottom.equalToSuperview().inset(K.BottomButtonConstraint.bottomPadding)
        }
    }

}

extension NicknameView {
    
    private func addLeftViewInTextField() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: 33))
        nicknameTextField.leftView = paddingView
        nicknameTextField.leftViewMode = .always
    }
    
}


import SwiftUI
#Preview{
    NicknameViewController()
}
