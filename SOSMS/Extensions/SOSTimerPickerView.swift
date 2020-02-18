////
////  SOSTimerPickerView.swift
////  SOSMS
////
////  Created by ELLI SCHARLIN on 2/17/20.
////  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
////
//
//import UIKit
//
//extension ViewController: SOSTimerDelegate {
//    func SOSTimerDidFinish() {
//        updateViews()
//        showAlert()
//    }
//    
//    func SOSTimerDidUpdate(timeRemaining: TimeInterval) {
//        updateViews()
//    }
//}
//extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
//    
//    private func showAlert() {
//        let alert = UIAlertController(title: "Timer Finished!", message: "Your countdown is over.", preferredStyle: .alert)
//        
//        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
//        self.present(alert, animated: true)
//    }
//    
//    private func updateViews() {
//        startButton.isEnabled = true
//        
//        switch countdown.state {
//        case .started:
//            timeLabel.text = string(from: countdown.timeRemaining)
//            startButton.isEnabled = false
//        case .finished:
//            timeLabel.text = string(from: 0)
//        case .reset:
//            timeLabel.text = string(from: countdown.duration)
//        }
//    }
//    
//    private func string(from duration: TimeInterval) -> String {
//        let date = Date(timeIntervalSinceReferenceDate: duration)
//        return dateFormatter.string(from: date)
//    }
//    
//    func setupPickerView(x: Double, y: Double, width: Double, height: Double) -> UIPickerView {
//           let pickerView = UIPickerView(frame: CGRect(x: x, y: y, width: width, height: height))
//           pickerView.delegate = self
//           pickerView.dataSource = self
//           
//           pickerView.center.x = (self.view.center.x * 1.20)
//           return pickerView
//       }
//    
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return SOSTimerPickerData.count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return SOSTimerPickerData[component].count
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//        let timeValue = SOSTimerPickerData[component][row]
//        return String(timeValue)
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
//        return 50
//    }
//    
//    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        sosTimer.duration = duration
//        updateViews()
//    }
//    
//}
