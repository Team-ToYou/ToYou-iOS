//
//  CustomCalendarCell.swift
//  ToYou
//
//  Created by 김미주 on 03/03/2025.
//

import UIKit

class CustomCalendarCell: UICollectionViewCell {
    static let identifier = "CustomCalendarCell"
    
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
    
    // MARK: - layout
    private let monthCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.minimumInteritemSpacing = 5
        $0.minimumLineSpacing = 15
        $0.scrollDirection = .vertical
    }).then {
        $0.register(MyRecordDayCell.self, forCellWithReuseIdentifier: MyRecordDayCell.identifier)
        $0.isScrollEnabled = false
        $0.backgroundColor = .clear
    }
    
    // MARK: - function
    private func setView() {
        addSubview(monthCollectionView)
        
        monthCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}


extension CustomCalendarCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyRecordDayCell.identifier, for: indexPath) as? MyRecordDayCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension CustomCalendarCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - (5 * 6)) / 7 // 7열 구조 유지, 간격 고려
        let height = width
        return CGSize(width: width, height: height)
    }
}
