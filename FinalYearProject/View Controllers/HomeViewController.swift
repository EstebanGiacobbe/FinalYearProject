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
    var text: String
    var date: String
    var progress: String
    
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
        todoTV.tableFooterView = UIView()
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
        
        tasksCollectionRef.addSnapshotListener { (querySnapshot, error) in
            guard let snapshot = querySnapshot else {return}
            
            snapshot.documentChanges.forEach {
                
                diff in
                
                if (diff.type == .added) {
                    
                    let data = diff.document.data()
                    
                    let description = data["Description"] as? String ?? ""

                    let name = data["name"] as? String ?? ""
                    
                    let documentID = diff.document.documentID
                    
                    let text = data["text"] as? String ?? ""
                    
                    let date = data["date"] as? String ?? ""
                    
                    let progress = data["progress"] as? String ?? ""
                    
                    
                    let newTask = tasks(name: name, description: description, documentID: documentID, text:text, date: date, progress: progress)
                    self.tasksArray.append(newTask)
                    
                    //self.iD = documentID
                    
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
        
        cell.dateLabel.text = tasksArray[indexPath.row].date
        
        if tasksArray[indexPath.row].progress == "Done" {
            cell.checkmarkImage.image = UIImage(named: "checkmarks.png")
            
        } else {
            
            cell.checkmarkImage.image = nil
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "showdetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            tasksCollectionRef.document(tasksArray[indexPath.row].documentID).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print ("Document successfully removed!")
                }
            }
            tasksArray.remove(at: indexPath.row)
            
            todoTV.beginUpdates()
            todoTV.deleteRows(at: [indexPath], with: .automatic)
            todoTV.endUpdates()
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destination = segue.destination as? UpdateViewController {
            
            destination.documentID = tasksArray[todoTV.indexPathForSelectedRow!.row].documentID
            
            destination.descriptions = tasksArray[todoTV.indexPathForSelectedRow!.row].description
            
            destination.text = tasksArray[todoTV.indexPathForSelectedRow!.row].text
            
            destination.progress = tasksArray[todoTV.indexPathForSelectedRow!.row].progress
            
        }
    }
    
    
}


