//
//  TaskViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 15/03/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class TaskViewController: UIViewController {

    var db: Firestore!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    
    @IBOutlet weak var informationTextView: UITextView!
    
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        
        informationTextView.layer.cornerRadius = 5
        informationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        informationTextView.layer.borderWidth = 0.5
        informationTextView.clipsToBounds = true
        
        db = Firestore.firestore()

    }
    
    @IBAction func updateButton(_ sender: Any) {
        
        let description = descriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let information = informationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        var ref: DocumentReference? = nil
        ref = db.collection("Tasks").addDocument(data: ["Description":description, "name": name, "text" : information]) { err in
            if let err = err{
                print ("error adding document: \(err)")
            } else {
                
                print("Document added with ID: \(ref!.documentID)")
                
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    

}
