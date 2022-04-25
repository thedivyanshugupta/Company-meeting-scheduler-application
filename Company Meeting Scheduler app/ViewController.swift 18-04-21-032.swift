//
//  ViewController.swift
//  Company Meeting Scheduler
//
//  Created by Roro on 4/8/22.

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var dictionary = [[String : Any]]()
    
    @IBOutlet weak var TodayDate: UILabel!
    
    @IBOutlet weak var cellTableVieew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        cellTableVieew.delegate = self
        cellTableVieew.dataSource = self
        
    }
    func getData() {
        
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        TodayDate.text = DateInFormat
        print(DateInFormat)
        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(DateInFormat)")
        let session = URLSession.shared
        print(DateInFormat)
        let task = session.dataTask(with:serviceUrl!) { (serviceData, serviceResponse, error) in
            if error == nil {
                let httpResponse = serviceResponse as! HTTPURLResponse
                if(httpResponse.statusCode == 200) {
                    let json = try? JSONSerialization.jsonObject (with: serviceData!, options: .mutableContainers)
                    if let result = json as? [[String: Any]]
                    {
                        self.jsonParsing(json: result)
                        print(json)
                    }
                }
            }
        }
        task.resume()
    }
    
    func jsonParsing(json : [[String: Any]]) {
        print(json)
        dictionary = json
        DispatchQueue.main.async {
            self.cellTableVieew.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dictionary.count
    }

    func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cells") as! Cells
        let number = dictionary[indexPath.row]
        cell.startEnd.text = "\(number["start_time"] as? String ?? "") - \(number["end_time"] as? String ?? "")"
        cell.descript.text = number["description"] as! String
        return cell
    }
    
    func convertNextDate() {
        let currentDate = Date()
        var dateComponent = DateComponents()
        dateComponent.day = 1
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: currentDate)
        print(currentDate)
        print(futureDate!)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: futureDate!))
        TodayDate.text = formatter.string(from: futureDate!)
        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: futureDate!))")
        let session = URLSession.shared
        let task = session.dataTask(with:serviceUrl!) { (serviceData, serviceResponse, error) in
            if error == nil {
                let httpResponse = serviceResponse as! HTTPURLResponse
                if(httpResponse.statusCode == 200) {
                    let json = try? JSONSerialization.jsonObject (with: serviceData!, options: .mutableContainers)
                    if let result = json as? [[String: Any]]
                    {
                        self.jsonParsing(json: result)
                    }
                }
            }
        }
        task.resume()
    }
    
    func convertPrevDate() {
        let prevDate = Date().addingTimeInterval(-1 * 24 * 60 * 60)
        print(prevDate)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: prevDate))
        TodayDate.text = formatter.string(from: prevDate)
        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: prevDate))")
        let session = URLSession.shared
        let task = session.dataTask(with:serviceUrl!) { (serviceData, serviceResponse, error) in
            if error == nil {
                let httpResponse = serviceResponse as! HTTPURLResponse
                if(httpResponse.statusCode == 200) {
                    let json = try? JSONSerialization.jsonObject (with: serviceData!, options: .mutableContainers)
                    if let result = json as? [[String: Any]]
                    {
                        self.jsonParsing(json: result)
                    }
                }
            }
        }
        task.resume()
    }
    
    @IBAction func nextButton(_ sender: Any) {
        convertNextDate()
    
    }

    @IBAction func prevButton(_ sender: Any) {
        convertPrevDate()
    }

}
