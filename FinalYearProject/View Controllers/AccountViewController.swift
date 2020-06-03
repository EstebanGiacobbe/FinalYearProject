//
//  AccountViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 31/05/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import Firebase

class AccountViewController: UIViewController {
    
    //private var tasksCollectionRef: CollectionReference!
    @IBOutlet weak var accountName: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //tasksCollectionRef = Firestore.firestore().collection("users")
        loadAccount()
    }
    
    func loadAccount(){
        
        
    
    
    }
    
    
}
