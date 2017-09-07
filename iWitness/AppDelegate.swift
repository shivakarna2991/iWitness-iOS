//
//  AppDelegate.swift
//  iWitness
//
//  Created by Sravani on 18/11/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import Fabric
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit

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


//import Tune
//import AdSupport
//import CoreTelephony
//import iAd
//import MobileCoreServices
//import Security
//import StoreKit
//import SystemConfiguration


let kDefault_USLocation  = CLLocationCoordinate2DMake(41.850033, -87.6500523)


let kHostname                 =  "https://api.iwitness.com"
//let kHostname                 =  "http://api.balukiran.com"


let kService_Authorization    = "/oauth"
let kService_UserInfo         = "/user?phone=%@"
let kService_ResetPassword    = "/user/forgot-password/%@"
let kService_Contact          = "/contact?user_id=%@"
let kService_User             = "/user/%@"
let kService_EventPage        = "/event?user_id=%@&page=%li&sort=-created"
let kService_Invitation       = "/invitation"
let kService_Register         = "/user"
let kURL_GoogleMapAPI         =  "/maps/api/geocode/json?latlng=%f,%f&sensor=true"
let kService_Asset            = "/asset"
let kService_Device           = "/device"
let kService_EventCall911     = "/event"
let kService_Emergency        = "/emergency"
let kService_EventDetail      = "/event/%@"
let kService_Event            = "/event?user_id=%@"
let kService_Subscription     = "/subscription"
let kService_SubscriptionInfo = "/subscription?receiptId=%@"
let kService_UploadPhoto      = "/user/%@/upload"
let kService_DeleteOrUpdateContact  =  "/contact/%@"
let kServiceLogout = "/user/logout/%@"
let kServie_LogoutAllDevices = "user/logoutall/%@"

let _OperationQueue : OperationQueue = OperationQueue();

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8 , value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var isAppCallRightBtnCreated = false
    var _call911Item:UIBarButtonItem!
    var appController:AppContainerViewController!
    var isSubscriptionRenew : Bool?
    var contactsArray = [[String:AnyObject]]()

    var _userServices: UserServices?
    var isLoginScreen:Bool = false
    var isTerminateRecord:Bool = false
    
    
    var canSendSafeNotification:Bool = false //which is used for sending safe or danger Notification, it will be true when user started recording video and false olny when manually stopped recording video or else in menu if we tap on any screen


    
    var NotificationsArray:[NSDictionary]!
    var notificationUnreadCount:Int = 0

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
       
//        Tune.setDelegate(self)
//        
//        // call one of the Tune init methods
//        Tune.initializeWithTuneAdvertiserId("13410", tuneConversionKey:"90ac9dd21b2e6311e5b236daace68cca")
//        Tune.setAppleAdvertisingIdentifier(ASIdentifierManager.sharedManager().advertisingIdentifier, advertisingTrackingEnabled:ASIdentifierManager.sharedManager().advertisingTrackingEnabled)
//       
        
        Fabric.with([Crashlytics.self])
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        FBSDKProfile.enableUpdates(onAccessTokenChange: true)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AppDelegate.facebookProfileChanged),
                                               name: .FBSDKProfileDidChange,
                                               object: nil)
        
        if UserPreferences.sharedInstance.displayIntro() {
            let storyboard = UIStoryboard(name: "Discovery", bundle: nil)
            
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "intro")
            
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
            return true
        }        
        
        launchMain(application)
        
        return true
    }
    
    func launchMain(_ application: UIApplication) {
        _customizeAppNavigationAppearance()
        
        application.applicationSupportsShakeToEdit = true
        
        appController = window?.rootViewController as! AppContainerViewController
        AFNetworkReachabilityManager.shared().startMonitoring()
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate._handleReachabilityStateChangedNotification), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
        _call911Item = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.plain, target: self, action:#selector(AppDelegate.call911BtnTapped))
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.updateEmergencyNumber), name:NSNotification.Name(rawValue: kNotification_EmergencyNumberChanged) , object: nil)
        
        //        self.initializeOperationQueue()
        //        self.initOperation()
        
        getNotificationsList()
    }
    
    
    func call911BtnTapped()
    {
      NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_CallBtntapped), object: nil)
    }
    
    func updateEmergencyNumber()
    {
        if(kUserPreferences.currentProfileId() != nil){
            
            let currentPhoneNo = _g_EmergencyPhone[kUserPreferences.emergencyPhone()!] as! String
            var newPhoneNo:String!
            
         if let oldCountry = kUserPreferences.countryName(){
            
            newPhoneNo = _g_EmergencyPhone[oldCountry] as! String
            
            if(newPhoneNo != currentPhoneNo)
            {
                kUserPreferences.setEmergencyPhone(oldCountry)
                kUserPreferences.save()
            }
            newPhoneNo =  (newPhoneNo.length > 0) ? newPhoneNo : "911"
          }
            
            else
           {
              newPhoneNo = "911"
            }
            _call911Item.title = String(format:"Call %@",newPhoneNo)
        }
        
    }
    
    
    // Get the documents Directory
    func documentsDirectoryPlistpath() -> String {
        let documentsFolderPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        let path = (documentsFolderPath as NSString).appendingPathComponent("Notifications.plist")
        return path
    }
    
    
// Get path for a file in the directory
    func getNotificationsListFilePath() ->String
    {
        let path = documentsDirectoryPlistpath()
        
        let fileManager = FileManager.default
        if (!(fileManager.fileExists(atPath: path)))
        {
            let bundle : NSString = Bundle.main.path(forResource: "Notifications", ofType: "plist")! as NSString
            do {
                try fileManager.copyItem(atPath: bundle as String, toPath: path)
            }
                
            catch _ as NSError {
            }
        
            let data = NSArray(contentsOfFile: path)
            data!.write(toFile: path, atomically: true)

        }
        
        return path
    }
    
    func updatePlistContents()
    {
        let path = documentsDirectoryPlistpath()
        
        let fileManager = FileManager.default
        if (fileManager.fileExists(atPath: path))
        {
            (NotificationsArray as NSArray).write(toFile: path, atomically: true)
        }
    }
    
    
    func getNotificationsList()
    {
        if let arrayOfItems = NSArray(contentsOfFile: getNotificationsListFilePath()) {
        
          NotificationsArray = arrayOfItems as! [NSDictionary]
            
            for(dict) in NotificationsArray{
                
                if(!(dict["isRead"] as! Bool)){
                  
                    notificationUnreadCount += 1
                }
            }
        }
        
        else
        {
            NotificationsArray = [
                ["NotificationText": "Optimize your phone like this...", "isRead": false,"tipno" : "tipone"],
                ["NotificationText": "A great tip for you...", "isRead":false,"tipno" : "tiptwo"],
                ["NotificationText": "Important iWitness Disclaimer", "isRead": true,"tipno" : "tipthree"]
            ]
            notificationUnreadCount = 2
  
        }
    }

    
    func _customizeAppNavigationAppearance()
    {
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent

        let navigationBarAppearace = UINavigationBar.appearance()
      //  navigationBarAppearace.barTintColor = UIColor.darkGrayColor() //Navigation Bar Background color
//        navigationBarAppearace.barTintColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
//        navigationBarAppearace.barTintColor = UIColor(red: 50.0/255.0, green: 50.0/255.0, blue: 50.0/255.0, alpha: 1.0)
        navigationBarAppearace.barTintColor = UIColor(red: 30.0/255.0, green: 30.0/255.0, blue: 30.0/255.0, alpha: 1.0)

        navigationBarAppearace.tintColor = UIColor.white // Navigation Bar back arrow
        navigationBarAppearace.titleTextAttributes = [NSFontAttributeName : UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSForegroundColorAttributeName : UIColor.white]
       
        //Bar Button Items
        let shadow:NSShadow
        shadow = NSShadow()
        shadow.shadowColor = UIColor.clear
        shadow.shadowOffset = CGSize(width: 0.0, height: 0.0)
        
        setAppNavBarButtonItemsTextColor()
        
      //  UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16)!,NSShadowAttributeName:shadow, NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)

        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16)!,NSShadowAttributeName:shadow, NSForegroundColorAttributeName:UIColor.lightGray], for: UIControlState.disabled)

    }
    
    func setAppNavBarButtonItemsTextColor()
    {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 16)!, NSForegroundColorAttributeName:UIColor.white], for: UIControlState())
        
    }

    func setAppActionPickerButtonItemsTextColor()
    {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSFontAttributeName: UIFont(name: "HelveticaNeue-Light", size: 16)!, NSForegroundColorAttributeName:UIColor.blue], for: UIControlState())
  
    }
    
    func _handleReachabilityStateChangedNotification() {
        
        if !AFNetworkReachabilityManager.shared().isReachable {
            
           let alertView = UIAlertView(title: kText_Info, message: kText_NetworkNotAvailable, delegate: nil, cancelButtonTitle: "OK")
           alertView.show()
        }
    }

//MARK:================ Network Checking ===========================================================
    
    func isInterentConnected() -> Bool
    {
        return AFNetworkReachabilityManager.shared().isReachable
        
    }

    func applicationWillResignActive(_ application: UIApplication) {
   
         kLocation.stopLocation()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
        if(_userServices == nil){
            self.initializeOperationQueue()
            self.initOperation()
        }
        else{
            if(_userServices?._bgTask == UIBackgroundTaskInvalid){
                self.initializeOperationQueue()
                self.initOperation()
            }
            
            
//            if(_userServices?._bgTask == nil){
//                
//            }
//            _userServices?.execute()
//            _OperationQueue.addOperation(_userServices!)
        }
        kLocation.startLocation()
        if (kLocation.locationStatus != CLAuthorizationStatus.authorizedWhenInUse) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_LocationUpdated), object: nil)
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func initializeOperationQueue() {
        
        
        var modelName = UIDevice.current.modelName
        
        if(modelName.hasPrefix("iPod")){
            modelName = (modelName as NSString).substring(from: 4)
            let modelVersion = Float(modelName)
            _OperationQueue.maxConcurrentOperationCount = Int((modelVersion < 5) ? 3 : 5)
        }
        if(modelName.hasPrefix("iPhone")){
            modelName = (modelName as NSString).substring(from: 6)
            let modelVersion = Float(modelName)
            _OperationQueue.maxConcurrentOperationCount = Int((modelVersion < 4) ? 3 : 5)
        }
        else{
            _OperationQueue.maxConcurrentOperationCount = 5
        }
        
       // if(Int(UIDevice.currentDevice().systemVersion) >= 8){
           // if #available(iOS 8.0, *) {
                _OperationQueue.qualityOfService = QualityOfService.utility
            //} else {
                // Fallback on earlier versions
           // }
       // }
    }
    
    func initOperation(){
        _userServices  = UserServices.init()
        _userServices?.execute()
        _OperationQueue.addOperation(_userServices!)
    }
    
    func facebookProfileChanged(notification: NSNotification) {
        
    }


}



