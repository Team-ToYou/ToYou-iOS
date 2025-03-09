//
//  CalendarManager.swift
//  ToYou
//
//  Created by 김미주 on 10/03/2025.
//

import Foundation

struct CalendarDate {
    let date: Date
    let day: Int
    let isWithinCurrentMonth: Bool
}

class CalendarManager {
    static let shared = CalendarManager()
    private let calendar = Calendar.current
    
    func generateDates(for year: Int, month: Int) -> [CalendarDate] {
        var dates: [CalendarDate] = []
        
        guard let firstDayOfMonth = calendar.date(from: DateComponents(year: year, month: month, day: 1)),
              let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth) else {
            return []
        }
        
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth) - 1 // 0 기반 인덱스 조정
        let totalDays = range.count
        let totalCells = ((firstWeekday + totalDays) <= 35) ? 35 : 42 // 6주 보장

        for i in 0..<totalCells {
            let offset = i - firstWeekday
            let date = calendar.date(byAdding: .day, value: offset, to: firstDayOfMonth)!

            let isWithinCurrentMonth = offset >= 0 && offset < totalDays
            let day = isWithinCurrentMonth ? offset + 1 : 0
            
            dates.append(CalendarDate(date: date, day: day, isWithinCurrentMonth: isWithinCurrentMonth))
        }
        
        return dates
    }
}
