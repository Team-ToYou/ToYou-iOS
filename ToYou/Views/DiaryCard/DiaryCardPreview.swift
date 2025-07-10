//
//  DiaryCardPreview.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit
import SnapKit

class DiaryCardPreview: UIView {
    private var titleCenterYConstraint: Constraint?
    
    // MARK: - init
    init(emotion: Emotion) {
        self.previewCard = MyDiaryCard(frame: .zero, emotion: emotion)
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
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
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "나의 일기카드"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-4Regular", size: 17)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "미리보기"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 13)
        $0.isHidden = false
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .black02
        $0.isHidden = false
    }
    
    public var previewCard: MyDiaryCard

    public let saveEditButton = UIButton().then {
        $0.setTitle("저장하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "S-CoreDream-4Regular", size: 16)
        $0.setTitleColor(.black04, for: .normal)
    }
    
    // MARK: - function
    public var isSaved: Bool = false {
        didSet {
            updateSaveStateUI()
        }
    }
    
    private func updateSaveStateUI() {
        subTitleLabel.isHidden = isSaved
        lineView.isHidden = isSaved
        let buttonTitle = isSaved ? "수정하기" : "저장하기"
        saveEditButton.setTitle(buttonTitle, for: .normal)
        titleCenterYConstraint?.update(offset: isSaved ? 17 : 0)
    }
    
    private func setView() {
        [
            paperBackgroundView, backButton,
            titleLabel, subTitleLabel, lineView,
            previewCard,
            saveEditButton
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
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            self.titleCenterYConstraint = $0.centerY.equalTo(backButton).constraint
        }
        
        subTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(36)
            $0.height.equalTo(1)
        }
        
        previewCard.snp.makeConstraints {
            $0.top.equalTo(backButton.snp.bottom).offset(57.75)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        saveEditButton.snp.makeConstraints {
            $0.top.equalTo(previewCard.snp.bottom).offset(25.58)
            $0.centerX.equalToSuperview()
        }
    }

}
