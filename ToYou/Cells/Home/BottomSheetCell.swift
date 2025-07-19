//
//  BottomSheetCell.swift
//  ToYou
//
//  Created by 김미주 on 7/19/25.
//

import UIKit

class BottomSheetCell: UICollectionViewCell {
    static let identifier = "BottomSheetCell"
    
    // MARK: - layout
    private let diaryCardContainer = UIView()

    private let diaryCard = MyDiaryCard(
        frame: .zero,
        emotion: .HAPPY
    ).then {
        $0.backgroundColor = .red
    }
    
    let nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 18)
        $0.textColor = .black04
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - function
    private func setView() {
        // 카드 뷰 축소 (0.5배)
        diaryCard.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        
        contentView.addSubview(diaryCardContainer)
        diaryCardContainer.addSubview(diaryCard)
        contentView.addSubview(nicknameLabel)
        
        diaryCard.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(350.43)
            $0.height.equalTo(605)
        }
        
        diaryCardContainer.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
            $0.width.equalTo(175.21)
            $0.height.equalTo(302.5)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(diaryCardContainer.snp.bottom).offset(4)
        }
    }
}

import SwiftUI
#Preview {
    BottomSheetCell()
}
