//
//  ForgotPasswordViewController.swift
//  iWitness
//
//  Created by Sravani on 18/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AFNetworking

class ForgotPasswordViewController: BaseViewController,UITextFieldDelegate {
    
    @IBOutlet var sendBtn:UIBarButtonItem!
    @IBOutlet var emailTxtField:UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTxtField.enablesReturnKeyAutomatically = false
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.isLoginScreen =  true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kAppDelegate.isLoginScreen =  false
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func sendBtnPressed()
    {
      
        if(!( emailTxtField.text!.isValidEmail || emailTxtField.text!.isPhoneNumber)){
       
           self.showAlert("Failed Validation", message: "Please enter a valid email or mobile number.")
           return
         
        }
 
        
       emailTxtField.resignFirstResponder()
       let textTosend = emailTxtField.text!.trim()
        
      //sendBtn.enabled = false
      emailTxtField.text = ""
      kNetworkManager.executeGetRequest(String(format: kService_ResetPassword,textTosend), parameters: nil, requestVC: self)

    }
    
  override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        let alertView = UIAlertView(title: kText_AppName, message: kText_SuccessForgotPassword, delegate: self, cancelButtonTitle:"OK")
        alertView.show()
  
    }
    
   override func requestFailed(_ error:NSError!,requesteUrl:String){
    
    self.showAlert(kText_Warning, message:kText_CouldNotResetPassword)
 
    }
    
//   override func requestErrorCode(responseObject:AnyObject!,requesteUrl:String, statusCode:Int)
//    {
//        self.showAlert(kText_Warning, message:kText_CouldNotResetPassword)
//  
//    }

    
//MARK: Text Filed Delegates-------------------------------------------------------------------
    
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
   {
    
    
//    let newString = (textField.text! as NSString).stringByReplacingCharactersInRange(range, withString: string)
//  
//    if newString.isValidEmail || newString.isPhoneNumber{
//        
//        sendBtn.enabled = true
//    }
//    else
//    {
//        sendBtn.enabled = false
//    }
    
    return true
    
   }
    
    
//MARK: Alertview Delegates-------------------------------------------------------------------
    
     func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
     {
       _ =  self.navigationController?.popViewController(animated: true)
    }

}
