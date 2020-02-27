//
//  SetupUIElement.swift
//  SOSMS
//
//  Created by ELLI SCHARLIN on 2/17/20.
//  Copyright © 2020 ELLI SCHARLIN. All rights reserved.
//

import Foundation
import UIKit

// This file is a helper file meant to make creating the UIElements more simple and streamlined. Like a Stylesheet.

class SetupUIElement {
    
    func setupTextField(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UITextField {
        let UIElement =  UITextField(frame: CGRect(x: x, y: y, width: width, height: height))
        UIElement.delegate = vc
        UIElement.returnKeyType = .done
        UIElement.backgroundColor = .lightGray
        UIElement.layer.cornerRadius = 5
        UIElement.borderStyle = .roundedRect
        
        return UIElement
    }
    
    func setupButton(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UIButton {
        let UIElement =  UIButton(frame: CGRect(x: x, y: y, width: width, height: height))
        UIElement.layer.cornerRadius = 5
        UIElement.center.x = vc.view.center.x
        UIElement.backgroundColor = .lightGray
        return UIElement
    }
    
    func setupLabel(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UILabel {
        let UIElement =  UILabel(frame: CGRect(x: x, y: y, width: width, height: height))
        UIElement.backgroundColor = .systemGreen
        UIElement.alpha = 0
        UIElement.center.x = vc.view.center.x
        UIElement.adjustsFontForContentSizeCategory = true
        UIElement.textAlignment = .center
        UIElement.layer.cornerRadius = 5
        UIElement.font = UIElement.font.withSize(20.0)
        UIElement.allowsDefaultTighteningForTruncation = true
        
        return UIElement
    }
    
    func setupTextView(vc: ViewController, x: Double, y: Double, width: Double, height: Double) -> UITextView {
        let UIElement =  UITextView(frame: CGRect(x: x, y: y, width: width, height: height))
        UIElement.delegate = vc
        UIElement.layer.cornerRadius = 5
        
        UIElement.returnKeyType = .default
        UIElement.backgroundColor = .lightGray
        UIElement.center.x = vc.view.center.x
        UIElement.resignFirstResponder()
        UIElement.text = "Hey, I'm running late, any chance you can walk the dog?"
        UIElement.textColor = UIColor.white
        let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: vc.view.frame.size.width, height: 30))
        //create left side empty space so that done button set on right side
        let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
        let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: vc, action: #selector(doneButtonAction))
        toolbar.setItems([flexSpace, doneBtn], animated: false)
        toolbar.sizeToFit()
        //setting toolbar as inputAccessoryView
        UIElement.inputAccessoryView = toolbar
        
        return UIElement
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
