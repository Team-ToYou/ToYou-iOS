//
//  DiaryCardAnswerView.swift
//  ToYou
//
//  Created by 김미주 on 18/03/2025.
//

import UIKit

class DiaryCardAnswerView: UIView {
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
    private let longOptionTitle = CustomLabelView(text: "장문형", isLight: false)
    
    public let longOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(LongAnswerCell.self, forCellWithReuseIdentifier: LongAnswerCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    public let longStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    // 스크롤뷰
    private let scrollView = UIScrollView().then {
        $0.showsVerticalScrollIndicator = false
        $0.alwaysBounceVertical = true
    }
    
    private let contentView = UIView()
    
    // 단답형
    private let shortOptionTitle = CustomLabelView(text: "단답형", isLight: false)
    
    public let shortOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(ShortAnswerCell.self, forCellWithReuseIdentifier: ShortAnswerCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    public let shortStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    // 선택형
    private let selectOptionTitle = CustomLabelView(text: "선택형", isLight: false)
    
    public let selectOptionCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 16
        $0.scrollDirection = .horizontal
    }).then {
        $0.register(SelectAnswerCell.self, forCellWithReuseIdentifier: SelectAnswerCell.identifier)
        $0.backgroundColor = .clear
        $0.showsHorizontalScrollIndicator = false
        $0.contentInset = .init(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    public let selectStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
    }
    
    // 질문 전체
    private let questionStack = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 33
        $0.alignment = .fill
        $0.distribution = .fill
    }
    
    // 다음 버튼
    public let nextButton = UIButton().then {
        $0.setTitle("다음", for: .normal)
        $0.setTitleColor(.black01, for: .normal)
        $0.titleLabel?.font = UIFont(name: "S-CoreDream-5Medium", size: 15)
        $0.backgroundColor = .gray00
        $0.layer.cornerRadius = 7
        $0.isEnabled = true
    }
    
    // MARK: - function
    private func setView() {
        [
            paperBackgroundView, backButton,
            titleLabel, subTitleLabel, lineView,
            scrollView,
            nextButton
        ].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        contentView.addSubview(questionStack)
        
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
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(24)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-20)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        questionStack.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.bottom.equalToSuperview()
        }
        setQuestionStack()
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().offset(-34)
            $0.height.equalTo(43)
        }
    }
    
    private func setQuestionStack() {
        // 장문형
        longStack.addSubview(longOptionTitle)
        longStack.addSubview(longOptionCollectionView)
        longOptionTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        longOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(longOptionTitle.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(245)
            $0.bottom.equalToSuperview()
        }

        // 단답형
        shortStack.addSubview(shortOptionTitle)
        shortStack.addSubview(shortOptionCollectionView)
        shortOptionTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        shortOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(shortOptionTitle.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(125)
            $0.bottom.equalToSuperview()
        }

        // 선택형
        selectStack.addSubview(selectOptionTitle)
        selectStack.addSubview(selectOptionCollectionView)
        selectOptionTitle.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(30)
        }
        selectOptionCollectionView.snp.makeConstraints {
            $0.top.equalTo(selectOptionTitle.snp.bottom).offset(11)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(160)
            $0.bottom.equalToSuperview()
        }

        // 전체 스택에 추가
        questionStack.addArrangedSubview(longStack)
        questionStack.addArrangedSubview(shortStack)
        questionStack.addArrangedSubview(selectStack)
    }

    
}
