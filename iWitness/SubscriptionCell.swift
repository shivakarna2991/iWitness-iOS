//
//  SubscriptionCell.swift
//  iWitness
//
//  Created by People Tech on 1/4/16.
//  Copyright © 2016 PTG. All rights reserved.
//

import UIKit
import StoreKit
    
    class SubscriptionCell: UITableViewCell {
        
        @IBOutlet var _selectImage:UIButton!
        @IBOutlet var _titleLabel:UILabel!
        
        var _isSelected :Bool!
        var subscription :SKProduct!
        
        
        override func awakeFromNib() {
            super.awakeFromNib()
            // Initialization code
        }
        
        override func setSelected(_ selected: Bool, animated: Bool) {
            super.setSelected(selected, animated: animated)
            _isSelected = selected
            //        _selectImage.image != _isSelected ? kIcn_Check01 : kIcn_Uncheck01
            
            // Configure the view for the selected state
        }
        
        // MARK : - Class's public methods
        
        
}
