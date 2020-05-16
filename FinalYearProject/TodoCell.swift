//
//  TodoCell.swift
//  FinalYearProject
//
//  Created by Esteban Giacobbe on 12/03/2020.
//  Copyright © 2020 Esteban Giacobbe. All rights reserved.
//

import UIKit

class TodoCell: UITableViewCell {
    
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var taskLabelVC: UIView!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taskLabelVC.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
