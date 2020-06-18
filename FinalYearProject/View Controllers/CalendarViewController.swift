//
//  CalendarViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 02/06/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//
//
// In order to implement this view i have followed FSCalendar instructions found on
// Cocoapods website. https://cocoapods.org/pods/FSCalendar
// Wenchao Ding provided my project with the FSCalendar functionality needed to reflect any tasks dates as events.
// further implementation is needed in order to display any tasks found in a selected date
// within a table view. and any time another date is selected the table view should display different tasks
// contained within that date.

import UIKit
import FSCalendar
import Firebase

// model containing details of tasks.
// it has been created but not yet used in the current prototype
// due to a bug found during the implementation of a the table view containing its data.
// future development of my application will implement this view furthermore and
// deal with the problem
struct details {
    
    var title: String
    var information: String
    var name: String
    var date: String
}


class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    
    @IBOutlet weak var calendar: FSCalendar!
    
    
    var eventArray = [String]()
    //var detailArray = [details]()
    
    private var tasksCollectionRef: CollectionReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        calendar.dataSource = self
        calendar.delegate = self

        
        tasksCollectionRef = Firestore.firestore().collection("Tasks")
        loadEvents()
    }
    
    // this method will retrieve the dates from the database and append each in an array.
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
    
    
    fileprivate lazy var formattingDate: DateFormatter = {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        return formatter
    }()
    
// if any date within the array has the same format as the calendar format then a dot is created
// in order to reflect an event.
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        
        let dateToString = self.formattingDate.string(from: date)

        if self.eventArray.contains(dateToString){
            return 1
        }
  
        return 0
    }
    

        // this method deals with users selecting a date within the calendar.
        // currently it will display an alert depending on what date has been selected.
        // future implementation would involve the use of a table view to display information of a task any time
        // that a date is selected.
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        let dateToString = self.formattingDate.string(from: date)
        
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
