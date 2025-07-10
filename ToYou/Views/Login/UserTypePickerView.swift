//
//  UserTypePickerView.swift
//  ToYou
//
//  Created by 이승준 on 2/10/25.
//

import UIKit

class UserTypePickerView: UIView {
    
    let buttonSpacing: CGFloat = 12
    
    // MARK: Main Components
    private lazy var mainLabel = UILabel().then {
        $0.text = "현재 상태를 알려주세요."
        $0.font = UIFont(name: K.Font.s_core_regular , size: 16)
        $0.textColor = .black04
    }
    
    private lazy var subLabel = UILabel().then {
        $0.text = "선택하신 정보를 기반으로 맞춤형 질문을 추천해드립니다.\n다른 목적으로 사용되거나 제 3자에게 제공되지 않습니다."
        $0.numberOfLines = 2
        $0.font = UIFont(name: K.Font.s_core_regular , size: 13)
        $0.textAlignment = .center
        $0.textColor = .black02
    }
    
    public lazy var studentButton = UserTypeButton()
    
    public lazy var collegeButton = UserTypeButton()
    
    public lazy var workerButton = UserTypeButton()
    
    public lazy var ectButton = UserTypeButton()
    
    public lazy var navigationBar = CustomNavigationBar()
    
    public lazy var nextButton = ConfirmButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.signUpTopTitleComponents()
        self.addComponents()
        self.setUpNextButton()
    }
    
    private func addComponents() {
        self.addSubview(mainLabel)
        self.addSubview(subLabel)
        
        mainLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(navigationBar.dividerLine).offset(96)
        }
        
        subLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainLabel.snp.bottom).offset(9)
        }
        
        self.addSubview(studentButton)
        self.addSubview(collegeButton)
        self.addSubview(workerButton)
        self.addSubview(ectButton)
        
        studentButton.configure(userType: .SCHOOL)
        collegeButton.configure(userType: .COLLEGE)
        workerButton.configure(userType: .OFFICE)
        ectButton.configure(userType: .ETC)
        
        studentButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        collegeButton.snp.makeConstraints { make in
            make.top.equalTo(studentButton.snp.bottom).offset(buttonSpacing)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        workerButton.snp.makeConstraints { make in
            make.top.equalTo(collegeButton.snp.bottom).offset(buttonSpacing)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
        ectButton.snp.makeConstraints { make in
            make.top.equalTo(workerButton.snp.bottom).offset(buttonSpacing)
            make.leading.trailing.equalToSuperview().inset(60)
        }
        
    }
    
    private func signUpTopTitleComponents() {
        self.addSubview(navigationBar)
        
        navigationBar.configure(with: "회원가입")
        navigationBar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
