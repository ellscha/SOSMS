//
//  SOSMSConstants.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/18/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation
class SOSMSConstants {
    public static let fiveMinutesInSeconds = 300
    public static let secondsPickerValue = 0
}

// Use to make a list of default messages
class SOSMSMessageList {
//    public static let customSOS: SOSMSMessage = SOSMSMessage.init(messageName: "Custom", messageBody: SOSMSDataStore.sharedInstance.messageBody, senderName: SOSMSDataStore.sharedInstance.senderName, timeAmountInSeconds: SOSMSDataStore.sharedInstance.timeAmountInSeconds, pickerValue: SOSMSDataStore.sharedInstance.pickerRow)
    public static let momEmergencySOS: SOSMSMessage = SOSMSMessage.init(messageName: "MOM SOS", messageBody: "Hi Hun, I tried calling but couldnt get thru... Emergency at home, come home ASAP!", senderName: "ICE Mom", timeAmountInSeconds: SOSMSConstants.fiveMinutesInSeconds, pickerValue: SOSMSConstants.secondsPickerValue)
    public static let neighborFireSOS: SOSMSMessage = SOSMSMessage.init(messageName: "Neighbor Fire SOS", messageBody: "I think there is a fire in your place, you should probably head home, calling 911", senderName: "Neighbor", timeAmountInSeconds: SOSMSConstants.fiveMinutesInSeconds, pickerValue: SOSMSConstants.secondsPickerValue)
    public static let dadEmergency: SOSMSMessage = SOSMSMessage.init(messageName: "Dad Grounded", messageBody: "YOU ARE GROUNDED! COME HOME NOW OR I INCREASE GROUNDING!!!!!", senderName: "ICE Dad", timeAmountInSeconds: SOSMSConstants.fiveMinutesInSeconds, pickerValue: SOSMSConstants.secondsPickerValue)
}
