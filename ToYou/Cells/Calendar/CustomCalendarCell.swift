//
//  CustomCalendarCell.swift
//  ToYou
//
//  Created by 김미주 on 03/03/2025.
//

import UIKit

class CustomCalendarCell: UICollectionViewCell {
    static let identifier = "CustomCalendarCell"
    
    private let weekDays: [UIImage] = [.mon, .tue, .wed, .thu, .fri, .sat, .sun]
    private var calendarDates: [CalendarDate] = []
    
    private var emotionList: [String: String] = [:]
    
    private var friendCountPerDay: [String: Int] = [:]
    private var isFriendRecord: Bool = false
    weak var delegate: CustomCalendarCellDelegate?
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        
        setView()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with year: Int, month: Int, isFriendRecord: Bool, emotionList: [String: String], friendCountPerDay: [String: Int] = [:]) {
        self.isFriendRecord = isFriendRecord
        self.emotionList = emotionList
        self.friendCountPerDay = friendCountPerDay
        self.calendarDates = CalendarManager.shared.generateDates(for: year, month: month)
        self.monthLabel.text = "\(year)년 \(month)월"
        self.monthCollectionView.reloadData()
    }
    
    // MARK: - layout
    public let leftButton = UIButton().then {
        $0.setImage(.calendarLeftIcon, for: .normal)
    }
    
    private let monthLabel = UILabel().then {
        $0.text = "0월"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-5Medium", size: 14.63)
        $0.textAlignment = .center
    }
    
    public let rightButton = UIButton().then {
        $0.setImage(.calendarRightIcon, for: .normal)
    }
    
    private lazy var weekDayImages: [UIImageView] = weekDays.map {
        let image = UIImageView()
        image.image = $0
        image.contentMode = .scaleAspectFit
        return image
    }
    
    private lazy var weekDayStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: weekDayImages)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let monthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 5
        $0.minimumLineSpacing = 15
        $0.scrollDirection = .vertical
    }).then {
        $0.register(MyRecordDayCell.self, forCellWithReuseIdentifier: MyRecordDayCell.identifier)
        $0.register(FriendRecordDayCell.self, forCellWithReuseIdentifier: FriendRecordDayCell.identifier)
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    // MARK: - function
    private func setView() {
        [ leftButton, monthLabel, rightButton,
          weekDayStackView,
          monthCollectionView
        ].forEach { addSubview($0) }
        
        monthLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.left.equalToSuperview().offset(15)
        }
        
        rightButton.snp.makeConstraints {
            $0.centerY.equalTo(monthLabel)
            $0.right.equalToSuperview().offset(-15)
        }
        
        weekDayStackView.snp.makeConstraints {
            $0.top.equalTo(monthLabel.snp.bottom).offset(35)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(8)
        }
        
        monthCollectionView.snp.makeConstraints {
            $0.top.equalTo(weekDayStackView.snp.bottom).offset(35)
            $0.horizontalEdges.bottom.equalToSuperview()
        }
    }
}


extension CustomCalendarCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return calendarDates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let calendarDate = calendarDates[indexPath.item]
        
        if isFriendRecord {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendRecordDayCell.identifier, for: indexPath) as? FriendRecordDayCell else {
                return UICollectionViewCell()
            }
            let dateString = calendarDate.fullDateString
            let count = friendCountPerDay[dateString] ?? 0
            cell.configure(with: calendarDate, friendCount: count)

            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecordDayCell.identifier, for: indexPath) as? MyRecordDayCell else {
                return UICollectionViewCell()
            }
            cell.configure(with: calendarDate, emotionList: self.emotionList)
            return cell
        }
    }

}

extension CustomCalendarCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = CGFloat(Int((collectionView.frame.width - (5 * 6)) / 7)) // 7열 구조 유지, 간격 고려
        let height = width
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = calendarDates[indexPath.item]

        if isFriendRecord {
            print("날짜: \(selectedDate)")
            delegate?.didSelectFriendDate(selectedDate)
        }
    }
}

// MARK: - Protocol
protocol CustomCalendarCellDelegate: AnyObject {
    func didSelectFriendDate(_ date: CalendarDate)
}

import SwiftUI
#Preview {
    CalendarViewController()
}
