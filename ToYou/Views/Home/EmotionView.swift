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
    private let questionLabel = UILabel().then {
        $0.text = "오늘 하루는 어땠나요?"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 30)
    }
    
    private let subQuestionLabel = UILabel().then {
        $0.text = "감정우표를 선택해주세요"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 25)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "선택한 감정우표를 기반으로 맞춤형 질문이 배달됩니다"
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
    }
    
    // 감정우표
    public let emotionTableView = UITableView().then {
        $0.register(EmotionTableViewCell.self, forCellReuseIdentifier: EmotionTableViewCell.identifier)
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    public let emotionView = UIView().then {
        $0.isHidden = true
    }
    
    public let emotionPaperView = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    public let emotionLabel = UILabel().then {
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 30)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
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
            questionLabel, subQuestionLabel, subLabel,
            emotionTableView,
            emotionView, emotionPaperView, emotionLabel
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.left.equalToSuperview().offset(17)
            $0.width.height.equalTo(19.25)
        }
        
        questionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(safeAreaLayoutGuide).offset(80)
        }
        
        subQuestionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(questionLabel.snp.bottom)
        }
        
        subLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(subQuestionLabel.snp.bottom).offset(19.5)
        }
        
        emotionTableView.snp.makeConstraints {
            $0.top.equalTo(subLabel.snp.bottom).offset(36.8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(150)
            $0.height.equalTo(480)
        }
        
        emotionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emotionPaperView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        emotionLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
    
}
