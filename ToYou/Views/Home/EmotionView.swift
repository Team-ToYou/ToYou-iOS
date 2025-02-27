//
//  EmotionView.swift
//  ToYou
//
//  Created by 김미주 on 28/02/2025.
//

import UIKit

class EmotionView: UIView {
    // MARK: - layout
    // 배경
    private let paperBackgroundView = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFit
    }
    
    // 뒤로가기
    public let backButton = UIButton().then {
        $0.setImage(.popUpIcon, for: .normal)
    }
    
    // 질문
    
    // 감정우표

    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - function
    private func setView() {
        [
            paperBackgroundView, backButton,
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(19)
            $0.left.equalToSuperview().offset(17)
            $0.width.height.equalTo(19.25)
        }
    }
    
}
