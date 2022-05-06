

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var meetingDescriptionTextfield: UITextField!
    @IBOutlet weak var meetingTextfield: UITextField!
    @IBOutlet weak var startTimeTextfield: UITextField!
    @IBOutlet weak var endTimeTextfield: UITextField!
    
    let datePickerSet = UIDatePicker()
    let startTimePickerSet = UIDatePicker()
    let endTimePickerSet = UIDatePicker()
    var jsonResult: [[String : Any]] = []
    var slot = 0
    
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
        startTimeTextfield.inputView = startTimePickerSet
        startTimePickerSet.datePickerMode = .time
        startTimePickerSet.preferredDatePickerStyle = .wheels
    }
    
    @objc func startTimeDonePressed () {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .none
        formatter2.timeStyle = .short
        formatter2.dateFormat = "HH:mm"
        startTimeTextfield.text = formatter2.string(from: startTimePickerSet.date)
        self.view.endEditing(true)
    }
    
    func createEndTimePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(endTimeDonePressed))
        toolbar.setItems([doneBtn], animated: true)
        endTimeTextfield.inputAccessoryView = toolbar
        endTimeTextfield.inputView = endTimePickerSet
        endTimePickerSet.datePickerMode = .time
        endTimePickerSet.preferredDatePickerStyle = .wheels
    }
    
    @objc func endTimeDonePressed () {
        let formatter2 = DateFormatter()
        formatter2.dateStyle = .none
        formatter2.timeStyle = .short
        formatter2.dateFormat = "HH:mm"
        endTimeTextfield.text = formatter2.string(from: endTimePickerSet.date)
        self.view.endEditing(true)
    }
    
    func getData() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        if let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: datePickerSet.date))") {
            let session = URLSession.shared
            let task = session.dataTask(with:serviceUrl) { [self] (serviceData ,serviceResponse, error) in
                if error == nil {
                    if let serviceDataVariable = serviceData {
                        if let httpResponse = serviceResponse as? HTTPURLResponse {
                            if(httpResponse.statusCode == 200) {
                                let json = try? JSONSerialization.jsonObject (with: serviceDataVariable, options: .mutableContainers)
                                    if let result = json as? [[String: Any]] {
                                        jsonResult = result
                                        slotAvailabilityChecker()
                                    }
                                }
                            }
                        }
                    }
                }
            task.resume()
        }
    }

    func slotAvailabilityChecker() {
        let formatter2 = DateFormatter()
                formatter2.timeZone = .current
                formatter2.locale = .current
                formatter2.dateFormat = "HH:mm"
        for jsonElement in jsonResult {
            var meetingStartTime = "\(jsonElement["start_time"] as? String ?? "")"
            var meetingEndTime = "\(jsonElement["end_time"] as? String ?? "")"
            if meetingStartTime.count == 4 {
                meetingStartTime = "0" + meetingStartTime
            }
            if meetingEndTime.count == 4 {
                meetingEndTime = "0" + meetingEndTime
            }
            if (formatter2.string(from: startTimePickerSet.date) >= meetingStartTime && formatter2.string(from: startTimePickerSet.date) <= meetingEndTime) || (formatter2.string(from: endTimePickerSet.date) >= meetingStartTime && formatter2.string(from: endTimePickerSet.date) <= meetingEndTime) || (meetingStartTime >= formatter2.string(from: startTimePickerSet.date) && meetingStartTime <= formatter2.string(from: endTimePickerSet.date)) || (meetingEndTime >= formatter2.string(from: startTimePickerSet.date) && meetingEndTime <= formatter2.string(from: endTimePickerSet.date)) {
                slot = slot + 1
            }
        }
        slotAvailabilityPrinter()
    }
    
    func slotAvailabilityPrinter() {
        if endTimeTextfield.text == "" || startTimeTextfield.text == "" || meetingTextfield.text == "" {
            DispatchQueue.main.async {
                self.showAlert(title: "Enter all meeting details", message: "", segueDismiss: false)
            }
        } else if slot == 0 {
            DispatchQueue.main.async {
                self.showAlert(title: "Slot Available", message: "", segueDismiss: true)
            }
        } else {
            DispatchQueue.main.async {
                self.showAlert(title: "Slot Not Available", message: "", segueDismiss: true)
            }
        }
    }
    
    func showAlert(title: String, message: String ,segueDismiss: Bool) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)
                if segueDismiss { self.dismiss(animated: true, completion: nil) } }))
                self.present(alert, animated: true, completion: nil)
        }

    @IBAction func submitButtonPresed(_ sender: Any) {
        getData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

