//
//  ShareViewController.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AFNetworking

class ShareViewController: BaseViewController ,textDataInsertDelegate{
    
    var shareList : NSMutableArray!
    var shareCount  = 0
    
    @IBOutlet var _tbleView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
        _localize()
        NotificationCenter.default.addObserver(self, selector: #selector(ShareViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ShareViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        // Do any additional setup after loading the view.
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        self.title = "Share"
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        let rightBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"add_Share.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(ShareViewController.addNewItem))
        
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(ShareViewController.menuBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(ShareViewController.closeMenuScreen(_:)))
        _tbleView.addGestureRecognizer(tapGesture)
        
    }
    
    func _localize()
    {
        if(shareList != nil){
            shareList = NSMutableArray(capacity: 1)
            shareList.add(NSMutableDictionary(dictionary: ["name":"" , "email":""]))
        }
        else {
            shareList = NSMutableArray.init(capacity: 1)
            shareList.add(NSMutableDictionary(dictionary: ["name":"" , "email":""]))
        }
    }
    
    //MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        _tbleView.endEditing(true)
        kAppController!.menuBtnTapped()
    }
    
    
    @IBAction func addNewItem()
    {
        shareCount += 1
        _tbleView.endEditing(true)
        shareList.add(NSMutableDictionary(dictionary: ["name":"" , "email":""]))
        
        let indexPath = IndexPath(row: ((shareList.count)-1), section: 0)
        _tbleView.beginUpdates()
        _tbleView.insertRows(at: [indexPath], with: UITableViewRowAnimation.none)
        _tbleView.endUpdates()
        _tbleView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    
    func closeMenuScreen(_ tapgesture:UITapGestureRecognizer) {
        
        
        let tapPoint:CGPoint = tapgesture.location(in: _tbleView)
        let indexpath = self._tbleView.indexPathForRow(at: tapPoint)

        if let _ = indexpath{
            
            tapgesture.cancelsTouchesInView = false
            
        }else if(kAppController!.isExpanded == true)
        {
            _tbleView.endEditing(true)
            kAppController!.menuBtnTapped()
            return
        }
        _tbleView.endEditing(true)

    }
    
    @IBAction func shareBtnTapped(){
        
        _tbleView.endEditing(true)
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        
        
        let validRecipients : NSMutableArray = NSMutableArray(capacity:shareList.count)
        let emptyEmails : NSMutableArray = NSMutableArray(capacity:shareList.count)
        let emptyName : NSMutableArray = NSMutableArray(capacity:shareList.count)
        let invalidEmails : NSMutableString = NSMutableString(capacity: 1000)
        
        
        shareList.enumerateObjects ( { (recipient, idx: Int, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
            
            
            let name : String = ((recipient as! NSDictionary).object(forKey: "name") as! String).trim()
            let email : String = ((recipient as! NSDictionary).object(forKey: "email") as! String).trim()
            
            if (name.length == 0 && email.length == 0) {
                emptyEmails.add(recipient)
                emptyName.add(recipient)
                return
            }
            
            if (name.length > 0 && email.length == 0  ) {
                emptyEmails.add(recipient)
            }
            if (name.length == 0 && email.length > 0  ) {
                emptyName.add(recipient)
            }
            //&& email.isValidEmail
            if (name.length > 0 && email.length > 0  ) {
                
                if(!(email.isValidEmail)){
                    invalidEmails.appendFormat("%@, ", email)
                }
                else{
                    validRecipients.add(recipient)
                }
                
            }
            else{
                
            }
            
        }) //as! (Any, Int, UnsafeMutablePointer<ObjCBool>) -> Void)
        
        /* Condition validation: At least 1 valid recipients */
        if (validRecipients.count < 1 && invalidEmails.length == 0) {
            if(emptyName.count > 0 && emptyEmails.count > 0){
                self.showAlert(kText_AppName, message: "Please enter the recipient's name and email address before sending.")
            }
            else if(emptyName.count > 0){
                self.showAlert(kText_AppName, message: "Please enter the recipient's name before sending.")
            }
            else if(emptyEmails.count > 0){
                self.showAlert(kText_AppName, message: "Please enter the recipient's email address before sending.")
            }
            
            return
        }
        
        /* Condition validation: All input recipients' emails must be valid */
        if (invalidEmails.length > 0) {
            invalidEmails.replaceCharacters(in: NSMakeRange((invalidEmails.length - 2), 2), with: "")
            
            let tokens : NSArray = (invalidEmails.components(separatedBy: ", ") as NSArray)
            if (tokens.count  < 2) {
                
                self.showAlert(kText_AppName, message: String(format: "The email address \"%@\" is not valid.", arguments: [invalidEmails]))
            }
            else {
                self.showAlert(kText_AppName, message: String(format: "The email addresses \"%@\" is not valid.", arguments: [invalidEmails]))
            }
            return;
        }
        
        let message : String = "I’m using the iWitness app because I want to stay safe. I hope you’ll check it out too."
        
       // validRecipients = ["sravani.gandu@ptgindia.com"]
        let firstname : String =  kUserPreferences.getProfileData()!.object(forKey: "firstName") as! String
        var lastname : String = kUserPreferences.getProfileData()!.object(forKey: "lastName") as! String
        let email : String = kUserPreferences.getProfileData()!.object(forKey: "email") as! String
        if(lastname.length == 0){
            lastname = ""
        }
        
        let paramDict : NSDictionary = ["firstName":firstname , "lastName" :lastname, "email":email , "subject"  : "Check out iWitness" ,"message" : message,"friends":validRecipients]
       
        
        kNetworkManager.executePostRequest(kService_Invitation, parameters: paramDict, requestVC: self)
    }
    
    override func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        self.showAlert(kText_AppName, message:kText_SuccessInviteYourFriends)
        _localize()
        _tbleView.reloadData()
    }
    
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        self.showAlert(kText_Warning, message:kText_CouldNotConnectToServer)
    }


    
    //MARK: UITableView Delegate and DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shareList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let aCell =
        _tbleView.dequeueReusableCell(withIdentifier: "ShareCell",
            for: indexPath) as! ShareTableViewCell
        
        aCell.txtEmail.layer.borderWidth = 1.5
        aCell.txtEmail.layer.borderColor = kLightGrayColor
        
        aCell.delegate = self
        aCell.txtName.layer.borderWidth = 1.5
        aCell.txtName.layer.borderColor = kLightGrayColor
        aCell.indexOfRow = (indexPath as NSIndexPath).row
        aCell.applyInfo(shareList[(indexPath as NSIndexPath).row] as! NSMutableDictionary)
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
      
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }

    }
    
    func keyboardWillShow(_ notification:Notification){
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = _tbleView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        _tbleView.contentInset = contentInset
    }
    
    func keyboardWillHide(_ notification:Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        _tbleView.contentInset = contentInset
    }
    
    func dataInserted(_ info:NSMutableDictionary , indexOfRow:Int){
        shareList.replaceObject(at: indexOfRow, with: info)
    }
    
    //    func textFieldDidBeginEditing(textField: UITextField) {
    //
    //        let pointInTable:CGPoint = textField.superview!.convertPoint(textField.frame.origin, toView: _tbleView)
    //        var contentOffset:CGPoint = _tbleView.contentOffset
    //        contentOffset.y  = pointInTable.y
    //        if let accessoryView = textField.inputAccessoryView {
    //            contentOffset.y -= accessoryView.frame.size.height
    //        }
    //        _tbleView.contentOffset = contentOffset
    //    }
    //
    //
    //    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
    //        textField.resignFirstResponder()
    //        return true
    //    }
    
}
