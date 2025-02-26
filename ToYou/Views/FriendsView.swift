//
//  LetterComposeView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class FriendsView: UIView {
    
    let mainPadding: CGFloat = 35
    
    private lazy var addFriendLabel = UILabel().then {
        $0.text = "친구 추가하기"
        $0.font = UIFont(name: K.Font.s_core_regular, size: 17)
        $0.textColor = .black04
    }
        
    public lazy var searchTextField = UITextField().then {
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
    
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        self.addSearchComponents()
        self.setupBackground()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FriendsView {
    
    private func addSearchComponents() {
        addLeftViewInTextField() // 좌측에 아이콘 추가
        searchTextField.setPlaceholder(text: "친구 아이디를 입력하세요.", color: .gray00)
        self.addSubview(addFriendLabel)
        self.addSubview(searchTextField)
        
        addFriendLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(23)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(63)
        }
        
        searchTextField.snp.makeConstraints { make in
            make.top.equalTo(addFriendLabel.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(mainPadding)
            make.height.equalTo(40)
        }
        
        
        
    }
    
    private func setupBackground() {
        self.addSubview(paperBackground)
        
        paperBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension FriendsView {
    
    private func addLeftViewInTextField() {
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 35, height: 30))
        
        let searchIcon = UIImageView().then {
            $0.image = .search
            $0.contentMode = .scaleAspectFit
        }
                
        searchTextField.addSubview(searchIcon)
        
        searchIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
        }
        
        searchIcon.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
        }

        
        searchTextField.leftView = leftView
        searchTextField.leftViewMode = .always
    }
    
}

import SwiftUI
#Preview {
    FriendsViewController()
}
