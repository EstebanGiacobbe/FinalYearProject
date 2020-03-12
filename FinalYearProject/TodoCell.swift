//
//  TodoCell.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 12/03/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    
    @IBOutlet weak var todoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
