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

struct tasks: Equatable {
    var name, description: String
    var documentID: String
    var text: String
    var date: String
    var progress: String
    
}


class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

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
        
        
        
        tasksCollectionRef = Firestore.firestore().collection("Tasks")
        
        loadToDo()
        
        myRefreshControl.addTarget(self, action: #selector(HomeViewController.handleRefresh), for: .valueChanged)
        todoTV.refreshControl = myRefreshControl
        
        }
    
    @objc func handleRefresh(){
        Timer.scheduledTimer(withTimeInterval: 1.0,repeats: false){ (timer) in
            self.todoTV.reloadData()
            self.myRefreshControl.endRefreshing()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        //loadToDo()
    }
    
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
                    print(self.tasksArray)
                    //self.iD = documentID
                    
                    DispatchQueue.main.async {
                        self.todoTV.reloadData()
                    }
                }
                if (diff.type == .removed) {
                    
                    print("Removed document: \(diff.document.data())")
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
       
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
        }
    }
    
    
}


