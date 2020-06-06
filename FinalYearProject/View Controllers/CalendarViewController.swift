//
//  CalendarViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 02/06/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import FSCalendar
import Firebase

struct details {
    
    var title: String
    var information: String
    var name: String
    var date: String
}


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    
    var eventArray = [String]()
    var detailArray = [details]()
    
    private var tasksCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.dataSource = self
        calendar.delegate = self

        
        tasksCollectionRef = Firestore.firestore().collection("Tasks")
        loadEvents()
    }
    
    
    func loadEvents(){
        
        tasksCollectionRef.addSnapshotListener { (querySnapshot, error) in
        guard let snapshot = querySnapshot else {return}
        
        snapshot.documentChanges.forEach {
            
            diff in
            if (diff.type == .added) {
                
                let data = diff.document.data()

                let date = data["date"] as? String ?? ""
                //let title = data["Description"] as? String ?? ""
                //let info = data["text"] as? String ?? ""
                //let member = data["name"] as? String ?? ""
                
                self.eventArray.append(date)
                
                //let newDetails = details(title: title, information: info, name: member, date: date)
                
                //self.detailArray.append(newDetails)
                
              //print("newArra: \(self.eventArray)")

            }
            }
        }
    }
    
    
    fileprivate lazy var dateFormatter2: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    

    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateToString = self.dateFormatter2.string(from: date)

        if self.eventArray.contains(dateToString){
            return 1
        }
  
        return 0
    }
    
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateToString = self.dateFormatter2.string(from: date)
        
        if self.eventArray.contains(dateToString){
        let alert = UIAlertController(title: "Tasks due", message:"Open the task board to check if you have any tasks assigned for this day.", preferredStyle: .alert)

            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)

            alert.addAction(cancel)
            present(alert,animated:  true, completion: nil)
        }
        else{
            let alert = UIAlertController(title: "Tasks empty", message:"There are no tasks due for this day, try again later.", preferredStyle: .alert)

            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)

            alert.addAction(cancel)
            present(alert,animated:  true, completion: nil)
            
        }
    }

}
