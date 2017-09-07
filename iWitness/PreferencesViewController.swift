//
//  PreferencesViewController.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import ActionSheetPicker_3_0


class PreferencesViewController: BaseViewController {
    
    @IBOutlet var cameraSwitch:UISwitch!
    @IBOutlet var tapToCallSwitch:UISwitch!
    @IBOutlet var tapToShakeSwitch:UISwitch!
    @IBOutlet var timeLimitBtn:UIButton!
    @IBOutlet var emergencyNoBtn:UIButton!
    @IBOutlet var timeLimitTitleBtn:UIButton!
    @IBOutlet var emergencyNoTitleBtn:UIButton!

    // var _dateFormatter:NSDateFormatter!
    
    var keys:[String]!
    var minsArray = [Int]()
    var secondsArray = [Int]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        
        NotificationCenter.default.addObserver(self, selector: #selector(PreferencesViewController.updateEmergencyNumberBtnTitle), name:NSNotification.Name(rawValue: kNotification_EmergencyNumberChanged) , object: nil)

        _visualize()
        initDataArrays()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraSwitch.isOn = kUserPreferences.enableTorch()
        tapToCallSwitch.isOn = kUserPreferences.enableTap()
        tapToShakeSwitch.isOn = kUserPreferences.enableShake()
        
//        timeLimitBtn.layer.borderWidth = 1
//        timeLimitBtn.layer.borderColor = UIColor.grayColor().CGColor
//
//        emergencyNoBtn.layer.borderWidth = 1
//        emergencyNoBtn.layer.borderColor = UIColor.grayColor().CGColor

        updateEmergencyNumberBtnTitle()
        
        let minsectuple = getMinuteSecondsTuple(kUserPreferences.recordTime())
        let str = String(format:"%02d:%02d",minsectuple.0,minsectuple.1)
        timeLimitBtn.setTitle(str, for: UIControlState())
    }
    
    func updateEmergencyNumberBtnTitle()
    {
      
        self.emergencyNoBtn.setTitle(self.getEmergencyPhoneNoAsString(), for: UIControlState())

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
//MARK: Class's private methods=====================================================================================
    
    func _visualize()
    {
        self.title = "Preferences"
       // let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.Plain, target: self, action:"call911BtnTapped")
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(PreferencesViewController.menuBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item
        
    }
    
    
    
    func initDataArrays()
    {
        keys = (_g_EmergencyPhone.allKeys as! [String]).sorted()
        
//        for i in 0..<30
//        {
//            minsArray.append(i )
//        }
        
        minsArray = [10,20,30]
      //  secondsArray = [00]

       // for i in 0..<60
     //   {
          //  secondsArray.append(0)
     //   }
    }
    
    
    func getMinuteSecondsTuple(_ totaltime:NSInteger)-> (mins:NSInteger,secs:NSInteger)
    {
        let _secs = 0
        let _mins = (totaltime-_secs)/60
        return (_mins,_secs)
    }

    
//MARK: Action Methods=====================================================================================
    
    @IBAction func handleSwitchAction(_ sender:UISwitch)
    {
        if(sender == cameraSwitch)
        {
            kUserPreferences.setEnableTorch(cameraSwitch.isOn)
        }
        else if(sender == tapToCallSwitch)
        {
            kUserPreferences.setEnableTap(tapToCallSwitch.isOn)
        }
        else if(sender == tapToShakeSwitch)
        {
            kUserPreferences.setEnableShake(tapToShakeSwitch.isOn)
        }
        kUserPreferences.save()
    }
    
    
    @IBAction func _keyPressed(_ sender:UIButton){
        
        
        kAppDelegate.setAppActionPickerButtonItemsTextColor()
        
        if(sender == emergencyNoBtn || sender == emergencyNoTitleBtn){
            
            ActionSheetStringPicker.show(withTitle: "Select Emergency No", rows:keys, initialSelection: keys.index(of: kUserPreferences.emergencyPhone()!)!, doneBlock: {
                picker, value, index in
                
                if((_g_EmergencyPhone[(kUserPreferences.emergencyPhone()!)] as! String ) != _g_EmergencyPhone[(index as? String)!] as? String){
                    NotificationCenter.default.post(name: Notification.Name(rawValue: kNotification_LocationUpdated), object: nil)
                }
                
                kUserPreferences.setEmergencyPhone(index as? String)
                kUserPreferences.setCountryName((index as? String)!)
                kUserPreferences.save()
                
                
                let phoneNo = _g_EmergencyPhone[(index as? String)!] as! String
                if(phoneNo.length > 0){
                    self.emergencyNoBtn.setTitle(phoneNo, for: UIControlState())
                    kAppDelegate._call911Item.title = String(format:"Call %@",phoneNo)
                }
                else
                {
                    self.emergencyNoBtn.setTitle("911", for: UIControlState())
                    kAppDelegate._call911Item.title = "Call 911"
                }
                kAppDelegate.setAppNavBarButtonItemsTextColor()
                
                return
                }, cancel: {  ActionStringCancelBlock in
                    
                    kAppDelegate.setAppNavBarButtonItemsTextColor()
                    return
                }, origin: emergencyNoBtn)
        }
            
            
        else if(sender == timeLimitBtn || sender == timeLimitTitleBtn){
            
            
            var minsectuple = getMinuteSecondsTuple(kUserPreferences.recordTime())

            ActionSheetStringPicker.show(withTitle: "Time Limit (mins)", rows:minsArray, initialSelection: minsArray.index(of: minsectuple.0)!, doneBlock: {
                picker, value, index in

                let totalDuration:NSInteger = (((index as AnyObject!).intValue)*60)

                minsectuple = self.getMinuteSecondsTuple(totalDuration)
                self.timeLimitBtn.setTitle(String(format:"%02d:%02d",minsectuple.0,minsectuple.1) , for: UIControlState())
                kUserPreferences.setRecordTime(totalDuration)
                kUserPreferences.save()
                
                kAppDelegate.setAppNavBarButtonItemsTextColor()
                
                
                return
                }, cancel: {  ActionStringCancelBlock in
                    
                    kAppDelegate.setAppNavBarButtonItemsTextColor()
                    return
                }, origin: timeLimitBtn)
            
            
            
            
            
            
//            var minsectuple = getMinuteSecondsTuple(kUserPreferences.recordTime())
//            
//            ActionSheetMultipleStringPicker.showPickerWithTitle("Time Limit (mm:ss)", rows: [
//                minsArray,
//                secondsArray
//                ], initialSelection: [minsArray.indexOf(minsectuple.0)!,secondsArray.indexOf(minsectuple.1)!], doneBlock: {
//                    picker, values, indexes in
//                    
//                        let totalDuration:NSInteger = (indexes[0].integerValue*60)+indexes[1].integerValue
//                    
//                    if(totalDuration < 30)
//                    {
//                        self.showAlert(kText_AppName, message: kText_InvalidRecordTime)
//                    }
//                    else
//                    {
//                        minsectuple = self.getMinuteSecondsTuple(totalDuration)
//                        self.timeLimitBtn.setTitle(String(format:"%02d : %02d",minsectuple.0,minsectuple.1) , forState: UIControlState.Normal)
//                        kUserPreferences.setRecordTime(totalDuration)
//                        kUserPreferences.save()
//                    }
//                    
//                    kAppDelegate.setAppNavBarButtonItemsTextColor()
//                    
//                    return
//                }, cancelBlock: { ActionMultipleStringCancelBlock in
//                    kAppDelegate.setAppNavBarButtonItemsTextColor()
//                    return }, origin: timeLimitBtn)
        }
        
    }
    
    @IBAction func menuBtnTapped(){
        
        kAppController!.menuBtnTapped()
    }
    
//    @IBAction func call911BtnTapped()
//    {
//        
//    }
    
}
