//
//  BottomSheetView.swift
//  ToYou
//
//  Created by 김미주 on 7/18/25.
//

import UIKit

class BottomSheetView: UIView {
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
        self.backgroundColor = .white
        self.layer.cornerRadius = 21.8
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - function
    private func setView() {        
        [
            sheetBar, mailImage, titleLabel,
            collectionView,
        ].forEach {
            addSubview($0)
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
