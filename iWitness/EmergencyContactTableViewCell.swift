//
//  EmergencyContactTableViewCell.swift
//  iWitness
//
//  Created by Sravani on 09/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class EmergencyContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactname: UILabel!
    @IBOutlet weak var contactrelation: UILabel!
    @IBOutlet weak var contactBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
