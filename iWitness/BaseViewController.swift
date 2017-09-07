//
//  BaseViewController.swift
//  iWitness
//
//  Created by Sravani on 23/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
//import AFNetworking

class BaseViewController: UIViewController {

    var loaderView:UIView?
    var alertView:UIAlertView?
    var appUserDefaults:UserDefaults!
    //var _call911Item:UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.showCallScreen), name:NSNotification.Name(rawValue: kNotification_CallBtntapped) , object: nil)
        

    }
    
    func showCallScreen()
    {
        
        if(Thread.current.isMainThread == false)
        {
            DispatchQueue.main.async(execute: {
               
                let callScreenVCObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Call911VCId") as! Call911ViewController
                self.present(callScreenVCObj, animated: true, completion: nil)

            })
        }

        else{
            let callScreenVCObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Call911VCId") as! Call911ViewController
            self.present(callScreenVCObj, animated: true, completion: nil)
        }
        
    }


   func getEmergencyPhoneNoAsString() -> String
   {
    
    let phoneNo = _g_EmergencyPhone[kUserPreferences.emergencyPhone()!] as! String
    if(phoneNo.length > 0){
        return phoneNo
    }
    else
    {
        return "911"
    }
  }
    
    
    
//MARK:==============  Device check Methods ===========================================================
    
    func isiPhone4()->Bool
    {
        if (self.view.frame.size.height == 480){
          return true
        }
        return false
    }
    
    func isiPhone5()->Bool
    {
        if (self.view.frame.size.height == 568){
            return true
        }
        return false
    }

//MARK:==============  Loader Methods ===========================================================
    
    
    func showloader()
    {
        if(loaderView == nil)
        {
            loaderView = UIView(frame:UIScreen.main.applicationFrame)
            loaderView?.backgroundColor = UIColor.black
            loaderView?.alpha = 0.5
            loaderView?.tag = 11111111
            self.view.addSubview(loaderView!)
            self.view.bringSubview(toFront: loaderView!)
            
            
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            var center = loaderView!.center;
            center.y = center.y-20
            
            activityIndicator.center = center
            activityIndicator.startAnimating()
            loaderView?.addSubview(activityIndicator)
        }
    }
    
    
    func removeloader()
    {
        for tempview in self.view.subviews
        {
            if(tempview.tag == 11111111){
                tempview.removeFromSuperview()
            }
            loaderView?.removeFromSuperview()
            loaderView = nil
        }
    }
    
//MARK:================ Alertview ===========================================================
    
    
    func showAlert(_ title : String, message :String)
    {
        
        if let aView = alertView
        {
            if(aView.isVisible){
                return
            }
        }
        alertView = UIAlertView(title: title, message: message, delegate: nil, cancelButtonTitle: "OK")
//        let alertMessage : UILabel = alertView?.subviews.obje
        alertView!.show()
        
    }


    
//MARK:================Touch Event Handlers ===========================================================
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        
        if(kAppController!.isExpanded == true)
        {
          kAppController!.menuBtnTapped()
        }
        UIView.animate(withDuration: 0.3, animations: {
           self.view.endEditing(true)
        }) 
        super.touchesBegan(touches, with: event)
    }
    
//MARK:================Network Handlers ===========================================================
    
    
    func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        
    }
    
    func requestFailed(_ error:NSError!,requesteUrl:String){
        
    }

    
    func requestErrorCode(_ responseObject:AnyObject!,requesteUrl:String, statusCode:Int)
    {
     switch(statusCode)
     {
        
     case 400:
        var title = kText_Warning
        var detail = "Unable to process your request."
        
        if let tempDetail = responseObject.value(forKey: "detail") as? String
        {
            title = responseObject.value(forKey: "title") as! String
            detail = tempDetail
        }
        
        if( title == "Already Loggedin")
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_DoLogoutAllDevices), object: responseObject)
 
        }
        else{
            showAlert(title, message: detail)

        }
        

 
     case 401:
       
        let title = kText_Warning
        var detail = "Unable to process your request."

        if let msg = responseObject["title"] as? String
        {
            
            detail = (responseObject.value(forKey: "detail") as? String)!

            if msg == kText_Expired
            {
               kAppController!.showExpiredSubscriptionAlert()
                
            }
            else
            {
                showAlert(msg, message: detail)
            }
        }
        
        else{
            showAlert(title, message: detail)

        }

     case 404:
           var title = kText_Warning
           var detail = "Resource is not available."
           
           if let tempDetail = responseObject.value(forKey: "detail") as? String
           {
             title = responseObject.value(forKey: "title") as! String
             detail = tempDetail
           }
        
           showAlert(title, message: detail)
        
     case 422:
        
        
        var title = responseObject.value(forKey: "title") as! String
        var detail = responseObject.value(forKey: "detail") as! String

        
        if let reponseDict = responseObject.value(forKeyPath: "validation_messages") as? [String:AnyObject]
            {
                title = responseObject.value(forKey: "detail") as! String
                
                   if let str = reponseDict.values.first! as? [String:AnyObject] {
                    
                    for value in Array(str.values) {
                       detail = value as! String
                        break
                    }
                   }
                   else if let str = reponseDict.values.first! as? [AnyObject] {
                      
                        detail = str[0] as! String
                    
                       }
                   else if let str = reponseDict["message"] {
                    
                    detail = str as! String
                   }
                    
                   else {
                        detail = "Please try again."
                    }
                
             }
        
           showAlert(title, message: detail)


     case 408,429,500: showAlert(kText_Warning, message: "Server is busy at the moment.")
        
     case 503: showAlert(kText_Warning, message: "This service is not available at the moment.")
    
     case 507: showAlert(kText_Warning, message: "Uploaded file had been rejected by server.")
        
     default: showAlert(kText_Warning, message: "Could not process your request at the moment.")
        
     }
   
    }
    
   

}
