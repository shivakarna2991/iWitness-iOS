 //
 //  UserServices.swift
 //  iWitness
 //
 //  Created by Sravani on 04/01/16.
 //  Copyright © 2016 PTG. All rights reserved.
 //
 
 import UIKit
 import AFNetworking
 
 class UserServices: Operation {
    
    var isReload : Bool!
    var isRefresh : Bool!
    var isUploading : Bool!
    var _timer : Timer!
    var _IsMultitaskingSupported : Bool?
    var _bgTask : UIBackgroundTaskIdentifier?
    
    override init ()  {
        super.init();
        _IsMultitaskingSupported = false
        self.isRefresh = false
        self.isReload = false
        self.isUploading = false
        if(UIDevice.current.responds(to: #selector(getter: UIDevice.isMultitaskingSupported)) == true){
            _IsMultitaskingSupported = UIDevice.current.isMultitaskingSupported
        }
    }
    
    func execute() {
        if(self.isCancelled){
            if(self._bgTask != UIBackgroundTaskInvalid){
                UIApplication.shared.endBackgroundTask(self._bgTask!)
                self._bgTask = UIBackgroundTaskInvalid
            }
        }
        else{
            if(_IsMultitaskingSupported == true){
                
                if((UIApplication.shared.responds(to: #selector(UIApplication.beginBackgroundTask(expirationHandler: ))))){
                    // if((UIApplication.shared.responds(to: #selector(UIApplication.beginBackgroundTask(expirationHandler:)(_:))))){
                    self.executeBusiness()
                    _bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: { () -> Void in
                        if(self._bgTask != UIBackgroundTaskInvalid){
                            UIApplication.shared.endBackgroundTask(self._bgTask!)
                            self._bgTask = UIBackgroundTaskInvalid
                            self.cancel()
                            self._timer.invalidate()
                        }
                    })
                }
                
                
            }
        }
    }
    
    
    
    func executeBusiness() {
        /* Condition validation */
        //    if (self.isCancelled) return;
        
        // Create timer to keep the cron job alive
        
        
        //   DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority. background).async
        DispatchQueue.global(qos: .background).async{
            self._timer = Timer.scheduledTimer(timeInterval: 1.0, target:self, selector:(#selector(UserServices._doServices)), userInfo: nil, repeats: true)
            let runloop : RunLoop = RunLoop.current
            runloop.run()
            //            dispatch_async(dispatch_get_main_queue()) {
            //            }
        }
        
    }
    
    func _doServices() {
        
        
        if(kUserPreferences.currentProfileId() == nil)
        {
            return
        }
        
        
        self._doReloadProfile()
        self._doRefreshAccessToken()
        self._doUploadVideos()
    }
    
    
    
    
    func _doReloadProfile() {
        
        //        if(self.isReload == true || kUserPreferences.getProfileData() != nil){
        //            return
        //        }
        
        
        if(self.isReload == true){
            return
        }
        
        
        if(kAppDelegate.isLoginScreen == false){
            self.isReload = true
            if(kUserPreferences.currentProfileId() != nil){
                
                kNetworkManager.manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
                kNetworkManager.manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
                
                kNetworkManager.manager.get(String(format: kService_User,kUserPreferences.currentProfileId()!),parameters: nil,
                                            success: { (task, responseObject1) in
                                                
                                                DispatchQueue.main.async(execute: {
                                                    
                                                    let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                                                    if (httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299){
                                                        
                                                        kUserPreferences.setProfileData(responseObject1 as? NSDictionary)
                                                        kUserPreferences.setCurrentUsername((responseObject1 as? NSDictionary)!.object(forKey: "phone") as? String)
                                                        kUserPreferences.setCurrentProfileId((responseObject1 as? NSDictionary)!.object(forKey: "id") as? String)
                                                        
                                                        kUserPreferences.save()
                                                        
                                                        
                                                    }
                                                    self.isReload = false
                                                })
                                             },
                                            failure: { (task, error) in
                                                DispatchQueue.main.async(execute: {
                                                    
                                                    self.isReload = false
                                                    
                                                    if let httpResponse: HTTPURLResponse = task!.response as? HTTPURLResponse {
                                                    
                                                    if(httpResponse.statusCode == 401){
                                                        self.showErrorAlert(error: (error as NSError!))
                                                       }
                                                    }
                                                    
                                                   })
                                            }
                
                ) }
                
            else{
                
                DispatchQueue.main.async(execute: {
                    
                    self.isReload = false
                    self.doLogoutOfApp(message: "Something went wrong. Please re-login.")
                })
            }
        }
        
    }
    
    
    
    func doLogoutOfApp(message:String) {
        
        let alert:UIAlertController = UIAlertController(title: kText_AppName, message: message, preferredStyle: .alert)
        let buttonCancel = UIAlertAction(title: "Ok", style: .cancel) { (action) -> Void in
        }
        alert.addAction(buttonCancel)
        kAppController!.present(alert, animated: true, completion: nil)
        
        kAppController!.selectedRow = 0
        kAppDelegate.isLoginScreen = true
        kAppDelegate.canSendSafeNotification = false
        kUserPreferences.reset()
        kAppController!.showLoginScreen()
    }
    
    
    func showErrorAlert(error:NSError) {
       
            if let underError = error.userInfo["NSUnderlyingError"]{
                if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                    do {
                        let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                        if let tempDetail = obj.value(forKey: "detail") as? String{
                            
                            if(tempDetail == "User not logged in"){
                                
                                self.doLogoutOfApp(message: "Your iWitness account has been logged in on different device, if you did not authorize this change please go to www.iWitness.com and reset your password and log-in on your device using your updated credentials.")
                                
                            }
                        }
                        
                    } catch {
                    }
                }
            }
        
    }
    
    
    
    
    func _doRefreshAccessToken() {
        
        let now : Date = Date()
        var expiredTime : Date = Date()
        if(kUserPreferences.expiredTime() == nil){
            return
        }
        expiredTime =  kUserPreferences.expiredTime()! as Date
        
        if((expiredTime.timeIntervalSince1970 - now.timeIntervalSince1970) >= 180.0){
            return
        }
        
        if(self.isRefresh == true){
            return;
        }
        self.isRefresh = true
        
        let dict : NSDictionary = NSDictionary(objects: ["refresh_token", kUserPreferences.refreshToken(),kUserPreferences.clientId(),kUserPreferences.clientSecret()], forKeys: [ "grant_type" as NSCopying, "refresh_token" as NSCopying ,"client_id" as NSCopying , "client_secret" as NSCopying ])
        
        //let manager = AFHTTPSessionManager(baseURL:NSURL(string:kHostname)!, sessionConfiguration: NSURLSessionConfiguration.defaultSessionConfiguration())
        
        kNetworkManager.manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        kNetworkManager.manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        
        kNetworkManager.manager.post(String(format: kService_Authorization),parameters: dict,
                                     success: { (task, responseObject1) in
                                        
                                        DispatchQueue.main.async(execute: {
                                            
                                            let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                                            if (httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299) {
                                                kUserPreferences.setTokenType((responseObject1 as? NSDictionary)!.object(forKey: "token_type") as? String)
                                                kUserPreferences.setAccessToken((responseObject1 as? NSDictionary)!.object(forKey: "access_token") as? String)
                                                kUserPreferences.setRefreshToken((responseObject1 as? NSDictionary)!.object(forKey: "refresh_token") as? String)
                                                
                                                let currentDate = Date()
                                                let str = (responseObject1 as AnyObject!)["expires_in"] as! NSNumber
                                                let expiredate = currentDate.addingTimeInterval(Double(str))
                                                kUserPreferences.setExpiredTime(expiredate)
                                                kUserPreferences.save()
                                            }
                                            else {
                                            }
                                            self.isRefresh = false
                                            
                                        })
        },
                                     failure: { (task, error) in
                                        DispatchQueue.main.async(execute: {
                                            self.isRefresh = false
                                            self.doLogoutOfApp(message: "Your session is expired. Please re-login.")
                                            
                                        }
                                        )
        }
        )
        
        
    }
    
    
    func _doUploadVideos() {
        
        
        if (self.isUploading == true || kUserPreferences.accessToken() == nil) {
            return
        }
        self.isUploading = true
        
        let videoPart : NSDictionary? = self.getCurrentVideoFilePath()
        
        
        if let _ = videoPart {
            
            if(videoPart!.count < 3 ){
                self.isUploading = false
                return
            }
        }
        else{
            
            self.isUploading = false
            return
        }
        
        let tokens : NSArray = ((videoPart!["_file"]! as AnyObject).components(separatedBy: "_") as NSArray)
        
        
        var filename : String = String(format: "%@.mp4", (tokens[0] as! String))
        let lat : String
        var lng : String
        var accessToken : String
        if(tokens.count>4){
            lat  = String(format: "%@", (tokens[3] as! String))
            lng  = String(format: "%@", (tokens[4] as! String))
            lng  = lng.replacingOccurrences(of: ".mp4", with: "")
            accessToken  = String(format: "%@", (tokens[5] as! String))
            accessToken  = accessToken.replacingOccurrences(of: ".mp4", with: "")
        }
        else{
            lat = ""
            lng = ""
            accessToken  = String(format: "%@", (tokens[3] as! String))
            accessToken  = accessToken.replacingOccurrences(of: ".mp4", with: "")
        }
        
        
        filename = filename.replacingOccurrences(of: "-", with: "")
        
        
        let videoData = try? Data(contentsOf: URL(fileURLWithPath: videoPart!["_video"] as! String))
        
        //        print(videoData!.length)
        
        let urlPath: String = kHostname+kService_Asset
        let url: URL = URL(string: urlPath)!
        let request1: NSMutableURLRequest = NSMutableURLRequest(url: url)
        request1.httpMethod = "POST"
        request1.timeoutInterval = 60
        
        
        let boundary : String = String(format:"----------%li", Date().timeIntervalSince1970)
        
        let contentType : String = String(format:"multipart/form-data; boundary=%@", boundary)
        request1.addValue(contentType, forHTTPHeaderField: "Content-Type")
        
        let body : NSMutableData = NSMutableData()
        body.append(String(format:"\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        body.append(String(format:"Content-Disposition: form-data; name=\"media\"; filename=\"%@\"\r\n", filename).data(using: String.Encoding.utf8)!)
        body.append(String(format:"Content-Type: video/mp4\r\n\r\n").data(using: String.Encoding.utf8)!)
        body.append(videoData!)
        body.append(String(format:"\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        body.append(String(format:"Content-Disposition: form-data; name=\"event-id\"\r\n\r\n").data(using: String.Encoding.utf8)!)
        body.append(String(format:"%@",videoPart!["_eventId"] as! String ).data(using: String.Encoding.utf8)!)
        body.append(String(format:"\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        body.append(String(format:"Content-Disposition: form-data; name=\"lat\"\r\n\r\n").data(using: String.Encoding.utf8)!)
        body.append(String(format:"%@",lat ).data(using: String.Encoding.utf8)!)
        body.append(String(format:"\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        body.append(String(format:"Content-Disposition: form-data; name=\"lng\"\r\n\r\n").data(using: String.Encoding.utf8)!)
        body.append(String(format:"%@",lng ).data(using: String.Encoding.utf8)!)
        body.append(String(format:"\r\n--%@\r\n", boundary).data(using: String.Encoding.utf8)!)
        
        var length : size_t = 0
        length = body.length
        
        request1.setValue(String(format:"%zu", length), forHTTPHeaderField: "Content-Length")
        request1.setValue(String(format:"%@ %@", kUserPreferences.tokenType(),accessToken), forHTTPHeaderField: "Authorization")
        request1.httpBody = body as Data
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request1 as URLRequest, completionHandler: {data, response, error -> Void in
            if (error != nil)
            {
                self.isUploading = false
            }
            else
            {
                let httpResponse : HTTPURLResponse = response as! HTTPURLResponse
                
                if((200 <= httpResponse.statusCode) && (httpResponse.statusCode <= 299)){
                    do{
                        let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        //print("uploaded file data : \(jsonResult)")
                        do{
                            
                            let _ = try FileManager.default.removeItem(atPath: videoPart!["_video"] as! String)
                            self.isUploading = false
                            
                        }catch{ //else part dont remove current one
                        }
                        
                    }catch{ //else part dont remove current one
                    }
                }
            }
            
            
        })
        
        task.resume()
        
        /*   let queue:OperationQueue = OperationQueue()
         
         NSURLConnection.sendAsynchronousRequest(request1 as URLRequest, queue: queue, completionHandler:{ (response: URLResponse?, data: Data?, error: NSError?) -> Void in
         
         if ((error) != nil)
         {
         self.isUploading = false
         }
         else
         {
         let httpResponse : HTTPURLResponse = response as! HTTPURLResponse
         
         if((200 <= httpResponse.statusCode) && (httpResponse.statusCode <= 299)){
         do{
         let jsonResult: NSDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
         print("AsSynchronous\(jsonResult)")
         do{
         let _ = try FileManager.default.removeItem(atPath: videoPart!["_video"] as! String)
         self.isUploading = false
         }catch{ //else part dont remove current one
         }
         
         }catch{ //else part dont remove current one
         }
         }
         
         }
         
         } as! (URLResponse?, Data?, Error?) -> Void)
         
         */
        
    }
    
    
    
    
    func getCurrentVideoFilePath() -> NSDictionary
    {
        
        let fileManager = FileManager.default
        let documentPath :String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
        
        // Check Root folder which mapped against user's Id
        
        let clientPath = documentPath+"/"+kUserPreferences.clientId()
        
        if (!(fileManager.fileExists(atPath: clientPath)))
        {
            return [:]
        }
        
        
        do{
            let eventPaths =  try fileManager.contentsOfDirectory(atPath: clientPath)
            
            if(eventPaths.count == 0)
            {
                return [:]
            }
            
            
            var sortedFiles = self.setSortedFilesinCacheforPath2(clientPath,subPathArray:eventPaths as [String])
            
            // Check video parts within an event folder
            
            var eventId = ""
            var eventPath = ""
            
            for i in 0 ..< sortedFiles.count
            {
                eventId = (sortedFiles[i] )["path"] as! String
                eventPath = String(format: "%@/%@",clientPath,eventId)
                
                if(eventId.caseInsensitiveCompare("(null)") == ComparisonResult.orderedSame){
                    
                    sortedFiles.remove(at: i)
                    do{
                        try fileManager.removeItem(atPath: eventPath)
                    }catch{
                        return [:]
                    }
                }
                    
                else
                {
                    
                    do{
                        let _ = try fileManager.contentsOfDirectory(atPath: eventPath)
                        break
                        
                    }catch{ //else part dont remove current one
                        
                        if(!(eventId == kUserPreferences.eventId()))
                        {
                            sortedFiles.remove(at: i)
                            do{
                                try fileManager.removeItem(atPath: eventPath)
                            }catch{
                                
                            }
                            
                        }
                        
                    }
                    
                }
            }
            
            if(sortedFiles.count > 0)
            {
                eventId = ((sortedFiles[sortedFiles.count-1] as AnyObject).object(forKey: "path"))! as! String
                eventPath = String(format: "%@/%@",clientPath,eventId)
            }
            
            if(!(eventId.length > 0 && eventPath.length > 0))
            {
                return [:]
            }
            
            do{
                let videoParts = try fileManager.contentsOfDirectory(atPath: eventPath)
                
                if(videoParts.count == 0){
                    
                    do{
                        try fileManager.removeItem(atPath: eventPath)
                    }catch{
                        
                        return [:]
                        
                    }
                    return [:]
                }
                
                //  sort by creation date
                let sortedVideoFiles = self.setSortedFilesinCacheforPath2(eventPath,subPathArray:videoParts as [String])
                
                
                if let value = (sortedVideoFiles[sortedVideoFiles.count-1] as AnyObject).object(forKey: "path"){
                    
                    let finalOPDict = ["_eventId":eventId  ,"_file":value,"_video": String(format:"%@/%@",arguments: [eventPath,(value as! String)])]
                    
                    return finalOPDict as NSDictionary
                }
                
                return [:]
                
            }
                
            catch{
                
                return [:]
                
            }
            
            
            
        } catch  {
            return [:]
        }
        
    }
    
    
    
    
    //   func setSortedFilesinCacheforPath(_ path:String,subPathArray:NSArray) -> NSMutableArray
    //    {
    //         let fileManager = FileManager.default
    //
    //        let filesAndProperties:NSMutableArray = NSMutableArray(capacity: subPathArray.count)
    //        for file in subPathArray
    //        {
    //            let filePath = String(format: "%@/%@", path,file as! String)
    //            do{
    //                
    //                let properties =  try fileManager.attributesOfItem(atPath: filePath) as NSDictionary
    //                let modDate =  properties.object(forKey: FileAttributeKey.creationDate) as! Date
    //                
    //                filesAndProperties.add(["path" : file as! String, "createdDate": modDate])
    //                
    //            }catch {
    //            }
    //        }
    //        
    //        if(filesAndProperties.count > 1){
    //            let finalArray =  filesAndProperties.sorted  {
    //                item1, item2 in
    //                let date1 = (item1 as AnyObject!)["createdDate"] as! Date
    //                let date2 = (item2 as AnyObject!)["createdDate"] as! Date
    //                return date1.compare(date2) == ComparisonResult.orderedDescending
    //            }
    //            
    //            let resultArray:NSMutableArray = NSMutableArray(array: finalArray)
    //
    //            return resultArray
    //        }
    //        else
    //        {
    //            return filesAndProperties
    //        }
    //  
    //  
    //        
    //        
    //        
    //    }
    
    
    func setSortedFilesinCacheforPath2(_ path:String, subPathArray:[String]) -> [[String:AnyObject]]{
        let fileManager = FileManager.default
        var filesAndProperties = [[String:AnyObject]]()
        for file in subPathArray
        {
            let filePath = String(format: "%@/%@", path,file)
            do{
                let properties =  try fileManager.attributesOfItem(atPath: filePath) as Dictionary
                let modDate =  properties[FileAttributeKey.creationDate] as! Date
                filesAndProperties.append(["path" : file as AnyObject, "createdDate": modDate as AnyObject])
                
            }catch {
            }
        }
        
        if(filesAndProperties.count > 1){
            let finalArray =  filesAndProperties.sorted  {
                item1, item2 in
                let date1 = item1["createdDate"] as! Date
                let date2 = item2["createdDate"] as! Date
                return date1.compare(date2) == ComparisonResult.orderedDescending
            }
            
            return finalArray
        }
        else
        {
            return filesAndProperties
        }
        
    }
    
    
    
    
    
    
 }
