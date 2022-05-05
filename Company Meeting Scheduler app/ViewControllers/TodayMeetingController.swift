
import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
    var dictionary = [[String : Any]]()
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
                        let httpResponse = serviceResponse as! HTTPURLResponse
                        if(httpResponse.statusCode == 200) {
                            let json = try? JSONSerialization.jsonObject (with: serviceDataVariable, options: .mutableContainers)
                            if let result = json as? [[String: Any]] {
                                self.jsonParsing(json: result)
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }
    
    func jsonParsing(json : [[String: Any]]) {
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
        cell.startEndTime.text = "\(number["start_time"] as? String ?? "") - \(number["end_time"] as? String ?? "")"
        cell.meetingDescription.text = number["description"] as? String
        return cell
    }
    
    func getNextDateMeeting() {
        let futureDate = currentDate.addingTimeInterval(+(1) * 24 * 60 * 60)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        todayDate.text = formatter.string(from: futureDate)
        getMeetingData(meetingDate: formatter.string(from: futureDate))
        currentDate = futureDate
    }
    
    func getPrevDateMeeting() {
        let prevDate = currentDate.addingTimeInterval(-(1) * 24 * 60 * 60)
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        todayDate.text = formatter.string(from: prevDate)
        getMeetingData(meetingDate: formatter.string(from: prevDate))
        currentDate = prevDate
    }
    
    @IBAction func nextButton(_ sender: Any) {
       getNextDateMeeting()
    }

    @IBAction func prevButton(_ sender: Any) {
        getPrevDateMeeting()
    }

}
