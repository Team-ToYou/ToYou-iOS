//
//  CalendarViewController.swift
//  ToYou
//
//  Created by 이승준 on 2/1/25.
//

import UIKit
import Alamofire

class CalendarViewController: UIViewController {
    let calendarView = CalendarView()
    
    private var isFriendRecord: Bool = false
    
    private var months: [(year: Int, month: Int)] = []
    private var currentYear = Calendar.current.component(.year, from: Date())
    private var currentMonth = Calendar.current.component(.month, from: Date())
    private var currentIndex: Int = 0
    
    // 날짜:감정
    private var emotionList: [String: String] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = calendarView
        navigationController?.navigationBar.isHidden = true
        
        initializeCalendar()
        setAction()
        setCollectionView()
        
        DispatchQueue.main.async {
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            self.calendarView.customCalendar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        }
        
        let (year, month) = months[currentIndex]
        setMyCalendarAPI(year: year, month: month)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let (year, month) = months[currentIndex]
        setMyCalendarAPI(year: year, month: month)
    }
    
    // MARK: - function
    private func setCollectionView() {
        calendarView.customCalendar.delegate = self
        calendarView.customCalendar.dataSource = self
        calendarView.friendRecordList.dataSource = self
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
    
    private func setMyCalendarAPI(year: Int, month: Int) {
        let url = K.URLString.baseURL + "/diarycards/mine?year=\(year)&month=\(month)"
        
        guard let accessToken = KeychainService.get(key: K.Key.accessToken) else { return }
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(accessToken)"
        ]
        
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MyDiaryCardResponse.self) { response in
                switch response.result {
                case .success(let data):
                    self.emotionList = [:]
                    for card in data.result.cardList {
                        self.emotionList[card.date] = card.emotion
                    }

                    let indexPath = IndexPath(item: self.currentIndex, section: 0)
                    self.calendarView.customCalendar.reloadItems(at: [indexPath])
                case .failure(let error):
                    print("My Calendar API Error: \(error)")
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
        
        if isFriendRecord {
            calendarView.friendDateLabel.isHidden = false
            calendarView.friendLabel.isHidden = false
            calendarView.friendRecordList.isHidden = false
        } else {
            calendarView.friendDateLabel.isHidden = true
            calendarView.friendLabel.isHidden = true
            calendarView.friendRecordList.isHidden = true
        }
        
        calendarView.customCalendar.reloadData()
    }
    
}

extension CalendarViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == calendarView.customCalendar {
            return months.count
        } else if collectionView == calendarView.friendRecordList {
            return 7
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == calendarView.customCalendar {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCalendarCell.identifier, for: indexPath) as? CustomCalendarCell else {
                return UICollectionViewCell()
            }
            
            let (year, month) = months[indexPath.item]
            cell.configure(with: year, month: month, isFriendRecord: isFriendRecord, emotionList: emotionList)
            
            return cell
        } else if collectionView == calendarView.friendRecordList {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendRecordListCell.identifier, for: indexPath) as? FriendRecordListCell else {
                return UICollectionViewCell()
            }
            
            return cell
        }

        return UICollectionViewCell()
    }
    
    
}

extension CalendarViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let visibleCell = calendarView.customCalendar.visibleCells.first,
              let indexPath = calendarView.customCalendar.indexPath(for: visibleCell) else { return }

        currentIndex = indexPath.item

        let (year, month) = months[currentIndex]
        setMyCalendarAPI(year: year, month: month)
        
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
        calendarView.customCalendar.reloadData()
        
        // 기존 위치 유지
        let indexPath = IndexPath(item: 1, section: 0)
        calendarView.customCalendar.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
        calendarView.customCalendar.reloadData()
    }
}
