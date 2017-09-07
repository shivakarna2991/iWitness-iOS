//
//  VideoListTableViewCell.swift
//  iWitness
//
//  Created by Sravani on 28/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class VideoListTableViewCell: UITableViewCell {

    @IBOutlet weak var dateofVideo: UILabel!
    @IBOutlet weak var timeOfVideo: UILabel!
    @IBOutlet weak var durationOfVideo: UILabel!
    @IBOutlet weak var locationOfVideo: UILabel!
    @IBOutlet weak var imageOfVideo: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
