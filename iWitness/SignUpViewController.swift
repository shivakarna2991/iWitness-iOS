//
//  SignUpViewController.swift
//  iWitness
//
//  Created by Sravani on 03/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
//import AFNetworking

class SignUpViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var textFiledsBgview :UIView!
    @IBOutlet var signupBtn :UIButton!
    @IBOutlet var centerYConstraint : NSLayoutConstraint!
    @IBOutlet var firstNameTxtFiled :UITextField!
    @IBOutlet var lastNameTxtFiled :UITextField!
    @IBOutlet var emailTxtFiled :UITextField!
    @IBOutlet var phoneNoTxtFiled :UITextField!
    @IBOutlet var passwordTxtFiled :UITextField!
    @IBOutlet var confirmTxtFiled :UITextField!
    var UserId : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.isLoginScreen =  true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kAppDelegate.isLoginScreen =  false
    }
    
    

//MARK: Event Handlers=============
    
    @IBAction func signUpBtnPressed()
    {
        

        let firstName = firstNameTxtFiled.text?.trim()
        let lastName = lastNameTxtFiled.text?.trim()
        let email = emailTxtFiled.text?.trim()
        let phoneNo = phoneNoTxtFiled.text?.trim()
        let password = passwordTxtFiled.text?.trim()
        let confirmPwd = confirmTxtFiled.text?.trim()
        
        if(firstName!.length <= 0 && lastName!.length <= 0 && email!.length <= 0 && phoneNo!.length <= 0 && password!.length <= 0 && confirmPwd!.length <= 0 )
        {
            self.showAlert(kText_AppName, message: "Please enter required fields.")
            return
        }

       
        if(firstName!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireFirstname)
            return
        }
            
        if(lastName!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireLastname)
            return
        }
            
        if(email!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireEmailAddress)
            return
        } else if(!(email!.isValidEmail))
        {
            self.showAlert(kText_AppName, message: kText_InvalidEmailAddress)
            return
        }
            
        if(phoneNo!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequirePhone)
            return
        }
        else if(!(phoneNo!.isPhoneNumber))
        {
            self.showAlert(kText_AppName, message: kText_InvalidUSPhone)
            return
        }
            
        if(password!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequirePassword)
            return
        }
        else if(!(password!.isPassword))
        {
            self.showAlert(kText_AppName, message: kText_InvalidPassword)
            return
        }
        
        if(confirmPwd!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireConfirmPassword)
            return
        }
        else if(!(password == confirmPwd))
        {
            self.showAlert(kText_AppName, message: kText_InvalidConfirmPassword)
            return
        }

        self.registerProfile()
    }
    
    
    
    func registerProfile()
    {
        
        self.view.endEditing(true)
        
        let paramDict:NSDictionary  = ["subscriptionUuid":UserId,"phone":phoneNoTxtFiled.text!.digitsOnly() ,"firstName":firstNameTxtFiled.text!,"lastName":lastNameTxtFiled.text!,"email":emailTxtFiled.text!,"password":passwordTxtFiled.text!]

        kNetworkManager.executePostRequest(kService_Register, parameters: paramDict, requestVC: self)
  
    }
    
    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        
        
        if(requesteUrl == kService_Authorization){
            
            let responseDict = responseObject as! NSDictionary
            
            // 1. Update authorization code
            kUserPreferences.setTokenType(responseDict.value(forKey: "token_type") as? String)
            kUserPreferences.setAccessToken(responseDict.value(forKey: "access_token") as? String)
            kUserPreferences.setRefreshToken(responseDict.value(forKey: "refresh_token") as? String)
            
            // 2. Calculate expire time
            let currentDate = Date()
            let str = responseDict["expires_in"] as! NSNumber
            let expiredate = currentDate.addingTimeInterval(Double(str))
            kUserPreferences.setExpiredTime(expiredate)
            
            // 3. Save
            kUserPreferences.save()
            
            
            navigateToEmergencyContactScreen()
            
        }
            
        else{ //registartion


            
            
            //            // Save user's profile
            kUserPreferences.setProfileData(responseObject as? NSDictionary)
            kUserPreferences.setCurrentUsername((responseObject as? NSDictionary)!.object(forKey: "phone") as? String)
            kUserPreferences.setCurrentProfileId((responseObject as? NSDictionary)!.object(forKey: "id") as? String)
            kUserPreferences.save()
            
            kUserPreferences.setFirstRegistered(false)
            kUserPreferences.save()
            
           let paramDict:NSDictionary  = ["grant_type":"password","username":phoneNoTxtFiled.text!,"password":passwordTxtFiled.text!,"client_id":kUserPreferences.clientId(),"client_secret":kUserPreferences.clientSecret()]
         
           kNetworkManager.executePostRequest(kService_Authorization, parameters: paramDict, requestVC: self)
            
        }
    }
    
    
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        self.showAlert(kText_Warning, message:kText_CouldNotConnectToServer)
        
    }

    
    func navigateToEmergencyContactScreen()
    {
       // self.performSegueWithIdentifier("FromSignUpToAddContact", sender: self)
        
        let emergencyContactListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ContactsVCId") as! EmergenctListViewController
        emergencyContactListVC.isScreenFromSignup = true
        self.navigationController?.pushViewController(emergencyContactListVC, animated: true)
   
    }
    

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let detailVCObj = segue.destination as! AddContactViewController
    detailVCObj.isScreenFromSignup = true
}



//MARK: Class's private methods
    
    func _visualize()
    {
        
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(SignUpViewController.backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn

        textFiledsBgview.layer.cornerRadius = 3.0;
        signupBtn.layer.cornerRadius = 3.0;
    }
    
    
    func backBtnTapped()
    {
       _ =  self.navigationController?.popViewController(animated: true)
    }

    
//MARK: Text Filed Delegates-------------------------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
        
        if( (textField == firstNameTxtFiled) || (textField == lastNameTxtFiled) || (textField == emailTxtFiled)){
            return;
        }
        
        if(isiPhone4() || isiPhone5()){
            
            UIView.animate(withDuration: 0.3, animations: {
                self.centerYConstraint.constant = -110.0
                self.view.layoutIfNeeded()
            }) 
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
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
        
        if(textField == firstNameTxtFiled)
        {
            lastNameTxtFiled.becomeFirstResponder()
        }
        else if(textField == lastNameTxtFiled)
        {
            emailTxtFiled.becomeFirstResponder()
        }
        else if(textField == emailTxtFiled)
        {
            phoneNoTxtFiled.becomeFirstResponder()
        
        } else if(textField == phoneNoTxtFiled)
        {
            passwordTxtFiled.becomeFirstResponder()
       
        } else if(textField == passwordTxtFiled)
        {
            confirmTxtFiled.becomeFirstResponder()
        }
        
        else if(textField == confirmTxtFiled)
        {
            resetView()
            signUpBtnPressed()
        }
        
        return true
    }
    
    func resetView()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
            self.centerYConstraint.constant = 17.0
            self.view.layoutIfNeeded()
        }) 
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        resetView()
        super.touchesBegan(touches, with: event)
    }
    
}
