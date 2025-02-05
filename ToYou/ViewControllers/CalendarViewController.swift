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
    }
    
}

