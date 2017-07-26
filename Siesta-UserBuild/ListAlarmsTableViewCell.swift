//
//  ListNotesTableViewCell.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 21/07/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class ListAlarmsTableViewCell: UITableViewCell {

    @IBOutlet weak var alarmTimeLabel: UILabel!
    
    
    @IBOutlet weak var alarmOrigin: UILabel!
    @IBOutlet weak var alarmDestination: UILabel!
    
    
        override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
