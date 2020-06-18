//
//  LoginViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//
//  This View Controller has been created thanks to the guidance of
//  Christopher Ching's online courses.
//  references can be found within final year project report.
//  Link to his website its also found in the utilities class.

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setUpElements()
    }
    
    func setUpElements() {
        
        //error label hidden
        errorLabel.alpha = 0
        
        //Styling elements
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
        //validate text fields
        
        
        //create clean versions of text field
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //signing the user
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if error != nil {
                
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                let tabVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
                
                self.view.window?.rootViewController = tabVC
                self.view.window?.makeKeyAndVisible()

                }
                
            }
        }
    }
    


