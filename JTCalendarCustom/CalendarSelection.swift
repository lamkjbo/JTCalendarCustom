//
//  CalendarSelection.swift
//  JTCalendarCustom
//
//  Created by Lam Le Tung on 12/14/18.
//  Copyright © 2018 ltlam. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CalendarSelection: UIViewController {

    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet weak var selectTitle: UILabel!
    @IBOutlet weak var selectedDates: UILabel!
    @IBOutlet weak var btnApplyDateSelection: UIButton!
    @IBOutlet weak var mon: UILabel!
    @IBOutlet weak var tue: UILabel!
    @IBOutlet weak var wed: UILabel!
    @IBOutlet weak var thu: UILabel!
    @IBOutlet weak var fri: UILabel!
    @IBOutlet weak var sat: UILabel!
    @IBOutlet weak var sun: UILabel!
    
    let formatter = DateFormatter()
    var datesToDeselect: [Date]?
    var dateSelect = Date()
    
    var delegate:CalendarDelegate?
    var startDate = Date()
    var endDate = Date()
    var isSelected = true
    var isClear = true
    var isClearDates = false
    var datesRange = -1
    @IBOutlet weak var calendarWidth: NSLayoutConstraint!
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    let backgroudViewColor = UIColor.init(red: 230/255, green: 0, blue: 0, alpha: 0.5)
    
    @IBAction func onBack(_ sender: Any) {
        Utility.backToPreviousScreen(self)
    }
    
    @IBAction func next(_ sender: Any) {
        self.calendarView.scrollToSegment(.next)
    }
    
    @IBAction func previous(_ sender: Any) {
        self.calendarView.scrollToSegment(.previous)
    }
    
    @IBAction func applyDateSelection(_ sender: Any) {
        self.delegate?.didUpdatedDates(startDate, endDate, self.selectedDates.text ?? "All time")
        Utility.backToPreviousScreen(self)
    }
    @IBAction func showAll(_ sender: Any) {
        self.delegate?.didUpdatedDates(nil, nil, "All time")
        Utility.backToPreviousScreen(self)
    }
    
    func initData(_ dates: [Date]) {
        
        calendarView.selectDates(
            from: dates.first!,
            to: dates.last!,
            triggerSelectionDelegate: true,
            keepSelectionIfMultiSelectionAllowed: true)
        
        calendarView.reloadData()
    }
    
    func initDate(){
        if let firstDate = calendarView.selectedDates.first, let lastDate = calendarView.selectedDates.last {
            selectedDates.text = convertDateFormat(firstDate) + " to " + convertDateFormat(lastDate)
            startDate = firstDate
            endDate = lastDate
        }
    }
    
    let df = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let model = UIDevice.current.modelName
        if model == "iPhone 7 Plus" || model == "iPhone 8 Plus" {
            calendarWidth.constant = 410.0
            calendarHeight.constant = 375.0
        }
        
        let date = Date()
        self.calendarView.scrollToDate(date, animateScroll: false)
        
        calendarView.visibleDates() { visibleDates in
            self.setupMonthLabel(date: visibleDates.monthDates.first!.date)
        }
        
        calendarView.isRangeSelectionUsed = true
        calendarView.allowsMultipleSelection = true
        
        //        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        
        activeButton()
    }
    
    func activeButton() {
        if calendarView.selectedDates.count == 0 {
            btnApplyDateSelection.isEnabled = false
            btnApplyDateSelection.backgroundColor = UIColor(red:204/255, green:204/255, blue:204/255, alpha:1)
            btnApplyDateSelection.setTitleColor(UIColor(red:102/255, green:102/255, blue:102/255, alpha:1), for: .normal)
            selectTitle.text = "Please choose a date or date range to filter the SOS Band activities."
            selectedDates.isHidden = true
        } else {
            btnApplyDateSelection.isEnabled = true
            btnApplyDateSelection.backgroundColor = UIColor.red
            btnApplyDateSelection.setTitleColor(UIColor.white, for: .normal)
            if calendarView.selectedDates.count == 1 {
                selectTitle.text = "Your selected date:"
            } else {
                selectTitle.text = "Your selected dates:"
            }
            selectedDates.isHidden = false
        }
        
    }
    
    func setupMonthLabel(date: Date) {
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        let year = String(anchorComponents.year ?? 2018)
        let month = String(anchorComponents.month ?? 1)
        
        monthLabel.text = month
        yearLabel.text = year
        
        // day of week
        mon.text = "MON"
        tue.text = "TUE"
        wed.text = "WED"
        thu.text = "THU"
        fri.text = "FRI"
        sat.text = "SAT"
        sun.text = "SUN"
    }
    
    func handleConfiguration(cell: JTAppleCell?, cellState: CellState) {
        guard let cell = cell as? TestRangeSelectionViewControllerCell else { return }
        handleCellColor(cell: cell, cellState: cellState)
        handleCellSelection(cell: cell, cellState: cellState)
    }
    
    func handleCellColor(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.label.textColor = .black
        } else {
            cell.label.textColor = .gray
        }
    }
    
    func handleCellSelection(cell: TestRangeSelectionViewControllerCell, cellState: CellState) {
        if cellState.dateBelongsTo == .thisMonth {
            cell.selectedView.isHidden = !cellState.isSelected
            print("Position: \(cellState.selectedPosition())")
            switch cellState.selectedPosition() {
            case .left:
                cell.circleView.isHidden = false
                cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                
                cell.selectedView.backgroundColor = backgroudViewColor
                cell.selectedView.roundCorners([.layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                cell.label.textColor = .white
            case .middle:
                cell.circleView.isHidden = true
                cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                
                cell.selectedView.backgroundColor = backgroudViewColor
                cell.selectedView.roundCorners([], radius: 0)
                cell.label.textColor = .white
            case .right:
                cell.circleView.isHidden = false
                cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                
                cell.selectedView.backgroundColor = backgroudViewColor
                cell.selectedView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                cell.label.textColor = .white
            case .full:
                cell.circleView.isHidden = false
                cell.circleView.layer.cornerRadius = cell.circleView.frame.size.width/2
                
                cell.selectedView.backgroundColor = backgroudViewColor
                cell.selectedView.roundCorners([.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], radius: cell.selectedView.frame.size.width/2)
                cell.selectedView.isHidden = true
                cell.label.textColor = .white
            default:
                cell.circleView.isHidden = true
                break
            }
        } else {
            cell.selectedView.isHidden = true
            cell.circleView.isHidden = true
        }
    }
}

extension CalendarSelection: JTAppleCalendarViewDelegate, JTAppleCalendarViewDataSource {
    
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        handleConfiguration(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "cell", for: indexPath) as! TestRangeSelectionViewControllerCell
        cell.label.text = cellState.text
        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
        if cellState.dateBelongsTo == .thisMonth {
            cell.isUserInteractionEnabled = true
        } else {
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupMonthLabel(date: visibleDates.monthDates.first!.date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        
        activeButton()
        isSelected = false
        //if (calendar.selectedDates.count > 1) {
        
        if (isClearDates) {
            self.isClearDates = false
            //calendar.deselectAllDates()
            calendar.selectDates(from: date, to: date)
            calendar.reloadData()
        }
        else
            if (calendar.selectedDates.count == 2) {
                let calen = Calendar.current
                // Replace the hour (time) of both dates with 00:00
                let date1 = calen.startOfDay(for: calendar.selectedDates.first!)
                let date2 = calen.startOfDay(for: calendar.selectedDates.last!)
                
                let components = calen.dateComponents([.day], from: date1, to: date2)
                datesRange = components.day! + 1
                
                initData(calendar.selectedDates)
                if date > calendar.selectedDates.first! {
                    selectedDates.text = convertDateFormat(calendar.selectedDates.first!) + " to " + convertDateFormat(date)
                    startDate = calendar.selectedDates.first!
                    endDate = date
                } else {
                    selectedDates.text = convertDateFormat(date) + " to " + convertDateFormat(calendar.selectedDates.last!)
                    startDate = date
                    endDate = calendar.selectedDates.last!
                }
        }
        
        if calendar.selectedDates.count == datesRange {
            self.isClearDates = true
            datesRange = -1
        }
        isClear = true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleConfiguration(cell: cell, cellState: cellState)
        if isSelected {activeButton()}
        if (calendar.selectedDates.count == 1) {
            selectedDates.text = convertDateFormat(calendar.selectedDates.first!)
        } else{
            self.initDate()
        }
        isSelected = true
    }
    
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let df = DateFormatter()
        df.dateFormat = "yyyy MM dd"
        
        let startDate = df.date(from: "2018 01 01")!
        let endDate = df.date(from: "2030 12 31")!
        
        let parameter = ConfigurationParameters(startDate: startDate,
                                                endDate: endDate,
                                                numberOfRows: 6,
                                                generateInDates: .forAllMonths,
                                                generateOutDates: .tillEndOfGrid,
                                                firstDayOfWeek: .monday)
        return parameter
    }
    
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        dateSelect = date
        datesToDeselect?.append(date)
        
        if (calendar.selectedDates.count == 0) {
            selectedDates.text = convertDateFormat(date)
            startDate = date
            endDate = date
        }
        return true
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        let selectedDates = calendar.selectedDates
        dateSelect = date
        isSelected = true
        self.isClearDates = false
        
        if selectedDates.contains(date) {
            
            // remove dates from the last selected.
            //            if (selectedDates.count > 2 && selectedDates.first != date && selectedDates.last != date) {
            //                let indexOfDate = selectedDates.index(of: date)
            //                let dateBeforeDeselectedDate = selectedDates[indexOfDate!]
            //                calendar.deselectAllDates()
            //                calendar.selectDates(
            //                    from: selectedDates.first!,
            //                    to: dateBeforeDeselectedDate,
            //                    triggerSelectionDelegate: true,
            //                    keepSelectionIfMultiSelectionAllowed: true)
            //                calendar.reloadData()
            //            }
            
            if (selectedDates.count > 1 && isClear) {
                self.isClear = false
                calendar.deselectAllDates()
                calendar.selectDates(from: date, to: date)
                calendarView.reloadData(withanchor: date, completionHandler: {
                })
            }
            
        }
        
        return true
    }
    
}

class TestRangeSelectionViewControllerCell: JTAppleCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var selectedView: UIView!
    @IBOutlet weak var circleView: UIView!
}



extension CalendarSelection {
    func convertDateFormat(_ date : Date) -> String{
        // Day
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        // month
        let month = String(anchorComponents.month ?? 1)
        
        // day of month
        let day = String(anchorComponents.day ?? 1)
        
        // year
        let year = String(anchorComponents.year ?? 2018)
        
        let result = String(format: "%1$@-%2$@-%3$@", day, month, year)
        return result
    }
}

