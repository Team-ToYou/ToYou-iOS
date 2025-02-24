//
//  EditProfileView.swift
//  ToYou
//
//  Created by 이승준 on 2/23/25.
//

import UIKit

class EditProfileView: UIView {
    
    // MARK: Background & NavigationTop
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    public lazy var popUpViewButton = UIButton().then {
        $0.setImage(.popUpIcon , for: .normal)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.text = "프로필 수정"
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
        $0.textColor = .black04
    }
    
    private lazy var signUpTopLine = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.setupBackground()
        self.signUpTopTitleComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension EditProfileView {
    private func setupBackground() {
        self.addSubview(paperBackground)
        
        paperBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    private func signUpTopTitleComponents() {
        self.addSubview(popUpViewButton)
        self.addSubview(titleLabel)
        self.addSubview(signUpTopLine)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(19)
            make.centerX.equalToSuperview()
        }
        
        popUpViewButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(17)
            make.height.width.equalTo(23)
        }
        
        signUpTopLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
    }
}
