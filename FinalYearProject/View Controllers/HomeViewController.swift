//
//  HomeViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
  //  @objc func handleSignOut(){
    //    let alertcontroller = UIAlertController(title: nil, message:"Are you sure you want to sign out?", preferredStyle: .actionSheet)
     //   alertcontroller.addAction(UIAlertAction(title: "Sign Out",style: .destructive,handler: { (_)in self.logout()
            
       // }))
        //alertcontroller.addAction(UIAlertAction(title: "cancel", style: .cancel,handler: nil))
        //present(alertcontroller, animated: true,completion: nil)
    
    //func logout(){
            
      //      do {
                
        //        try Auth.auth().signOut()
          //      let VC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.viewController) as? ViewController
                
           //     self.view.window?.rootViewController = VC
            //    self.view.window?.makeKeyAndVisible()
                    

                
         //   } catch let error {
          //      print("Error", error)
                
            //}
            
        //}
        

    //}
    
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
        
    }

