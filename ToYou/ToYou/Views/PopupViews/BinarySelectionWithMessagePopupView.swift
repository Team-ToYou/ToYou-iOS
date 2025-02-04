//
//  PopupView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class BinarySelectionWithMessagePopupView: UIView {
    
    private lazy var mainFrame = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 26
        $0.clipsToBounds = true
    }
    
    public lazy var mainTitleLabel = UILabel().then {
        $0.numberOfLines = 1
        $0.text = "정말 탈퇴하시겠습니까?"
        $0.textAlignment = .center
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
        $0.textColor = .black04
    }
    
    private lazy var subTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "작성하신 일기카드가 모두\n삭제되며 복구할 수 없어요"
        $0.textAlignment = .center
        $0.font = UIFont(name: K.Font.s_core_light, size: 12)
        $0.textColor = .black04
    }
    
    public lazy var buttonStackFrame = UIView()
    
    public lazy var leftConfirmButton = UIButton().then {
        $0.setTitle("탈퇴하기", for: .normal)
        $0.setTitleColor(.red02, for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.s_core_medium, size: 12.5)
    }
    
    public lazy var rightConfirmButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.black04, for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.s_core_medium, size: 12.5)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        self.addComponents()
    }
    
    private func addComponents() {
        self.snp.makeConstraints { make in
            make.height.equalTo(129.52)
            make.width.equalTo(244.48)
        }
        
        self.addSubview(mainFrame)
        
        mainFrame.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        mainFrame.addSubview(mainTitleLabel)
        mainFrame.addSubview(subTitleLabel)
        mainFrame.addSubview(buttonStackFrame)
        
        mainTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(22)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(mainTitleLabel.snp.bottom).offset(10)
        }
        
        buttonStackFrame.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(29)
            make.bottom.equalToSuperview().inset(12)
        }
        
        buttonStackFrame.addSubview(leftConfirmButton)
        buttonStackFrame.addSubview(rightConfirmButton)
        
        leftConfirmButton.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview()
            make.width.equalTo(73)
            make.height.equalTo(29)
        }
        
        rightConfirmButton.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview()
            make.width.equalTo(73)
            make.height.equalTo(29)
        }
    }
    
    public func configure(title: String, confirmText: String) {
        mainTitleLabel.text = title
        leftConfirmButton.setTitle(confirmText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

