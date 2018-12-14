//
//  ViewController.swift
//  JTCalendarCustom
//
//  Created by Lam Le Tung on 12/14/18.
//  Copyright © 2018 ltlam. All rights reserved.
//

import UIKit

protocol CalendarDelegate {
    func didUpdatedDates(_ startDate: Date?, _ endDate: Date?,_ dateRanges: String)
}

class ViewController: UIViewController {
    
    @IBOutlet weak var lbrangeDates: UILabel!

    var startDate: Date? = nil
    var endDate: Date? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lbrangeDates.text = "Have not choose yet."
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCalendar" {
            let vc = segue.destination as! CalendarSelection
            vc.delegate = self
        }
    }

    @IBAction func showCalendar(_ sender: Any) {
        performSegue(withIdentifier: "showCalendar", sender: nil)
    }
    
}

extension ViewController: CalendarDelegate {
    func didUpdatedDates(_ startDate: Date?,_ endDate: Date?,_ dateRanges: String) {
        self.startDate = startDate
        self.endDate = endDate
        self.lbrangeDates.text = dateRanges
    }
}
