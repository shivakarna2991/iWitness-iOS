//
//  HomeViewController.swift
//  iWitness
//
//  Created by Sravani on 01/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
import MapKit
import MessageUI
import CameraManager
import AVFoundation
import CoreMotion
import AFNetworking

class HomeViewController: BaseViewController,MFMessageComposeViewControllerDelegate,UIAlertViewDelegate {
    
    @IBOutlet var topUnRecordedView:UIView!
    @IBOutlet var bottomUnRecordedView:UIView!
    @IBOutlet var bg_unrecordImgView:UIImageView!
    
    @IBOutlet weak var flashlightIconImageView: UIImageView!
    @IBOutlet var torchButton :UIButton!
    @IBOutlet var bottomMapDisplayBtn:UIButton!
    @IBOutlet var bottomVideoDisplayBtn:UIButton!
    @IBOutlet var videoListDisplayBtn:UIButton!
    @IBOutlet var mapView:MKMapView!
    @IBOutlet var topStatusLbl:UILabel!
    @IBOutlet var notificationCountlbl:UIButton!
    @IBOutlet var topLeftBorderView:UIView!
    @IBOutlet var topRightBorderView:UIView!
    
    //Recoreded View Outlets
    
//    @IBOutlet var bottomRecordedView:UIView!
//    @IBOutlet var tap_On_OffBtn:UIButton!
//    @IBOutlet var shake_On_OffBtn:UIButton!
    
    //Send Notification View
    
    @IBOutlet var sendNotificationView:UIView!
    
    //Camera View
    @IBOutlet var cameraView:UIView!
    @IBOutlet var msgLabelToEnableCamera:UILabel!
    var secondsToRecordVideo:NSInteger!
    var pause_secondsToRecordVideo:NSInteger!
    var _dateFormatter = DateFormatter()
    //var tapGesture:UITapGestureRecognizer!
    
    var userWantToContinue:Bool = false
    
    
    var videoAlert:UIAlertController!
    @IBOutlet weak var changeCameraIcon: UIImageView!
    var noOfTimesToShowAlert:NSInteger = 0
    var sendNotificationToShowVideosAlert = false
    
    var motionManager: CMMotionManager!
    
    @IBOutlet var bottomRecordedViewConstaraint:NSLayoutConstraint!
    @IBOutlet var bottomUnRecordedViewConstaraint:NSLayoutConstraint!
    @IBOutlet var SendNotificationViewTopConstraint:NSLayoutConstraint!
    @IBOutlet var SendNotificationViewBottomConstraint:NSLayoutConstraint!
    
    
    var topbarStatusTimer:Timer?
    var cameraTimer:Timer?
    var isAppRecordingVideo = false
    var cameraManager =  CameraManager()
    var recordStartName : String!
    var videoCount : Int!
    
    //
    //  iWitness 2.0
    //
    @IBOutlet var callMethodLbl:UILabel!
    func updateCallMethodLbl() {
        if (isShakeEnabled && isTapEnabled) {
            callMethodLbl.text = "Tap or Shake to Call"
        }
        else if (isTapEnabled && !isShakeEnabled) {
            callMethodLbl.text = "Tap to Call"
        }
        else if (isShakeEnabled && !isTapEnabled) {
            callMethodLbl.text = "Shake to Call"
        }
        else {
            callMethodLbl.text = ""
        }
    }

    @IBOutlet weak var shakeOnOffStatusImageView: UIImageView!
    var isShakeEnabled: Bool = false {
        didSet {
            shakeOnOffStatusImageView.image = UIImage(named: isShakeEnabled ? "icon_shake_red" : "icon_shake_white")
            updateCallMethodLbl()
        }
    }
    
    @IBOutlet weak var tapOnOffStatusImageView: UIImageView!
    var isTapEnabled: Bool = false {
        didSet {
            tapOnOffStatusImageView.image = UIImage(named: isTapEnabled ? "icon_police_red" : "icon_police_white")
            updateCenterLabel()
            updateCallMethodLbl()
        }
    }
    
    
    @IBOutlet weak var isAlarmEnabledImageView: UIImageView!
    var isAlarmEnabled: Bool = false {
        didSet {
            isAlarmEnabledImageView.image = UIImage(named: isAlarmEnabled ? "icon_alarm_red" : "icon_alarm_white")
            updateCenterLabel()
            updateCallMethodLbl()
        }
    }
    
    @IBOutlet weak var isContactEnabledImageView: UIImageView!
    var isContactEnabled: Bool = false {
        didSet {
            isContactEnabledImageView.image = UIImage(named: isContactEnabled ? "icon_emergency_contact_red" : "icon_emergency_contact_white")
            updateCenterLabel()
            updateCallMethodLbl()
        }
    }
    
    @IBOutlet weak var centerLabel: UILabel!
    func updateCenterLabel() {
        if isTapEnabled {
            centerLabel.text = "911"
        }
        else if isContactEnabled {
            centerLabel.text = "CONTACT"
        }
        else if isAlarmEnabled {
            centerLabel.text = "ALERT"
        }
        else {
            centerLabel.text = ""
        }
    }
    
    
    @IBOutlet weak var isRecordingImageView: UIImageView!
    @IBOutlet weak var isRecordingLabel: UILabel!
    var isRecording: Bool = false {
        didSet {
            isRecordingImageView.image = UIImage(named: isRecording ? "icon_recording_on" : "icon_recording_off")
            isRecordingLabel.isHidden = !isRecording
            if (isRecording) {
                isShowingMap = false
            }
        }
    }
    
    @IBOutlet weak var recordTimerLabel: UILabel!
    
    
    @IBOutlet weak var mapIconImageView: UIImageView!
    var isShowingMap: Bool = false {
        didSet {
            if (isShowingMap) {
                //msgLabelToEnableCamera.isHidden = true
                //
                //bottomMapDisplayBtn.isHidden = true
                //bottomVideoDisplayBtn.isHidden = false
                
                if(kLocation.locationStatus == CLAuthorizationStatus.authorizedWhenInUse && (kLocation.currentLocation != nil)){
                    let center = CLLocationCoordinate2D(latitude:kLocation.currentLocation.coordinate.latitude, longitude:kLocation.currentLocation.coordinate.longitude)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                    self.mapView.setRegion(region, animated: true)
                }
                
                mapIconImageView.image = UIImage(named: "icon_location_white")
                mapView.isHidden = false
                cameraView.isHidden = true
            }
            else {
                mapView.isHidden = true
                cameraView.isHidden = false
                mapIconImageView.image = UIImage(named: "icon_location_red")
            }
            
        }
    }
    
    @IBOutlet weak var cameraCanvasView: UIView!
    
    
    //
    //
    //
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController._handleUIApplicationDidBecomeActiveNotification), name:NSNotification.Name.UIApplicationDidBecomeActive , object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController._handleUIApplicationWillResignActiveNotification), name:NSNotification.Name.UIApplicationWillResignActive , object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.dismissNotificationScene), name:NSNotification.Name(rawValue: "showOnlyCameraScreen") , object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(HomeViewController.showCameraCanvasView),
                                               name:NSNotification.Name(rawValue: "showCameraCanvas"),
                                               object: nil)

        recordStartName = self.generateFileNameWithCurrentTime()
        videoCount = 0
        _visualize()
        
        setCameraManager()
        UpdateStatusLabels()

        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeViewController.UpdateStatusLabels), name:NSNotification.Name(rawValue: kNotification_EmergencyNumberChanged) , object: nil)
        
    }
    
    
    
    func getTinyUrl()  {
        
        let lat : String = String(format: "%f",kLocation.currentLocation.coordinate.latitude)
        let longi : String = String(format: "%f",kLocation.currentLocation.coordinate.longitude)
        
        let longUrl : String = String(format:"https://maps.google.com/maps?q=%@,%@",lat ,longi)
        self.showloader()
        
        
        
        let urlPath = "https://tinyurl.com/api-create.php?url=" + longUrl
        guard let endpoint = URL(string: urlPath) else {
            return
        }
        let request = URLRequest(url:endpoint)
        
        URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { (data1, response, error) in
            if ((error) != nil)
            {
                self.messageCompose(kText_EmergencyTextMessage)
            }
            else
            {
                let dataString : String = NSString(data: data1!, encoding:String.Encoding.utf8.rawValue) as! String
                
                CLGeocoder().reverseGeocodeLocation(kLocation.currentLocation, completionHandler: {(placemarks, error) -> Void in
                    
                    if placemarks != nil{
                        if placemarks!.count > 0 {
                            let pm:CLPlacemark  = placemarks![0]
                            if let name = pm.name{
                                let strMess : String = kText_EmergencyTextMessage + "\n" + "Geo location: " + dataString + "\n" + "Address: "
                                var add:String = ""
                                
                                if (pm.thoroughfare != nil && name != pm.thoroughfare){
                                    
                                    if (pm.subThoroughfare != nil && pm.subThoroughfare != pm.thoroughfare){
                                        
                                        add = String(format:"%@ %@ %@ %@ %@ %@",name,pm.thoroughfare!,pm.subThoroughfare!, pm.locality!,pm.subLocality!,pm.administrativeArea!)
                                    }
                                    else{
                                        add = String(format:"%@ %@ %@ %@ %@",name,pm.thoroughfare!, pm.locality!,pm.subLocality!,pm.administrativeArea!)
                                    }
                                    
                                }
                                    
                                else{
                                    add = String(format:"%@ %@ %@ %@",name, pm.locality!,pm.subLocality!,pm.administrativeArea!)
                                    
                                }
                                
                                
                                self.messageCompose(strMess + add)
                                
                            }
                        }
                    }
                    
                })
                
            }
            
            }) .resume()
    }
    
    
    func messageCompose(_ messageString : String) {
        
        self.removeloader()
        
        
        let messageVC = MFMessageComposeViewController()
        messageVC.messageComposeDelegate = self
        
        var finalListOfRecipients = [String]()
        for dict  in kAppDelegate.contactsArray {
            
            if((dict["flags"] as! NSInteger) == ContactStatus.accepted.rawValue)
            {
                if ((dict["phone"] as! String).range(of: "+") != nil)
                    
                {
                    finalListOfRecipients.append(dict["phone"] as! String)
                }
                else
                {
                    finalListOfRecipients.append("+" + (dict["phone"] as! String))
                }
            }
            
        }
        
        messageVC.recipients = finalListOfRecipients
        messageVC.body = messageString
        self.present(messageVC, animated: true, completion: nil)
    }
    
    func _handleUIApplicationDidBecomeActiveNotification()
    {
        self.viewDidAppear(true)
    }
    
    func _handleUIApplicationWillResignActiveNotification()
    {
        self.viewWillDisappear(true)
    }
    
    //    func userLoggedOutOfApp()
    //    {
    //        if(isAppRecordingVideo == true){
    //             Stop_StoreRecordedVideoPath()
    //        }
    //    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        updateMsglabelToEnableCamera()
        
        if(kAppDelegate.notificationUnreadCount > 0){
            notificationCountlbl.setTitle(String(kAppDelegate.notificationUnreadCount), for: UIControlState())
        }
        else
        {
            notificationCountlbl.isHidden = true
        }
        
        kAppDelegate.isSubscriptionRenew = false
    }
    
    override func viewDidAppear(_ animated: Bool){
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
        
        
        if(self.isAppRecordingVideo == true){
            self.isAppRecordingVideo = true
            
            if(self.cameraTimer == nil){
                self.cameraTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HomeViewController.updateVideoRecordingSettings), userInfo: nil, repeats: true)
            }
            self.cameraManager.startRecordingVideo()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        
        if(self.isAppRecordingVideo == true){
            self.Stop_StoreRecordedVideoPath()
            self.isAppRecordingVideo = true
        }
        
        if(self.cameraTimer != nil){
            self.cameraTimer?.invalidate()
            self.cameraTimer = nil
        }
        
        
    }
    //below two methods are for motion events(some times not detecting shake events, for that)
    
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        self.title = kText_AppName
        //   let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.Plain, target: self, action:"call911BtnTapped")
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(HomeViewController.menuBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item
        
        topLeftBorderView.alpha = 0.5
        topRightBorderView.alpha = 0.5
        
        self.sendNotificationView.translatesAutoresizingMaskIntoConstraints = false
        
        SendNotificationViewTopConstraint.constant = -(self.view.frame.size.height)
        SendNotificationViewBottomConstraint.constant = (self.view.frame.size.height)
        
        isShakeEnabled = kUserPreferences.enableShake()
        isTapEnabled = kUserPreferences.enableTap()
        isContactEnabled = kUserPreferences.enableContact()
        isAlarmEnabled = kUserPreferences.enableAlarm()
        
        isRecording = false
        recordTimerLabel.text = recordTimeText() // "10:00"
    }
    
    
    func enableTorch(_ enable:Bool)
    {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        if (device?.hasTorch)! {
            do {
                try device?.lockForConfiguration()
                
                if(enable == true)
                {
                    device?.torchMode = AVCaptureTorchMode.on
                    
                }
                else{
                    device?.torchMode = AVCaptureTorchMode.off
                    
                }
                device?.unlockForConfiguration()
            } catch {
            }
        }
    }
    
    func setCameraManager()
    {
        cameraManager.cameraOutputMode = .videoWithMic
        cameraManager.cameraOutputQuality = .medium
        cameraManager.writeFilesToPhoneLibrary = false
        cameraManager.showAccessPermissionPopupAutomatically = true
        cameraManager.shouldRespondToOrientationChanges = false
        
        if(kUserPreferences.enableTorch() ){
            torchButton.isSelected = kUserPreferences.enableTorch()
            enableTorch(true)
        }
        cameraView.isHidden = false
        _ = cameraManager.addPreviewLayerToView(self.cameraView)
        
        _dateFormatter.timeZone = TimeZone(identifier:"UTC") //better to consider default device timezone
        _dateFormatter.dateFormat = "mm:ss"
    }
    
    //MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        kAppController!.menuBtnTapped()
    }
    
    //    @IBAction func call911BtnTapped()
    //    {
    //
    //    }
    
    
    
    func UpdateStatusLabels()
    {
        if(isAppRecordingVideo == false){
            
            topStatusLbl.text = String(format: "Pressing \"REC\" button WILL NOT automatically call %@.", self.getEmergencyPhoneNoAsString())

        }
//        updateTaporShakeStausLabelTextForCall()
    }
    
    
    @IBAction func notificationsBtnTapped()
    {
        
        let notificationVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "NotificationsVCId") as! NotificationsListViewController
        notificationVC.isScreenFromHomeScreen  = true
        
        self.navigationController?.pushViewController(notificationVC, animated: true)
        
    }
    
    func updateRecordingStatusText()
    {
        
        if( topStatusLbl.text == kText_StreamingText)
        {
            topStatusLbl.text  = kText_RecordingTimerText
        }
        else if( topStatusLbl.text == kText_RecordingTimerText)
        {
            topStatusLbl.text = kText_StreamingText
        }
        
    }
    
    
    @IBAction func videosListBtnTapped()
    {
        let videosListVC =  UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VideosVCId") as! VideosListViewController
        videosListVC.isScreenFromHomeScreen  = true
        videosListVC.isScreenAfterVideoRecorded = sendNotificationToShowVideosAlert
        self.navigationController?.pushViewController(videosListVC, animated: true)
        
        sendNotificationToShowVideosAlert =  false //to reintialize
        
    }
    
    
    @IBAction func mapViewBtnTapped()
    {
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        
        isShowingMap = !isShowingMap;
    }
    
    @IBAction func bottomBarButtonAction(_ sender: UIButton) {
        
        let menuVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "HomeScreenMenu") as! HomeMenuController
        menuVC.isTapEnabled = kUserPreferences.enableTap()
        menuVC.isContactEnabled = kUserPreferences.enableContact()
        menuVC.isAlarmEnabled = kUserPreferences.enableAlarm()
        menuVC.homeVC = self
        menuVC.completion = { (vc: HomeMenuController) -> Void in
            kUserPreferences.setEnableTap(vc.isTapEnabled)
            self.isTapEnabled = vc.isTapEnabled
            
            kUserPreferences.setEnableAlarm(vc.isAlarmEnabled)
            self.isAlarmEnabled = vc.isAlarmEnabled
            
            kUserPreferences.setEnableContact(vc.isContactEnabled)
            self.isContactEnabled = vc.isContactEnabled
        }
        present(menuVC, animated: true, completion: nil)
    }
    
    
    func updateMsglabelToEnableCamera()
    {
        if(checkCamera() == false)
        {
            msgLabelToEnableCamera.isHidden = false
        }
        else{
            msgLabelToEnableCamera.isHidden = true
        }
    }
    
    
    @IBAction func videoDisplayBtnTapped()
    {
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }

        updateMsglabelToEnableCamera()

        bottomMapDisplayBtn.isHidden = false
        bottomVideoDisplayBtn.isHidden = true
        
        mapView.isHidden = true
        // bg_unrecordImgView.hidden = false
        cameraView.isHidden = false
    }
    
    
    func checkCamera() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if(authStatus == .authorized){
            
            return true
        }
        else{
            
            return false
        }
        
    }
    
    func checkMicrophone() -> Bool {
        let authStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeAudio)
        
        if(authStatus == .authorized){
            
            return true
        }
        else{
            
            return false
        }
        
    }
    
    
    func alertToEncourageCameraAccessInitially() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera and Microphone access is required to use this application",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow access", style: .cancel, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplicationOpenSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Please provide access to Camera and Microphone to record a video",
            preferredStyle: UIAlertControllerStyle.alert
        )
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel) { alert in
            if AVCaptureDevice.devices(withMediaType: AVMediaTypeVideo).count > 0 {
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo) { granted in
                    DispatchQueue.main.async {
                        self.startRecord() } }
            }
            }
        )
        present(alert, animated: true, completion: nil)
    }
    
    
    
    @IBAction func toggleRecordAction(_ sender: Any) {
        if (isRecording) {
            stopRecord()
            isRecording = false
        }
        else {
            startRecord()
            isRecording = true
        }
    }
    
    @IBAction func startRecord()
    {
        
        if(kUtilities.isAccountExpired(kUserPreferences.getProfileData()!)){
            kAppController!.showExpiredSubscriptionAlert()
            return
        }
        
        
        if(checkCamera() == false && mapView.isHidden == true)
        {
            msgLabelToEnableCamera.isHidden = false
            self.view.bringSubview(toFront: msgLabelToEnableCamera)

        }
        
        if(!(checkCamera() == true && checkMicrophone() == true))
        {
            alertToEncourageCameraAccessInitially()
            return
        }
        
        kAppDelegate.isTerminateRecord = false
        
        if(mapView.isHidden == false)
        {
            videoDisplayBtnTapped()
        }
        
        kUserPreferences.setEventId(kUtilities.randomIdentifier())
        kUserPreferences.save()
        self.videoCount = 0
        
        
        kAppDelegate.canSendSafeNotification = true
        
        
        self.secondsToRecordVideo = kUserPreferences.recordTime()
        userWantToContinue = false
        
        if(self.secondsToRecordVideo == 600)
        {
            noOfTimesToShowAlert = 2
        }
        else if(self.secondsToRecordVideo == 1200)
        {
            noOfTimesToShowAlert = 1
        }
        
        // ODO - REMOVE
        //UIView.animate(withDuration: 0.3, animations: {
        //    self.bottomRecordedViewConstaraint.constant = 0.0
        //    self.bottomUnRecordedViewConstaraint.constant = -(self.bottomUnRecordedView.frame.size.height+50)
        //    self.view.layoutIfNeeded()
        //})
        
        
        //if(isAppRecordingVideo == true) //while
        //{
        showOrHideSendNotificationScene(false) //if notifications scene is visible it willmake hide
        //  return
        
        // }
        
        isAppRecordingVideo = true
        
        showCameraView()
        
        
        if let timer = topbarStatusTimer
        {
            timer.invalidate()
        }
        
        topStatusLbl.text = kText_StreamingText
        topbarStatusTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(HomeViewController.updateRecordingStatusText), userInfo: nil, repeats: true)
        
    }
    
    @IBAction func stopRecord() //final stop and close the camera scne
    {
        
        self.showAlert(kText_AppName, message:"Video has finished recording.")

        isAppRecordingVideo = false
        kAppDelegate.isTerminateRecord = true

        
        hideCameraView()
        topbarStatusTimer?.invalidate()
        
        self.title = kText_AppName
        
        topStatusLbl.text = String(format: "Pressing \"REC\" button WILL NOT automatically call %@.", self.getEmergencyPhoneNoAsString())
        
        //till here is newly updated for stop
        
// To enable safe notification to apper uncomment below scenario
       
//        if(kAppDelegate.canSendSafeNotification == true)
//        {
//            kAppDelegate.canSendSafeNotification = false
//            showOrHideSendNotificationScene(true)
//            updateBottomBarUnrecordedView(true) //while showing send notification scene update bottom bar view elements
//
//        }
        
        // TODO - REMOVE
        //UIView.animate(withDuration: 0.3, animations: {
        //
        //    self.bottomRecordedViewConstaraint.constant = -(self.bottomRecordedView.frame.size.height+50)
        //    self.bottomUnRecordedViewConstaraint.constant = 0.0
        //    self.view.layoutIfNeeded()
        //})
        
        recordTimerLabel.text = recordTimeText() // "10:00"
    }
    
    
    func showOrHideSendNotificationScene(_ value:Bool)
    {
        // TODO - REMOVE
        /*
        UIView.animate(withDuration: 0.3, animations: {
            if(value == true)
            {
                self.SendNotificationViewBottomConstraint.constant = 90.0
                self.SendNotificationViewTopConstraint.constant = 64.0
                self.view.bringSubview(toFront: self.sendNotificationView)
                self.view.bringSubview(toFront: self.bottomUnRecordedView) //to show record button above than all views
            }
            else
            {
                self.SendNotificationViewTopConstraint.constant = -(self.view.frame.size.height)
                self.SendNotificationViewBottomConstraint.constant = (self.view.frame.size.height)
            }
            self.view.layoutIfNeeded()
            
        }) 
 */
    }
    
    
    func updateBottomBarUnrecordedView(_ value:Bool)
    {
        // TODO - REMOVE
        /*
        if(value == true)
        {
            bottomMapDisplayBtn.isHidden = value
            bottomVideoDisplayBtn.isHidden = value
            videoListDisplayBtn.isHidden = value
            
            bottomUnRecordedView.backgroundColor = UIColor.gray
            
        }
        else
        {
            bottomMapDisplayBtn.isHidden = value
            bottomVideoDisplayBtn.isHidden = true // As we have to Display only any of button either map or camera
            videoListDisplayBtn.isHidden = value
            
            bottomUnRecordedView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
            
        }
 */
        
    }
  
    /*
    func updateTaporShakeStausLabelTextForCall()
    {
        return
        if ( (kUserPreferences.enableShake() == false) && (kUserPreferences.enableTap() == false))
        {
            bottomStatusLbl.text = String(format:"TAP \"Call %@\"  to initiate a %@ call",self.getEmergencyPhoneNoAsString(),self.getEmergencyPhoneNoAsString())
        }
            
        else if ( (kUserPreferences.enableShake() == false) && (kUserPreferences.enableTap() == true))
        {
            bottomStatusLbl.text = String(format:"TAP screen  to initiate a %@ call",self.getEmergencyPhoneNoAsString())
        }
        else if ( (kUserPreferences.enableShake() == true) && (kUserPreferences.enableTap() == false))
        {
            bottomStatusLbl.text = String(format:"SHAKE screen  to initiate a %@ call",self.getEmergencyPhoneNoAsString())
        }
            
        else if ( (kUserPreferences.enableShake() == true) && (kUserPreferences.enableTap() == true))
        {
            bottomStatusLbl.text = String(format:"TAP or SHAKE screen  to initiate a %@ call",self.getEmergencyPhoneNoAsString())
        }
        
    }
    
    */
    
    @IBAction func shakeToCallBtnTapped()
    {
        isShakeEnabled = !isShakeEnabled
        kUserPreferences.setEnableShake(isShakeEnabled)
    }
    

    /*
    @IBAction func tapToCallBtnTapped()
    {
        if tap_On_OffBtn.isSelected == true{
            
            tap_On_OffBtn.isSelected = false
            kUserPreferences.setEnableTap(false)
            isTapEnabled = false
        }
        else
        {
            tap_On_OffBtn.isSelected = true
            kUserPreferences.setEnableTap(true)
            isTapEnabled = true
        }
        updateTaporShakeStausLabelTextForCall()
        
    }
    */
    
    @IBAction func torchbButtonTapped(_ sender: UIButton)
    {
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }

        if (cameraManager.hasFlash == true)
        {
            
            torchButton.isSelected = !(torchButton.isSelected)
            kUserPreferences.setEnableTorch(torchButton.isSelected)
            
            if(torchButton.isSelected)
            {
                enableTorch(true)
                flashlightIconImageView.image = UIImage(named: "icon_flashlight_on.png")
            }
            else
            {
                enableTorch(false)
                flashlightIconImageView.image = UIImage(named: "icon_flashlight_off.png")

            }
            
        }
        
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        if cameraManager.hasFrontCamera {
            cameraManager.cameraDevice = cameraManager.cameraDevice == CameraDevice.back ? CameraDevice.front : CameraDevice.back
            
            if cameraManager.cameraDevice == CameraDevice.back
            {
                changeCameraIcon.image = UIImage(named:"icon_camera_front.png")
                
            }
            else
            {
                changeCameraIcon.image = UIImage(named:"icon_camera_back.png")

            }
        }
        
      
    }
    
    @IBAction func keyPresseedInSendNotificationView(_ sender:UIButton)
    {
        
        
        if(sender.tag == 111)
        {
            //reloadContactsList() //first fetch emergency contacts list and then show msg screen
            sendSafeNotificationToEmergencyContacts()
            
        }else if(sender.tag == 222)
        {
            dismissNotificationScene()
            sendNotificationToShowVideosAlert = true
            videosListBtnTapped()
        }
    }
    
    
    func dismissNotificationScene()   {
        
        updateBottomBarUnrecordedView(false)
        showOrHideSendNotificationScene(false) //false means hide scene
        
    }
    
    
    func sendSafeNotificationToEmergencyContacts() {
        
        
        var lat = ""
        var longi = ""
        
        if(kLocation.locationStatus == CLAuthorizationStatus.authorizedWhenInUse)
        {
            lat = String(format: "%lf",kLocation.currentLocation.coordinate.latitude)
            longi = String(format: "%lf",kLocation.currentLocation.coordinate.longitude)
        }
        
        let paramDict  = ["name":"New Event","initialLat":lat,"initialLong":longi]
        
        kNetworkManager.executePostRequest(kService_EventCall911, parameters: paramDict as NSDictionary, requestVC: self)
        
    }
    
    
    
    //Mark:Request To fetch emergency contacts (Get request)=========================================================
    
    func reloadContactsList()
    {
        kNetworkManager.executeGetRequest(String(format: kService_Contact,kUserPreferences.currentProfileId()!), parameters: nil, requestVC: self)
    }
    
    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        
        
        if(requesteUrl == kService_EventCall911){
            
            var paramDict:NSDictionary
            paramDict  = ["eventId":(responseObject.object(forKey: "id") as! String),"userId":kUserPreferences.currentProfileId()!,"msgtype":"safe"]
            kNetworkManager.executePostRequest(kService_Emergency, parameters: paramDict, requestVC: self)
        }
        
        else if(requesteUrl == kService_Emergency)
        {
            self.showAlert(kText_AppName, message:"Notification sent sucessfully to emergency contact(s).")
            dismissNotificationScene()

        }
        
//        else if(requesteUrl == String(format: kService_Contact,kUserPreferences.currentProfileId()!))
//        {
//            
//            if(kAppDelegate.contactsArray.count > 0){
//                kAppDelegate.contactsArray.removeAllObjects()
//            }
//            
//            if(responseObject.valueForKey("_embedded")?.valueForKey("contact")?.count > 0){
//                kAppDelegate.contactsArray = (responseObject.valueForKey("_embedded")?.valueForKey("contact"))!.mutableCopy() as! NSMutableArray
//            }
//            
//            showMessageScreen()
//        }
        
    }
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
//        if(requesteUrl == String(format: kService_Contact,kUserPreferences.currentProfileId()!)) {
//            self.showAlert(kText_Warning, message:kText_CouldNotLoadEmergencyContactList)
//        }
        
        
        if(requesteUrl == kService_EventCall911 || requesteUrl == kService_Emergency){
           self.showAlert(kText_Warning, message:"Failed to send notification to emergency contact(s).")
            dismissNotificationScene()
        }

    }
    
    
    //====================end of safeNotification================================================================================
    
    func showMessageScreen()
    {
        
        if(kUtilities.hasCellularCoverage()){
            
            if MFMessageComposeViewController.canSendText() {
                if(kLocation.locationStatus == CLAuthorizationStatus.authorizedWhenInUse){
                    self.getTinyUrl()
                }
                else{
                    self.messageCompose(kText_EmergencyTextMessage)
                }
            }
            else {
                dismissNotificationScene()
                self.showAlert(kText_AppName, message: "Device does not support sending messages.")
            }
        }
        else{
            dismissNotificationScene()
            self.showAlert(kText_AppName, message: "Due to SIM unavailability, unable to send notification message.")
        }
    }
    
    func messageComposeViewController(_ controller:MFMessageComposeViewController, didFinishWith result:MessageComposeResult) {
        controller.dismiss(animated: true, completion:nil)
        
        
        dismissNotificationScene()
        
        switch result.rawValue {
            
        case MessageComposeResult.sent.rawValue:
            self.showAlert(kText_AppName, message: "Message sent sucessfully to emergency contact(s).")
            
        case MessageComposeResult.cancelled.rawValue : break
            
        case MessageComposeResult.failed.rawValue :
            self.showAlert(kText_AppName, message: "Failed to send message to emergency contact(s).")
            
        default:
            break
        }
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    
    //==========================================Video Recording Functionalities=======================================================
    
    
    func showCameraView()
    {
        // cameraView.hidden = false
        
        self.cameraManager.startRecordingVideo()
        
        if let timer = cameraTimer
        {
            timer.invalidate()
        }
        
        cameraTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(HomeViewController.updateVideoRecordingSettings), userInfo: nil, repeats: true)
        
    }
    
    func showCameraCanvasView() {
        cameraCanvasView.isHidden = false
    }
    
    
    func hideCameraView()
    {
        //cameraView.hidden = true
        cameraTimer?.invalidate()
        cameraTimer = nil
        Stop_StoreRecordedVideoPath()
        
    }
    
    
    func Stop_StoreRecordedVideoPath() // to stop video locally
    {
        

       cameraManager.stopVideoRecording({ (videoURL : URL?, error : NSError?) -> Void in
        
            if(kUserPreferences.currentProfileId() == nil || kUserPreferences.eventId() == nil)
            {
                return
            }
            
            
            if(self.secondsToRecordVideo > 0) //if record time gets over
            {
                if(kUserPreferences.enableTorch() ){
                    self.enableTorch(true)
                }
                
                self.cameraManager.startRecordingVideo()
            }
            
            let fileManager = FileManager.default
            let documentPath :String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0]
            
            let clientPath = documentPath+"/"+kUserPreferences.clientId()
            
            if (!(fileManager.fileExists(atPath: clientPath)))
            {
                
                do {
                    try fileManager.createDirectory(atPath: clientPath, withIntermediateDirectories: true, attributes: nil)
                    
                }
                    
                catch _ as NSError {
                    
                    return
                }
            }
            
            let eventPath = clientPath + "/" + kUserPreferences.eventId()!
            
            if (!(fileManager.fileExists(atPath: eventPath)))
            {
                do {
                    try fileManager.createDirectory(atPath: eventPath, withIntermediateDirectories: true, attributes: nil)
                    
                }
                    
                catch _ as NSError {
                    
                    return
                }
            }
            
            var videoPath : String = String()
            
            if(kLocation.locationStatus == CLAuthorizationStatus.authorizedWhenInUse && (kLocation.currentLocation != nil)){
                
                
                videoPath = String(format: "%@/%ld_%@_%@_%f_%f_%@.mp4", arguments: [eventPath,self.videoCount,self.recordStartName,self.generateFileNameWithCurrentTime(),kLocation.currentLocation.coordinate.latitude,kLocation.currentLocation.coordinate.longitude,kUserPreferences.accessToken()!])
            }
            else{
                videoPath = String(format: "%@/%ld_%@_%@_%@.mp4", arguments: [eventPath,self.videoCount,self.recordStartName,self.generateFileNameWithCurrentTime(),kUserPreferences.accessToken()!])
            }
            
            
            do {
                
                
                let newVideoUrlPath = (videoURL!).description.replacingOccurrences(of: "file://", with: "")
                
                try fileManager.moveItem(atPath: newVideoUrlPath, toPath: videoPath)
            }
                
            catch _ as NSError {
                
            }
            if(kAppDelegate.isTerminateRecord){
                kUserPreferences.setEventId(nil)
                kUserPreferences.save()
                kAppDelegate.isTerminateRecord = false
            }
            
            
            self.videoCount = self.videoCount+1
        })
        
    }
    
    
    func generateFileNameWithCurrentTime() -> String  {
        let time = Date()
        let df = DateFormatter()
        df.dateFormat = "dd-MM-yyyy-hh-mm-ss"
        let timeString = df.string(from: time)
        return timeString
    }
    
    
    func updateVideoRecordingSettings()
    {
        self.secondsToRecordVideo = (self.secondsToRecordVideo-1)
        
        if (self.secondsToRecordVideo < 0) {
            self.secondsToRecordVideo = 0
        }
        
        recordTimerLabel.text = String(format: "%02d:%02d", self.secondsToRecordVideo / 60, self.secondsToRecordVideo % 60)
        
        if(self.secondsToRecordVideo <= 0 && noOfTimesToShowAlert > 0)
        {
            noOfTimesToShowAlert = (noOfTimesToShowAlert-1)
            videoAlert.dismiss(animated: true, completion: nil) //if visible
            self.secondsToRecordVideo = (self.secondsToRecordVideo+600)
            //self.secondsToRecordVideo = (self.secondsToRecordVideo+60)
        }
        
        if(self.secondsToRecordVideo <= 0) //if record time gets over
        {
            stopRecord()
            return
        }
        
        if(self.secondsToRecordVideo == 30 && noOfTimesToShowAlert > 0)
        {
            
            
            videoAlert = UIAlertController(title: kText_AppName, message: "Do you want to continue recording?", preferredStyle: .alert)
            let buttonOne = UIAlertAction(title: "Continue", style: .default, handler: { (action) -> Void in
                self.videoAlert.dismiss(animated: true, completion: nil)
                //  self.userWantToContinue = true
                
            })
            
            let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                self.videoAlert.dismiss(animated: true, completion: nil)
                // self.userWantToContinue = false
                self.noOfTimesToShowAlert = 0
            }
            videoAlert.addAction(buttonOne)
            videoAlert.addAction(buttonCancel)
            
            present(videoAlert, animated: true, completion: nil)
            
        }
        
        
        let time = Date(timeIntervalSince1970:TimeInterval(self.secondsToRecordVideo))
        self.title = _dateFormatter.string(from: time)
        
        
        if(self.secondsToRecordVideo % 5 == 0)
        {
            Stop_StoreRecordedVideoPath()
            
        }
        
    }
    
    @IBAction func actionButtonAction(_ sender: UIButton) {
        if(kUserPreferences.enableTap()) {
            cameraCanvasView.isHidden = true
            self.showCallScreen()
        }
    }
    
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?){
        
        if(kUserPreferences.enableShake()) {
            if(event!.subtype == .motionShake) {
                cameraCanvasView.isHidden = true
                self.showCallScreen()
            }
        }
    }
    
    func recordTimeText() -> String {
        let recordTime = UserPreferences.sharedInstance.recordTime()
        return String(format: "%02d:%02d", recordTime / 60, recordTime % 60)
    }
    
    
}
