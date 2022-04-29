

import UIKit

class SecondViewController: UIViewController {

    var dictionary = [[String : Any]]()
    
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
    
//    @objc func donePressed (format : String, textfield : String,) {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .short
//        formatter.timeStyle = .none
//        formatter.dateFormat = format
//        meetingTextfield.text = formatter.string(from: datePickerSet.date)
//        self.view.endEditing(true)
//    }
//
    @objc func donePressed () {
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
        print(formatter2.string(from: starttimePickerSet.date))
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
        print(formatter2.string(from: endtimePickerSet.date))
        self.view.endEditing(true)
    }
    
    func getData() {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd/MM/yyyy"
        print(formatter.string(from: datePickerSet.date))
        let formatter2 = DateFormatter()
        formatter2.timeZone = .current
        formatter2.locale = .current
        formatter2.dateFormat = "HH:mm"
//        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: datePicker.date))")
        let serviceUrl = URL(string: "https://fathomless-shelf-5846.herokuapp.com/api/schedule?date=\(formatter.string(from: datePickerSet.date))")
        let session = URLSession.shared
        print(datePickerSet.date)
        let task = session.dataTask(with:serviceUrl!) { [self] (serviceData, serviceResponse, error) in
            if error == nil {
                let httpResponse = serviceResponse as! HTTPURLResponse
                if(httpResponse.statusCode == 200) {
                    let json = try? JSONSerialization.jsonObject (with: serviceData!, options: .mutableContainers)
                    if let result = json as? [[String: Any]] {
                        self.jsonParsing(json: result)
//                        print(json)
                        var slot = 0
                        for jsonElement in result {
                            var meetingStartTime = "\(jsonElement["start_time"] as? String ?? "")"
                            var meetingEndTime = "\(jsonElement["end_time"] as? String ?? "")"
//                            print(meetingStartTime.count)
//                            print(meetingEndTime.count)
                            if meetingStartTime.count == 4 {
                                meetingStartTime = "0" + meetingStartTime
                            }
                            if meetingEndTime.count == 4 {
                                meetingEndTime = "0" + meetingEndTime
                            }
//                            print(meetingStartTime)
//                            print(meetingEndTime)
                            if (formatter2.string(from: starttimePickerSet.date) >= meetingStartTime && formatter2.string(from: starttimePickerSet.date) <= meetingEndTime) || (formatter2.string(from: endtimePickerSet.date) >= meetingStartTime && formatter2.string(from: endtimePickerSet.date) <= meetingEndTime) {
                                slot = slot + 1
                            }
                        }
//                        print(slot)
                        if slot == 0 {
                            DispatchQueue.main.async {
// ( An object that manages the execution of tasks serially or concurrently on your app's main thread or on a background thread.
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
        task.resume()
    }
//
//    override func viewWillTransitionToSize(size: CGSize,   withTransitionCoordinator coordinator:    UIViewControllerTransitionCoordinator) {
//
//        coordinator.animateAlongsideTransition({ (UIViewControllerTransitionCoordinatorContext) -> Void in
//
//            let orient = UIApplication.sharedApplication().statusBarOrientation
//
//            switch orient {
//            case .Portrait:
//                print("Portrait")
//                self.ApplyportraitConstraint()
//                break
//                // Do something
//            default:
//                print("LandScape")
//                // Do something else
//                self.applyLandScapeConstraint()
//                break
//            }
//            }, completion: { (UIViewControllerTransitionCoordinatorContext) -> Void in
//                print("rotation completed")
//        })
//        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
//    }
//
//    func ApplyportraitConstraint(){
//
//     self.view.addConstraint(self.RedViewHeight)
//     self.view.addConstraint(self.RedView_VerticalSpace_To_BlueView)
//     self.view.addConstraint(self.RedView_LeadingSpace_To_SuperView)
//     self.view.addConstraint(self.BlueView_TrailingSpace_To_SuperView)
//
//     self.view.removeConstraint(self.RedViewWidth)
//     self.view.removeConstraint(self.RedView_HorizontalSpace_To_BlueView)
//     self.view.removeConstraint(self.RedView_BottomSpace_To_SuperView)
//     self.view.removeConstraint(self.BlueView_TopSpace_To_SuperView)
//
//
//    }
//
//    func applyLandScapeConstraint(){
//
//        self.view.removeConstraint(self.RedViewHeight)
//        self.view.removeConstraint(self.RedView_VerticalSpace_To_BlueView)
//        self.view.removeConstraint(self.RedView_LeadingSpace_To_SuperView)
//       self.view.removeConstraint(self.BlueView_TrailingSpace_To_SuperView)
//
//        self.view.addConstraint(self.RedViewWidth)
//        self.view.addConstraint(self.RedView_HorizontalSpace_To_BlueView)
//        self.view.addConstraint(self.RedView_BottomSpace_To_SuperView)
//        self.view.addConstraint(self.BlueView_TopSpace_To_SuperView)
//
//    }

    func showAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {(action) in alert.dismiss(animated: true, completion: nil)}))
            self.present(alert, animated: true, completion: nil)
        }
    
    func jsonParsing(json : [[String: Any]]) {
        print(json)
        dictionary = json
    }
    
    @IBAction func submitButtonPresed(_ sender: Any) {
        getData()
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

