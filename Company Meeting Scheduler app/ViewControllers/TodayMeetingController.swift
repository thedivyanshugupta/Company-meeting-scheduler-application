
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var dataDictionary = [[String : Any]]()
    var currentDate = Date()
    
    @IBOutlet weak var todayDate: UILabel!
    
    @IBOutlet weak var cellTableVieew: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getTodayMeeting()
        cellTableVieew.delegate = self
        cellTableVieew.dataSource = self
    }
    
    func getTodayMeeting() {
        let todaysDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let DateInFormat = dateFormatter.string(from: todaysDate)
        todayDate.text = DateInFormat
        getMeetingData(meetingDate: DateInFormat)
    }
    
    func getMeetingData(meetingDate: String) {
        if let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(meetingDate)") {
            let session = URLSession.shared
            let task = session.dataTask(with:serviceUrl) { (serviceData, serviceResponse, error) in
                if error == nil {
                    if let serviceDataVariable = serviceData {
                        if let httpResponse = serviceResponse as? HTTPURLResponse{
                            if(httpResponse.statusCode == 200) {
                                let json = try? JSONSerialization.jsonObject (with: serviceDataVariable, options: .mutableContainers)
                                if let result = json as? [[String: Any]] {
                                    self.jsonParsing(json: result)
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func jsonParsing(json : [[String: Any]]) {
        dataDictionary = json
        DispatchQueue.main.async {
            self.cellTableVieew.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataDictionary.count
    }

    func tableView(_ tableView: UITableView,  cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cells") as? Cells else { return UITableViewCell() }
        let number = dataDictionary[indexPath.row]
        cell.startEndTime.text = "\(number["start_time"] as? String ?? "") - \(number["end_time"] as? String ?? "")"
        cell.meetingDescription.text = number["description"] as? String
        return cell
    }
    
    func getNextOrPrevDateMeeting(dayNumber: Double) {
        let newDate = currentDate.addingTimeInterval(+(dayNumber) * 24 * 60 * 60)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        todayDate.text = formatter.string(from: newDate)
        getMeetingData(meetingDate: formatter.string(from: newDate))
        currentDate = newDate
    }
    
    @IBAction func nextButton(_ sender: Any) {
       getNextOrPrevDateMeeting(dayNumber: 1)
    }

    @IBAction func prevButton(_ sender: Any) {
        getNextOrPrevDateMeeting(dayNumber: -1)
    }

}
