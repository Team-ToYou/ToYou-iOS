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
    
    private var isFriendRecord: Bool = false
    
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
    
    func configure(with year: Int, month: Int, isFriendRecord: Bool, emotionList: [String: String]) {
        self.isFriendRecord = isFriendRecord
        calendarDates = CalendarManager.shared.generateDates(for: year, month: month)
        monthLabel.text = "\(month)월"
        self.emotionList = emotionList
        monthCollectionView.reloadData()
    }
    
    // MARK: - layout
    private let monthLabel = UILabel().then {
        $0.text = "0월"
        $0.textColor = .black04
        $0.font = UIFont(name: "S-CoreDream-5Medium", size: 14.63)
        $0.textAlignment = .center
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
        addSubview(monthLabel)
        addSubview(weekDayStackView)
        addSubview(monthCollectionView)
        
        monthLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
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
            cell.configure(with: calendarDate)
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
}
