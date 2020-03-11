//
//  File.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 23/02/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import Foundation
import FirebaseFirestore

protocol DocumentSerializable {
    init?(dictionary:[String:Any])
}

struct  Constants {
    struct Storyboard {
        static let homeViewController = "HomeVC"
        static let tabViewController = "TabViewController"
        static let navViewController = "NavViewController1"
    }
    
    
}

struct todo{
    var name: String
    var description: String
    
    var dictionary: [String:Any]{
        return [
            "name":name,
            "description": description
        ]
    }
    
}

extension todo : DocumentSerializable{
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let description = dictionary["description"] as? String else {return nil}
        
        self.init(name: name, description: description)
    }
}
