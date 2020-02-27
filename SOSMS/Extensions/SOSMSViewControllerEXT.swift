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
    
    func presentAuthAlert() {
        let alert = UIAlertController(title:
            "Notification services were previously denied.", message: "Please enable notifications for this app in Settings.", preferredStyle: .alert)
        

        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    @objc func registerLocal() {
        
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                self.isAuthorized = true
                print("Yay!")
            } else {
                self.isAuthorized = false
                print("error")
            }
        }
    }
}
