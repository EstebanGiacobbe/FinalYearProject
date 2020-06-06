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

//Model of my MVC design
struct tasks: Equatable {
    var name, description: String
    var documentID: String
    var text: String
    var date: String
    var progress: String
    
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
//Struct initialised as an array.
    var tasksArray = [tasks]()
    
    private var tasksCollectionRef: CollectionReference!
    
    let myRefreshControl = UIRefreshControl()
    
    var iD : String?

    @IBOutlet weak var todoTV: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        todoTV.delegate = self
        todoTV.dataSource = self
        todoTV.tableFooterView = UIView()
        todoTV.rowHeight = 80
        
        
        //Database reference pointing to the path tasks.
        tasksCollectionRef = Firestore.firestore().collection("Tasks")
        
        loadToDo()
        
        myRefreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh), for: .valueChanged)
        todoTV.refreshControl = myRefreshControl
        
        }
    
    //This will handle the user refresh control.
    @objc func handleRefresh(){
        Timer.scheduledTimer(withTimeInterval: 1.0,repeats: false){ (timer) in
            self.todoTV.reloadData()
            self.myRefreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        
    }
    
    //Logout button, if user logs out he will be prompted to the navViewController
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
    
    //Retrieve data from database with a snapshotlistener
    //Implemented to listen for any data added and modified.
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
                    print(self.tasksArray)
                    
                    //This will sort the array by date.
                    self.tasksArray.sort(by: {$0.date < $1.date})
                    
                    DispatchQueue.main.async {
                        self.todoTV.reloadData()
                    }
                }
                if (diff.type == .removed) {
                    
                    print("Removed document: \(diff.document.data())")
                    let alert = UIAlertController(title: "Tasks deleted", message:"Some tasks have been deleted. Update the table view", preferredStyle: .alert)

                    let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        
                    
                    alert.addAction(cancel)
                    self.present(alert,animated:  true, completion: nil)
                }
                if (diff.type == .modified){
                    
                    print("Modified document: \(diff.document.data())")
                    
                    let data = diff.document.data()
                    let description = data["Description"] as? String ?? ""
                    let name = data["name"] as? String ?? ""
                    let documentID = diff.document.documentID
                    let text = data["text"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let progress = data["progress"] as? String ?? ""
                    
                    //Index pointing to the document with the same ID as the modified file.
                    guard let oldDocIndex = self.tasksArray.firstIndex(where: {$0.documentID == documentID}) else {return}
                    let indexToDelete = self.tasksArray[oldDocIndex]
                    
                    //remove the current task containing the same ID as the modified file.
                    if let index = self.tasksArray.firstIndex(of: indexToDelete) {
                        self.tasksArray.remove(at: index)
                    }
                    
                    //Append the modified task reflecting the changes.
                    let newTask = tasks(name: name, description: description, documentID: documentID, text:text, date: date, progress: progress)
                    self.tasksArray.append(newTask)
                    
                    //Sort array by date when data it's modified.
                    self.tasksArray.sort(by: {$0.date < $1.date})
                
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
        
        
        if tasksArray[indexPath.row].progress == "Not done" {
            cell.checkmarkImage.image = UIImage(named: "notChecked.png")
        }
        if tasksArray[indexPath.row].progress == "Done" {
            
            cell.checkmarkImage.image = UIImage(named:"checked.png")
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        performSegue(withIdentifier: "showdetail", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //Delete function implementation, contains an alert from which users can confirm or cancel action.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
       
        if editingStyle == .delete{
            
            let alert = UIAlertController(title: "Delete alert!", message:"Are you sure you want to delete this task?", preferredStyle: .alert)
        
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let confirm = UIAlertAction(title: "Confirm", style: .default){ _ in
                
                self.tasksCollectionRef.document(self.tasksArray[indexPath.row].documentID).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                    } else {
                        print ("Document successfully removed!")
                    }
                }
                self.tasksArray.remove(at: indexPath.row)
                
                self.todoTV.beginUpdates()
                self.todoTV.deleteRows(at: [indexPath], with: .automatic)
                self.todoTV.endUpdates()
                
            }
            alert.addAction(cancel)
            alert.addAction(confirm)
            present(alert,animated:  true, completion: nil)
    
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if let destination = segue.destination as? UpdateViewController {
            
            destination.documentID = tasksArray[todoTV.indexPathForSelectedRow!.row].documentID
        }
    }
    
    
}


