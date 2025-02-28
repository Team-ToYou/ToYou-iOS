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
            segmentControl, underLineView, underLine, lineView
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
    }
}
