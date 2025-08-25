//
//  HomeView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import SnapKit

class HomeView: UIView {
    // MARK: - layout
    private let paperBackgroundView = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFit
    }
    
    private let toyouLabel = UILabel().then {
        $0.text = "투유"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 35)
        $0.textColor = .black04
    }
    
    public let alertButton = UIButton().then {
        $0.setImage(.alertIcon, for: .normal)
    }
    
    public let dateBackView = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    public let dateLabel = UILabel().then {
        $0.text = "00000000"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 25)
        $0.textColor = .black04
        $0.textAlignment = .center
    }
    
    public let commentLabel = UILabel().then {
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 25)
        $0.textColor = .black04
    }
    
    public let emotionImage = UIImageView().then {
        $0.image = .defaultBubble
    }
    
    public let mailBoxImage = UIButton().then {
        $0.setImage(.mailboxEmpty, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    // 바텀시트
    public let bottomSheetView = BottomSheetView()
    public var bottomSheetTopConstraint: Constraint?
    
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
            paperBackgroundView,
            toyouLabel, alertButton,
            dateBackView, dateLabel,
            commentLabel,
            emotionImage,
            mailBoxImage,
            bottomSheetView
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        toyouLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(10)
            $0.left.equalToSuperview().offset(27)
            $0.height.equalTo(34)
        }
        
        alertButton.snp.makeConstraints {
            $0.centerY.equalTo(toyouLabel)
            $0.right.equalToSuperview().offset(-36)
        }
        
        dateBackView.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(160)
            $0.height.equalTo(21)
            $0.width.equalTo(161)
        }
        
        dateLabel.snp.makeConstraints {
            $0.centerY.equalTo(dateBackView).offset(-2)
            $0.centerX.equalToSuperview()
        }
        
        commentLabel.snp.makeConstraints {
            $0.top.equalTo(dateBackView.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }
        
        emotionImage.snp.makeConstraints {
            $0.top.equalTo(dateLabel.snp.bottom).offset(52)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(63.9)
            $0.height.equalTo(74.4)
        }
        
        mailBoxImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(emotionImage.snp.bottom).offset(28.5)
            $0.bottom.equalTo(safeAreaLayoutGuide).offset(20)
        }

        bottomSheetView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(715)
            self.bottomSheetTopConstraint = $0.top.equalToSuperview().offset(UIScreen.main.bounds.height - (68+50)).constraint
        }
    }
    
}

import SwiftUI

#Preview {
    HomeView()
}
