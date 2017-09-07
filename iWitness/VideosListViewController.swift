//
//  VideosListViewController.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import CoreLocation
import AFNetworking
import AVKit
import AVFoundation
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


class VideosListViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet var listView :UITableView!
    var listArray = [[String: AnyObject]]()
    var pagecount:Int?
    var totalCount:Int?
    var currentpageno = 0
    var isFirstTimeFetched = false
    var dateFormatter = DateFormatter()
    var isScreenFromHomeScreen = false
    var isScreenAfterVideoRecorded = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        _visualize()
        
        if(isScreenAfterVideoRecorded == true)
        {
            self.showAlert(kText_AppName, message:"New videos will be available when they're ready for playback on server.")
        }
        
        reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        self.title = "Videos"
        //let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.Plain, target: self, action:"call911BtnTapped")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(VideosListViewController.closeMenuScreen(_:)))
        listView.addGestureRecognizer(tapGesture)
        
        
        if(isScreenFromHomeScreen)
        {
            let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(VideosListViewController.backBtnTapped))
            self.navigationItem.leftBarButtonItem = leftBtn
            
        }
        else
        {
            let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(VideosListViewController.menuBtnTapped))
            self.navigationItem.leftBarButtonItem = leftBtn
            
        }
        
    }
    
    //MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        kAppController!.menuBtnTapped()
    }
    
    func backBtnTapped()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func closeMenuScreen(_ tapgesture:UITapGestureRecognizer) {
        
        
        let tapPoint:CGPoint = tapgesture.location(in: listView)
        let indexpath = self.listView.indexPathForRow(at: tapPoint)
        
        if let _ = indexpath{
            
            tapgesture.cancelsTouchesInView = false
            
        }else if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
    }
    
    
    //    @IBAction func call911BtnTapped()
    //    {
    //
    //    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return self.listArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
            listView.dequeueReusableCell(withIdentifier: "VideoCell",
                                         for: indexPath) as! VideoListTableViewCell
        /// <#Description#>
        let obj = self.listArray[indexPath.row] as [String:AnyObject]
        aCell.locationOfVideo.text = "- Not Available -"
        
        
        if let _ = obj["initialLat"]{
            let location = CLLocation(latitude: (obj["initialLat"] as! NSNumber).doubleValue, longitude: (obj["initialLong"] as! NSNumber).doubleValue)
            CLGeocoder().reverseGeocodeLocation(location, completionHandler:
                {(placemarks, error) in
                    if (error == nil && placemarks != nil &&  (placemarks! as [CLPlacemark]).count > 0) {
                        
                        let pm:CLPlacemark  = placemarks![0]
                        if let name = pm.locality {
                            
                            aCell.locationOfVideo.text = String(format:"%@, %@",name,pm.administrativeArea!)
                        }
                    }
            })

        }
        
        
        if(obj["duration"] as? String == "0"){
            aCell.durationOfVideo.text = "- NA -"
        }
        else{
            
            let fullNameArr = (obj["duration"] as? String)!.components(separatedBy: ":")  //come as
            aCell.durationOfVideo.text = String(format:"%@:%@",fullNameArr[1],fullNameArr[2])
        }
        
        
        
        let date = Date(timeIntervalSince1970:(obj["created"] as! NSNumber).doubleValue)
        // dateFormatter.timeZone = NSTimeZone(name: "(UTC -10:00) Pacific/Honolulu")
        dateFormatter.dateFormat = "MM/dd/yy"
        aCell.dateofVideo.text = dateFormatter.string(from: date)
        dateFormatter.dateFormat = "hh:mm a"
        aCell.timeOfVideo.text = dateFormatter.string(from: date)
        aCell.imageOfVideo.setImageWith(URL(string: obj["imageUrl"] as! String)!, placeholderImage: UIImage(named: "no_video.png"))
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        // if menu is opened then it will close menu screen and will get return here
        
        
        let obj = self.listArray[indexPath.row] as [String:AnyObject]
        
        //        let detalplayerObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VidepPlayVCId") as! VideoPlayViewController
        //        detalplayerObj.videoUrlString = obj.valueForKey("videoUrl") as! String
        //        self.navigationController?.pushViewController(detalplayerObj, animated: true)
        
        
        let detalplayerObj = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AVPlayerVCId") as! AVPlayerViewController
        let url = URL(string:
            obj["videoUrl"] as! String)
        detalplayerObj.player = AVPlayer(url: url!)
        detalplayerObj.videoGravity =  AVLayerVideoGravityResizeAspectFill
        detalplayerObj.player!.play()
        self.present(detalplayerObj, animated: true, completion: nil)
        
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let  height : CGFloat = scrollView.frame.size.height
        
        let contentYoffset : CGFloat = scrollView.contentOffset.y
        
        let distanceFromBottom : CGFloat = scrollView.contentSize.height - contentYoffset - 5
        
        if (distanceFromBottom < height )
        {
            if currentpageno < pagecount{
                reloadData()
            }
        }
    }
    
    
    
    func reloadData()
    {
        
        self.showloader()
        
        let manager = AFHTTPSessionManager(baseURL:URL(string:kHostname)!, sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        manager.requestSerializer.timeoutInterval = 60.0
        manager.get(
            String(format: kService_EventPage,kUserPreferences.currentProfileId()!,self.currentpageno+1),
            parameters: nil,
            success: { (task, responseObject) in
                
                self.removeloader()
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    self.removeloader()
                    
                    DispatchQueue.main.async(execute: {
                        
                       let responseObject1 = responseObject as AnyObject
                        
                        if self.isFirstTimeFetched == false { //while fetching first time
                            
                            self.isFirstTimeFetched = true
                            
                            self.listArray = ((responseObject1["_embedded"] as! [String:AnyObject])["event"]) as! [[String:AnyObject]]
                            self.currentpageno += 1
                            self.pagecount = (responseObject1["page_count"] as? Int)
                            self.totalCount = (responseObject1["total_items"] as? Int)
                            self.listView.reloadData()
                            
                        }
                            
                        else // when bottom reload triggered
                        {
                            var indexpathArray = [IndexPath]()
                            
                            var tempArray = ((responseObject1["_embedded"] as! [String:AnyObject])["event"]) as! [[String:AnyObject]]
                            
                            self.currentpageno += 1
                            for i in 0..<tempArray.count {
                                let nspath = IndexPath(row: (self.listArray.count), section: 0)
                                indexpathArray.append(nspath)
                                self.listArray.append(tempArray[i])
                            }
                            self.listView.beginUpdates()
                            self.listView.insertRows(at: indexpathArray, with: UITableViewRowAnimation.left)
                            self.listView.endUpdates()
                            
                        }
                    })
                    
                } else {
                    
                    self.requestErrorCode(responseObject as AnyObject, requesteUrl: String(format: kService_EventPage,kUserPreferences.currentProfileId()!,self.currentpageno+1), statusCode:httpResponse.statusCode)
                }
            },
            failure: { (task, error) in
                DispatchQueue.main.async(execute: {
                    
                    self.removeloader()
                    
                    if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                        if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                            
                            let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse
                            
                            do {
                                let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                                self.requestErrorCode(obj, requesteUrl: String(format: kService_EventPage,kUserPreferences.currentProfileId()!,self.currentpageno+1),statusCode:httpResponse.statusCode)
                                return
                                
                            } catch {
                            }
                            
                        }
                    }
                    
                    self.showAlert(kText_Warning, message:kText_CouldNotLoadEvents)
                    
                    }
                )
            }
        )
    }
    
    
}
