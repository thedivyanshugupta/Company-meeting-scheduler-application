//
//  SecondViewController.swift
//  Company Meeting Scheduler
//
//  Created by Roro on 4/24/22.
//

import UIKit

class SecondViewController: UIViewController {

    var dictionary = [[String : Any]]()
    
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

    }
    
    func getData() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: datePicker.date))
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "HH:mm"
        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: datePicker.date))")
        let session = URLSession.shared
        print(datePicker.date)
        let task = session.dataTask(with:serviceUrl!) { [self] (serviceData, serviceResponse, error) in
            if error == nil {
                let httpResponse = serviceResponse as! HTTPURLResponse
                if(httpResponse.statusCode == 200) {
                    let json = try? JSONSerialization.jsonObject (with: serviceData!, options: .mutableContainers)
                    if let result = json as? [[String: Any]]
                    {
                        self.jsonParsing(json: result)
                        print(json)
                        for jsonElement in result {
                            let a = "\(jsonElement["start_time"] as? String ?? "")"
                            let b = "\(jsonElement["end_time"] as? String ?? "")"
                            print(a)
                            print(b)
                            var n = 0
                            if (formatter2.string(from: startTime.date) >= a && formatter2.string(from: endTime.date) <= a) || (formatter2.string(from: startTime.date) >= b && formatter2.string(from: endTime.date) <= b) {
                                n = n + 1
                            }
                        }
                        if n = 0 {
                            
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func jsonParsing(json : [[String: Any]]) {
        print(json)
        dictionary = json
    }
    
    @IBAction func descriptionClicked(_ sender: Any) {
       
    }
    @IBAction func submitButtonPresed(_ sender: Any) {
        getData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
