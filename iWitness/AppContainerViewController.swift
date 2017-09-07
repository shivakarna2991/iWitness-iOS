//
//  AppContainerViewController.swift
//  iWitness
//
//  Created by Sravani on 18/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AFNetworking

class AppContainerViewController: UIViewController,UIAlertViewDelegate {
    
    var loginNavController :UINavigationController?
    var homeNavController :UINavigationController?
    var renewSubscriptionNavController:UINavigationController?
    
    var slidemenuVC:MenuListViewController?
    var mainStoryboard:UIStoryboard!
    var statusBarBackgroundView :UIView!
    var isExpanded = false
    var selectedRow:Int = 0
    // 0, 5, 3, 4, 2, ..., 6, 1
    let viewConreollerSegueArray = ["HomeVCId","PreferenceVCId","ContactsVCId","VideosVCId","NotificationsVCId","HomeVCId","ShareVCId","ProfileVCId"]
//    let viewConreollerSegueArray = ["HomeVCId","ProfileVCId","NotificationsVCId","ContactsVCId","VideosVCId","PreferenceVCId","ShareVCId"]
    var countryName:String!
    var currentNavigationController:UINavigationController?
    var isEmergencyNoAlertShowing:Bool = false
    
    var loaderView:UIView?
    var alertView:UIAlertView?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        customAppearence() //through out application
        mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppContainerViewController._handleLocationChangedNotification(_:)), name:NSNotification.Name(rawValue: kNotification_LocationUpdated) , object: nil)

        if (kUserPreferences.accessToken() != nil){
            addHomeNavigationToContainer()
        }
        else
        {
            addLoginNavigationToContainer()
        }
        
    }
    
    func customAppearence()
    {
        statusBarBackgroundView = UIView()
        statusBarBackgroundView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 20);
        statusBarBackgroundView.backgroundColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addLoginNavigationToContainer()
    {
        loginNavController = mainStoryboard.instantiateViewController(withIdentifier: "LoginNavigationId") as? UINavigationController
        view.addSubview((loginNavController?.view)!)
        addChildViewController(loginNavController!)
        view .addSubview(statusBarBackgroundView)
        
        currentNavigationController = loginNavController
        
        loginNavController?.didMove(toParentViewController: self)
        
    }
    
    func addHomeNavigationToContainer()
    {
       homeNavController = mainStoryboard.instantiateViewController(withIdentifier: "HomeNavigationId") as? UINavigationController
        let homeVc = mainStoryboard.instantiateViewController(withIdentifier: "HomeVCId")
        homeNavController?.viewControllers = [homeVc]
       view.addSubview((homeNavController?.view)!)
       addChildViewController(homeNavController!)
       view.addSubview(statusBarBackgroundView)
       homeNavController?.didMove(toParentViewController: self)
        
        currentNavigationController = homeNavController
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_EmergencyNumberChanged), object: nil)

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AppContainerViewController.handleTapGesture(_:)))
        homeNavController!.view.addGestureRecognizer(tapGestureRecognizer)

    }
    
    func removeCurrentNavControllerFromScene()
    {
        self.currentNavigationController?.removeFromParentViewController()
        self.currentNavigationController?.view.removeFromSuperview()
        self.currentNavigationController?.willMove(toParentViewController: nil)
        self.currentNavigationController = nil
    }
    
    func showHomePage()
    {
//        self.loginNavController?.removeFromParentViewController()
//        self.loginNavController?.view.removeFromSuperview()
//        self.loginNavController?.willMoveToParentViewController(nil)
//        self.loginNavController = nil
        
        removeCurrentNavControllerFromScene()
        addHomeNavigationToContainer()
    }
    
    func showLoginScreen()
    {
//        self.homeNavController?.removeFromParentViewController()
//        self.homeNavController?.view.removeFromSuperview()
//        self.homeNavController?.willMoveToParentViewController(nil)
//        self.homeNavController = nil
        removeCurrentNavControllerFromScene()
        addLoginNavigationToContainer()
    }
    
    
    func showRenewSubScriptionScene()
    {

        let renewSubscription =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SubScriptionVCId") as! SubscriptionViewController
        currentNavigationController!.pushViewController(renewSubscription, animated: true)

  
    }
    
    
    func menuBtnTapped()
    {
        addLeftPanelViewController()
        
        if isExpanded == false
        {
            animateCenterPanelXPosition(targetPosition: homeNavController!.view.frame.width - 125)
            isExpanded = true
            
        }
        else
        {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.isExpanded = false
                self.slidemenuVC?.view.removeFromSuperview()
                self.slidemenuVC = nil;
            }
        }
    }
    
    func animateCenterPanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)! = nil) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIViewAnimationOptions(), animations: {
            self.homeNavController!.view.frame.origin.x = targetPosition
            }, completion: completion)
    }
    
    
    func addLeftPanelViewController() {
        if (slidemenuVC == nil) {
            slidemenuVC = mainStoryboard.instantiateViewController(withIdentifier: "MenuVCId") as? MenuListViewController
            self.view.insertSubview((slidemenuVC?.view)!, at: 0)
            self.addChildViewController(slidemenuVC!)
            slidemenuVC!.selectedRowIndex = selectedRow
            slidemenuVC!.didMove(toParentViewController: self)
        }
    }
    

    
    func menuDidSelectedRow(_ newSelectedrow:Int)
    {
        menuBtnTapped()
        
//        if(newSelectedrow == 0 && selectedRow == 0)
//        {
//            NSNotificationCenter.defaultCenter().postNotificationName("showOnlyCameraScreen", object: nil)
//            return
//        }
//        
//        if(newSelectedrow != 0 && selectedRow == 0)
//        {
//            kAppDelegate.isTerminateRecord = true
//        }
        
        
        
//
        
       
        
        if(selectedRow == 0)
        {
            kUserPreferences.setEventId(nil)
            kUserPreferences.save()
            kAppDelegate.isTerminateRecord = false
        }
        
        kAppDelegate.canSendSafeNotification = false
        selectedRow = newSelectedrow
//        if(newSelectedrow == 7)
//        {
//            selectedRow = 0
//            kAppDelegate.isLoginScreen = true //when we click logout to stop session expired alert
//            kUserPreferences.reset()
//                self.showLoginScreen()
//                return
//
//            LogoutFromApp()
//            return
//
//        }
        
        let homeVc = mainStoryboard.instantiateViewController(withIdentifier: viewConreollerSegueArray[selectedRow])
        homeNavController?.viewControllers.removeAll()
        homeNavController?.viewControllers = [homeVc]
        
     }
    
    
    
    func animateLeftPanel(shouldExpand: Bool) {
        if (shouldExpand) {
            self.isExpanded = true
            animateCenterPanelXPosition(targetPosition: homeNavController!.view.frame.width - 125)
        } else {
            animateCenterPanelXPosition(targetPosition: 0) { finished in
                self.isExpanded = false
                self.slidemenuVC?.view.removeFromSuperview()
                self.slidemenuVC = nil;
            }
        }
    }
    
    
    func showloader1()
    {
        if(loaderView == nil)
        {
            loaderView = UIView(frame:UIScreen.main.applicationFrame)
            loaderView?.backgroundColor = UIColor.black
            loaderView?.alpha = 0.5
            loaderView?.tag = 11111112
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
    
    
    func removeloader1()
    {
        for tempview in self.view.subviews
        {
            if(tempview.tag == 11111112){
                tempview.removeFromSuperview()
            }
            loaderView?.removeFromSuperview()
            loaderView = nil
        }
    }

    
    func LogoutFromApp()

        {
            
            showloader1()
            
            let manager = AFHTTPSessionManager(baseURL:URL(string:kHostname)!, sessionConfiguration: URLSessionConfiguration.default)
            manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
            manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(), kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
            manager.requestSerializer.timeoutInterval = 60.0
            manager.get(
                String(format: kServiceLogout,kUserPreferences.currentProfileId()!),
                parameters: nil,
                success: { (task, responseObject) in
                    
                    self.removeloader1()
                    
                    let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                    if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                        
                        self.removeloader1()
                        
                        DispatchQueue.main.async(execute: {
                            
                            self.selectedRow = 0
                            kAppDelegate.isLoginScreen = true //when we click logout to stop session expired alert
                            kUserPreferences.reset()
                            self.showLoginScreen()
                            return
                            
                        })
                        
                    } 
            },
                failure: { (task, error) in
                    DispatchQueue.main.async(execute: {
                        
                        self.removeloader1()
                        let alertView = UIAlertView(title: kText_AppName, message:"Failed to Logout", delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                        
                    }
                    )
            }
            )
        
     }

//Mark:Location Notification Handlers======================================================
    
    func _handleLocationChangedNotification(_ notificaton:Notification)
    {
        
        /* Condition validation: If user is not logged in, ignore this notification. */
//        if(kUserPreferences.currentProfileId() == nil)
//        {
//            return
//        }
        if (kLocation.currentLocation == nil)
        {
            return
        }
        
        let location = kLocation.currentLocation.coordinate
        if (location.latitude == 0.0 && location.longitude == 0.0)
        {
            return
        }
        
        let manager = AFHTTPSessionManager(baseURL:URL(string:"https://maps.googleapis.com")!, sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        manager.get(
            String(format: kURL_GoogleMapAPI,location.latitude,location.longitude),
            parameters: nil,
            success: { (task: URLSessionDataTask!, responseObject: Any!) in
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    DispatchQueue.main.async(execute: {
                      
                        let resultDict = responseObject as! [String:AnyObject]
                        if( resultDict["status"] as! String == "OK")
                        {
                        //    let res1 = resultDict["results"] as! [AnyObject]
                         //   let res2 = (res1[0] as! [String:AnyObject])["address_components"]
                            
                            let tempArray = ((resultDict["results"] as! [AnyObject])[0] as! [String:AnyObject])["address_components"] as! [[String:AnyObject]]
                            
                            for (_, recipient) in tempArray.enumerated() {
                                
                                let name  =  (recipient["types"] as! [AnyObject])[0] as! String
                                
                                if (name == "country") {
                                    
                                    self.countryName = (recipient as NSDictionary).value(forKey: "long_name") as! String
                                    if(kUserPreferences.currentProfileId() != nil && kUserPreferences.accessToken() != nil){
                                    
                                            var currentPhoneNo = _g_EmergencyPhone[kUserPreferences.emergencyPhone()!] as! String
                                            
                                             var newPhoneNo = ""

                                        if let val = _g_EmergencyPhone[self.countryName]
                                        {
                                            newPhoneNo =  val as! String
                                            
                                        }else if(self.countryName == "United States of America")
                                        {
                                            self.countryName = "United States"
                                            newPhoneNo = "911"
                                        }
                                        else if let data = _g_EmergencyPhone[(self.countryName+" Option 1")]
                                        {
                                            newPhoneNo = data as! String
                                            self.countryName = (self.countryName+" Option 1")
                                        }

                                              newPhoneNo =  (newPhoneNo.length > 0) ? newPhoneNo : "911"
                                              currentPhoneNo =  (currentPhoneNo.length > 0) ? currentPhoneNo : "911"
                                      
                                            if(newPhoneNo != currentPhoneNo)
                                            {

                                                if(self.isEmergencyNoAlertShowing == false){
                                                   
                                                    self.isEmergencyNoAlertShowing = true

                                                    let alertView = UIAlertView(title:kText_Warning , message:String(format:kText_EmergencyPhoneChanged ,currentPhoneNo,newPhoneNo), delegate: self, cancelButtonTitle: nil, otherButtonTitles:"Yes","No")
                                                   alertView.tag = 1000
                                                    alertView.show()
                                                }
                                                
                                            }
                                        
                                        else // once login and 
                                        {
                                            kUserPreferences.setEmergencyPhone(self.countryName)
                                            kUserPreferences.setCountryName(self.countryName)
                                            kUserPreferences.save()
                                         }
                                       }
                                    else //if not login we can not store into emergency phone value,as we have dependency with profileid until login store in country
                                    {
                                        kUserPreferences.setCountryName(self.countryName)
                                        kUserPreferences.save()
  
                                    }
                                    
                                    break
                                }
                                
                            }
                            
                        }
                        
                        
                    })
                }
            },
            failure: { (task, error) in
            }
        )
    }
    
//Mark:Renew SubscriptionAlert
    
    func showExpiredSubscriptionAlert()
    {
            let alertView = UIAlertView(title:kText_Info , message:kText_RenewSubscription , delegate: self, cancelButtonTitle:nil, otherButtonTitles:"Yes","No")
            alertView.tag = 401
            alertView.show()
  
    }
    
//MARK: AlertView Delegates
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
        
        if(alertView.tag == 401 && buttonIndex == 0)
        {
            kAppDelegate.isSubscriptionRenew = true
            showRenewSubScriptionScene()
            return
        }
        
        if(alertView.tag == 1000)
        {
            isEmergencyNoAlertShowing = false
            
            if(buttonIndex == 0){
            kUserPreferences.setEmergencyPhone(self.countryName)
            kUserPreferences.setCountryName(self.countryName)
            kUserPreferences.save()

            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_EmergencyNumberChanged), object: nil)

           }
           self.countryName = nil;
        }
     }
    
   }




extension AppContainerViewController: UIGestureRecognizerDelegate {
    // MARK: Gesture recognizer
    
    func handleTapGesture(_ recognizer: UITapGestureRecognizer) {
        if (isExpanded) {
            animateLeftPanel(shouldExpand: false)
        }
    }
    
    func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
        
        if(!isExpanded && !gestureIsDraggingFromLeftToRight){
            return
        }
        
        switch(recognizer.state) {
        case .began:
            if (isExpanded == false) {
                if (gestureIsDraggingFromLeftToRight) {
                    addLeftPanelViewController()
                } else {
                    
                }
            }
        case .changed:
            recognizer.view!.center.x = recognizer.view!.center.x + recognizer.translation(in: view).x
            recognizer.setTranslation(CGPoint.zero, in: view)
            
        case .ended:
            if (slidemenuVC != nil) {
                // animate the side panel open or closed based on whether the view has moved more or less than halfway
                let hasMovedGreaterThanHalfway = recognizer.view!.center.x > view.bounds.size.width
                animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
            }
        default:
            break
        }
    }
}


