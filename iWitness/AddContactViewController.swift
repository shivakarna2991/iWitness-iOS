//
//  AddContactViewController.swift
//  iWitness
//
//  Created by Sravani on 14/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AFNetworking


class AddContactViewController: BaseViewController,UIAlertViewDelegate {
    
    @IBOutlet var nameTxtFiled :UITextField!
    @IBOutlet var lastNameTxtField :UITextField!
    @IBOutlet var phoneNoTxtFiled :UITextField!
    @IBOutlet var emailTxtFiled:UITextField!
    @IBOutlet var relationshipTxtFiled :UITextField!
    
    var isScreenFromSignup = false
    var isContactForUpdate = false
    
    var updatedDict:NSDictionary?
    
    
    @IBOutlet var topConstraint:NSLayoutConstraint!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _visualize()
        self.addPadding()
        if(updatedDict != nil)
        {
            nameTxtFiled.text = updatedDict!["firstName"] as? String
            lastNameTxtField.text = updatedDict!["lastName"] as? String
            phoneNoTxtFiled.text = (updatedDict!["phone"] as? String)!.digitsOnly()
            emailTxtFiled.text = updatedDict!["email"] as? String
            relationshipTxtFiled.text = updatedDict!["relationType"] as? String
            
        }
        
    
        // Do any additional setup after loading the view.
    }
    
    func addPadding() {
        
        let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: nameTxtFiled.frame.size.height))
        
        nameTxtFiled.leftView = paddingView
        nameTxtFiled.leftViewMode = UITextFieldViewMode.always
        
        
        let paddingView1 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: nameTxtFiled.frame.size.height))
        
        
        lastNameTxtField.leftView = paddingView1
        lastNameTxtField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: nameTxtFiled.frame.size.height))
        
        phoneNoTxtFiled.leftView = paddingView2
        phoneNoTxtFiled.leftViewMode = UITextFieldViewMode.always
        
        let paddingView3 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: nameTxtFiled.frame.size.height))
        
        emailTxtFiled.leftView = paddingView3
        emailTxtFiled.leftViewMode = UITextFieldViewMode.always
        
        let paddingView4 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: nameTxtFiled.frame.size.height))
        
        relationshipTxtFiled.leftView = paddingView4
        relationshipTxtFiled.leftViewMode = UITextFieldViewMode.always
        
    }
    
    func _visualize()
    {
        
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(AddContactViewController.backBtnTapped))
        
        if(isContactForUpdate == true)
        {
            
            self.title = ""
            let rightBtn : UIBarButtonItem = UIBarButtonItem(title:"Delete", style:UIBarButtonItemStyle.plain, target: self, action:#selector(AddContactViewController.DeleteBtnTapped))
            self.navigationItem.rightBarButtonItem = rightBtn
            self.navigationItem.leftBarButtonItem = leftBtn

            
        }
        else
        {
            self.title = "Add Contact"
            
            if(isScreenFromSignup == true){
                let rightBtn : UIBarButtonItem = UIBarButtonItem(title:"Skip", style:UIBarButtonItemStyle.plain, target: self, action:#selector(AddContactViewController.skipBtnTapped))
                self.navigationItem.rightBarButtonItem = rightBtn
                self.navigationItem.setHidesBackButton(true, animated: false)

            
                
            }
            else{
                self.navigationItem.leftBarButtonItem = leftBtn

            }
        }
    }
    
    
    
    func skipBtnTapped() //while new registartion
    {
        showNotificationCliamScreen()
        
    }
    
    func backBtnTapped()
    {
      _ =  self.navigationController?.popViewController(animated: true)
    }
    
    func DeleteBtnTapped()
    {
            let alertView = UIAlertView(title:kText_AppName , message:"Are you sure you want to delete this contact from Emergency Contacts list?", delegate: self, cancelButtonTitle: nil, otherButtonTitles:"Yes","No")
            alertView.show()
        
    }
    
    
   func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        
        if(buttonIndex == 0)
        {
            kNetworkManager.executeDeleteRequest(String(format: kService_DeleteOrUpdateContact,updatedDict!["id"] as! String), parameters: nil, requestVC: self)
        }
    }

    
    @IBAction func saveContact()
    {
        
       
        let nameText = nameTxtFiled.text!.trim()
        let lastnameText = lastNameTxtField.text!.trim()
        
        if(nameText.length <= 0 && lastnameText.length <= 0 && phoneNoTxtFiled.text!.length <= 0)
        {
            self.showAlert(kText_AppName, message: "Please enter required fields.")
            return
        }
        
        if(nameText.length <= 0)
        {
            self.showAlert(kText_AppName, message: "Please enter first name.")
            return
        }
        
        if(lastnameText.length <= 0)
        {
            self.showAlert(kText_AppName, message: "Please enter last name.")
            return
        }
        
        
        if(phoneNoTxtFiled.text!.length <= 0)
        {
            self.showAlert(kText_AppName, message:"Please enter mobile number.")
            return
        }
        else if(!(phoneNoTxtFiled.text!.isPhoneNumber))
        {
            self.showAlert(kText_AppName, message: kText_InvalidUSPhone)
            return
        }
        
//        if(emailTxtFiled.text!.length <= 0)
//        {
//            self.showAlert(kText_AppName, message: kText_RequireEmailAddress)
//            return
//        } else
        
            
        if(emailTxtFiled.text!.length > 0 && (!(emailTxtFiled.text!.isValidEmail)))
        {
            self.showAlert(kText_AppName, message: kText_InvalidEmailAddress)
            return
        }
        
//        if(relationshipTxtFiled.text!.length <= 0)
//        {
//            self.showAlert(kText_AppName, message: kText_RequireRelation)
//            return
//        }
        

        let paramDict:NSDictionary  = ["userId":kUserPreferences.currentProfileId()!,"email":emailTxtFiled.text!,"firstName":nameTxtFiled.text!,"lastName":lastNameTxtField.text!,"phone":phoneNoTxtFiled.text!.digitsOnly(),"phoneAlt":"","relationType":relationshipTxtFiled.text!]

        
//        let paramDict:NSDictionary  = ["userId":kUserPreferences.currentProfileId()!,"email":"sravani.gandu@ptgindia.com","firstName":nameTxtFiled.text!,"lastName":lastNameTxtField.text!,"phone":"+918790361549","phoneAlt":"","relationType":relationshipTxtFiled.text!]

        if(isContactForUpdate == true){
           
            kNetworkManager.executePatchRequest(String(format: kService_DeleteOrUpdateContact,updatedDict!["id"] as! String) , parameters: paramDict, requestVC: self)
        }
        
        else
        {
        kNetworkManager.executePostRequest(String(format:kService_Contact,kUserPreferences.currentProfileId()!) , parameters: paramDict, requestVC: self)
       }
    }
    
    
    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        
        if(isScreenFromSignup == true)
        {
            showNotificationCliamScreen()
            return
  
        }
        
       _ =  self.navigationController?.popViewController(animated: true)
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadContacts"), object: nil)

    }
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        if(requesteUrl == String(format:kService_Contact,kUserPreferences.currentProfileId()!)) //for add contact
        {
            self.showAlert(kText_Warning, message:kText_CouldNotCreateEmergencyContact)
            return
        }
        
        self.showAlert(kText_Warning, message:kText_CouldNotDelete_updateEmergencyContact) //for delete or update
    }

    
    func showNotificationCliamScreen()
    {
        self.performSegue(withIdentifier: "FromSignUpToNotification", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let detailVCObj = segue.destination as! NotificationDetailViewController
        detailVCObj.isScreenFromRegistration = true
    }
    
    
    
    //MARK: Text Filed Delegates-------------------------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
        
        if( (textField == nameTxtFiled) || (textField == lastNameTxtField) || (textField == phoneNoTxtFiled)){
            return;
        }
        
        if(isiPhone4()){
            UIView.animate(withDuration: 0.3, animations: {
                self.topConstraint.constant = -45.0
                self.view.layoutIfNeeded()
            }) 
        }
        else if(isiPhone5()){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.topConstraint.constant = -5.0
                self.view.layoutIfNeeded()
            }) 

        }
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if(textField != emailTxtFiled)
        {
            return newString.length <= 20
            
        }
        return true
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if(textField == nameTxtFiled)
        {
            lastNameTxtField.becomeFirstResponder()
            
        }else if(textField == lastNameTxtField)
        {
            phoneNoTxtFiled.becomeFirstResponder()
        }
        else if(textField == phoneNoTxtFiled)
        {
            emailTxtFiled.becomeFirstResponder()
        }
        else if(textField == emailTxtFiled)
        {
            relationshipTxtFiled.becomeFirstResponder()
        }
            
        else if(textField == relationshipTxtFiled)
        {
            resetView()
            saveContact()
        }
        
        return true
        
    }
    
    
    func resetView()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
            self.topConstraint.constant = 70.0
            self.view.layoutIfNeeded()
        }) 
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        resetView()
        super.touchesBegan(touches, with: event)
    }
    

    
    
}
