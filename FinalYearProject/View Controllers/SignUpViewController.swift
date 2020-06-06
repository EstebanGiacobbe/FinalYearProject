//
//  SignUpViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import Firebase




class SignUpViewController: UIViewController {

    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    //var uid = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpElements()
        
    }
    
    func setUpElements(){
        
        //error label hidden
        errorLabel.alpha = 0
        
        //Style
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        
    }
    
    //validate fields empty and password
    func validateFields() -> String?{
        
        //check that all fields are filled in
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all fields"
            
        }
        // check if the password is secure with method from the utilities file passing a boolean
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
       if Utilities.isPasswordValid(cleanedPassword) == false {
            // password is not secure enough
        return "please make sure your password is at least 8 characters, contains a special character and a number"
        }
        
        return nil
        
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        
        //validate the fields
        let error = validateFields()
        
        if error != nil {
        
            showError(error!)
        }
        else {
        //create clean versions of the data
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            
        //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    //error creating user
                    self.showError("Error creating user")
                }
                else {
                    //user created successfully
                    //reference to firestore
                    let db = Firestore.firestore()
                    
                    //self.uid = result!.user.uid
                    
                    db.collection("users").addDocument(data: ["firstname":firstName, "lastname": lastName, "uid": result!.user.uid]) { (error) in
                        if error != nil {
                            //show error
                            self.showError("User data couldn't be saved.")
                        }
                    }
                    
                    //transition to the home page
                    self.transitionToHome()
                    
                }
            }
        
        
        }
        
    }
    
    func showError (_ message:String){
        
        //show error message
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    func transitionToHome(){
        
        let tabVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
        
        self.view.window?.rootViewController = tabVC
        self.view.window?.makeKeyAndVisible()
        
        
    }
    
    

}
