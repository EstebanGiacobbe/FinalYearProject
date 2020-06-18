//
//  Utilities.swift
//  customauth
//
//  Created by Christopher Ching on 2019-05-09.
//  Copyright © 2019 Christopher Ching. All rights reserved.
//
//
//  This Utilities swift class has been downloaded from a tutorial found online.
//  The original author is Chirstopher Ching and he owns an Online iOS training website called:
//  https://codewithchris.com. His training courses and youtube videos have assisted me when
//  creating the login and register view controllers. this also includes and any label and buttons
//  styled within those views.
//  colours and contraints have been customed in order to reflect my personal preferences.


import Foundation
import UIKit

class Utilities {
    
    // this method will give a style to text fields. it's used for the register and login button within my project.
    static func styleTextField(_ textfield:UITextField) {
        // this will create the bottom line for the text fields.
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textfield.frame.height - 2, width: textfield.frame.width, height: 2)
        bottomLine.backgroundColor = UIColor.init(red: 0.000, green: 0.333, blue: 0.557, alpha: 1).cgColor
        // Remove border on text field
        textfield.borderStyle = .none
        // Add the line to the text field
        textfield.layer.addSublayer(bottomLine)
    }
    
    // This method will be used to style login/register buttons
    static func styleFilledButton(_ button:UIButton) {
        
        // Filled rounded corner style
        //button.backgroundColor = UIColor.init(red: 48/255, green: 173/255, blue: 99/255, alpha: 1)
        button.backgroundColor = UIColor.init(red: 0.000, green: 0.333, blue: 0.557, alpha: 1)
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    static func styleHollowButton(_ button:UIButton) {
        
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }
    
    static func styleUpdate(_ button:UIButton) {
        
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 10.0
        button.tintColor = UIColor.black    }
    
    //This function will validate the password created when users register a new account.
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
}
