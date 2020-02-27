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
    
    var didShow = false
    var isAuthorized: Bool = false
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
    var messageSentLabel = UILabel()
    var nameInfo = UILabel()
    var messageInfo = UILabel()


//    var statusLabel1 = UILabel()
//    var statusLabel2 = UILabel()
//    var statusLabel3 = UILabel()
//    var statusLabel4 = UILabel()
//    var statusLabel5 = UILabel()
    var timer = Timer()
    var timerIsRunning = false
    let timeUnits = ["seconds", "minutes", "hours"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerLocal()
    }
    
    
    func welcomeUser() {
        DispatchQueue.main.async {
            self.onBoardingUI()
            self.view.addSubview(self.messageInfo)
            self.view.addSubview(self.nameInfo)

            self.nameInfo.flashOnBoard()
            self.messageInfo.flashOnBoard()
        let alert = UIAlertController(title:
                   "Welcome to Message-SOS!", message: "To get started, customize the text boxes above, and then hit send.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Got it", style: .default, handler:{ (alert) -> Void in
                self.nameInfo.isHidden = true
                self.messageInfo.isHidden = true
               }))
               self.present(alert, animated: true)
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        if !didShow {
            self.messageInfo.alpha = 1.0
            self.nameInfo.alpha = 1.0
            self.welcomeUser()
            didShow = true
        }
        print("will appear")
        super.viewWillAppear(animated)
        self.setupView()
//        self.view.addSubview(previousButton)
        self.view.addSubview(startButton)
        self.view.addSubview(senderTextField)
        self.view.addSubview(messageBodyTextView)
        self.view.addSubview(messageSentLabel)

//        self.view.addSubview(statusLabel1)
//        self.view.addSubview(statusLabel2)
//        self.view.addSubview(statusLabel3)
//        self.view.addSubview(statusLabel4)
//        self.view.addSubview(statusLabel5)
        
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
    
    @objc func goButtonAction() {
        if !isAuthorized {
            self.presentAuthAlert()
            self.registerLocal()
            return
        }
        guard let senderName = senderTextField.text else {
            return
        }
        
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderName
        
        dataStore.messageBody = messageBodyTextView.text
        dataStore.senderName = senderTextField.text ?? "ICE MOM"
        
        runTimer()
        timerIsRunning = true
        
        dataStore.setDefaults()
        
        print(dataStore.timeAmountInSeconds, dataStore.messageBody, dataStore.senderName)
        
        self.messageSentLabel.flashSendLabel()
        
        
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
    
    func successfulSend() {
        self.readyToSend()
        timer.invalidate()
    }
    
    func setupContent(contents: [UNMutableNotificationContent]) {
        for content in contents {
            content.title = dataStore.senderName
            content.sound = UNNotificationSound.default
        }
    }
    
    func runTimer() {
//        self.sendingInProgress()
        setupContent(contents: [contentCustom, content2, content3])
        
        contentCustom.body = dataStore.messageBody
        content2.body = "lmk asap"
//        content3.body = "ANSWER ME OR CALL ME BACK NOW!!"
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds), repeats: false)
//        let triggerDelay1 = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds + 5), repeats: false)
//        let triggerDelay2 = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds + 15), repeats: false)
        
        let req = UNNotificationRequest(identifier: "message1", content: contentCustom, trigger: trigger)
        
//        let req2 = UNNotificationRequest(identifier: "message2", content: content2, trigger: triggerDelay1)
        
//        let req3 = UNNotificationRequest(identifier: "message3", content: content3, trigger: triggerDelay2)
        
        center.add(req, withCompletionHandler: { (error) in
            if let error = error {
                print("\n\t ERROR: \(error)")
            } else {
                print("first one! \(self.contentCustom.body)")
                
                self.successfulSend()
            }
        })
//        center.add(req2, withCompletionHandler: { (error) in
//            if let error = error {
//                print("\n\t ERROR: \(error)")
//            } else {
//                print("second one! \(self.content2.body)")
//            }
//        })
//        center.add(req3, withCompletionHandler: { (error) in
//            if let error = error {
//                print("\n\t ERROR: \(error)")
//            } else {
//                print("third one! \(self.content3.body)")
//
//                self.successfulSend()
//            }
//        })
    }
}

extension UILabel {

    func flashSendLabel() {
        UILabel.animate(withDuration: 2.0,
                        delay: 3.0,
                options: [],
                animations: { [self.alpha = 1, self.alpha = 0] }
        )
    }
    
    func flashOnBoard() {
        UILabel.animate(withDuration: 0.75,
                        delay: 0.0,
                        options: [.repeat, .autoreverse],
                        animations: { [self.backgroundColor = .systemTeal, self.backgroundColor = .systemGreen] }
        )
    }

}
