//
//  UserTypePickerView.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit

class UserTypePickerView: UIView {
    
    // MARK: Main Components
    private lazy var mainLabel = UILabel().then {
        $0.text = "현재 상태를 알려주세요."
        $0.font = UIFont(name: K.Font.s_core_regular , size: 16)
        $0.textColor = .black04
    }
    
    private lazy var subLabel = UILabel().then {
        $0.text = "선택하신 정보를 기반으로 맞춤형 질문을 추천해드립니다.\n다른 목적으로 사용되거나 제 3자에게 제공되지 않습니다."
        $0.numberOfLines = 2
        $0.font = UIFont(name: K.Font.s_core_regular , size: 12)
        $0.textAlignment = .center
        $0.textColor = .black02
    }
    
    private lazy var studentButton = UserTypeButton()
    
    private lazy var collegeButton = UserTypeButton()
    
    private lazy var workerButton = UserTypeButton()
    
    private lazy var ectButton = UserTypeButton()
    
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
    
    public lazy var nextButton = ConfirmButtonView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackground()
        self.signUpTopTitleComponents()
        self.addComponents()
        self.setUpNextButton()
    }
    
    private func addComponents() {
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(signUpTopLine).offset(96)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(9)
        }
        
        self.addSubview(studentButton)
        self.addSubview(collegeButton)
        self.addSubview(workerButton)
        self.addSubview(ectButton)
        
        studentButton.configure(userType: .student)
        collegeButton.configure(userType: .college)
        workerButton.configure(userType: .worker)
        ectButton.configure(userType: .ect)
        
        studentButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        collegeButton.snp.makeConstraints { make in
            make.top.equalTo(studentButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        workerButton.snp.makeConstraints { make in
            make.top.equalTo(collegeButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        ectButton.snp.makeConstraints { make in
            make.top.equalTo(workerButton.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(60)
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import SwiftUI
#Preview{
    UserTypePickerViewController()
}
