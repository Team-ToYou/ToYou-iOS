//
//  PopupView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class BinarySelectionPopupView: UIView {
    
    public lazy var mainFrame = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 26
        $0.clipsToBounds = true
    }
    
    public lazy var mainTitleLabel = UILabel().then {
        $0.numberOfLines = 2
        $0.text = "선택한 친구를\n삭제하시겠습니까?"
        $0.textAlignment = .center
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
        $0.textColor = .black04
    }
    
    public lazy var buttonStackFrame = UIView()
    
    public lazy var leftConfirmButton = UIButton().then {
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.black04, for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.s_core_light, size: 13)
    }
    
    public lazy var rightConfirmButton = UIButton().then {
        $0.setTitle("삭제", for: .normal)
        $0.setTitleColor(.red01, for: .normal)
        $0.titleLabel?.font = UIFont(name: K.Font.s_core_light, size: 13)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        self.addComponents()
    }
    
    private func addComponents() {
        
        self.addSubview(mainFrame)
        
        mainFrame.snp.makeConstraints { make in
            make.height.equalTo(129.52)
            make.width.equalTo(244.48)
            make.center.equalToSuperview()
        }
        
        mainFrame.addSubview(mainTitleLabel)
        mainFrame.addSubview(buttonStackFrame)
        
        mainTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
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
    
    public func configure(title: String, leftConfirmText: String, leftTextColor: UIColor,rightConfirmText: String, rightTextColor: UIColor) {
        mainTitleLabel.text = title
        leftConfirmButton.setTitle(leftConfirmText, for: .normal)
        leftConfirmButton.setTitleColor(leftTextColor, for: .normal)
        rightConfirmButton.setTitle(rightConfirmText, for: .normal)
        rightConfirmButton.setTitleColor(rightTextColor, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

