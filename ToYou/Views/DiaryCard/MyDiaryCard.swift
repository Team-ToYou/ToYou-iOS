//
//  MyDiaryCard.swift
//  ToYou
//
//  Created by 김미주 on 4/7/25.
//

import UIKit

class MyDiaryCard: UIView {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: - layout
    private let backView = UIView().then {
        $0.backgroundColor = .green00
        $0.layer.cornerRadius = 5.3
    }
    
    private let emotionStamp = UIImageView().then {
        $0.image = UIImage(resource: .nervousStamp)
    }
    
    private let dateLabel = UILabel().then {
        $0.text = "20240504"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 25)
        $0.textColor = .black04
    }
    
    private let toLabel = UILabel().then {
        $0.text = "To.OOO"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 20)
        $0.textColor = .black04
    }
    
    public let lockButton = UIButton().then {
        $0.setImage(.unlockIcon, for: .normal)
    }
    
    public let answerTableView = UITableView().then {
        $0.register(DiaryCardAnswerCell.self, forCellReuseIdentifier: DiaryCardAnswerCell.identifier)
        $0.separatorStyle = .none
        $0.backgroundColor = .clear
    }
    
    // MARK: - function
    private func setView() {
        [
            backView, lockButton,
            emotionStamp, dateLabel, toLabel,
            answerTableView
        ].forEach {
            addSubview($0)
        }
        
        backView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.height.equalTo(600)
        }
        
        lockButton.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(12)
            $0.right.equalTo(backView.snp.right).offset(-12.17)
        }
        
        emotionStamp.snp.makeConstraints {
            $0.top.equalTo(backView.snp.top).offset(22.3)
            $0.left.equalTo(backView.snp.left).offset(33.6)
            $0.width.equalTo(42.6)
            $0.height.equalTo(47)
        }
        
        dateLabel.snp.makeConstraints {
            $0.left.equalTo(toLabel.snp.left)
            $0.bottom.equalTo(toLabel.snp.top).offset(5.33)
        }
        
        toLabel.snp.makeConstraints {
            $0.left.equalTo(emotionStamp.snp.right).offset(13.25)
            $0.bottom.equalTo(emotionStamp.snp.bottom).offset(-2.28)
        }
        
        answerTableView.snp.makeConstraints {
            $0.top.equalTo(toLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalTo(backView).inset(17)
            $0.bottom.equalTo(backView.snp.bottom).offset(-24)
        }
    }

}

import SwiftUI

#Preview {
    DiaryCardPreview()
}
