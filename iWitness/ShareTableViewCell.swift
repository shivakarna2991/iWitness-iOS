//
//  ShareTableViewCell.swift
//  iWitness
//
//  Created by People Tech on 12/24/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

protocol textDataInsertDelegate{
    func dataInserted(_ info:NSMutableDictionary , indexOfRow:Int)
}

class ShareTableViewCell: UITableViewCell {
    
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtEmail:UITextField!
    var info : NSMutableDictionary!
    var indexOfRow : Int!
    var delegate :textDataInsertDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
            let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: txtName.frame.size.height))
            
            txtName.leftView = paddingView
            txtName.leftViewMode = UITextFieldViewMode.always
            
            
            let paddingView1 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: txtName.frame.size.height))
            
            
            txtEmail.leftView = paddingView1
            txtEmail.leftViewMode = UITextFieldViewMode.always
            
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func applyInfo(_ info1 : NSMutableDictionary ) {
        
        self.info = NSMutableDictionary.init(dictionary: info1 as NSDictionary)
        txtName.text  = (self.info["name"] as! String)
        
        txtEmail.text = (self.info["email"] as! String)
    }
    
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool{
        
        if(textField == txtName){
            self.info["name"] = ""
        }
        else if (textField == txtEmail){
            self.info["email"] = ""
        }
        
        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        if (textField == txtName) {
            txtEmail.becomeFirstResponder()
        }
        else {
            txtName.resignFirstResponder()
            txtEmail.resignFirstResponder()
        }
        return true
    }
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
    
      if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return false
        }
        return true
           
    }

    
    func textFieldDidEndEditing(_ textField: UITextField){
        if (textField == txtName) {
            self.info["name"] = txtName.text
        }
        else {
            self.info["email"] = txtEmail.text
        }
        
        delegate?.dataInserted(self.info,indexOfRow: self.indexOfRow)
    }
    
    
}
