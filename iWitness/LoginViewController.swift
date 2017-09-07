//
//  LoginViewController.swift
//  iWitness
//
//  Created by Sravani on 18/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit


class LoginViewController: BaseViewController, UITextFieldDelegate,UIAlertViewDelegate {
    
    @IBOutlet var txtField_BGView:UIView!
    @IBOutlet var loginBtn:UIButton!
    @IBOutlet var signUpBtn:UIButton!
    @IBOutlet var forgotPwdBtn:UIButton!
    @IBOutlet var usernameTxtFiled :UITextField!
    @IBOutlet var passwordTxtFiled :UITextField!
    var logoutUserID:String! = ""
    
    @IBOutlet var centerYConstraint : NSLayoutConstraint!
    
    //
    //  Device - dependent constraints
    //
    @IBOutlet weak var subscribe2fbConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottom2subscribeConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var subscribeHeightConstraint: NSLayoutConstraint!
    
    //
    //
    //
    
    override func viewDidLoad() {
        super.viewDidLoad()

        _visualize()
        
        NotificationCenter.default.addObserver(self, selector: #selector(LoginViewController.showLogoutAllDeviceAlert), name:NSNotification.Name(rawValue: kNotification_DoLogoutAllDevices) , object: nil)
        
        if (UIScreen.main.bounds.width == 414) {
            subscribe2fbConstraint.constant = 60
            bottom2subscribeConstraint.constant = 62
            centerYConstraint.constant = -83
            logoWidthConstraint.constant = 216
            subscribeHeightConstraint.constant = 64
            signUpBtn.layer.cornerRadius = 32
        }
        else if (UIScreen.main.bounds.width == 375) {
            subscribe2fbConstraint.constant = 40
            bottom2subscribeConstraint.constant = 40
            centerYConstraint.constant = -73
            logoWidthConstraint.constant = 196
            subscribeHeightConstraint.constant = 54
            signUpBtn.layer.cornerRadius = 27
        }
        else {
            subscribe2fbConstraint.constant = 20
            bottom2subscribeConstraint.constant = 20
            centerYConstraint.constant = -50
            logoWidthConstraint.constant = 167
            subscribeHeightConstraint.constant = 40
            signUpBtn.layer.cornerRadius = 20
        }
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        kAppDelegate.isLoginScreen =  true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        kAppDelegate.isLoginScreen =  false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        usernameTxtFiled.attributedPlaceholder =
            NSAttributedString(string: usernameTxtFiled.placeholder!,
                               attributes: [NSForegroundColorAttributeName: UIColor.black])
        passwordTxtFiled.attributedPlaceholder =
            NSAttributedString(string: passwordTxtFiled.placeholder!,
                               attributes: [NSForegroundColorAttributeName: UIColor.black])
        loginBtn.layer.borderColor = UIColor(red: 0.82, green: 0.01, blue: 0.11, alpha: 1.0).cgColor
        signUpBtn.layer.borderColor = UIColor(red: 0.64, green: 0.0, blue: 0.08, alpha: 1.0).cgColor
        
        //txtField_BGView.layer.cornerRadius = 3.0;
        //loginBtn.layer.cornerRadius = 3.0;
    }
    
    
    //MARK : - View s key pressed event handlers
    
    @IBAction func keyPressed(_ sender:UIButton){
        
        if(sender == loginBtn)
        {
            resetView()
            
            //            var username: String!
            //            var password :String!
            //
            //            if let name = usernameTxtFiled.text{
            //                username = name.trim()
            //            }
            //            if let passwd = passwordTxtFiled.text{
            //                password = passwd.trim()
            //            }
            
            if(usernameTxtFiled.text!.length <= 0)
            {
                self.showAlert(kText_AppName, message: kText_RequirePhone)
                
            }
            else if( passwordTxtFiled.text!.length <= 0)
            {
                self.showAlert(kText_AppName, message: kText_RequirePassword)
            }
            else {
                
                getAccessTokenForLoginUser(usernameTxtFiled.text!, password: passwordTxtFiled.text!)
                
            }
        }
        
    }
    
    
    @IBAction func facebookLogin(_ sender: UIButton) {
        FBSDKLoginManager().logIn(withReadPermissions: ["public_profile"],
                                  from: self) { (result: FBSDKLoginManagerLoginResult?, error: Error?) in
                                    //
        }
    }
    
    
    
//Mark:Request for User authentication (Post request)=====================================
    
    
    func getAccessTokenForLoginUser(_ name:String, password:String)
    {
        
        let paramDict:NSDictionary  = ["grant_type":"password","username":name,"password":password,"client_id":kUserPreferences.clientId(),"client_secret":kUserPreferences.clientSecret()]
        
        kNetworkManager.executePostRequest(kService_Authorization, parameters: paramDict, requestVC: self)
        
    }
    
    
    
    //Mark: To fetch User profile information (get request)
    
    func fetchUserInformation(_ responseDict:NSDictionary,username:String)
        
    {
        kNetworkManager.executeGetRequest(String(format: kService_UserInfo,username), parameters: nil, requestVC: self)
        
    }
    
    
    override func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
       if(requesteUrl == String(format: kServie_LogoutAllDevices,logoutUserID))
       {
            
        }else if(requesteUrl == kService_Authorization){
            
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
            
            
            self.fetchUserInformation(responseDict,username:usernameTxtFiled.text!)
        }
            
        else{
            
            // 1. Update user profile===========================
//            let obj = responseObject as! NSDictionary
//            let dataArray = (obj.value(forKey: "_embedded") as AnyObject).value(forKey: "user") as! NSArray
//            let finalDatDictionary = dataArray.object(at: 0)
            
            let obj = responseObject as! [String:AnyObject]
            let dataArray = (obj["_embedded"] as! [String:AnyObject])["user"] as! [AnyObject]
            let finalDatDictionary = dataArray[0]
            
            // Save user's profile
            kUserPreferences.setProfileData(finalDatDictionary as? NSDictionary)
            kUserPreferences.setCurrentProfileId((finalDatDictionary as AnyObject).value(forKey: "id") as? String)
            kUserPreferences.setCurrentUsername((finalDatDictionary as AnyObject).value(forKey: "phone") as? String)
            kUserPreferences.save()
            
            kUserPreferences.setFirstRegistered(false)
            
            kUserPreferences.save()
            
            kAppController!.showHomePage()//whick makes to show home page
            
        }
        
    }
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        if(requesteUrl == String(format: kServie_LogoutAllDevices,logoutUserID))
        {
            
        }else{
            
            kUserPreferences.reset()
        }
        
        self.showAlert(kText_Warning, message:kText_CouldNotConnectToServer)
    }
    
    
    
    
    func showLogoutAllDeviceAlert(_ notification: NSNotification)
    {
        
        
        if let detailMessgae = (notification.object! as AnyObject).value(forKey: "detail") as? String
        {
            let words = detailMessgae.components(separatedBy: ":")
            logoutUserID = words[1]
            
            let msgtitle =  (notification.object! as AnyObject).value(forKey: "title") as? String
            
            let alertView = UIAlertView(title:msgtitle! , message:words[0] , delegate: self, cancelButtonTitle:nil, otherButtonTitles:"Cancel","Logout")
            alertView.tag = 4001
            alertView.show()
            

        }
        
        
    }
    
    //MARK: AlertView Delegates
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        
        
        if(alertView.tag == 4001 && buttonIndex == 1)
        {

            kNetworkManager.executeGetRequest(String(format: kServie_LogoutAllDevices,logoutUserID), parameters: nil, requestVC: self)

        }
        else if(alertView.tag == 4001 && buttonIndex == 0)
        {
            usernameTxtFiled.text  = ""
            passwordTxtFiled.text =  ""

        }
        else if(buttonIndex == 0)
        {
            //Create Navigation controller For  Subscription and check in Network manager [kAppController presentRenewSubscriptionFlow];
            
        }
    }
    
    //MARK: Text Filed Delegates-------------------------------------------------------------------
    
    func textFieldDidBeginEditing(_ textField: UITextField) {    //delegate method
        
        
        UIView.animate(withDuration: 0.3, animations: {
//            self.centerYConstraint.constant = -110.0
            self.view.layoutIfNeeded()
        }) 
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if(textField == usernameTxtFiled)
        {
            passwordTxtFiled.becomeFirstResponder()
        }
        else
        {
            resetView()
            keyPressed(loginBtn)
        }
        
        return true
    }
    
    func resetView()
    {
        UIView.animate(withDuration: 0.3, animations: {
            self.view.endEditing(true)
//            self.centerYConstraint.constant = -80.0
            self.view.layoutIfNeeded()
        }) 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        resetView()
        super.touchesBegan(touches, with: event)
    }
    
    
}
