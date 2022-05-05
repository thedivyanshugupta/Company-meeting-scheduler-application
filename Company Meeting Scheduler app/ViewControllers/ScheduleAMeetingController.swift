

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var meetingDescriptionTextfield: UITextField!
    @IBOutlet weak var meetingTextfield: UITextField!
    @IBOutlet weak var startTimeTextfield: UITextField!
    @IBOutlet weak var endTimeTextfield: UITextField!
    
    let datePickerSet = UIDatePicker()
    let starttimePickerSet = UIDatePicker()
    let endtimePickerSet = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
        createStartTimePicker()
        createEndTimePicker()
    }
    
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        meetingTextfield.inputAccessoryView = toolbar
        meetingTextfield.inputView = datePickerSet
        datePickerSet.datePickerMode = .date
        datePickerSet.preferredDatePickerStyle = .inline
    }
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.dateFormat = "dd/MM/yyyy"
        meetingTextfield.text = formatter.string(from: datePickerSet.date)
        self.view.endEditing(true)
    }
    
    func createStartTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(startTimeDonePressed))
        toolbar.setItems([doneBtn], animated: true)
        startTimeTextfield.inputAccessoryView = toolbar
        startTimeTextfield.inputView = starttimePickerSet
        starttimePickerSet.datePickerMode = .time
        starttimePickerSet.preferredDatePickerStyle = .wheels
    }
    
    @objc func startTimeDonePressed () {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .none
        formatter2.timeStyle = .short
        formatter2.dateFormat = "HH:mm"
        startTimeTextfield.text = formatter2.string(from: starttimePickerSet.date)
        self.view.endEditing(true)
    }
    
    func createEndTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeDonePressed))
        toolbar.setItems([doneBtn], animated: true)
        endTimeTextfield.inputAccessoryView = toolbar
        endTimeTextfield.inputView = endtimePickerSet
        endtimePickerSet.datePickerMode = .time
        endtimePickerSet.preferredDatePickerStyle = .wheels
    }
    
    @objc func endTimeDonePressed () {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .none
        formatter2.timeStyle = .short
        formatter2.dateFormat = "HH:mm"
        endTimeTextfield.text = formatter2.string(from: endtimePickerSet.date)
        self.view.endEditing(true)
    }
    
    func getData() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "HH:mm"
        if let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: datePickerSet.date))") {
            let session = URLSession.shared
            let task = session.dataTask(with:serviceUrl) { [self] (serviceData ,serviceResponse, error) in
                if error == nil {
                    if let serviceDataVariable = serviceData {
                        let httpResponse = serviceResponse as! HTTPURLResponse
                        if(httpResponse.statusCode == 200) {
                            let json = try? JSONSerialization.jsonObject (with: serviceDataVariable, options: .mutableContainers)
                            if let result = json as? [[String: Any]] {
                                var slot = 0
                                for jsonElement in result {
                                    var meetingStartTime = "\(jsonElement["start_time"] as? String ?? "")"
                                    var meetingEndTime = "\(jsonElement["end_time"] as? String ?? "")"
                                    if meetingStartTime.count == 4 {
                                        meetingStartTime = "0" + meetingStartTime
                                    }
                                    if meetingEndTime.count == 4 {
                                        meetingEndTime = "0" + meetingEndTime
                                    }
                                    if (formatter2.string(from: starttimePickerSet.date) >= meetingStartTime && formatter2.string(from: starttimePickerSet.date) <= meetingEndTime) || (formatter2.string(from: endtimePickerSet.date) >= meetingStartTime && formatter2.string(from: endtimePickerSet.date) <= meetingEndTime) || (meetingStartTime >= formatter2.string(from: starttimePickerSet.date) && meetingStartTime <= formatter2.string(from: endtimePickerSet.date)) || (meetingEndTime >= formatter2.string(from: starttimePickerSet.date) && meetingEndTime <= formatter2.string(from: endtimePickerSet.date)) {
                                        slot = slot + 1
                                    }
                                }
                                if endTimeTextfield.text == "" || startTimeTextfield.text == "" || meetingTextfield.text == "" {
                                    DispatchQueue.main.async {
                                        showAlertForAllMeetingDetails(title: "Enter all meeting details", message: "")
                                    }
                                } else if slot == 0 {
                                    DispatchQueue.main.async {
                                        showAlert(title: "Slot Available", message: "")
                                    }
                                } else {
                                    DispatchQueue.main.async {
                                        showAlert(title: "Slot Not Available", message: "")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            task.resume()
        }
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
            self.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    
    func showAlertForAllMeetingDetails(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }

    @IBAction func submitButtonPresed(_ sender: Any) {
        getData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

