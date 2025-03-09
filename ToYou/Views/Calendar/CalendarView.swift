//
//  CalendarView.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class CalendarView: UIView {
    // MARK: - layout
    private let paperBackgroundView = UIImageView().then {
        $0.image = .paperTexture
        $0.contentMode = .scaleAspectFit
    }
    
    // 메뉴
    public let segmentControl = UISegmentedControl().then {
        $0.insertSegment(withTitle: "나의 기록", at: 0, animated: true)
        $0.insertSegment(withTitle: "친구 기록", at: 1, animated: true)
        $0.selectedSegmentIndex = 0
        
        $0.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.black04,
            NSAttributedString.Key.font: UIFont(name: "S-CoreDream-4Regular", size: 16)!
        ], for: .normal)
        
        $0.backgroundColor = .clear
        let clearBackground = UIImage.colorImage(color: UIColor.white.withAlphaComponent(0.06))
        $0.setBackgroundImage(clearBackground, for: .normal, barMetrics: .default)
        $0.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    public let underLineView = UIView().then {
        $0.backgroundColor = .clear
    }
    
    public let underLine = UIView().then {
        $0.backgroundColor = .black04
    }
    
    private let lineView = UIView().then {
        $0.backgroundColor = .gray00
    }
    
    private let calendarBackground = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 7.3
        
        $0.layer.shadowColor = UIColor.black04.withAlphaComponent(0.25).cgColor
        $0.layer.shadowOpacity = 1
        $0.layer.shadowRadius = 25
        $0.layer.shadowOffset = CGSize(width: 0, height: 3.66)
    }
    
    public let myRecordCalendar = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 0
    }).then {
        $0.register(CustomCalendarCell.self, forCellWithReuseIdentifier: CustomCalendarCell.identifier)
        $0.showsHorizontalScrollIndicator = false
        $0.isPagingEnabled = true
        $0.backgroundColor = .clear
    }
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .background
        
        self.setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateUnderLinePosition(index: segmentControl.selectedSegmentIndex)
    }
    
    // MARK: - function
    public func updateUnderLinePosition(index: Int) {
        let segmentWidth = segmentControl.frame.width / 2
        _ = segmentControl.frame.origin.x + (segmentWidth * CGFloat(index))

        underLineView.snp.updateConstraints {
            $0.width.equalTo(segmentWidth)
            $0.left.equalTo(segmentControl.snp.left).offset(segmentWidth * CGFloat(index))
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }
    }
    
    private func setView() {
        [
            paperBackgroundView,
            segmentControl, underLineView, underLine, lineView,
            calendarBackground, myRecordCalendar
        ].forEach {
            addSubview($0)
        }
        
        paperBackgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalToSuperview().offset(80)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(4)
            $0.left.equalTo(segmentControl.snp.left)
            $0.width.equalTo(0)
            $0.height.equalTo(2)
        }
        
        underLine.snp.makeConstraints {
            $0.centerX.equalTo(underLineView)
            $0.centerY.equalTo(underLineView)
            $0.width.equalTo(64)
            $0.height.equalTo(2)
        }
        
        lineView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(5)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        myRecordCalendar.snp.makeConstraints {
            $0.top.equalTo(lineView.snp.bottom).offset(70)
            $0.horizontalEdges.equalToSuperview().inset(50)
            $0.height.equalTo(420)
        }
        
        calendarBackground.snp.makeConstraints {
            $0.horizontalEdges.equalTo(myRecordCalendar).inset(-22)
            $0.verticalEdges.equalTo(myRecordCalendar).inset(-20)
        }
        

    }
}
