//
//  DisplayAlarmTableViewCell.swift
//  Siesta-UserBuild
//
//  Created by Pallak Singh on 03/08/17.
//  Copyright © 2017 Make School. All rights reserved.
//

import UIKit

class DisplayAlarmTableViewCell: UITableViewCell {

    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var settingsTextField: UITextField!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
