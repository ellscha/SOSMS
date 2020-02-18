//
//  ViewController.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/16/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    let center = UNUserNotificationCenter.current()
    let content = UNMutableNotificationContent()
    var dataStore = SOSMSDataStore.sharedInstance
    var setupClass = SetupUIElement()
    var senderTextField = UITextField()
    var messageBodyTextView = UITextView()
    var previousButton = UIButton()
    var startButton = UIButton()
    var cancelButton = UIButton()
    var timer = Timer()
    var timerIsRunning = false
    var timerTime = 60
    let fiveMinutes = 60
    let timeUnits = ["seconds", "minutes", "hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerLocal()
//        setupPickerView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        super.viewWillAppear(animated)
        self.setupView()
        setupClass.hideButtons(buttonsToHide: [cancelButton])
//        self.view.addSubview(previousButton)
        self.view.addSubview(startButton)
        self.view.addSubview(cancelButton)
        self.view.addSubview(senderTextField)
        self.view.addSubview(messageBodyTextView)
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


    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return timeUnits.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return timeUnits[row]
    }
    

    @objc func goButtonAction() {
        guard let senderName = senderTextField.text else {
            return
        }
        
        setupClass.hideButtons(buttonsToHide: [startButton])
        setupClass.showButtons(buttonsToShow: [cancelButton])
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderName
        
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderTextField.text ?? "ICE MOM"
        
        self.scheduleLocal()
            runTimer()
            timerIsRunning = true
        
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

        guard let senderName = dataStore.defaults.value(forKey: "senderName") else {return}

        messageBodyTextView.text = messageBody as? String
        senderTextField.text = senderName as? String
        }
    
    func setupView() {
        let x = 80.0
        let width = 300.0
        let height = 40.0
        senderTextField = setupClass.setupTextField(vc: self, x: x, y: 100.0, width: width, height: height)
        
        messageBodyTextView = setupClass.setupTextView(vc: self, x: x, y: 150.0, width: width, height: 200.0)

        startButton = setupClass.setupButton(vc: self, x: x, y: 450.0, width: width, height: height)

        cancelButton = setupClass.setupButton(vc: self, x: 80.0, y: 450.0, width: width, height: height)
        
        previousButton = setupClass.setupButton(vc: self, x: x, y: 400.0, width: width, height: height)
        
        
        startButton.backgroundColor = .green
        cancelButton.backgroundColor = .red
        cancelButton.setTitle("Cancel Message", for: .normal)
        
        cancelButton.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        
        startButton.setTitle("Get me the F%@! outta here!", for: UIControl.State.normal)
        
        previousButton.addTarget(self, action: #selector(previousInputPressed), for: .touchUpInside)
        previousButton.setTitle("Use my previous excuses", for: UIControl.State.normal)
        
        senderTextField.text = "ICE MOM"

        senderTextField.center.x = self.view.center.x
    }
    
  
    @objc func cancelButtonPressed() {
        timerTime = fiveMinutes
        setupClass.hideButtons(buttonsToHide: [cancelButton])
        setupClass.showButtons(buttonsToShow: [startButton])
        timerIsRunning = false
        center.removeAllPendingNotificationRequests()
        timer.invalidate()

        
    }
    
    @objc func updateTimer() {
        print("Timer, \(timerTime)")
        if timerTime < 1 {
            
             timer.invalidate()
            setupClass.hideButtons(buttonsToHide: [cancelButton])
            setupClass.showButtons(buttonsToShow: [startButton])
            timerTime = fiveMinutes
            
             //Send alert to indicate "time's up!"
        } else {
        timerTime -= 1     //This will decrement(count down)the seconds.
        }
    }
    
    func successfulSend() {
         timer.invalidate()
        setupClass.hideButtons(buttonsToHide: [cancelButton])
        setupClass.showButtons(buttonsToShow: [startButton])
        timerTime = fiveMinutes
    }
    
    func runTimer() {
        createNotification(sender: dataStore.senderName, messageBody: dataStore.messageBody)
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds), repeats: false)
        
        let req = UNNotificationRequest(identifier: "message", content: content, trigger: trigger)
       center.add(req, withCompletionHandler: { (error) in
             if let error = error {
                  print("\n\t ERROR: \(error)")
             } else {
                  print("\n\t request fulfilled \(req)")
                self.successfulSend()
             }
        })
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(timerTime), target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func createNotification(sender: String, messageBody: String) {
        if messageBody.elementsEqual("") {
            content.body = "WTF COME HOME NOW!!!!"
        } else {
            content.body = messageBody
        }
        content.title = sender
        content.categoryIdentifier = "message"
        content.sound = UNNotificationSound.default
    }
    
}

