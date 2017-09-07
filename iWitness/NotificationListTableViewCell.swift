//
//  NotificationListTableViewCell.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class NotificationListTableViewCell: UITableViewCell {
    @IBOutlet weak var notificationLbl: UILabel!
    @IBOutlet weak var notificationImgView: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
