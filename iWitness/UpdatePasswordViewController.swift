//
//  UpdatePasswordViewController.swift
//  iWitness
//
//  Created by Sravani on 28/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
//import AFNetworking

class UpdatePasswordViewController: BaseViewController,UITextFieldDelegate {
    @IBOutlet var _txtCurrent :UITextField!
    @IBOutlet var _txtPassword :UITextField!
    @IBOutlet var _txtConfirm :UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()

        // Do any additional setup after loading the view.
    }
    
    func _visualize()
    {
        self.title = "Update Password"
        let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action:#selector(UpdatePasswordViewController.keyPressed))
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(UpdatePasswordViewController.backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = rightBtn
        
    }
    
    func backBtnTapped()
    {
       _ = self.navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func keyPressed()
    {
        self.view.endEditing(true)
        
        
        let oldPwd = _txtCurrent.text?.trim()
        let password = _txtPassword.text?.trim()
        let confirmPwd = _txtConfirm.text?.trim()

        
        if(oldPwd!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireCurrentPassword)
            return
        }
        else if(!(oldPwd!.isPassword))
        {
            self.showAlert(kText_AppName, message: kText_InvalidCurrentPassword)
            return
        }
        

         if(password!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireNewPassword)
            return
        }
        else if(!(password!.isPassword))
        {
            self.showAlert(kText_AppName, message: kText_InvalidNewPassword)
            return
        }
        
        
        if((password! == oldPwd!))
        {
            self.showAlert(kText_AppName, message: kText_InvalidNew_OldPassword)
            return
        }

        
        if(confirmPwd!.length <= 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireNewConfirmPassword)
            return
        }
        else if(!(password == confirmPwd))
        {
            self.showAlert(kText_AppName, message: kText_InvalidNewConfirmPassword)
            return
        }
        
        
       
        let paramDict:NSDictionary  = ["password":oldPwd!,"newPassword":password!]

        kNetworkManager.executePatchRequest(String(format: kService_User,kUserPreferences.currentProfileId()!), parameters: paramDict, requestVC: self)


    }
    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        self.showAlert(kText_Warning, message:kText_CouldNotUpdatePassword)
        
    }
    
//    override func requestErrorCode(responseObject:AnyObject!,requesteUrl:String, statusCode:Int)
//    {
//        self.showAlert(kText_Warning, message:kText_CouldNotUpdatePassword)
//        
//    }


    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        return newString.length <= 20
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        if(textField == _txtCurrent)
        {
            _txtPassword.becomeFirstResponder()
        }
        else if(textField == _txtPassword)
        {
            _txtConfirm.becomeFirstResponder()
        }
        else if(textField == _txtConfirm)
        {
            keyPressed()
        }
        
        return true
    }

}
