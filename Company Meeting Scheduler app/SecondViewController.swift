//
//  SecondViewController.swift
//  Company Meeting Scheduler
//
//  Created by Roro on 4/24/22.
//

import UIKit

class SecondViewController: UIViewController {


    @IBOutlet weak var meetingDescriptionTextfield: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var startTime: UIDatePicker!
    @IBOutlet weak var endTime: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        datePicker.locale = .current
        datePicker.date = Date()
        datePicker.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        
        startTime.locale = .current
        startTime.date = Date()
        startTime.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        
        endTime.locale = .current
        endTime.date = Date()
        endTime.addTarget(self, action: #selector(dateSelected), for: .valueChanged)
        

        // Do any additional setup after loading the view.
    }
    
    @objc func dateSelected() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: datePicker.date))
        
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "HH:mm"
        print(formatter2.string(from: startTime.date))
       
        print(formatter2.string(from: endTime.date))
        
        
//        print(datePicker.date)
//        print(startTime.date)
        //        print(endTime.date)
    }
    
    @IBAction func descriptionClicked(_ sender: Any) {
       
    }
    @IBAction func submitButtonPresed(_ sender: Any) {
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
