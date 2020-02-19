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
    let contentCustom = UNMutableNotificationContent()
    let content2 = UNMutableNotificationContent()
    let content3 = UNMutableNotificationContent()
    var dataStore = SOSMSDataStore.sharedInstance
    var setupClass = SetupUIElement()
    var senderTextField = UITextField()
    var messageBodyTextView = UITextView()
    var previousButton = UIButton()
    var startButton = UIButton()
    var pauseButton = UIButton()
    var resetButton = UIButton()
    var cancelButton = UIButton()
    var statusLabel1 = UILabel()
    var statusLabel2 = UILabel()
    var statusLabel3 = UILabel()
    var statusLabel4 = UILabel()
    var statusLabel5 = UILabel()
    var timer = Timer()
    var timerIsRunning = false
//    var timerTime = 30
//    let fiveMinutes = 30
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
//        setupClass.hideButtons(buttonsToHide: [cancelButton])
        self.view.addSubview(previousButton)
        self.view.addSubview(startButton)
//        self.view.addSubview(cancelButton)
        self.view.addSubview(senderTextField)
        self.view.addSubview(messageBodyTextView)
        self.view.addSubview(statusLabel1)
        self.view.addSubview(statusLabel2)
        self.view.addSubview(statusLabel3)
        self.view.addSubview(statusLabel4)
        self.view.addSubview(statusLabel5)

        readyToSend()

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
        
//        setupClass.showButtons(buttonsToShow: [cancelButton])
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderName
        
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderTextField.text ?? "ICE MOM"
        
            runTimer()
            timerIsRunning = true
        
        dataStore.setDefaults()

        print(dataStore.timeAmountInSeconds, dataStore.messageBody, dataStore.senderName)
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
        setupStatusLabels()
        let x = 80.0
        let width = Double(self.view.frame.size.width * 0.9)
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
        previousButton.setTitle("Use my most recent excuse", for: UIControl.State.normal)
        
        senderTextField.text = "ICE MOM"

        senderTextField.center.x = self.view.center.x
    }
    
  
    @objc func cancelButtonPressed() {
//        timerTime = fiveMinutes
        setupClass.hideButtons(buttonsToHide: [cancelButton])
        setupClass.showButtons(buttonsToShow: [startButton])
        timerIsRunning = false
        center.removeAllPendingNotificationRequests()
        timer.invalidate()
    }
    
    @objc func updateTimer() {
//        print("Timer, \(timerTime)")
//        if timerTime < 1 {
            
         timer.invalidate()
            readyToSend()
//            setupClass.hideButtons(buttonsToHide: [cancelButton])
//            setupClass.showButtons(buttonsToShow: [startButton])
//            timerTime = fiveMinutes
            
             //Send alert to indicate "time's up!"
//        } else {
            sendingInProgress()
//        timerTime -= 1     //This will decrement(count down)the seconds.
//        }
    }
    
    func successfulSend() {
        readyToSend()
        timer.invalidate()
//        timerTime = fiveMinutes
    }
    
    func setupContent(contents: [UNMutableNotificationContent]) {
        for content in contents {
            content.title = dataStore.senderName
            content.sound = UNNotificationSound.defaultCritical
        }
    }
    
    func runTimer() {
        sendingInProgress()
        createNotification(sender: dataStore.senderName, messageBody: dataStore.messageBody)
        
        setupContent(contents: [contentCustom, content2, content3])
        
        contentCustom.body = dataStore.messageBody
        content2.body = "HELLO!??"
        content3.body = "ANSWER ME OR CALL ME BACK NOW!!?"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds), repeats: false)
        let triggerDelay1 = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds + 5), repeats: false)
        let triggerDelay2 = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds + 10), repeats: false)

        let req = UNNotificationRequest(identifier: "message1", content: contentCustom, trigger: trigger)

        let req2 = UNNotificationRequest(identifier: "message2", content: content2, trigger: triggerDelay1)
        
        let req3 = UNNotificationRequest(identifier: "message3", content: content3, trigger: triggerDelay2)

       center.add(req, withCompletionHandler: { (error) in
             if let error = error {
                  print("\n\t ERROR: \(error)")
             } else {
                print("first one! \(self.contentCustom.body)")

                self.successfulSend()
             }
        })
        center.add(req2, withCompletionHandler: { (error) in
              if let error = error {
                   print("\n\t ERROR: \(error)")
              } else {
                print("second one! \(self.content2.body)")
              }
         })
        center.add(req3, withCompletionHandler: { (error) in
              if let error = error {
                   print("\n\t ERROR: \(error)")
              } else {
                print("third one! \(self.content3.body)")

                 self.successfulSend()
              }
         })
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(dataStore.timeAmountInSeconds), target: self,   selector: (#selector(updateTimer)), userInfo: nil, repeats: true)
    }
    
    func createNotification(sender: String, messageBody: String) {
        contentCustom.body = messageBody
        contentCustom.title = sender
        contentCustom.categoryIdentifier = "message"
        contentCustom.sound = UNNotificationSound.default
    }
    func sendingInProgress() {
        statusLabel1.isHidden = false
        statusLabel2.isHidden = false
        statusLabel3.isHidden = false
        statusLabel4.isHidden = false
        statusLabel5.isHidden = false
        startButton.isHidden = true
        messageBodyTextView.isHidden = true
        senderTextField.isHidden = true
        previousButton.isHidden = true
    }
    func readyToSend() {
        previousButton.isHidden = false
        statusLabel1.isHidden = true
        statusLabel2.isHidden = true
        statusLabel3.isHidden = true
        statusLabel4.isHidden = true
        statusLabel5.isHidden = true
        startButton.isHidden = false
        messageBodyTextView.isHidden = false
        senderTextField.isHidden = false
    }
    
    func setupStatusLabels() {
        let x = 80.0
        let width = Double(self.view.frame.size.width * 0.9)
        
        statusLabel1 = setupClass.setupLabel(vc: self, x: x, y: 150.0, width: width, height: 40.0)
        statusLabel2 = setupClass.setupLabel(vc: self, x: x, y: 200.0, width: width, height: 40.0)
        statusLabel3 = setupClass.setupLabel(vc: self, x: x, y: 250.0, width: width, height: 40.0)
        statusLabel4 = setupClass.setupLabel(vc: self, x: x, y: 300.0, width: width, height: 40.0)
        statusLabel5 = setupClass.setupLabel(vc: self, x: x, y: 350.0, width: width, height: 40.0)
        
        statusLabel1.center.x = self.view.center.x - 10
        statusLabel3.center.x = self.view.center.x - 10
        statusLabel5.center.x = self.view.center.x - 10

        statusLabel2.center.x = self.view.center.x + 10
        statusLabel4.center.x = self.view.center.x + 10

        statusLabel1.text = "Turn off your screen like nothing happened!"
        statusLabel2.text = "Your message will take about a minute"
        statusLabel3.text = "Followed by two more messages..."
        statusLabel4.text = "5 and 10 seconds later"
        statusLabel5.text = "Good luck and get home safe!"
        
        statusLabel1.backgroundColor = .red
        statusLabel2.backgroundColor = .black
        statusLabel2.textColor = .white
        statusLabel3.backgroundColor = .systemPink
        statusLabel4.backgroundColor = .black
        statusLabel4.textColor = .white
        statusLabel5.backgroundColor = .red
    }
}

