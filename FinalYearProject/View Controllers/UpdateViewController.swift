//
//  UpdateViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/03/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase

class UpdateViewController: UIViewController {
    
    private var tasksCollectionRef: CollectionReference!

    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    //@IBOutlet weak var documentIDLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    //@IBOutlet weak var informationTextView: UITextView!
    
    @IBOutlet weak var informationTextView: UITextView!
    
    
    @IBOutlet weak var progressLabel: UILabel!
    
    
    @IBOutlet weak var checkbox: UIButton!
    
    
    @IBOutlet weak var updateTxt: UIButton!
    
    
    @IBOutlet weak var stack: UIStackView!
    
    
    @IBOutlet weak var startTime: UITextField!
    
    
    @IBOutlet weak var finishTime: UITextField!
    
    
    @IBOutlet weak var finalTime: UILabel!
    
    var documentID: String?
    var descriptions: String?
    var text: String?
    var progress: String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tasksCollectionRef = Firestore.firestore().collection("Tasks")

        // Do any additional setup after loading the view.
        //documentIDLabel.text = documentID
        descriptionLabel.text = descriptions
        //textLabel.text = text
        
        informationTextView.text = text
        progressLabel.text = progress
        
        informationTextView.layer.cornerRadius = 5
        informationTextView.layer.borderColor = UIColor.gray.withAlphaComponent(0.5).cgColor
        informationTextView.layer.borderWidth = 0.5
        informationTextView.clipsToBounds = true
        
        loadProgress()
        loadInfo()
        
        //Utilities.styleUpdate(updateTxt)
        
    }
    
    func loadInfo(){
        
        tasksCollectionRef.document(documentID!)
            .addSnapshotListener{ (querySnapshot, error) in
                guard let snapshot = querySnapshot else {return}
                
                guard let data = snapshot.data() else {
                    return
                }
                //print("Current data: \(data)")
                let info = data["text"] as? String ?? ""
                print("info: \(info)")
                self.informationTextView.text = info
                
        }
        
    }
    
    func loadProgress(){
        
        /*
        let docRef = tasksCollectionRef.document(documentID!)
        
        docRef.getDocument { (document, error) in
            
            if error == nil {
                
                if document != nil && document!.exists {
                    
                    let documentData = document!.data()
                    
                    let name = documentData!["name"] as? String ?? ""
                 
                    let texts = documentData!["text"] as? String ?? ""
                    
                    self.text = texts
                }
            }
        }*/
        
        tasksCollectionRef.document(documentID!)
            .addSnapshotListener{ (querySnapshot, error) in
                guard let snapshot = querySnapshot else {return}
                
                guard let data = snapshot.data() else {
                    return
                }

                //print("Current data: \(data)")
                let progress = data["progress"] as? String ?? ""
                print("progress: \(progress)")
                self.progressLabel.text = progress
                
                let start = data["startTime"] as? String ?? ""
                self.startTime.text = start
                
                let finish = data["finishTime"] as? String ?? ""
                self.finishTime.text = finish
                
                let final = data["finalTime"] as? String ?? ""
                self.finalTime.text = final
                
                let description = data["Description"] as? String ?? ""
                self.descriptionLabel.text = description
                
                if self.progressLabel.text == "Done" {
                    self.checkbox.setImage(UIImage(named: "checked.png"), for: .normal)
                } else {
                    self.checkbox.setImage(UIImage(named: "notChecked.png"), for: .normal)
                    }
                    
                
        }
    }
    
    
    @IBAction func checkbox(_ sender: Any) {
        
        let docRef = tasksCollectionRef.document(documentID!)
        if self.progressLabel.text == "Not done" {
        docRef.updateData(["progress":"Done"]) {
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print ("Document updated.")
            }
            }}
        else {
           docRef.updateData(["progress":"Not done"]) {
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print ("Document updated.")
            }
            }
        }
    }
    
    @IBAction func updateText(_ sender: Any) {
        
        
        let alert = UIAlertController(title: "Edit Task information", message:"Edit task information", preferredStyle: .alert)
            alert.addTextField{ (textField) in
                textField.placeholder = "Enter new information"
            }
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let update = UIAlertAction(title: "Update", style: .default){ _ in
                guard let text = alert.textFields?.first?.text else {return}
                print(text)
                
                let docRef = self.tasksCollectionRef.document(self.documentID!)
                
                //let information = informationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
                
                docRef.updateData(["text":text]) {
                err in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print ("Document updated.")
                }
                }
                
            }
            alert.addAction(cancel)
            alert.addAction(update)
            present(alert,animated:  true, completion: nil)
        
    }
    
    
    
    @IBAction func startTask(_ sender: Any) {
        
        let time1 = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        startTime.text = formatter.string(from: time1)
        
        timeToFireStore()
    }
    
    
    @IBAction func finishTask(_ sender: Any) {
        let time2 = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        
        finishTime.text = formatter.string(from: time2)
    
        let date2 = formatter.date(from: startTime.text!)!
        
        let elapsedTime = time2.timeIntervalSince(date2)
        
        let hours = floor(elapsedTime / 60 / 60)
        
        let minutes = floor ((elapsedTime - (hours * 60 * 60)) / 60)
        
        //print("\(Int(hours)) hr and \(Int(minutes)) min ")
        
        print("\(Int(minutes)) minutes taken to complete task ")

        finalTime.text = "The task has been completed in \(Int(minutes)) minutes"
        
        timeToFireStore()
    }
    
    func timeToFireStore(){
        
        let docRef = tasksCollectionRef.document(documentID!)
        
        let startTi = startTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let finishTi = finishTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let finalTi = finalTime.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        docRef.updateData(["startTime":startTi, "finishTime":finishTi, "finalTime":finalTi]) {
        err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print ("Document updated.")
        }
        }
        
    }
    
    
    @IBAction func editTaskLabel(_ sender: Any) {
        
        let alert = UIAlertController(title: "Edit Task name", message:"Edit task name", preferredStyle: .alert)
        alert.addTextField{ (textField) in
            textField.placeholder = "Enter new task label"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let update = UIAlertAction(title: "Update", style: .default){ _ in
            guard let text = alert.textFields?.first?.text else {return}
            print(text)
            
            let docRef = self.tasksCollectionRef.document(self.documentID!)
            
            docRef.updateData(["Description":text]) {
            err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print ("Document updated.")
            }
            }
        }
        alert.addAction(cancel)
        alert.addAction(update)
        present(alert,animated:  true, completion: nil)
    }
}
