//
//  ViewController.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/16/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
//
//    @IBOutlet weak var senderTextField: UITextField!
//    @IBOutlet weak var bodyTextView: UITextView!
//    @IBOutlet weak var timeAmountTextField: UITextField!
//    @IBOutlet weak var timeUnitPickerView: UIPickerView!
//    @IBOutlet weak var sendButton: UIButton!
//
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var resetButton = UIButton()
    var dataStore = SOSMSDataStore.sharedInstance
    var setupClass = SetupUIElement()
    var senderTextField = UITextField()
    var messageBodyTextView = UITextView()
    var timeAmountTextField = UITextField()
    var timeUnitPickerView = UIPickerView()
    var previousButton = UIButton()
    var startButton = UIButton()
    var SOSMSLabel = UILabel()
    var timer = Timer()
    var timerIsRunning = false
    var timerTime = 0
    
    let timeUnits = ["seconds", "minutes", "hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerLocal()
        
        if (dataStore.defaults.hasValue(forKey: "senderName")) {
            setupClass.hideButtons(buttonsToHide: [previousButton])
        } else {
            setupClass.showButtons(buttonsToShow: [previousButton])
        }
        
//        setupPickerView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setupView()
        self.view.addSubview(previousButton)
        self.view.addSubview(startButton)
//        self.view.addSubview(pauseButton)
        self.view.addSubview(resetButton)
        self.view.addSubview(senderTextField)
        self.view.addSubview(timeUnitPickerView)
        self.view.addSubview(timeAmountTextField)
        self.view.addSubview(messageBodyTextView)
        self.view.addSubview(SOSMSLabel)
        setupClass.hideButtons(buttonsToHide: [resetButton, pauseButton])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeUnits.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeUnits[row]
    }
    

    @objc func goButtonAction() {
        guard let timeAmount = timeAmountTextField.text else {
            return
        }
        guard let senderName = senderTextField.text else {
            return
        }
        
        setupClass.hideButtons(buttonsToHide: [startButton])
        setupClass.showButtons(buttonsToShow: [pauseButton, resetButton])
        
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderName
        dataStore.pickerRow = timeUnitPickerView.selectedRow(inComponent: 0)

        
        if !timeAmount.isInt {
            let alert = UIAlertController(title:
                "Time input invalid.", message: "Please enter a whole number", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
            timerTime = Int(timeAmount) ?? 0
        self.scheduleLocal()
            runTimer()
            timerIsRunning = true
            timeAmountTextField.isEnabled = false
            startButton.isHidden = true
            pauseButton.isHidden = false
            resetButton.isHidden = false
        
        switch timeUnitPickerView.selectedRow(inComponent: 0){
        case 0:
            // seconds as is.
            dataStore.timeAmountInSeconds = timerTime
        case 1:
            // 60 seconds in a minute
            dataStore.timeAmountInSeconds = timerTime * 60
        case 2:
            // 60 minutes in an hour * 60 seconds in a minute
            dataStore.timeAmountInSeconds = timerTime * 3600
        default:
            dataStore.timeAmountInSeconds = 5
        }
        
        dataStore.setDefaults()

        print(dataStore.timeAmountInSeconds, dataStore.messageBody, dataStore.senderName)
    }
    
    func timeString(time:TimeInterval) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
    

    @objc func doneButtonAction(vc: ViewController) {
       self.view.endEditing(true)
    }
    
    @objc func previousInputPressed() {
        guard let messageBody = dataStore.defaults.value(forKey: "messageBody") else {return}
        guard let timeAmount = dataStore.defaults.value(forKey: "timeAmountInSeconds") else {return}
        guard let senderName = dataStore.defaults.value(forKey: "senderName") else {return}
        guard let pickerRow = dataStore.defaults.value(forKey: "pickerRow") else {return}
        
        switch pickerRow as! Int {
        case 0:
            // seconds as is.
            timeAmountTextField.text = "\(timeAmount)"
        case 1:
            // 60 seconds in a minute
            let timeInMinutes = timeAmount as! Int
            timeAmountTextField.text = "\(timeInMinutes/60)"
        case 2:
            // 60 minutes in an hour * 60 seconds in a minute
            let timeInHours = timeAmount as! Int
            timeAmountTextField.text = "\(timeInHours/3600)"
        default:
            return
        }
        timeUnitPickerView.selectRow(pickerRow as! Int, inComponent: 0, animated: true)
        messageBodyTextView.text = messageBody as? String
        senderTextField.text = senderName as? String

        SOSMSLabel.text = timeString(time: TimeInterval(dataStore.timeAmountInSeconds))
        }
    
    func setupView() {
        let x = 80.0
        let width = 300.0
        let height = 40.0
        senderTextField = setupClass.setupTextField(vc: self, x: x, y: 100.0, width: width, height: height)
        
        messageBodyTextView = setupClass.setupTextView(vc: self, x: x, y: 150.0, width: width, height: 200.0)
        
        timeAmountTextField = setupClass.setupTextField(vc: self, x: x, y: 360.0, width: 100.0, height: height)
        
        timeUnitPickerView = setupClass.setupPickerView(vc: self, x: x, y: 360.0, width: 200.0, height: height)
        
        startButton = setupClass.setupButton(vc: self, x: x, y: 400.0, width: width, height: height)
        
        pauseButton = setupClass.setupButton(vc: self, x: x, y: 400.0, width: width, height: height)
        resetButton = setupClass.setupButton(vc: self, x: 80.0, y: 450.0, width: width, height: height)
        
        previousButton = setupClass.setupButton(vc: self, x: x, y: 700.0, width: width, height: height)
        
        SOSMSLabel = setupClass.setupLabel(vc: self, x: x, y: 600.0, width: width, height: 80.0)
        
        startButton.backgroundColor = .green
        pauseButton.backgroundColor = .gray
        resetButton.backgroundColor = .red
        pauseButton.setTitle("Pause Timer", for: .normal)
        resetButton.setTitle("Reset Timer", for: .normal)
        
        pauseButton.addTarget(self, action: #selector(pauseButtonPressed), for: .touchUpInside)
        
        resetButton.addTarget(self, action: #selector(resetButtonPressed), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        
        startButton.setTitle("Get me the F%@! outta here!\nStart Timer", for: UIControl.State.normal)
        
        previousButton.addTarget(self, action: #selector(previousInputPressed), for: .touchUpInside)
        previousButton.setTitle("Use my previous excuses", for: UIControl.State.normal)
        
        senderTextField.text = "ICE MOM"
        
        timeAmountTextField.text = "300"
        
        timeUnitPickerView.selectRow(0, inComponent: 0, animated: true)
        
        SOSMSLabel.text = timeString(time: TimeInterval(dataStore.timeAmountInSeconds))
        senderTextField.center.x = self.view.center.x
        timeAmountTextField.center.x = (self.view.center.x * 0.51)
        timeAmountTextField.keyboardType = .numbersAndPunctuation
    }
    
    @objc func pauseButtonPressed() {
        if timerIsRunning == true {
             timer.invalidate()
            pauseButton.setTitle("Resume Timer", for: .normal)
             timerIsRunning = false
        } else {
             runTimer()
            pauseButton.setTitle("Pause Timer", for: .normal)

            timerIsRunning = true
        }
        
    }
    @objc func resetButtonPressed() {
        center.removeAllPendingNotificationRequests()
        timer.invalidate()
        timerTime = Int(timeAmountTextField.text!) ?? 0
        SOSMSLabel.text = timeString(time: TimeInterval(timerTime))
        setupClass.hideButtons(buttonsToHide: [resetButton, pauseButton])
        setupClass.showButtons(buttonsToShow: [startButton])
        timeAmountTextField.isEnabled = true
        pauseButton.setTitle("Pause Timer", for: .normal)
        timerIsRunning = false
        
    }
    
    @objc func updateTimer() {
        print("Timer, \(timerTime)")
        if timerTime < 1 {
             timer.invalidate()
            setupClass.hideButtons(buttonsToHide: [pauseButton, resetButton])
            setupClass.showButtons(buttonsToShow: [startButton])
            
             //Send alert to indicate "time's up!"
        } else {
        timerTime -= 1     //This will decrement(count down)the seconds.
        SOSMSLabel.text = timeString(time: TimeInterval(timerTime))
        }
    }
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
}

