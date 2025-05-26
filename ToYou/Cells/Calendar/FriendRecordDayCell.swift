//
//  FriendRecordDayCell.swift
//  ToYou
//
//  Created by 김미주 on 10/03/2025.
//

import UIKit

class FriendRecordDayCell: UICollectionViewCell {
    static let identifier = "FriendRecordDayCell"
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with calendarDate: CalendarDate, friendCount: Int) {
        dayLabel.text = calendarDate.day == 0 ? "" : "\(calendarDate.day)"
        dayLabel.textColor = calendarDate.isWithinCurrentMonth ? .black04 : .gray
        stampImage.isHidden = (calendarDate.day == 0 || friendCount == 0)
        self.friendCount.text = "\(friendCount)"
        self.friendCount.isHidden = (calendarDate.day == 0 || friendCount == 0)
    }
    
    // MARK: - layout
    private let dayLabel = UILabel().then {
        $0.text = "0"
        $0.font = UIFont.systemFont(ofSize: 14.63)
        $0.textColor = .black04
    }
    
    private let stampImage = UIImageView().then {
        $0.image = .friendStamp
        $0.contentMode = .scaleAspectFit
    }
    
    private let friendCount = UILabel().then {
        $0.text = "0"
        $0.font = UIFont(name: "GangwonEduHyeonokT_OTFMedium", size: 21.3)
        $0.textColor = .black04
    }
    
    // MARK: - function
    private func setView() {
        [ dayLabel, stampImage, friendCount ].forEach { addSubview($0) }
        
        dayLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview()
        }
        
        stampImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(dayLabel.snp.bottom).offset(3)
            $0.height.equalTo(29)
        }
        
        friendCount.snp.makeConstraints {
            $0.centerX.equalTo(stampImage)
            $0.centerY.equalTo(stampImage).offset(-2)
        }
    }
}
