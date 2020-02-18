//
//  SetupUIElement.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/17/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation
import UIKit

class SetupUIElement {
       
       func setupTextField(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UITextField {
           let textField =  UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
           textField.delegate = vc
           textField.returnKeyType = .done
           textField.backgroundColor = .lightGray
           return textField
       }
       
    func setupButton(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UIButton {
           let button =  UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
           button.layer.cornerRadius = 5
           button.center.x = vc.view.center.x
           return button
       }
    
    func setupLabel(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UILabel {
           let label =  UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
           label.backgroundColor = .systemPink
           label.layer.cornerRadius = 5
           label.center.x = vc.view.center.x
        label.adjustsFontForContentSizeCategory = true
        label.lineBreakMode = .byCharWrapping
        label.textAlignment = .center
           return label
       }
       
       func setupTextView(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UITextView {
           let textView =  UITextView(frame: CGRect(x: x, y: y, width: width, height: height))
           textView.delegate = vc
           textView.returnKeyType = .default
           textView.backgroundColor = .darkGray
           textView.center.x = vc.view.center.x
           textView.resignFirstResponder()
           textView.text = "Come home, your brother has fallen off the wagon and needs you."
           textView.textColor = UIColor.lightGray
           let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: vc.view.frame.size.width, height: 30))
           //create left side empty space so that done button set on right side
           let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
           let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: vc, action: #selector(doneButtonAction))
           toolbar.setItems([flexSpace, doneBtn], animated: false)
           toolbar.sizeToFit()
           //setting toolbar as inputAccessoryView
           textView.inputAccessoryView = toolbar
           
           return textView
       }
        
        @objc func doneButtonAction(vc: ViewController) {
           vc.view.endEditing(true)
        }
    
    func hideButtons(buttonsToHide: [UIButton]) {
        for button in buttonsToHide {
            button.isHidden = true
        }
    }
    
    func showButtons(buttonsToShow: [UIButton]) {
        for button in buttonsToShow {
            button.isHidden = false
        }
    }
    
}
