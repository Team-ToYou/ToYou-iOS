//
//  PolicyAgreementView.swift
//  ToYou
//
//  Created by 이승준 on 2/6/25.
//

import UIKit

class PolicyAgreementView: UIView {
    
    // MARK: Policy Check
    private lazy var titleLabel = UILabel().then {
        $0.text = "약간동의"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 20)
        $0.textColor = .black04
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.text = "투유와 함께하기 전\n필요한 약관들을 확인해주세요!"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
        $0.textColor = .black02
        $0.numberOfLines = 2
        $0.textAlignment = .left
    }
    
    public lazy var agreeAllButton = CheckBoxButton()
    
    private lazy var selectAllLabel = UILabel().then {
        $0.text = "전체선택"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
        $0.textColor = .black04
    }
    
    private lazy var selectUnderline = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    public lazy var over14Button = CheckBoxButton()
    public lazy var policyAgreeButton = CheckBoxButton()
    public lazy var privacyAgreeButton = CheckBoxButton()
    
    private lazy var over14Label = UILabel().then {
        $0.text = "만 14세 이상입니다"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 15)
        $0.textColor = .black04
    }
    
    private lazy var policyAgreeLabel = UILabel().then {
        $0.text = "이용약관 동의"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 15)
        $0.textColor = .black04
    }

    private lazy var privacyAgreeLabel = UILabel().then {
        $0.text = "개인정보 수집 및 이용동의"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 15)
        $0.textColor = .black04
    }
    
    private lazy var requiredLabel01 = createRequiredLabel()
    private lazy var requiredLabel02 = createRequiredLabel()
    private lazy var requiredLabel03 = createRequiredLabel()
    public lazy var goTermsOfUse = goDetailButton()
    public lazy var goPrivacyDetail = goDetailButton()
    
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
        self.addSubview(titleLabel)
        self.addSubview(subTitleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(navigationBar.dividerLine.snp.bottom).offset(97)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
        }
        
        self.addSubview(agreeAllButton)
        self.addSubview(selectAllLabel)
        self.addSubview(selectUnderline)
        
        agreeAllButton.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.leading.equalToSuperview().offset(10)
            make.top.equalTo(subTitleLabel.snp.bottom).offset(38.75)
        }
        
        selectAllLabel.snp.makeConstraints { make in
            make.centerY.equalTo(agreeAllButton.snp.centerY)
            make.leading.equalTo(agreeAllButton.snp.trailing).offset(5.75)
        }
        
        selectUnderline.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(agreeAllButton.snp.bottom).offset(12.75)
        }
        
        self.addSubview(over14Button)
        self.addSubview(over14Label)
        self.addSubview(requiredLabel01)
        self.addSubview(policyAgreeButton)
        self.addSubview(policyAgreeLabel)
        self.addSubview(requiredLabel02)
        self.addSubview(goTermsOfUse)
        self.addSubview(privacyAgreeButton)
        self.addSubview(privacyAgreeLabel)
        self.addSubview(requiredLabel03)
        self.addSubview(goPrivacyDetail)
        
        over14Button.snp.makeConstraints { make in
            make.top.equalTo(selectUnderline.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(24)
        }
        
        over14Label.snp.makeConstraints { make in
            make.centerY.equalTo(over14Button.snp.centerY)
            make.leading.equalTo(over14Button.snp.trailing).offset(6.42)
        }
        
        requiredLabel01.snp.makeConstraints { make in
            make.centerY.equalTo(over14Button.snp.centerY)
            make.leading.equalTo(over14Label.snp.trailing).offset(6.42)
            make.height.equalTo(17.22)
            make.width.equalTo(40.55)
        }
        
        policyAgreeButton.snp.makeConstraints { make in
            make.top.equalTo(over14Button.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(24)
        }
        
        policyAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(policyAgreeButton.snp.centerY)
            make.leading.equalTo(policyAgreeButton.snp.trailing).offset(6.42)
        }
        
        requiredLabel02.snp.makeConstraints { make in
            make.centerY.equalTo(policyAgreeButton.snp.centerY)
            make.leading.equalTo(policyAgreeLabel.snp.trailing).offset(6.42)
            make.height.equalTo(17.22)
            make.width.equalTo(40.55)
        }
        
        goTermsOfUse.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(policyAgreeButton.snp.centerY)
            make.leading.equalTo(requiredLabel02.snp.trailing).offset(6.42)
        }
        
        privacyAgreeButton.snp.makeConstraints { make in
            make.top.equalTo(policyAgreeButton.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(15)
            make.width.height.equalTo(24)
        }
        
        privacyAgreeLabel.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeButton.snp.centerY)
            make.leading.equalTo(privacyAgreeButton.snp.trailing).offset(6.42)
        }
        
        requiredLabel03.snp.makeConstraints { make in
            make.centerY.equalTo(privacyAgreeButton.snp.centerY)
            make.leading.equalTo(privacyAgreeLabel.snp.trailing).offset(6.42)
            make.height.equalTo(17.22)
            make.width.equalTo(40.55)
        }
        
        goPrivacyDetail.snp.makeConstraints { make in
            make.width.height.equalTo(24)
            make.centerY.equalTo(privacyAgreeButton.snp.centerY)
            make.leading.equalTo(requiredLabel03.snp.trailing).offset(6.42)
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
    
    private func createRequiredLabel() -> UILabel {
        return UILabel().then {
            $0.text = "필수"
            $0.textAlignment = .center
            $0.font = UIFont(name: K.Font.s_core_regular, size: 13)
            $0.textColor = .white
            $0.backgroundColor = .red02
            $0.layer.cornerRadius = 5.68
            $0.clipsToBounds = true
        }
    }
    
    private func goDetailButton() -> UIButton {
        return UIButton().then {
            $0.setImage(.goDetail , for: .normal)
            $0.contentMode = .scaleAspectFit
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
