//
//  SOSMSMessage.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation

class SOSMSMessage {
    var messageName: String
    var messageBody: String
    var senderName: String
    var timeAmountInSecond: Int
    var pickerValue: Int
    
    init(messageName: String, messageBody: String, senderName: String, timeAmountInSeconds: Int, pickerValue: Int) {
        self.messageName = messageName
        self.messageBody = messageBody
        self.senderName = senderName
        self.timeAmountInSecond = timeAmountInSeconds
        self.pickerValue = pickerValue
    }
}
