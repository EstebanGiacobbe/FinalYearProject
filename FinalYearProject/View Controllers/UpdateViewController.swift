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
    
    @IBOutlet weak var informationTextView: UITextView!
    
    @IBOutlet weak var progressLabel: UILabel!
    
    
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
        
        //loadLabel()
        
    }
    
    func loadLabel(){
        
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
            
        }
            
        
        
        
        
    }
    
}
