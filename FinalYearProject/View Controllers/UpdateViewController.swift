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
        
        Utilities.styleUpdate(updateTxt)
        
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
        
         let docRef = tasksCollectionRef.document(documentID!)
        
        let information = informationTextView.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        docRef.updateData(["text":information]) {
        err in
        if let err = err {
            print("Error updating document: \(err)")
        } else {
            print ("Document updated.")
        }
        }
        
    }
    
    
}
