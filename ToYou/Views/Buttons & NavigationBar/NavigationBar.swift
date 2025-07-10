//
//  NavigationBar.swift
//  ToYou
//
//  Created by 이승준 on 7/10/25.
//

import UIKit

final class NavigationBar: UIView {
    
    private lazy var paperBackground = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFill
    }
    
    public var popUpViewButton = UIButton().then {
        $0.setImage(.popUpIcon, for: .normal)
    }
    
    private lazy var titleLabel = UILabel().then {
        $0.textColor = .black04
        $0.font = UIFont(name: K.Font.s_core_medium, size: 17)
    }
    
    public let dividerLine = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    func configure(with title: String, isHiddenPopUpButton: Bool = false, isTitleHidden: Bool = false) {
        self.titleLabel.text = title
        popUpViewButton.isHidden = isHiddenPopUpButton
        titleLabel.isHidden = isTitleHidden
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(paperBackground)
        self.addSubview(popUpViewButton)
        self.addSubview(titleLabel)
        self.addSubview(dividerLine)
        
        paperBackground.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(19)
            make.centerX.equalToSuperview()
        }
        
        popUpViewButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.leading.equalToSuperview().offset(17)
            make.height.width.equalTo(23)
        }
        
        dividerLine.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
