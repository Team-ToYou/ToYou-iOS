//
//  CalendarDetailView.swift
//  ToYou
//
//  Created by 김미주 on 6/23/25.
//

import Foundation

class CalendarDetailView: UIView {
    // MARK: - init
    init(emotion: Emotion) {
        self.diaryCard = MyDiaryCard(frame: .zero, emotion: emotion)
        super.init(frame: .zero)
        self.backgroundColor = .white
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let paperBackgroundView = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFit
    }
    
    public let cancelButton = UIButton().then {
        $0.setImage(.cancelIcon, for: .normal)
    }
    
    public let diaryCard: MyDiaryCard
    
    public let deleteButton = UIButton().then {
        $0.setTitle("삭제하기", for: .normal)
        $0.titleLabel?.font = UIFont(name: "S-CoreDream-4Regular", size: 17)
        $0.setTitleColor(.black04, for: .normal)
    }
    
    // MARK: - function
    private func setView() {
        [
            paperBackgroundView, cancelButton,
            diaryCard, deleteButton
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        cancelButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(53)
            $0.left.equalToSuperview().offset(15)
        }
        
        diaryCard.snp.makeConstraints {
            $0.top.equalTo(cancelButton).offset(58)
            $0.horizontalEdges.equalToSuperview().inset(21)
        }
        
        deleteButton.snp.makeConstraints {
            $0.top.equalTo(diaryCard.snp.bottom).offset(25.5)
            $0.centerX.equalToSuperview()
        }
    }
}

import SwiftUI

#Preview {
    CalendarDetailViewController()
}
