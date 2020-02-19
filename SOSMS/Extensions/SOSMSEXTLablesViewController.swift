//
//  SOSMSEXTLablesViewController.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation
import UIKit

// ViewController Extension that deals with the functions Setting up UIElements to declutter the main ViewController File.
extension ViewController {
    
    // There are so many labels this is a setup dedicated to just the status labels.
    func setupStatusLabels() {
        let x = 80.0
        let width = Double(self.view.frame.size.width * 0.9)
        
        self.statusLabel1 = setupClass.setupLabel(vc: self, x: x, y: 150.0, width: width, height: 40.0)
        self.statusLabel2 = setupClass.setupLabel(vc: self, x: x, y: 200.0, width: width, height: 40.0)
        self.statusLabel3 = setupClass.setupLabel(vc: self, x: x, y: 250.0, width: width, height: 40.0)
        self.statusLabel4 = setupClass.setupLabel(vc: self, x: x, y: 300.0, width: width, height: 40.0)
        self.statusLabel5 = setupClass.setupLabel(vc: self, x: x, y: 350.0, width: width, height: 40.0)
        
        self.statusLabel1.center.x = self.view.center.x - 10
        self.statusLabel3.center.x = self.view.center.x - 10
        self.statusLabel5.center.x = self.view.center.x - 10
        
        self.statusLabel2.center.x = self.view.center.x + 10
        self.statusLabel4.center.x = self.view.center.x + 10
        
        self.statusLabel1.text = "Turn off your screen like nothing happened!"
        self.statusLabel2.text = "Your message will take about 2 minutes"
        self.statusLabel3.text = "Followed by two more messages..."
        self.statusLabel4.text = "5 and 15 seconds later"
        self.statusLabel5.text = "Good luck and get home safe!"
        
        self.statusLabel1.backgroundColor = .red
        self.statusLabel2.backgroundColor = .black
        self.statusLabel2.textColor = .white
        self.statusLabel3.backgroundColor = .systemPink
        self.statusLabel4.backgroundColor = .black
        self.statusLabel4.textColor = .white
        self.statusLabel5.backgroundColor = .red
    }
    
    func sendingInProgress() {
        //        DispatchQueue.main.async {
        // Not doing in dispatch because of timing, need to move to a completion handler eventually...too hacky rn for both
        self.messageBodyTextView.resignFirstResponder()
        self.statusLabel1.isHidden = false
        self.statusLabel2.isHidden = false
        self.statusLabel3.isHidden = false
        self.statusLabel4.isHidden = false
        self.statusLabel5.isHidden = false
        self.startButton.isHidden = true
        self.messageBodyTextView.isHidden = true
        self.messageBodyTextView.resignFirstResponder()
        self.senderTextField.isHidden = true
        self.previousButton.isHidden = true
        //        }
    }
    func readyToSend() {
        //        DispatchQueue.main.async {
        self.previousButton.isHidden = false
        self.statusLabel1.isHidden = true
        self.statusLabel2.isHidden = true
        self.statusLabel3.isHidden = true
        self.statusLabel4.isHidden = true
        self.statusLabel5.isHidden = true
        self.startButton.isHidden = false
        self.messageBodyTextView.isHidden = false
        self.senderTextField.isHidden = false
        //        }
    }
    
    func setupView() {
        setupStatusLabels()
        let x = 80.0
        let width = Double(self.view.frame.size.width * 0.9)
        let height = 40.0
        senderTextField = setupClass.setupTextField(vc: self, x: x, y: 100.0, width: width, height: height)
        
        messageBodyTextView = setupClass.setupTextView(vc: self, x: x, y: 150.0, width: width, height: 200.0)
        
        startButton = setupClass.setupButton(vc: self, x: x, y: 450.0, width: width, height: height)
        
        previousButton = setupClass.setupButton(vc: self, x: x, y: 400.0, width: width, height: height)
        
        startButton.backgroundColor = .systemTeal
        messageBodyTextView.font = senderTextField.font
        
        startButton.addTarget(self, action: #selector(goButtonAction), for: .touchUpInside)
        
        startButton.setTitle("Get me the F%@! outta here!", for: UIControl.State.normal)
        
        previousButton.addTarget(self, action: #selector(previousInputPressed), for: .touchUpInside)
        previousButton.setTitle("Use my most recent excuse", for: UIControl.State.normal)
        
        senderTextField.text = "ICE MOM"
        
        senderTextField.center.x = self.view.center.x
    }
}
