//
//  MyRecordCollectionViewCell.swift
//  ToYou
//
//  Created by 김미주 on 02/03/2025.
//

import UIKit

class MyRecordDayCell: UICollectionViewCell {
    static let identifier = "MyRecordDayCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with calendarDate: CalendarDate) {
        dayLabel.text = calendarDate.day == 0 ? "" : "\(calendarDate.day)"
        dayLabel.textColor = calendarDate.isWithinCurrentMonth ? .black04 : .gray
        emotionImage.image = calendarDate.day == 0 ? .none : .normalStamp
    }
    
    // MARK: - layout
    private let dayLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 14.63)
        $0.textColor = .black04
    }
    
    private let emotionImage = UIImageView().then {
        $0.image = .normalStamp
        $0.contentMode = .scaleAspectFit
    }
    
    // MARK: - function
    private func setView() {
        [ dayLabel, emotionImage ].forEach { addSubview($0) }
        
        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        emotionImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayLabel.snp.bottom).offset(3)
            $0.height.equalTo(29)
        }
    }
}
