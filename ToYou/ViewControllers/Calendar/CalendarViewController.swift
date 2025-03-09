//
//  CalendarViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class CalendarViewController: UIViewController {
    let calendarView = CalendarView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarView
        navigationController?.navigationBar.isHidden = true
        
        setAction()
        setCollectionView()
    }
    
    // MARK: - function
    private func setCollectionView() {
        calendarView.myRecordCalendar.delegate = self
        calendarView.myRecordCalendar.dataSource = self
    }
    
    // MARK: - action
    private func setAction() {
        calendarView.segmentControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentControlChanged(_ segment: UISegmentedControl) {
        calendarView.updateUnderLinePosition(index: segment.selectedSegmentIndex)
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarCell.identifier, for: indexPath) as? CustomCalendarCell else {
            return UICollectionViewCell()
        }
        
        let year = Calendar.current.component(.year, from: Date())
        let month = indexPath.item + 1
        cell.configure(with: year, month: month)
        
        return cell
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
