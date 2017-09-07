//
//  UserPreferences.swift
//  iWitness
//
//  Created by Sravani on 16/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class UserPreferences: NSObject {
    
    var _preferences =  [String: AnyObject]()  //NSMutableDictionary()
    
    static let sharedInstance = UserPreferences()
    
    
    override init() {
        
        let appUserDefaults = UserDefaults.standard
        
        if let newData = appUserDefaults.object(forKey: "_appPreferences"){
            
            
            //            let dict = NSKeyedUnarchiver.unarchiveObject(with: newData as! Data) as! NSDictionary
            //            _preferences = dict.mutableCopy() as! NSMutableDictionary
            
            _preferences = NSKeyedUnarchiver.unarchiveObject(with: newData as! Data) as! [String:AnyObject]
            
            
        }
        else
        {
            // _preferences = NSMutableDictionary()
        }
        
        //        // Load user's profile & Continue upload
        //        if ([self accessToken].length > 0) {
        //            UserServices *upload = [[UserServices alloc] init];
        //            upload.delegate = self;
        //            [upload execute];
        //
        //            self.userServices = upload;
        //            FwiRelease(upload);
        //        }
        
    }
    
    
    
    func objectForKey(_ key:String)->AnyObject?
    {
        return _preferences[key] as AnyObject?
    }
    
    func setvalue(_ value: AnyObject?, forKey key: String) {
        
        // let lockQueue = dispatch_queue_create("com.test.LockQueue", nil)
        // dispatch_sync(lockQueue) {
        if let tempValue = value{
            // self._preferences.setValue(tempValue, forKey: key)
            self._preferences[key] = tempValue
            return
            // }
        }
        self._preferences.removeValue(forKey:key)
    }
    //}
    
    
    func reset()
    {
        //            if ((kAppDelegate._userServices) != nil) {
        //              kAppDelegate._userServices!.cancel()
        //              kAppDelegate._userServices = nil;
        //            }
        self.setEnableTap(true)
        self.setEnableShake(true) //have to set before seting current profile id to nil
        
        self.setCurrentUsername(nil)
        self.setCurrentProfileId(nil)
        self.setTokenType(nil)
        self.setExpiredTime(nil)
        self.setAccessToken(nil)
        self.setRefreshToken(nil)
        self.setEventId(nil)
        self.save()
        
    }
    
    func save()
    {
        
        let userdefaults = UserDefaults.standard
        let data :Data = NSKeyedArchiver.archivedData(withRootObject: _preferences)
        userdefaults.set(data, forKey:"_appPreferences")
        userdefaults.synchronize()
        
    }
    
    //MARK:=============User Credentials=========================================
    
    
    func clientId()->String
    {
        return "1ef28784-23f8-11e4-b8aa-000c29c9a052"
    }
    
    func clientSecret()->String
    {
        return "26b30aba-23f8-11e4-b8aa-000c29c9a052"
    }
    
    //MARK:====Setter & getter methods for currentUsername=====================
    
    func currentUsername()->String?
    {
        return self.objectForKey("_currentUsername") as? String
    }
    
    func setCurrentUsername(_ currentUsername:String?)
    {
        if let newValue = currentUsername {
            if (!(newValue.isEmpty)) {
                self.setvalue(newValue as AnyObject?, forKey:"_currentUsername")
                return
            }
        }
        _preferences.removeValue(forKey: "_currentUsername")
    }
    
    
    //MARK:====Setter & getter methods for Profile id ============================
    
    func currentProfileId()->String?
    {
        return self.objectForKey("_currentProfileId") as? String
    }
    
    func setCurrentProfileId(_ currentProfileId:String?)
    {
        
        if let newValue = currentProfileId {
            if (!(newValue.isEmpty)) {
                self.setvalue(newValue as AnyObject?, forKey:"_currentProfileId")
                return
            }
        }
        _preferences.removeValue(forKey:"_currentProfileId")
    }
    
    //MARK:====Setter & getter methods for tokenType============================
    
    func tokenType()->String
    {
        return self.objectForKey("_tokenType") as! String
    }
    
    func setTokenType(_ tokenType:String?)
    {
        if let newValue = tokenType {
            if (!(newValue.isEmpty)) {
                self.setvalue(newValue as AnyObject?, forKey:"_tokenType")
                return
            }
        }
        _preferences.removeValue(forKey: "_tokenType")
    }
    
    //MARK:====Setter & getter methods for expiredTime============================
    
    func expiredTime()->Date?
    {
        return self.objectForKey("_expiredTime") as? Date
    }
    
    func setExpiredTime(_ expiredTime:Date?)
    {
        if let newValue = expiredTime {
            self.setvalue(newValue as AnyObject?, forKey:"_expiredTime")
            return
        }
        _preferences.removeValue(forKey: "_expiredTime")
    }
    
    
    //MARK:====Setter & getter methods for accessToken============================
    
    func accessToken()->String?
    {
        return self.objectForKey("_accessToken") as? String
    }
    
    func setAccessToken(_ accessToken:String?)
    {
        if let newValue = accessToken {
            if (!(newValue.isEmpty)) {
                self.setvalue(newValue as AnyObject?, forKey:"_accessToken")
                //need to check old code, here all user services are starting
                return
            }
        }
        _preferences.removeValue(forKey: "_accessToken")
    }
    
    //MARK:====Setter & getter methods for ProfileData============================
    
    func setProfileData(_ profile:NSDictionary?)
    {
        if let newValue = profile {
            
            self.setvalue(newValue, forKey:"profileInfo")
            //need to check old code, here all user services are starting
            return
        }
        _preferences.removeValue(forKey: "profileInfo")
    }
    
    func getProfileData() -> NSDictionary?
    {
        return self.objectForKey("profileInfo") as? NSDictionary
    }
    
    
    //MARK:====Setter & getter methods for refreshToken============================
    
    func refreshToken()->String
    {
        return self.objectForKey("_refreshToken") as! String
    }
    
    func setRefreshToken(_ refreshToken:String?)
    {
        if let newValue = refreshToken {
            if (!(newValue.isEmpty)) {
                self.setvalue(newValue as AnyObject?, forKey:"_refreshToken")
                return
            }
        }
        _preferences.removeValue(forKey: "_refreshToken")
    }
    
    //MARK:====Setter & getter methods for User Profile ===========================
    
    func isFirstLogin()->Bool{
        
        if let isfirstLogin = self.objectForKey(String(format:"%@/_isFirstLogin",self.currentProfileId()!)) as? NSNumber
        {
            return isfirstLogin.boolValue
        }
        return false
        
    }
    
    func setFirstLogin(_ isFirstLogin:Bool)
    {
        self.setvalue(NSNumber(value: isFirstLogin as Bool), forKey: String(format:"%@/_isFirstLogin",self.currentProfileId()!))
    }
    
    
    func isFirstRegistered()->Bool{
        
        if let value = self.objectForKey(String(format:"%@/_isFirstRegistered",self.currentProfileId()!)) as? NSNumber
        {
            return value.boolValue
        }
        return false
        
    }
    
    func setFirstRegistered(_ isFirstRegistered:Bool)
    {
        self.setvalue(NSNumber(value: isFirstRegistered as Bool), forKey: String(format:"%@/_isFirstRegistered",self.currentProfileId()!))
    }
    
    
    func eventId()->String?
    {
        if let value = self.objectForKey("_eventId") as? String
        {
            return value
        }
        return nil
    }
    
    func setEventId(_ eventId:String?)
    {
        if let value = eventId
        {
            if(!(value.isEmpty))
            {
                self.setvalue(eventId as AnyObject?, forKey: "_eventId")
                return
            }
        }
        
        _preferences.removeValue(forKey: "_eventId")
    }
    
    
    //MARK:====Setter & getter methods for User Preferences===========================
    
    func enableShake()->Bool{
        
        if let value = self.objectForKey(String(format:"%@/_enableShake",self.currentProfileId()!)) as? NSNumber
        {
            return value.boolValue
        }
        return true
    }
    
    func setEnableShake(_ enableShake:Bool)
    {
        if( self.currentProfileId() != nil) {
            
            self.setvalue(NSNumber(value: enableShake as Bool), forKey: String(format:"%@/_enableShake",self.currentProfileId()!))
        }
    }
    
    func enableTap()->Bool{
        
        if let value = self.objectForKey(String(format:"%@/_enableTap",self.currentProfileId()!)) as? NSNumber
        {
            return value.boolValue
        }
        return true
    }
    func setEnableTap(_ enableTap:Bool)
    {
        if( self.currentProfileId() != nil) {
            
            self.setvalue(NSNumber(value: enableTap as Bool), forKey: String(format:"%@/_enableTap",self.currentProfileId()!))
        }
    }
    func enableContact()->Bool{
        
        if let value = self.objectForKey(String(format:"%@/_enableContact",self.currentProfileId()!)) as? NSNumber
        {
            return value.boolValue
        }
        return true
    }
    func setEnableContact(_ enableTap:Bool)
    {
        if( self.currentProfileId() != nil) {
            
            self.setvalue(NSNumber(value: enableTap as Bool), forKey: String(format:"%@/_enableContact",self.currentProfileId()!))
        }
    }
    func enableAlarm()->Bool{
        
        if let value = self.objectForKey(String(format:"%@/_enableAlarm",self.currentProfileId()!)) as? NSNumber
        {
            return value.boolValue
        }
        return true
    }
    func setEnableAlarm(_ enableTap:Bool)
    {
        if( self.currentProfileId() != nil) {
            
            self.setvalue(NSNumber(value: enableTap as Bool), forKey: String(format:"%@/_enableAlarm",self.currentProfileId()!))
        }
    }
    
    
    
    
    func enableTorch()->Bool{
        
        if( self.currentProfileId() != nil) {
            if let value = self.objectForKey(String(format:"%@/_enableTorch",self.currentProfileId()!)) as? NSNumber
            {
                return value.boolValue
            }
        }
        return false
    }
    
    func setEnableTorch(_ enableTorch:Bool)
    {
        if( self.currentProfileId() != nil) {
            
            self.setvalue(NSNumber(value: enableTorch as Bool), forKey: String(format:"%@/_enableTorch",self.currentProfileId()!))
        }
    }
    
    func setCountryName(_ name:String)
    {
        self.setvalue(name as AnyObject?, forKey:"Country")
        
    }
    
    func countryName() ->String?
    {
        return self.objectForKey("Country") as? String
    }
    
    func emergencyPhone()->String? //as emergencyPhone is not going be nil bcz of USA as default value
    {
        if let value = self.objectForKey(String(format:"%@/_emergencyPhone",self.currentProfileId()!)) as? String
        {
            return value
        }
        return "United States"
    }
    
    func setEmergencyPhone(_ emergencyPhone:String?)
    {
        if( self.currentProfileId() != nil) {
            self.setvalue(emergencyPhone as AnyObject?, forKey: String(format:"%@/_emergencyPhone",self.currentProfileId()!))
        }
    }
    
    func recordTime()->NSInteger // as record is not going be nil bcz of default value
    {
        let recordtime = self.objectForKey(String(format:"%@/_recordTime",self.currentProfileId()!)) as? NSNumber
        if let value = recordtime{
            return value.intValue
        }
        return kAppDefaultTime
    }
    
    func setRecordTime(_ recordTime:NSInteger)
    {
        if( self.currentProfileId() != nil) {
            self.setvalue(NSNumber(value: recordTime as Int), forKey: String(format:"%@/_recordTime",self.currentProfileId()!))
        }
    }
    
    func displayIntro() -> Bool
    {
        let d = self.objectForKey("displayIntro") as? NSNumber
        return d != nil ? (d!.boolValue) : true
    }
    
    func setDisplayIntro(_ d: Bool)
    {
        self.setvalue(NSNumber(value: d), forKey: "displayIntro")
    }
    
}


