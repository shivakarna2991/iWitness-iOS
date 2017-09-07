//
//  Utilities.swift
//  iWitness
//
//  Created by PTG on 09/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import CoreTelephony


class Utilities: NSObject {
    
    static let sharedInstance = Utilities()
    
    
    //MARK:================SYSTEMVERSION ===========================================================
    
    func checkiOS8() -> Bool {
        
        let Device = UIDevice.current
        let iosVersion = Double(Device.systemVersion) ?? 0
        
        let iOS8 = iosVersion >= 8
        return iOS8
//        return UIDevice.currentDevice().systemVersion.compare(version,
//            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    
    func convertToBase64(_ data : Data) -> String {
        
        let base64String = data.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        return base64String
    }
    
    func convertBase64ToString(_ base64String : String) -> Data {
        let data = Data(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0))
        return data!
        
    }
    
    func randomIdentifier()-> String
    {
        return  UUID().uuidString
    }
    
    func isAccountExpired(_ dict : NSDictionary)-> Bool
    {
        
        if(((dict.object(forKey: "type") as! NSString).isEqual(to: "Admin"))){
            return false
        }
        else{
            
            
            let expiredTime: TimeInterval = ((dict.object(forKey: "subscriptionExpireAt")) as! Double)
            
            let currentTime:TimeInterval = Date().timeIntervalSince1970
            
//            print("expired time====\(expiredTime)")
//            print("current time====\(currentTime)")
            
            if (expiredTime == 0.0) {return false}
            
            if (currentTime < expiredTime) {
                return false;
            }
            else {
                return true;
            }
        }
        
    }
    
    func hasCellularCoverage() -> Bool {
        if let cellularProvider  = CTTelephonyNetworkInfo().subscriberCellularProvider {
            if let mnCode = cellularProvider.mobileNetworkCode {
                print(mnCode)
                return true
            }
        }
        return false
    }

}
