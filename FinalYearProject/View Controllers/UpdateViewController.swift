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

    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var documentIDLabel: UILabel!
    
    @IBOutlet weak var textLabel: UILabel!
    
    var documentID: String?
    var descriptions: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       

        // Do any additional setup after loading the view.
    
        documentIDLabel.text = documentID
        descriptionLabel.text = descriptions
        
        loadLabel()
        
    }
    
    func loadLabel(){
        
        
        
    }
    
    

}
