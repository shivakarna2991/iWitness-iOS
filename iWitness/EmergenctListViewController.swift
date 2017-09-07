//
//  EmergenctListViewController.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AddressBook
import Contacts
import ContactsUI
import AddressBookUI
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


enum ContactStatus: Int {
    case pending = 1, accepted = 2, declined = 4
}

//let yearMonth = Month.May.rawValue


class EmergenctListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,UIAlertViewDelegate  {
    
    @IBOutlet var listView :UITableView!
    @IBOutlet var bottomConstraint:NSLayoutConstraint!
    var count:Int!
    var nameOfContact:String!
    var emailAddOfContact:String!
    var phoneNoOfContact:String!
    var lastNameOfContact:String!
    var isScreenFromSignup = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        self.automaticallyAdjustsScrollViewInsets = false

        _visualize()
        
        NotificationCenter.default.addObserver(self, selector:#selector(EmergenctListViewController.reloadContactsList) , name: NSNotification.Name(rawValue: "reloadContacts"), object: nil)
    
        reloadContactsList()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        self.title = "Emergency Contacts"
        
        if(isScreenFromSignup ==  true)
        {
            let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action:#selector(EmergenctListViewController.showNotificationCliamScreen))
            self.navigationItem.rightBarButtonItem = rightBtn
            self.navigationItem.setHidesBackButton(true, animated: false)

 
        }
        else{
            let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(EmergenctListViewController.menuBtnTapped))
            self.navigationItem.leftBarButtonItem = leftBtn

            self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item

        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EmergenctListViewController.closeMenuScreen(_:)))
        listView.addGestureRecognizer(tapGesture)

        
    }
    
    func closeMenuScreen(_ tapgesture:UITapGestureRecognizer) {
        
        
        let tapPoint:CGPoint = tapgesture.location(in: listView)
        let indexpath = self.listView.indexPathForRow(at: tapPoint)
        
        if let _ = indexpath{
           
            tapgesture.cancelsTouchesInView = false
            
        }else if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
    }
    
    func showNotificationCliamScreen()
    {
        let NotificationDetilVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationDetailVCId") as! NotificationDetailViewController
        NotificationDetilVC.isScreenFromRegistration = true
        self.navigationController?.pushViewController(NotificationDetilVC, animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        listView.reloadData()
        
    }
    
//Mark:Request To fetch emergency contacts (Get request)
    
    func reloadContactsList()
    {
        
        kNetworkManager.executeGetRequest(String(format: kService_Contact,kUserPreferences.currentProfileId()!), parameters: nil, requestVC: self)

    }

    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
       
        
        if(kAppDelegate.contactsArray.count > 0){
            kAppDelegate.contactsArray.removeAll()
        }
        
        
        if((((responseObject["_embedded"] as! [String:AnyObject])["contact"]) as! [[String:AnyObject]]).count > 0)
        {
            kAppDelegate.contactsArray = (((responseObject["_embedded"] as! [String:AnyObject])["contact"]) as! [[String:AnyObject]])
        }

//        if(((responseObject.value(forKey: "_embedded") as AnyObject).value(forKey: "contact") as AnyObject).count > 0){
//            
//            kAppDelegate.contactsArray = (((responseObject.value(forKey: "_embedded") as AnyObject).value(forKey: "contact"))! as AnyObject) as! [[String:AnyObject]]
//        }
        
        self.listView.reloadData()
    }
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        

        self.showAlert(kText_Warning, message:kText_CouldNotLoadEmergencyContactList)
        
    }
    
    
    //MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        kAppController!.menuBtnTapped()
    }
    
//    @IBAction func call911BtnTapped()
//    {
//        
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return (kAppDelegate.contactsArray.count+1)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        listView.dequeueReusableCell(withIdentifier: "contactcell",
            for: indexPath) as! EmergencyContactTableViewCell
        
        if((indexPath as NSIndexPath).row == kAppDelegate.contactsArray.count){
            aCell.contactname.isHidden = true
            aCell.contactrelation.isHidden = true
            aCell.contactBtn.isHidden = false
            aCell.backgroundColor = self.view.backgroundColor
        }
        else
        {
            
            let obj1 = kAppDelegate.contactsArray[(indexPath as NSIndexPath).row]
            
            let obj = obj1 as AnyObject
            
            aCell.contactname.isHidden = false
            aCell.contactrelation.isHidden = false
            aCell.contactBtn.isHidden = true
            aCell.contactname.text = String(format:"%@ %@", (obj["firstName"] as? String)! ,(obj["lastName"] as? String)!)
            aCell.backgroundColor = UIColor.white
            
            
            
            switch(obj["flags"] as! NSInteger)
            {
            case ContactStatus.pending.rawValue : aCell.contactrelation.text = "Pending"
            case ContactStatus.accepted.rawValue : aCell.contactrelation.text = "Accepted"
            case ContactStatus.declined.rawValue : aCell.contactrelation.text = "Declined"
            default:break
            }


        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }

        if((indexPath as NSIndexPath).row == kAppDelegate.contactsArray.count){
            return
        }

        
        let obj = kAppDelegate.contactsArray[(indexPath as NSIndexPath).row] as NSDictionary
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_UpdateVC") as! AddContactViewController
            detailVC.updatedDict = obj
            detailVC.isContactForUpdate = true
            self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
//     func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        return true
//    }
//    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.Delete) {
//            
//            let obj = kAppDelegate.contactsArray[indexPath.row] as! NSDictionary
//         
//            selectdContactId = obj.valueForKey("id") as! String
//            let alertView = UIAlertView(title:kText_AppName , message:"Are you sure you want to delete this contact from Emergency Contacts list?", delegate: self, cancelButtonTitle: nil, otherButtonTitles:"Yes","No")
//            alertView.tag = 999
//            alertView.show()
//            
//        }
//    }
//    
//    
//    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
//    {
//        
//        if(alertView.tag == 999 && buttonIndex == 0)
//        {
//            
//           kNetworkManager.executeDeleteRequest(String(format: kService_DeleteOrUpdateContact,selectdContactId), parameters: nil, requestVC: self)
//            
//        }
//    }
//    
    
    
    
    func showAddContactScreen()
    {
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_UpdateVC") as! AddContactViewController
        self.navigationController?.pushViewController(detailVC, animated: true)
   
    }

    @IBAction func AddContact()
    {
      
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }

        
        if(kAppDelegate.contactsArray.count >= 6)
        {
            self.showAlert(kText_AppName, message: kText_CannotAddMoreEmergencyContact)
            return
        }
        
       // if(kUtilities.checkiOS8()) {
            
           // if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let buttonOne = UIAlertAction(title: "Address Book", style: .default, handler: { (action) -> Void in
                    alertController.dismiss(animated: true, completion: nil)
                    
                      self.fetchFromExistingContacts()
                })
                let buttonTwo = UIAlertAction(title: "New Contact", style: .default, handler: { (action) -> Void in
                    alertController.dismiss(animated: true, completion: nil)
                    
                    self.showAddContactScreen()
               

                
                })
                let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                    alertController.dismiss(animated: true, completion: nil)
                }
                alertController.addAction(buttonOne)
                alertController.addAction(buttonTwo)
                alertController.addAction(buttonCancel)
                
                present(alertController, animated: true, completion: nil)
                
           // } else {
                // Fallback on earlier versions
          //  }
     //   }
//        else{
//            
//            let imageActionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:nil);
//            imageActionSheet.addButtonWithTitle("Address Book")
//            imageActionSheet.addButtonWithTitle("New Contact")
//            imageActionSheet.addButtonWithTitle("Cancel")
//            imageActionSheet.cancelButtonIndex = 2
//            
//            imageActionSheet.showInView(self.view)
//        }
        
    }
    
    
  func fetchFromExistingContacts()
  {
    if #available(iOS 9.0, *) {
        let peoplePicker = CNContactPickerViewController()
        peoplePicker.delegate = self
        self.present(peoplePicker, animated: true, completion: nil)
    } else {
        // Fallback on earlier versions
        let picker = ABPeoplePickerNavigationController()
        picker.peoplePickerDelegate = self
        self.present(picker, animated: true, completion: nil)
    }
    }
    


    
    
//MARK: Action Sheet Delegate Methods======
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        if(buttonIndex == 0){
             fetchFromExistingContacts()
        }
        else if(buttonIndex == 1){
               showAddContactScreen()
        }
        
    }
    
    
    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {
//        let unmanagedPhones = ABRecordCopyValue(person, kABPersonPhoneProperty)
        
        
        emailAddOfContact = ""

        if let value = ABRecordCopyValue(person, kABPersonEmailProperty)
        {
        
            let emailMultiValue:ABMultiValue = value.takeUnretainedValue()
            
            if ABMultiValueGetCount(emailMultiValue) > 0 {
            
            var iCloudEmail  : String = ""
            var homeEmail : String = ""
            var workEmail : String = ""
            var otherEmail  : String = ""
            var customEmail  : String = ""
            
            let emailAddresses: NSArray = ABMultiValueCopyArrayOfAllValues(emailMultiValue).takeUnretainedValue() as NSArray
            
            
            for index in 0..<(emailAddresses.count) {
                var emailLabel  = ABMultiValueCopyLabelAtIndex(emailMultiValue,index).takeUnretainedValue() as String
                
                //Strip out the stuff you don't need
                emailLabel = emailLabel.replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range: nil)
                emailLabel = emailLabel.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                emailLabel = emailLabel.replacingOccurrences(of: "!", with: "", options: NSString.CompareOptions.literal, range: nil)
                emailLabel = emailLabel.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
                emailLabel = emailLabel.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
                
                
                if emailLabel == "Home" && homeEmail.length == 0 {
                    
                    if let emailID = emailAddresses.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        homeEmail = emailID
                    }
                }
                else if emailLabel == "Work" && workEmail.length == 0 {
                    if let emailID = emailAddresses.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        workEmail = emailID
                    }
                }
                else if emailLabel == "iCloud" && iCloudEmail.length == 0 {
                    if let emailID = emailAddresses.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        iCloudEmail = emailID
                    }
                }
                else if emailLabel == "Other" && otherEmail.length == 0 {
                    if let emailID = emailAddresses.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        otherEmail = emailID
                    }
                }
                else if(customEmail.length == 0){
                    if let emailID = emailAddresses.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        customEmail = emailID
                    }
                }
            }
            
            if(homeEmail.length > 0){
                emailAddOfContact = homeEmail
            }
            else if(workEmail.length > 0){
                emailAddOfContact = workEmail
            }
            else if(iCloudEmail.length > 0){
                emailAddOfContact = iCloudEmail
            }
            else if(otherEmail.length > 0){
                emailAddOfContact = otherEmail
            }
            else if(customEmail.length > 0){
                emailAddOfContact = customEmail
            }
            
          }
        }
        
        
        let firstNameObj = ABRecordCopyValue(person, kABPersonFirstNameProperty);
        if(firstNameObj != nil) {
            nameOfContact = firstNameObj?.takeRetainedValue() as? String;
        } else {
            nameOfContact = "";
        }
        let lastNameObj = ABRecordCopyValue(person, kABPersonLastNameProperty);
        if(lastNameObj != nil) {
            lastNameOfContact = lastNameObj?.takeRetainedValue() as? String;
        } else {
            lastNameOfContact = "";
        }
        
        
       // let unmanagedPhones = ABRecordCopyValue(person, kABPersonPhoneProperty)
        phoneNoOfContact = ""


        if(ABRecordCopyValue(person, kABPersonPhoneProperty) != nil ){
        
        let phones: ABMultiValue = ABRecordCopyValue(person, kABPersonPhoneProperty).takeUnretainedValue()
        
        let countOfPhones = ABMultiValueGetCount(phones)
        
            if countOfPhones > 0 {
            
            
            var mobilePhone  : String = ""
            var homePhone  : String = ""
            var workPhone  : String = ""
            var otherPhone  : String = ""
            
            let phoneNumbers: NSArray = ABMultiValueCopyArrayOfAllValues(phones).takeUnretainedValue() as NSArray
            
            
            for index in 0..<(phoneNumbers.count) {
                var phoneLabel  = ABMultiValueCopyLabelAtIndex(phones,index).takeUnretainedValue() as String
                
                //Strip out the stuff you don't need
                phoneLabel = phoneLabel.replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range: nil)
                phoneLabel = phoneLabel.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                phoneLabel = phoneLabel.replacingOccurrences(of: "!", with: "", options: NSString.CompareOptions.literal, range: nil)
                phoneLabel = phoneLabel.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
                phoneLabel = phoneLabel.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
                
                
                
                if phoneLabel == "Mobile" && mobilePhone.length == 0 {
                    
                    if let phoneNo = phoneNumbers.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        mobilePhone = phoneNo
                    }
                }
                else if phoneLabel == "Home" && homePhone.length == 0 {
                    if let phoneNo = phoneNumbers.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        homePhone = phoneNo
                    }
                }
                else if phoneLabel == "Work" && workPhone.length == 0 {
                    if let phoneNo = phoneNumbers.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        workPhone = phoneNo
                    }
                }
                else if(otherPhone.length == 0) {
                    if let phoneNo = phoneNumbers.object(at: index) as? String{
                        //EmailID is <<errorType>>
                        otherPhone = phoneNo
                    }
                }
            }
            
            if(mobilePhone.length > 0){
                phoneNoOfContact = mobilePhone
            }
            else if(homePhone.length > 0){
                phoneNoOfContact = homePhone
            }
            else if(workPhone.length > 0){
                phoneNoOfContact = workPhone
            }
            else if(otherPhone.length > 0){
                phoneNoOfContact = otherPhone
            }
            
        }
      }
        
        
    let obj:NSDictionary = ["firstName":self.nameOfContact,"lastName" : self.lastNameOfContact, "phone":self.phoneNoOfContact,"email" : emailAddOfContact]
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_UpdateVC") as! AddContactViewController
        detailVC.updatedDict = obj
        self.navigationController?.pushViewController(detailVC, animated: true)

    }
    
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        picker.dismiss(animated: true, completion: nil)
    }
    @available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        //Dismiss the picker VC
        picker.dismiss(animated: true, completion: nil)
        
        emailAddOfContact = ""
        var iCloudEmail  : String = ""
        var homeEmail : String = ""
        var workEmail : String = ""
        var otherEmail  : String = ""
        var customEmail  : String = ""
        
        
        for emailAddress in contact.emailAddresses {
            if emailAddress.label == CNLabelHome && homeEmail.length == 0{
                if((emailAddress.value as String).length > 0){
                   homeEmail = (emailAddress.value as String)
                 //   break
                }
            }
            else if emailAddress.label == CNLabelWork && workEmail.length == 0 {
                if((emailAddress.value as String).length > 0){
                    workEmail = (emailAddress.value as String)
                //    break
                }
            }
            else if emailAddress.label == CNLabelEmailiCloud && iCloudEmail.length == 0 {
                if((emailAddress.value as String).length > 0){
                    iCloudEmail = (emailAddress.value as String)
                 //   break
                }
            }
            else if emailAddress.label == CNLabelOther && otherEmail.length == 0 {
                if((emailAddress.value as String).length > 0){
                    otherEmail = (emailAddress.value as String)
                 //   break
                }
            }
            else if(customEmail.length == 0){
                if((emailAddress.value as String).length > 0){
                    customEmail = (emailAddress.value as String)
                    //   break
                }
            }
        }
        
        if(homeEmail.length > 0){
            emailAddOfContact = homeEmail
        }
        else if(workEmail.length > 0){
            emailAddOfContact = workEmail
        }
        else if(iCloudEmail.length > 0){
            emailAddOfContact = iCloudEmail
        }
        else if(otherEmail.length > 0){
            emailAddOfContact = otherEmail
        }
        else if(customEmail.length > 0){
            emailAddOfContact = customEmail
        }
        
        
        if contact.givenName == "" {
            nameOfContact = ""
        }else{
            nameOfContact = contact.givenName
        }
        
        //If Not check for a last name
        if contact.familyName == "" {
            //If no last name set name to Unknown Name
            lastNameOfContact = ""
        }else{
            lastNameOfContact = contact.familyName
        }
        
        
        phoneNoOfContact = ""
        
        //Make sure we have at least one mobile number
        if contact.phoneNumbers.count > 0 {
            //If so get the CNPhoneNumber object from the first item in the array of mobile numbers
            
            var mobilePhone  : String = ""
            var homePhone  : String = ""
            var workPhone  : String = ""
            var otherPhone  : String = ""
            
            for number in contact.phoneNumbers {
                
                let numbervalue: CNPhoneNumber? = number.value
                
                if let actualNumber = numbervalue {
                    
                    var phoneNumberLabel = number.label
                    //Strip out the stuff you don't need
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "_", with: "", options: NSString.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "$", with: "", options: NSString.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "!", with: "", options: NSString.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: "<", with: "", options: NSString.CompareOptions.literal, range: nil)
                    phoneNumberLabel = phoneNumberLabel?.replacingOccurrences(of: ">", with: "", options: NSString.CompareOptions.literal, range: nil)
                    
                    if phoneNumberLabel == "Mobile" && mobilePhone.length == 0 {
                        mobilePhone = actualNumber.stringValue
                    }
                    else if phoneNumberLabel == "Home" && homePhone.length == 0 {
                        homePhone = actualNumber.stringValue
                    }
                    else if phoneNumberLabel == "Work" &&  workPhone.length == 0 {
                        workPhone = actualNumber.stringValue
                    }
                    else if( otherPhone.length == 0){
                        otherPhone = actualNumber.stringValue
                    }

                }
                
            }
            
            if(mobilePhone.length > 0){
                phoneNoOfContact = mobilePhone
            }
            else if(homePhone.length > 0){
                phoneNoOfContact = homePhone
            }
            else if(workPhone.length > 0){
                phoneNoOfContact = workPhone
            }
            else if(otherPhone.length > 0){
                phoneNoOfContact = otherPhone
            }
        }
        
        let obj:NSDictionary = ["firstName":self.nameOfContact,"lastName" : self.lastNameOfContact, "phone":self.phoneNoOfContact,"email" : emailAddOfContact]
        
        let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Add_UpdateVC") as! AddContactViewController
        detailVC.updatedDict = obj
        self.navigationController?.pushViewController(detailVC, animated: true)

        
    }

    
    

}
