//
//  Call911ViewController.swift
//  iWitness
//
//  Created by Sravani on 20/01/16.
//  Copyright © 2016 PTG. All rights reserved.
//

import UIKit
import AVFoundation
import AFNetworking
import CoreLocation



class Call911ViewController: UIViewController {
    
    @IBOutlet var titleLabel:UILabel!
    @IBOutlet var topInitiatedLabel:UILabel!
    @IBOutlet var countDownLabel:UILabel!
    @IBOutlet var callLabel:UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet var infoLabel1:UILabel!
    @IBOutlet var infoLabel2:UILabel!
    var audioPlayer:AVAudioPlayer!
    
    var Counter:Int = 5
    var timer:Timer!
    var eventID:String!
    var emergencyNoString:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Counter = 5
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(Call911ViewController._doTick), userInfo: nil, repeats: true)
        
        let alarmSound = URL(fileURLWithPath: Bundle.main.path(forResource: "Alarm", ofType: "caf")!)
        
        do{
            audioPlayer = try AVAudioPlayer(contentsOf:alarmSound)
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            audioPlayer.prepareToPlay()
            audioPlayer.play()
            
        }catch {
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        audioPlayer.stop()
        timer.invalidate()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showCameraCanvas"), object: nil)
    }
    
    @IBAction func closeScreen()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    func _visualize()
    {
        
        cancelButton.layer.borderColor = UIColor(red: 0.64, green: 0, blue: 0.08, alpha: 1.0).cgColor;
        let phoneNo = _g_EmergencyPhone[kUserPreferences.emergencyPhone()!] as! String
        if(phoneNo.length > 0){
            titleLabel.text = String(format:"Calling %@...",phoneNo)
            topInitiatedLabel.text = String(format:"You have initiated a %@ call.",phoneNo)
            emergencyNoString = phoneNo
        }
        else
        {
            titleLabel.text = String(format:"Calling %@...","911")
            topInitiatedLabel.text = String(format:"You have initiated a %@ call.","911")
            emergencyNoString = "911"
            
        }
        
    }
    
    
    
    
    func _doTick()
    {
        Counter -= 1;
        if(Counter == 0)
        {
            topInitiatedLabel.text = kText_911_IS_BEING_CALLED
            //infoLabel1.isHidden = false
            //infoLabel2.isHidden = false
            
            countDownLabel.isHidden = true
            callLabel.isHidden = true
        }
            
        else if(Counter < 0)
        {
            
            kAppDelegate.canSendSafeNotification = false
            sendEmergencyNotificationToContacts()
            
            
            let callUrl = URL(string:String(format: "tel:%@", emergencyNoString))
            
            //let callUrl = NSURL(string:String(format: "tel:%@", "+14255039467"))
            
            if( UIApplication.shared.canOpenURL(callUrl!))
            {
                UIApplication.shared.openURL(callUrl!)
            }
            
            closeScreen()
        }
            
        else
        {
            countDownLabel.text = String(format:"%d", Counter)
            //need to implement service check old once
        }
    }
    
    
    
    
    func sendEmergencyNotificationToContacts()  {
        
        
        var paramDict:NSDictionary
        
        var lat = ""
        var longi = ""
        
        if(kLocation.locationStatus == CLAuthorizationStatus.authorizedWhenInUse)
        {
            lat = String(format: "%lf",kLocation.currentLocation.coordinate.latitude)
            longi = String(format: "%lf",kLocation.currentLocation.coordinate.longitude)
        }
        
        if let eventId = kUserPreferences.eventId(){
            paramDict  = ["id":eventId,"name":"New Event","initialLat":lat,"initialLong":longi]
        }
        else{
            paramDict  = ["name":"New Event","initialLat":lat,"initialLong":longi]
        }
        
        
        let manager = AFHTTPSessionManager(baseURL:URL(string:kHostname)!, sessionConfiguration: URLSessionConfiguration.default)
        manager.responseSerializer = AFJSONResponseSerializer()
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=utf-8", forHTTPHeaderField:"Content-Type")
        manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        manager.requestSerializer.timeoutInterval = 60.0
        manager.post(
            kService_EventCall911,
            parameters: paramDict,
            success: { (task, responseObject) in
                
                let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                if httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299 {
                    
                    var paramDict1:NSDictionary
                    if(kUserPreferences.eventId() != nil){
                        
                        paramDict1  = ["eventId":((responseObject as AnyObject!).object(forKey: "id") as! String),"userId":kUserPreferences.currentProfileId()!,"dialno" :self.emergencyNoString,"msgtype":"dangervideo"]
                    }
                    else{
                        paramDict1  = ["eventId":((responseObject as AnyObject!).object(forKey: "id") as! String),"userId":kUserPreferences.currentProfileId()!,"msgtype":"danger","dialno" :self.emergencyNoString]
                    }
                    
                    
                    manager.post(
                        kService_Emergency,
                        parameters: paramDict1,
                        success: { (task, responseObject) in
                            
                        },
                        failure: { (task, error) in
                            
                        }
                    )
                }
            },
            
            failure: { (task: URLSessionDataTask?, error: Error!) in
                
            }
        )
        
        
    }
    
    
}
