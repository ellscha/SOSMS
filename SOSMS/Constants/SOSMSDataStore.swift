//
//  SOSMSDataStore.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/17/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation
import UIKit

final class SOSMSDataStore {
    
    static let sharedInstance = SOSMSDataStore()
    
    private init(){}
    
    var messagesList: [SOSMSMessage] = [ SOSMSMessageList.momEmergencySOS, SOSMSMessageList.dadEmergency, SOSMSMessageList.neighborFireSOS]
    // Defaults.
    var senderName: String = "MOM"
    var messageBody: String = "Hi Honey, It's Mom, I tried calling... EMERGENCY at HOME COME HOME NOW!"
    var timeAmountInSeconds: Int = 300
    var pickerRow: Int = 0
    
    let defaults = UserDefaults.standard
    
    func setDefaults() {
        defaults.set(timeAmountInSeconds, forKey: "timeAmountInSeconds")
        defaults.set(messageBody, forKey: "messageBody")
        defaults.set(senderName, forKey: "senderName")
        defaults.set(pickerRow, forKey: "pickerRow")
        defaults.synchronize()
    }
}
