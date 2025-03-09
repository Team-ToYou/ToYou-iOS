//
//  CalendarViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit

class CalendarViewController: UIViewController {
    let calendarView = CalendarView()
    
    private var isFriendRecord: Bool = false
    
    private var months: [(year: Int, month: Int)] = []
    private var currentYear = Calendar.current.component(.year, from: Date())
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var currentIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarView
        navigationController?.navigationBar.isHidden = true
        
        initializeCalendar()
        setAction()
        setCollectionView()
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.calendarView.myRecordCalendar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
    }
    
    // MARK: - function
    private func setCollectionView() {
        calendarView.myRecordCalendar.delegate = self
        calendarView.myRecordCalendar.dataSource = self
    }
    
    private func initializeCalendar() {
        for i in -6...6 { // 현재 달을 중심으로 앞뒤로 6개월씩 생성
            let newMonth = Calendar.current.date(byAdding: .month, value: i, to: Date())!
            let year = Calendar.current.component(.year, from: newMonth)
            let month = Calendar.current.component(.month, from: newMonth)
            months.append((year, month))
            
            if year == currentYear && month == currentMonth {
                currentIndex = months.count - 1
            }
        }
    }
    
    // MARK: - action
    private func setAction() {
        calendarView.segmentControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentControlChanged(_ segment: UISegmentedControl) {
        calendarView.updateUnderLinePosition(index: segment.selectedSegmentIndex)
        isFriendRecord = segment.selectedSegmentIndex == 1
        calendarView.myRecordCalendar.reloadData()
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarCell.identifier, for: indexPath) as? CustomCalendarCell else {
            return UICollectionViewCell()
        }
        
        let (year, month) = months[indexPath.item]
        cell.configure(with: year, month: month, isFriendRecord: isFriendRecord)
        return cell
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let visibleCell = calendarView.myRecordCalendar.visibleCells.first,
              let indexPath = calendarView.myRecordCalendar.indexPath(for: visibleCell) else { return }

        // 첫 번째 혹은 마지막에 도달하면 추가
        if indexPath.item == 0 {
            prependPreviousMonth()
        } else if indexPath.item == months.count - 1 {
            appendNextMonth()
        }
    }
    
    // 이전 달 추가
    private func prependPreviousMonth() {
        guard let firstMonthDate = Calendar.current.date(from: DateComponents(year: months.first!.year, month: months.first!.month)) else {
            print("Error: Could not create first month date")
            return
        }
        
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: firstMonthDate) else {
            print("Error: Could not create new date")
            return
        }
        
        let year = Calendar.current.component(.year, from: newDate)
        let month = Calendar.current.component(.month, from: newDate)
        
        months.insert((year, month), at: 0)
        calendarView.myRecordCalendar.reloadData()
        
        // 기존 위치 유지
        let indexPath = IndexPath(item: 1, section: 0)
        calendarView.myRecordCalendar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }

    // 다음 달 추가
    private func appendNextMonth() {
        guard let lastMonthDate = Calendar.current.date(from: DateComponents(year: months.last!.year, month: months.last!.month)) else {
            print("Error: Could not create last month date")
            return
        }

        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: lastMonthDate) else {
            print("Error: Could not create new date")
            return
        }
        
        let year = Calendar.current.component(.year, from: newDate)
        let month = Calendar.current.component(.month, from: newDate)
        
        months.append((year, month))
        calendarView.myRecordCalendar.reloadData()
    }
}
