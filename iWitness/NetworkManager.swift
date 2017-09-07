//
//  NetworkManager.swift
//  iWitness
//
//  Created by Sravani on 30/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import AFNetworking

class NetworkManager: NSObject {
    
    static let sharedInstance = NetworkManager()
    let manager : AFHTTPSessionManager!
    
    override init() {
        
        manager = AFHTTPSessionManager(baseURL:URL(string:kHostname)!, sessionConfiguration: URLSessionConfiguration.default)
        
        manager.requestSerializer.timeoutInterval = 60.0
        
    }
    
    
    func executePostRequest(_ url:String,parameters:NSDictionary?,requestVC:BaseViewController)
    {
        //        if !kAppDelegate.isInterentConnected()
        //        {
        //            requestVC.showAlert(kText_NoNetWorkTitle, message:kText_NoNetWorkMessage)
        //            return;
        //        }
        
        var paramDict:NSDictionary?
        
        if (parameters == nil){
            
            paramDict = nil
        }
        else
        {
            paramDict = parameters!
        }
        
        requestVC.showloader()
        
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")

        
        if((url != kService_Authorization)  && (kUserPreferences.accessToken() != nil))
        {
            manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        }
        
        
        manager.post(
            url,
            parameters: paramDict,
            success: { (task, responseObject) in
                
                requestVC.removeloader()

                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    requestVC.requestSuccess(responseObject as AnyObject!, requesteUrl: url)
                    
                } else {
                    requestVC.requestErrorCode(responseObject as AnyObject!, requesteUrl: url,statusCode:httpResponse.statusCode)
                    
                }
            },
            failure: { (task, error) in
                
                requestVC.removeloader()
                
                if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                    if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                        
                        let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse
                        
                        do {
                            let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                            requestVC.requestErrorCode(obj, requesteUrl: url,statusCode:httpResponse.statusCode)
                            return

                        } catch {
                        }

                    }
                }
               
                requestVC.requestFailed(error as NSError!, requesteUrl: url)
                
        })
    }
    
    
 
    
    
    func executeGetRequest(_ url:String,parameters:NSDictionary?,requestVC:BaseViewController)
    {
        //       if !kAppDelegate.isInterentConnected()
        //        {
        //            requestVC.showAlert(kText_NoNetWorkTitle, message:kText_NoNetWorkMessage)
        //            return;
        //        }
        
        var paramDict:NSDictionary?
        
        if (parameters == nil){
            
            paramDict = nil
        }
        else
        {
            paramDict = parameters!
        }
        
        requestVC.showloader()
        
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=UTF-8", forHTTPHeaderField:"Content-Type")
        
        
        if((url != kService_Authorization)  && (kUserPreferences.accessToken() != nil))
        {
            manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        }
        
        manager.get(url,
            parameters: paramDict,
            success: { (task, responseObject) in
                
                requestVC.removeloader()
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    requestVC.requestSuccess(responseObject as AnyObject!, requesteUrl: url)
                    
                    
                } else {
                    
                    requestVC.requestErrorCode(responseObject as AnyObject!, requesteUrl: url, statusCode:httpResponse.statusCode)
                    
                }
            },
            failure: { (task, error) in
                
                requestVC.removeloader()
                
                if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                    if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                        
                        let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse

                        do {
                            let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                            requestVC.requestErrorCode(obj, requesteUrl: url,statusCode:httpResponse.statusCode)
                            return
                            
                        } catch {
                        }
                        
                    }
                }
                requestVC.requestFailed(error as NSError!, requesteUrl: url)
                
                
        })
    }
    
    
    
    func executePatchRequest(_ url:String,parameters:NSDictionary?,requestVC:BaseViewController)
    {
        //        if !kAppDelegate.isInterentConnected()
        //        {
        //            requestVC.showAlert(kText_NoNetWorkTitle, message:kText_NoNetWorkMessage)
        //            return;
        //        }
        
        var paramDict:NSDictionary?
        
        if (parameters == nil){
            
            paramDict = nil
        }
        else
        {
            paramDict = parameters!
        }
        
        requestVC.showloader()
        
        
        
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=UTF-8", forHTTPHeaderField:"Content-Type")
        
        
        
        if((url != kService_Authorization)  && (kUserPreferences.accessToken() != nil))
        {
            manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        }
        
        
        
        
        manager.patch(url,
            parameters: paramDict,
            success: { (task, responseObject) in
                
                requestVC.removeloader()
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    requestVC.requestSuccess(responseObject as AnyObject!, requesteUrl: url)
                    
                } else {
                    
                    requestVC.requestErrorCode(responseObject as AnyObject!, requesteUrl: url,statusCode:httpResponse.statusCode)
                    
                }
            },
            failure: { (task, error) in
                
                requestVC.removeloader()
                
                if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                    if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                        
                        let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse
                        
                        do {
                            let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                            requestVC.requestErrorCode(obj, requesteUrl: url,statusCode:httpResponse.statusCode)
                            return
                            
                        } catch {
                        }
                        
                    }
                }
                requestVC.requestFailed((error as NSError!), requesteUrl: url)
                
                
        })
    }
    
    
    
    func executeDeleteRequest(_ url:String,parameters:NSDictionary?,requestVC:BaseViewController)
    {
        //       if !kAppDelegate.isInterentConnected()
        //        {
        //            requestVC.showAlert(kText_NoNetWorkTitle, message:kText_NoNetWorkMessage)
        //            return;
        //        }
        
        var paramDict:NSDictionary?
        
        if (parameters == nil){
            
            paramDict = nil
        }
        else
        {
            paramDict = parameters!
        }
        
        requestVC.showloader()
        
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json","application/problem+json") as Set<NSObject>
        
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=UTF-8", forHTTPHeaderField:"Content-Type")
        
        
        if((url != kService_Authorization)  && (kUserPreferences.accessToken() != nil))
        {
            manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        }
        manager.delete(url,
            parameters: paramDict,
            success: { (task, responseObject) in
                
                requestVC.removeloader()
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    requestVC.requestSuccess(responseObject as AnyObject!, requesteUrl: url)
                    
                } else {
                    
                    requestVC.requestErrorCode(responseObject as AnyObject!, requesteUrl: url, statusCode:httpResponse.statusCode)
                    
                }
            },
            failure: { (task, error) in
                
                requestVC.removeloader()
               
                let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse

                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    requestVC.requestSuccess(nil, requesteUrl: url)
                    
                }
                else{
                 if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                    if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                        
                        let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse
                        
                        do {
                            let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                            requestVC.requestErrorCode(obj, requesteUrl: url,statusCode:httpResponse.statusCode)
                            return
                            
                        } catch {
                        }
                        
                    }
                }
                requestVC.requestFailed((error as NSError!), requesteUrl: url)
                
                }
        })
    }
    
    
    
    
}
