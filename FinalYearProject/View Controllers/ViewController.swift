//
//  ViewController.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 22/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        authenticateUser()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // this will hide the navigation bar at the top of the view
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    // this override function will allow the navigation bar at the top of the view to
    // come back once the ViewController disappears. this will allow the next views to still use this bar.
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // method that will style my login and register buttons.
    func setUpElements() {
        
        //style elements
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
        
        
    }
    
    /*This function will authenticate users. If they are already logged in they will be
     prompted to the next view. this will be useful to avoid making users sign in everytime
     the app is loaded*/
    func authenticateUser(){
        
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                let tabVC = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.tabViewController) as? TabViewController
                
                self.view.window?.rootViewController = tabVC
                self.view.window?.makeKeyAndVisible()
            }
        }
    }


}

