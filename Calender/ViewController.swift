//
//  ViewController.swift
//  Calender
//
//  Created by Prakash on 06/06/20.
//  Copyright © 2020 Prakash. All rights reserved.
//

import UIKit
import FSCalendar

class ViewController: UIViewController,FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance {
    
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var viewCalender: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    // Tithi Name
    fileprivate let lunarFormatter = LunarFormatter()
    
    // Perticular Selected
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    fileprivate weak var eventLabel: UILabel!
    
    // Date Formate
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        formatter.dateStyle = .long
        formatter.dateFormat = "EEEE, dd MMMM, yyyy"
        return formatter
    }()
    
    var selectedDate = [String]()
    var totalEvent : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.lblDate.layer.borderColor = UIColor.black.cgColor
        self.lblDate.layer.borderWidth = 1.5
        
        SetupCalender()
    }
    
    // Setup calander
    func SetupCalender() {
        
        viewCalender.allowsMultipleSelection = true
        viewCalender.calendarHeaderView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        viewCalender.calendarWeekdayView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.1)
        viewCalender.appearance.eventSelectionColor = UIColor.white
        viewCalender.appearance.borderRadius = 0
        
        // Display only Date of current month
        viewCalender.placeholderType = .none
        
        //        viewCalender.appearance.eventOffset = CGPoint(x: 0, y: -7)
    }
    
    //MARK:- FSCalander Delegate & Datasource
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    // Get perticular selected date And Selected Date Array
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        if !self.gregorian.isDateInWeekend(date) {
            dateFormatter.dateFormat = "yyyy-MM-dd"

            print("did select date \(self.dateFormatter.string(from: date))")
            let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
            print("selected dates is \(selectedDates)")
            self.lblDate.text = self.dateFormatter.string(from: date)
            
            if monthPosition == .next || monthPosition == .previous {
                calendar.setCurrentPage(date, animated: true)
            }
            
            selectedDate = selectedDates
            
            //
            //            let formatter = DateFormatter()
            //            formatter.dateFormat = "dd"
            //            selectedDate.append(Int(formatter.string(from: date))!)
            calendar.reloadData()
        }
        
    }
    
    // Get New Month when Paging
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    // Set Title of Current Date
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        if self.gregorian.isDateInToday(date) {
            return "OK"
        }
        return nil
    }
    
    
    // Set number of Events Line Dot
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let day: Int! = self.gregorian.component(.day, from: date)
        return day % 5 == 0 ? day/5 : 0
    }
    
    // Set Event Dot Color
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        if self.gregorian.isDateInToday(date) {
            return [UIColor.green]
        }
        return [appearance.eventDefaultColor]
    }
    
    // Display Current Month
    func calendar(_ calendar: FSCalendar, shouldSelect date: Date, at monthPosition: FSCalendarMonthPosition)   -> Bool {
        return monthPosition == .current
    }
    
    // NOt Display Current Month
    func calendar(_ calendar: FSCalendar, shouldDeselect date: Date, at monthPosition: FSCalendarMonthPosition) -> Bool {
        return monthPosition == .current
    }
    
    // Set Tithi Name
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        return self.lunarFormatter.string(from: date)
    }
    
    // Set Image on Perticular Day
    func calendar(_ calendar: FSCalendar, imageFor date: Date) -> UIImage? {
        
        if selectedDate.contains(dateFormatter.string(from: date))
        {
            return UIImage(named: "icon_cat")
        }
        
        return nil
        
        //        let day: Int! = self.gregorian.component(.day, from: date)
        //        return selectedDate.contains(day) ? UIImage(named: "icon_cat") : nil
    }
    
    // Clear Color of Weekend Day
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        
        if !self.gregorian.isDateInWeekend(date)
        {
            return UIColor.green
        }
        
        return UIColor.clear
    }
    
    // Clear TExt Color for Weekend day
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        
        if !self.gregorian.isDateInWeekend(date)
        {
            return UIColor.black
        }
        
        return UIColor.red
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        
        return UIColor.gray
    }
    
    // Clear border Color for Weekend day
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderSelectionColorFor date: Date) -> UIColor? {
        
        if !self.gregorian.isDateInWeekend(date)
        {
            return UIColor.gray
        }
        
        return UIColor.clear
    }
    
    // Remove corner radius of selected perticular date
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, borderRadiusFor date: Date) -> CGFloat {
        
        if !self.gregorian.isDateInWeekend(date)
        {
            return 20
        }
        
        return 0
        
    }
    
    /*
     // Selected date starting to End And Other date are not selected
     func minimumDate(for calendar: FSCalendar) -> Date {
     return Date().startOfMonth()
     }
     
     func maximumDate(for calendar: FSCalendar) -> Date {
     return Date().endOfMonth()
     }
     */
}

extension Date {
    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }
    
    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth())!
    }
}
