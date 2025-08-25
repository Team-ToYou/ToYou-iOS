//
//  BottomSheetView.swift
//  ToYou
//
//  Created by 김미주 on 7/18/25.
//

import UIKit

class BottomSheetView: UIView {
    let backgroundView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 21.8
        $0.isUserInteractionEnabled = true
    }
    
    private let sheetBar = UIView().then {
        $0.backgroundColor = .black02
        $0.layer.cornerRadius = 2
    }
    
    private let mailImage = UIImageView().then {
        $0.image = .mail
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "따끈따끈한 친구들의 일기카드를 확인해보세요!"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 20)
        $0.textColor = .black04
    }
    
    let iconImage = UIImageView().then {
        $0.image = .unhappyIcon
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    let noCardLabel = UILabel().then {
        $0.text = "아직 친구들이 일기카드를\n작성하지 않았어요"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 30)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .black01
        $0.isHidden = true
    }
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumLineSpacing = 21
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: 164.77, height: 290)
    }).then {
        $0.showsVerticalScrollIndicator = false
        $0.showsHorizontalScrollIndicator = false
        $0.backgroundColor = .clear
        $0.register(BottomSheetCell.self, forCellWithReuseIdentifier: BottomSheetCell.identifier)
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
        [
            backgroundView,
            sheetBar, mailImage, titleLabel,
            iconImage, noCardLabel,
            collectionView,
        ].forEach {
            addSubview($0)
        }
        
        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        sheetBar.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(7.4)
            $0.height.equalTo(4)
            $0.width.equalTo(40)
        }
        
        mailImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.top).offset(-9)
            $0.left.equalTo(titleLabel.snp.left).offset(-24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(sheetBar.snp.bottom).offset(7.5)
            $0.centerX.equalToSuperview()
        }
        
        iconImage.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(77)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(30)
            $0.height.equalTo(28.82)
        }
        
        noCardLabel.snp.makeConstraints {
            $0.top.equalTo(iconImage.snp.bottom).offset(17)
            $0.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(26.7)
            $0.centerX.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(20)
            $0.bottom.equalToSuperview().offset(-68)
        }
    }
}



import SwiftUI

#Preview {
    BottomSheetView()
}
