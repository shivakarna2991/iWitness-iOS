//
//  MenuTableViewCell.swift
//  iWitness
//
//  Created by Sravani on 01/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menutitleLabel: UILabel!
    @IBOutlet weak var menuiconImgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
