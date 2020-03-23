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
    var documentID: String
    
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var iD : String?
    var tasksArray = [tasks]()
    private var tasksCollectionRef: CollectionReference!
    

    
    
    @IBOutlet weak var todoTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTV.delegate = self
        todoTV.dataSource = self
        todoTV.rowHeight = 100
        
        
        
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
        
        tasksCollectionRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                
                diff in
                
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let description = data["Description"] as? String ?? ""

                    let name = data["name"] as? String ?? ""
                    
                    let documentID = diff.document.documentID
                    
                    
                    let newTask = tasks(name: name, description: description, documentID: documentID)
                    self.tasksArray.append(newTask)
                    
                    self.iD = documentID
                    
                    DispatchQueue.main.async {
                        self.todoTV.reloadData()
                    }
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
        
        
        cell.nameLabel.text = tasksArray[indexPath.row].name
        cell.todoLabel.text = tasksArray[indexPath.row].description
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "showdetail", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destination = segue.destination as? UpdateViewController {
            
            destination.documentID = tasksArray[todoTV.indexPathForSelectedRow!.row].documentID
            
            destination.descriptions = tasksArray[todoTV.indexPathForSelectedRow!.row].description
            
        }
    }
    
    
}


