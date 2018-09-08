//
//  SettingsTableViewCell.swift
//  RummyScoreCount
//
//  Created by Ganesh on 30/06/18.
//  Copyright © 2018 Ganesh. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet weak var fieldGamePoints: UITextField!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        fieldGamePoints.layer.borderColor = UIColor.white.cgColor
        fieldGamePoints.layer.borderWidth = 1
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
