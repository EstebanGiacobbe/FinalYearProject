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
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var dateTxt: UITextField!
    
    let datePicker = UIDatePicker()
    
    
    @IBOutlet weak var popUpView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popUpView.layer.cornerRadius = 10
        
        informationTextView.layer.cornerRadius = 5
        informationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        informationTextView.layer.borderWidth = 0.5
        informationTextView.clipsToBounds = true
        
        db = Firestore.firestore()
        
        createDatePicker()
        
        errorLabel.alpha = 0

    }
    
// fields are validated in the same way as it's done within the sign up view controller.
    // if they are not empty then a new task can be created.
    @IBAction func uploadButton(_ sender: Any) {
        
        let error = validateFields()
              
              if error != nil {
                  showError(error!)
              }
              else {
              
              let description = descriptionTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              let information = informationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              let date = dateTxt.text!.trimmingCharacters(in: .whitespacesAndNewlines)
              
              let progress = "Not done"
              
              var ref: DocumentReference? = nil
              ref = db.collection("Tasks").addDocument(data: ["Description":description, "name": name, "text" : information, "date": date, "progress": progress]) { err in
                  if let err = err{
                      print ("error adding document: \(err)")
                  } else {
                      print("Document added with ID: \(ref!.documentID)")
                  }
              }
        
              dismiss(animated: true, completion: nil)
              }
    }
    

    
    func createDatePicker() {
        dateTxt.textAlignment = .center
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        // bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        //assign toolbar to the keyboard
        dateTxt.inputAccessoryView = toolbar
        
        //assign datepicker to the textfield
        dateTxt.inputView = datePicker
        
        //formatting datepicker
        datePicker.datePickerMode = .date
        print("date: \(datePicker.date)")
    }
    
    fileprivate lazy var formattingDate: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
    @objc func donePressed(){
        //format text
        //let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        
        //formatter.timeStyle = .none
        
        
        //dateTxt.text = formatter.string(from: datePicker.date)
        dateTxt.text = self.formattingDate.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    //check the vields and validate that the data is okay, if everything is okay this method returns nil otherwise return error message
    func validateFields() -> String?{
        
        //check that all fields are filled in
        if descriptionTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            informationTextView.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            dateTxt.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all fields"
            
        }
        return nil
}
    
    func showError (_ message:String){
        
        //show error message
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    
    
    @IBAction func CancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
