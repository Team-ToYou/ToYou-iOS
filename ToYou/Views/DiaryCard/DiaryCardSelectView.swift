//
//  DiaryCardSelectView.swift
//  ToYou
//
//  Created by 김미주 on 13/03/2025.
//

import UIKit

class DiaryCardSelectView: UIView {
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
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
    
    // 배경 아이콘
    private let backgroundIcon1 = UIImageView().then {
        $0.image = .defaultBluredStamp
        $0.alpha = 0.2
        $0.contentMode = .scaleAspectFit
        $0.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 18)
    }
    
    private let backgroundIcon2 = UIImageView().then {
        $0.image = .defaultBluredStamp
        $0.alpha = 0.2
        $0.contentMode = .scaleAspectFit
        $0.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 18)
    }
    
    // 뒤로가기
    public let backButton = UIButton().then {
        $0.setImage(.popUpIcon, for: .normal)
    }
    
    // 타이틀
    private let titleLabel = UILabel().then {
        $0.text = "일기카드 생성하기"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-4Regular", size: 17)
    }
    
    private let subTitleLabel = UILabel().then {
        $0.text = "답하고 싶은 질문을 선택해주세요"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-3Light", size: 12)
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .black02
    }
    
    // 장문형
    private let longOptionTitle = CustomLabelView(text: "장문형", isLight: true)
    
    public let longOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(NonSelectQuestionCell.self, forCellWithReuseIdentifier: NonSelectQuestionCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    // 단답형
    private let shortOptionTitle = CustomLabelView(text: "단답형", isLight: true)
    
    public let shortOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(NonSelectQuestionCell.self, forCellWithReuseIdentifier: NonSelectQuestionCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    // 선택형
    private let selectOptionTitle = CustomLabelView(text: "선택형", isLight: true)
    
    public let selectOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(SelectQuestionCell.self, forCellWithReuseIdentifier: SelectQuestionCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    // 다음 버튼
    public let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black01, for: .normal)
        $0.titleLabel?.font = UIFont(name: "S-CoreDream-5Medium", size: 15)
        $0.backgroundColor = .gray00
        $0.layer.cornerRadius = 7
        $0.isEnabled = false
    }
    
    // MARK: - function
    private func setView() {
        [
            paperBackgroundView, backgroundIcon1, backgroundIcon2, backButton,
            titleLabel, subTitleLabel, lineView,
            longOptionTitle, longOptionCollectionView,
            shortOptionTitle, shortOptionCollectionView,
            selectOptionTitle, selectOptionCollectionView,
            nextButton
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        backgroundIcon1.snp.makeConstraints {
            $0.top.equalToSuperview().offset(300)
            $0.left.equalToSuperview().offset(-15)
            $0.width.equalTo(85)
        }
        
        backgroundIcon2.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-80)
            $0.right.equalToSuperview().offset(20)
            $0.width.equalTo(128)
        }
        
        backButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.left.equalToSuperview().offset(17)
            $0.width.height.equalTo(19.25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalTo(backButton)
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
        
        longOptionTitle.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(30)
        }
        
        longOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(longOptionTitle.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        shortOptionTitle.snp.makeConstraints {
            $0.top.equalTo(longOptionCollectionView.snp.bottom).offset(33)
            $0.left.equalTo(longOptionTitle.snp.left)
        }
        
        shortOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(shortOptionTitle.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(100)
        }
        
        selectOptionTitle.snp.makeConstraints {
            $0.top.equalTo(shortOptionCollectionView.snp.bottom).offset(33)
            $0.left.equalTo(longOptionTitle.snp.left)
        }
        
        selectOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectOptionTitle.snp.bottom).offset(16)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(190)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-34)
            $0.height.equalTo(43)
        }
    }
}
