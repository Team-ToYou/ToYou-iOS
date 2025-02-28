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
    }
    
    // MARK: - function
    
    // MARK: - action
    private func setAction() {
        calendarView.segmentControl.addTarget(self, action: #selector(segmentControlChanged(_:)), for: .valueChanged)
    }
    
    @objc private func segmentControlChanged(_ segment: UISegmentedControl) {
        calendarView.updateUnderLinePosition(index: segment.selectedSegmentIndex)
    }
    
}

