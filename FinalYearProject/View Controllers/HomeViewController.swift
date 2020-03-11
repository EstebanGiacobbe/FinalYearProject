//
//  HomeViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import FirebaseFirestore
import Firebase


class HomeViewController: UIViewController {

    
    @IBOutlet weak var welcomeLabel: UILabel!
    
   
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
          loadToDo()
        }

        // Do any additional setup after loading the view.
    
    
    @IBAction func logout(_ sender: Any) {
        
        do {
            
            try Auth.auth().signOut()
            
            let navigationController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.navViewController) as? NavViewController
                 
                self.view.window?.rootViewController = navigationController
                self.view.window?.makeKeyAndVisible()
                
                
            } catch let error{
                print("error",error)
            
        }
            
        }
    
    func loadToDo(){
        let docRef = Firestore.firestore().collection("Tasks").document("Nk1okAiVIKVChsuLdMmF")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                 //let dataDescription2 = document.data().map(String.init(describing:)) ?? "nil"
                let property = document.get("Description")
                self.welcomeLabel.text = property as? String
            } else{
                
                print("Document does not exist")
            }

        }
            
        }
   
}


