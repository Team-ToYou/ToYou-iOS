//
//  SendQueryView.swift
//  ToYou
//
//  Created by 이승준 on 3/1/25.
//

import UIKit

class SendQueryView: UIView {
    
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
        $0.text = "질문 유형을 선택해주세요"
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    private lazy var divider = UIView().then {
        $0.backgroundColor = .black02
    }
    
    private lazy var mailImageView = UIImageView().then {
        $0.image = .mail
        $0.contentMode = .scaleAspectFit
    }
    
    private lazy var ananymousLabel = UILabel().then {
        $0.text = "익명으로 보내기"
        $0.font = UIFont(name: K.Font.gangwonEduHyeonokT_OTFMedium, size: 18)
        $0.textColor = .black00
    }
    
    public lazy var checkBoxButton = CheckBoxButtonVer02()
    
    public lazy var warningLabel = UILabel().then {
        $0.text = "비방 및 욕설은 처벌받을 수 있습니다."
        $0.textColor = .red02
        $0.font = UIFont(name: K.Font.s_core_light, size: 11)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        setupBackgroundAndBasicButtons()
        setTitleComponents()
        setMailConstraints()
        setQueryRelatedConstraints()
    }
    
    private func setQueryRelatedConstraints() {
        self.addSubview(ananymousLabel)
        self.addSubview(checkBoxButton)
        self.addSubview(warningLabel)
        
        ananymousLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(5)
            make.bottom.equalTo(confirmButton.snp.top).offset(-20)
        }
        
        checkBoxButton.snp.makeConstraints { make in
            make.centerY.equalTo(ananymousLabel)
            make.trailing.equalTo(ananymousLabel.snp.leading).offset(-5)
            make.height.width.equalTo(21.5)
        }
        
        warningLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(confirmButton.snp.bottom).offset(10.5)
        }
        
    }
    
    private func setMailConstraints() {
        self.addSubview(mailImageView)
        
        mailImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(100)
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
        
        confirmButton.configure(labelText: "질문 보내기")
        confirmButton.availableForSendQuery()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

import SwiftUI
#Preview{
    SendQueryViewController()
}
