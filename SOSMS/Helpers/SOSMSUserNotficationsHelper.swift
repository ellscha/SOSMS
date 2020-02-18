//
//  SOSMSUserNotficationsHelper.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//
import UIKit
import Foundation
import UserNotifications

extension ViewController {
    
    func scheduleLocal() {

        self.content.title = dataStore.senderName
        self.content.body = dataStore.messageBody
        self.content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(dataStore.timeAmountInSeconds), repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
    }
    
    @objc func registerLocal() {
        let alert = UIAlertController(title:
            "Notification services were previously denied.", message: "Please enable notifications for this app in Settings.", preferredStyle: .alert)
        

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                self.present(alert, animated: true)
            }
        }
    }
}
