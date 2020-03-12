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

struct tasks {
    
    var name, description: String
    
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    
    var tasksArray = [tasks]()
    private var tasksCollectionRef: CollectionReference!
    

    
    @IBOutlet weak var welcomeLabel: UILabel!
    
   
    @IBOutlet weak var todoTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTV.delegate = self
        todoTV.dataSource = self
        todoTV.rowHeight = 80
        
        tasksCollectionRef = Firestore.firestore().collection("Tasks")
        
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
        //let docRef = Firestore.firestore().collection("Tasks").document("Nk1okAiVIKVChsuLdMmF")
        //docRef.getDocument { (document, error) in
          //  if let document = document, document.exists {
                 //let dataDescription2 = document.data().map(String.init(describing:)) ?? "nil"
            //    let property = document.get("Description")
              //  self.welcomeLabel.text = property as? String
            //} else{
                
              //  print("Document does not exist")
            //}

        //
        tasksCollectionRef.getDocuments { (snapshot, error) in
            if let err = error {
                debugPrint("Error fetching docs \(err)")
            }
            else {
                guard let snap = snapshot else { return }
                for document in snap.documents{
                    let data = document.data()
                    
                    let description = data["Description"] as? String ?? ""

                    let name = data["name"] as? String ?? ""
                    let newTask = tasks(name: name, description: description)
                    self.tasksArray.append(newTask)
                }
                DispatchQueue.main.async {
                    self.todoTV.reloadData()
                }
            }
        }
        
            
        }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TodoCell
        
        cell.todoLabel.text = tasksArray[indexPath.row].description
        
        return cell
    }
    
   
}


