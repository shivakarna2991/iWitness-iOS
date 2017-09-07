//
//  ProfileViewController.swift
//  iWitness
//
//  Created by Sravani on 03/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//
//
import UIKit
import ActionSheetPicker_3_0
import AFNetworking
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

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate{
    
    let imagePicker = UIImagePickerController()
    var gender : NSInteger!
    var heightSelection1 = [String]()
    var heightSelection2 = [String]()
    var weightSelection : NSMutableArray = NSMutableArray()
    var timeZoneSelection  : NSMutableArray!
    var timeZoneNameSelection  : [String]!
    
    var rightBtn : UIBarButtonItem!
    var rightBtn2 : UIBarButtonItem!
    var leftBtn : UIBarButtonItem!
    var isEditMode : Bool!
    var _isAvatarPresented : Bool!
    
    var stateIndex : NSInteger = 0
    var timeZoneIndex : NSInteger = 0
    var weightIndex : NSInteger = 0
    var ethinicityIndex : NSInteger = 0
    var hairColorIndex : NSInteger = 0
    var eyeColorIndex : NSInteger = 0
    var height1Index : NSInteger = 0
    var height2Index : NSInteger = 0
    var space:UIBarButtonItem!
    var bdayDate : Date!
    var minimumDate : Date!
    var isprofileInUpdate:Bool = false
    
    
    @IBOutlet var bottomConstraint:NSLayoutConstraint!
    @IBOutlet var widthConstraint:NSLayoutConstraint!
    
    
    @IBOutlet var _nameTextField:UITextField!
    @IBOutlet var _emailTextField:UITextField!
    @IBOutlet var _phoneTextField:UITextField!
    @IBOutlet var _streetTextField:UITextField!
    @IBOutlet var _address2TextField:UITextField!
    @IBOutlet var _cityTextField:UITextField!
    @IBOutlet var _zipcodeTextField:UITextField!
    @IBOutlet var _stateTextField:UITextField!
    @IBOutlet var _distinguishTextField:UITextView!
    @IBOutlet var _bdayTextField:UITextField!
    @IBOutlet var _heightTextField:UITextField!
    @IBOutlet var _weightTextField:UITextField!
    @IBOutlet var _eyeColorTextField:UITextField!
    @IBOutlet var _timezoneTextField:UITextField!
    @IBOutlet var _hairColorTextField:UITextField!
    @IBOutlet var _ethnicityTextField:UITextField!
    
    @IBOutlet var _avtarImage:UIImageView!
    @IBOutlet var _stateDropDwnBtn:UIButton!
    @IBOutlet var _weightDropDwnBtn:UIButton!
    @IBOutlet var _bdyDropDwnBtn:UIButton!
    @IBOutlet var _timeZoneDropDwnBtn:UIButton!
    @IBOutlet var _ethinicityDropDwnBtn:UIButton!
    @IBOutlet var _hairColorDropDwnBtn:UIButton!
    @IBOutlet var _eyeColorDropDwnBtn:UIButton!
    @IBOutlet var _heightDropDwnBtn:UIButton!
    @IBOutlet var _uploadPhotoBtn:UIButton!
    @IBOutlet var _maleButton:UIButton!
    @IBOutlet var _femaleButton:UIButton!
    @IBOutlet var _maleTopButton:UIButton!
    @IBOutlet var _femaleTopButton:UIButton!
    @IBOutlet var _scrollView:UIScrollView!
    @IBOutlet var _profilePicActivity:UIActivityIndicatorView!
    @IBOutlet weak var _logoutButton: UIButton!
    
    
    var fr : UIView?

    var datePickerView:UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addPadding()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        _visualize()
        self.automaticallyAdjustsScrollViewInsets = false
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        initArrays()
        self.fetchProfileInformation()
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillShow(_:)), name:NSNotification.Name.UIKeyboardWillShow, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController.keyboardWillHide(_:)), name:NSNotification.Name.UIKeyboardWillHide, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(ProfileViewController._handleReachabilityStateChangedNotification), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
        
        let cal = Calendar.current
        minimumDate = Date()
        minimumDate = (cal as NSCalendar).date(byAdding: NSCalendar.Unit.year, value: -100, to: minimumDate, options: NSCalendar.Options.matchStrictly)!
        
        _logoutButton.layer.borderColor = UIColor(white: 0.6, alpha: 1.0).cgColor
    }
    
    
    
    func addPadding() {
        
        let paddingView : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _streetTextField.leftView = paddingView
        _streetTextField.leftViewMode = UITextFieldViewMode.always
        
        
        let paddingView1 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        
        _cityTextField.leftView = paddingView1
        _cityTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView2 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _zipcodeTextField.leftView = paddingView2
        _zipcodeTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView3 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _weightTextField.leftView = paddingView3
        _weightTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView4 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _eyeColorTextField.leftView = paddingView4
        _eyeColorTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView5 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _hairColorTextField.leftView = paddingView5
        _hairColorTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView6 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _heightTextField.leftView = paddingView6
        _heightTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView7 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _ethnicityTextField.leftView = paddingView7
        _ethnicityTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView8 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _heightTextField.frame.size.height))
        
        _timezoneTextField.leftView = paddingView8
        _timezoneTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView9 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _bdayTextField.frame.size.height))
        
        _bdayTextField.leftView = paddingView9
        _bdayTextField.leftViewMode = UITextFieldViewMode.always
        
        let paddingView10 : UIView = UIView.init(frame: CGRect(x: 0, y: 0, width: 10, height: _address2TextField.frame.size.height))
        
        _address2TextField.leftView = paddingView10
        _address2TextField.leftViewMode = UITextFieldViewMode.always
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // addGestures()
     }
    
    //MARK: Class's private methods
    
    func _visualize()
    {
        
        isEditMode = true
        self.title = "Profile"
        self._profilePicActivity.isHidden = true
        rightBtn = kAppDelegate._call911Item
//        rightBtn2 = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(ProfileViewController.editClicked))
        leftBtn = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(ProfileViewController.menuBtnTapped))
        
//        self.navigationItem.setRightBarButtonItems([rightBtn2,rightBtn], animated: true)
        
        space = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        space.width = 20 // adjust as needed

        self.navigationItem.leftBarButtonItem = leftBtn
        self.navigationItem.setRightBarButtonItems([rightBtn], animated: true)
        
        _streetTextField.layer.borderWidth = 1
        _address2TextField.layer.borderWidth = 1
        _cityTextField.layer.borderWidth = 1
        _zipcodeTextField.layer.borderWidth = 1
        _stateTextField.layer.borderWidth = 1
        _distinguishTextField.layer.borderWidth = 1
        _heightTextField.layer.borderWidth = 1
        _eyeColorTextField.layer.borderWidth = 1
        _timezoneTextField.layer.borderWidth = 1
        _weightTextField.layer.borderWidth = 1
        _ethnicityTextField.layer.borderWidth = 1
        _hairColorTextField.layer.borderWidth = 1
        _bdayTextField.layer.borderWidth = 1
        
        _maleButton.layer.borderWidth = 1
        _femaleButton.layer.borderWidth = 1
        
        _distinguishTextField.textColor = UIColor.lightGray
        
        _streetTextField.layer.borderColor = kLightGrayColor
        _address2TextField.layer.borderColor = kLightGrayColor
        _cityTextField.layer.borderColor = kLightGrayColor
        _zipcodeTextField.layer.borderColor = kLightGrayColor
        _stateTextField.layer.borderColor = kLightGrayColor
        _distinguishTextField.layer.borderColor = kLightGrayColor
        _heightTextField.layer.borderColor = kLightGrayColor
        _weightTextField.layer.borderColor = kLightGrayColor
        _eyeColorTextField.layer.borderColor = kLightGrayColor
        _timezoneTextField.layer.borderColor = kLightGrayColor
        _hairColorTextField.layer.borderColor = kLightGrayColor
        _ethnicityTextField.layer.borderColor = kLightGrayColor
        _bdayTextField.layer.borderColor = kLightGrayColor
        
        _maleButton.layer.borderColor = kLightGrayColor
        _femaleButton.layer.borderColor = kLightGrayColor
        
        _avtarImage.layer.cornerRadius = _avtarImage.frame.width/2.0 ;
        _avtarImage.layer.masksToBounds = true
        
        self.handleEnablingField(true)
        
        let scrollGesture = UITapGestureRecognizer(target: self, action: #selector(ProfileViewController.scrollEndEditing(_:)))
        scrollGesture.numberOfTapsRequired = 1
        _scrollView.addGestureRecognizer(scrollGesture)
    }
    
    func initArrays()
    {
        heightSelection1 = ["0'","1'","2'","3'","4'","5'","6'","7'"]
        heightSelection2 = ["0\"","1\"","2\"","3\"","4\"","5\"","6\"","7\"","8\"","9\"","10\"","11\""]
        for index in stride(from: 10, to: 510, by: 10) {
            weightSelection.add("\(index) lb")
        }
        
       
        let timeZoneArr = NSArray(contentsOfFile:Bundle.main.path(forResource: "Timezone", ofType:"plist")!)
        
        timeZoneSelection = timeZoneArr!.mutableCopy() as! NSMutableArray
        
        timeZoneNameSelection = timeZoneArr!.value(forKey: "Name") as! [String]
        
    }
    
    func handleEnablingField(_ isEnabling : Bool){
        
        _nameTextField.isEnabled = isEnabling
        _emailTextField.isEnabled = isEnabling
        _phoneTextField.isEnabled = isEnabling
        _streetTextField.isEnabled = isEnabling
        _address2TextField.isEnabled = isEnabling
        _bdayTextField.isEnabled = isEnabling
        _cityTextField.isEnabled = isEnabling
        _zipcodeTextField.isEnabled = isEnabling
        _stateTextField.isEnabled = isEnabling
        _distinguishTextField.isUserInteractionEnabled = isEnabling
        _heightTextField.isEnabled = isEnabling
        _eyeColorTextField.isEnabled = isEnabling
        _timezoneTextField.isEnabled = isEnabling
        _weightTextField.isEnabled = isEnabling
        _ethnicityTextField.isEnabled = isEnabling
        _hairColorTextField.isEnabled = isEnabling
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      //  kAppDelegate.isLoginScreen =  true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // kAppDelegate.isLoginScreen =  false
        
    }
    

    
    func showHomeScreen() {
       
        kAppController!.isExpanded = true  // this is kept as true bcz in menuDidSelectedRow method calling menubtntapped action which will reopen slide window, for stopping it make it as true
        kAppController!.menuDidSelectedRow(0)

    }
    
    
    func fetchProfileInformation() {
        
        kNetworkManager.executeGetRequest(String(format: kService_User,kUserPreferences.currentProfileId()!), parameters: nil, requestVC: self)

    }
    
    func fetchProfileInformation1()
        
    {
        
        if !kAppDelegate.isInterentConnected()
        {
            self.showAlert(kText_NoNetWorkTitle, message:kText_NoNetWorkMessage)
            return;
        }
        
        self.showloader()
        
        let manager = AFHTTPSessionManager(baseURL:URL(string:kHostname)!, sessionConfiguration: URLSessionConfiguration.default)
        
        manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        manager.requestSerializer.timeoutInterval = 60.0
        manager.get(String(format: kService_User,kUserPreferences.currentProfileId()!),parameters: nil,
            success: { (task: URLSessionDataTask!, responseObject1: Any!) in
                
                DispatchQueue.main.async(execute: {
                    
                    self.removeloader()
                    let httpResponse: HTTPURLResponse = task.response as! HTTPURLResponse
                    if (httpResponse.statusCode >= 200 || httpResponse.statusCode <= 299){
                        
                        kUserPreferences.setProfileData(responseObject1 as? NSDictionary)
                        kUserPreferences.setCurrentProfileId((responseObject1 as AnyObject).value(forKey: "id") as? String)
                        kUserPreferences.setCurrentUsername((responseObject1 as AnyObject).value(forKey: "phone") as? String)
                        self.presentProfileWith(responseObject1 as! [String : AnyObject])
                        
                    } else {
                        
                        self.requestErrorCode(responseObject1 as AnyObject!, requesteUrl: String(format: kService_User,kUserPreferences.currentProfileId()!), statusCode:httpResponse.statusCode)
                    }
                })
            },
            failure: { (task: URLSessionDataTask?, error: Error!) in
                DispatchQueue.main.async(execute: {
                    self.removeloader()
                    
                    
                    
                    if let underError = (error as NSError!).userInfo["NSUnderlyingError"]{
                        if let responseData = (underError as AnyObject).userInfo["com.alamofire.serialization.response.error.data"]{
                            
                            let httpResponse: HTTPURLResponse = task!.response as! HTTPURLResponse
                            
                            do {
                                let obj = try JSONSerialization.jsonObject(with: responseData as! Data, options: [JSONSerialization.ReadingOptions.allowFragments]) as! NSDictionary
                                self.requestErrorCode(obj, requesteUrl: String(format: kService_User,kUserPreferences.currentProfileId()!),statusCode:httpResponse.statusCode)
                                return
                                
                            } catch {
                            }
                            
                        }
                    }
                    
                    else{
                    
                    self.showAlert(kText_AppName, message:"Unable to process your request at the moment")
                    }
                    
                    }
                )
            }
        )
    }
    
    func presentProfileWith(_ responseObject:[String:AnyObject]){
        
       // var firstname : String   = responseObject.objectForKey("firstName") as! String
       // var lastname : String     = responseObject.objectForKey("lastName") as! String
        //var email : String    = responseObject.objectForKey("email") as! String
       // var phone : String      = responseObject.objectForKey("phone") as! String
        
        
        var firstname : String = ""
        if let value = responseObject["firstName"] as? String
        {
            firstname = value
        }
        
        var lastname : String = ""
        if let value = responseObject["lastName"] as? String
        {
            lastname = value
        }

        
        var email : String = ""
        if let value = responseObject["email"] as? String
        {
            email = value
        }

        
        var phone : String = ""
        if let value = responseObject["phone"] as? String
        {
            phone = value
        }
        
        var address1 : String = ""
        if let value = responseObject["address1"] as? String
        {
          address1 = value
        }
        
        
        var address2 : String = ""
        if let value = responseObject["address2"] as? String
        {
            address2 = value
        }
        
        
        var city : String = ""
        if let value = responseObject["city"] as? String
        {
            city = value
        }

        
        var state : String   = ""
        if let value = responseObject["state"] as? String
        {
            state = value
        }
        
        var zipcode : String   = ""
        if let value = responseObject["zip"] as? String
        {
            zipcode = value
        }
        
        var disFeature : String   = ""
        if let value = responseObject["distFeature"] as? String
        {
            disFeature = value
        }

        var ethnicity : String   = ""
        if let value = responseObject["ethnicity"] as? String
        {
            ethnicity = value
        }

        var eyeColor : String   = ""
        if let value = responseObject["eyeColor"] as? String
        {
            if(value.length > 0){
              
                if(value == "Other")
               {
                eyeColor = "Other colored eyes"
               }
              else{
                eyeColor = (value+" "+"eyes")
                }
            }
        }

        var hairColor : String   = ""
        if let value = responseObject["hairColor"] as? String
        {
          if(value.length > 0){

            if(value == "Other")
            {
                hairColor = "Other colored hair"
            }
            else if(value == "Blond")
            {
                hairColor = "Blond(e) hair"
            }
            else{
                hairColor = (value+" "+"hair")
            }
          }
        }
        
        var dateNumber : Double   = 0
        if let value = responseObject["birthDate"] as? Double
        {
            dateNumber = value
            let date = Date(timeIntervalSince1970: dateNumber)
            
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone(identifier: "UTC")
            dateFormatter.dateFormat = "MM/dd/yyyy"
            bdayDate = date
            self._bdayTextField.text = dateFormatter.string(from: date)
        }
        else{
            self._bdayTextField.text = ""
        }
        
        var timezoneValue = kText_DefaultTimezone
        
        if let value =  responseObject["timezone"] as? String
        {
            for i in 0 ..< timeZoneSelection.count
            
            {
                let dict = timeZoneSelection.object(at: i)
                if((dict as AnyObject).value(forKey: "Value") as! String ==  value){
                    timezoneValue = (dict as AnyObject).value(forKey: "Name") as! String
                    timeZoneIndex = i
                    break
                }
            }
        }
        
        // Prevent null object
        
//        address1 = address1 ?? ""
//        address2 = address2 ?? ""
//        city       = city ?? ""
//        state      = state ?? ""
//        zipcode    = zipcode ?? ""
//        
//        firstname  = firstname ?? ""
//        lastname   = lastname ?? ""
//        email      = email ?? ""
//        phone      = phone ?? ""
//        
//        disFeature = disFeature ?? ""
//        ethnicity  = ethnicity ?? ""
//        eyeColor   = eyeColor ?? ""
//        hairColor  = hairColor ?? ""
        
        _streetTextField.text = address1;
        _address2TextField.text = address2;
        _cityTextField.text    = city;
        _stateTextField.text   = state;
        _zipcodeTextField.text = zipcode;
        
        if(disFeature.length == 0){
           _distinguishTextField.text =  "Additional Distinguishing Features"
            _distinguishTextField.textColor = UIColor.lightGray
        }
        else{
            _distinguishTextField.text = disFeature
            _distinguishTextField.textColor = UIColor.black
        }
        
        _emailTextField.text = email;
        _ethnicityTextField.text = ethnicity;
        _eyeColorTextField.text = eyeColor;
        _timezoneTextField.text = timezoneValue;
        _hairColorTextField.text = hairColor;
        _nameTextField.text = firstname + " " + lastname
        _phoneTextField.text = phone;
        
       // var index : NSInteger
        
        if(_stateTextField.text!.isEmpty){
          
            stateIndex = 0
        }
        else
        {
            if(_g_stateCode.contains(_stateTextField.text!)){
                stateIndex = _g_stateCode.index(of: _stateTextField.text!)!
            }
            else{
                stateIndex = 0
            }
        }
        
        
        if(_ethnicityTextField.text!.isEmpty){
            
            ethinicityIndex = 0
        }
        else
        {
            if(_kEthnic.contains(_ethnicityTextField.text!)){
                ethinicityIndex = _kEthnic.index(of: _ethnicityTextField.text!)!
            }
            else{
                ethinicityIndex = 0
            }
        }
        

//        var tempTimeZone = [String]()
//        tempTimeZone     = timeZoneSelection!.valueForKey("Value") as! [String]
//        print(_timezoneTextField.text!)
//        print(tempTimeZone)
//        
//        if(_timezoneTextField.text!.isEmpty){
//            
//            timeZoneIndex = 0
//        }
//        else
//        {
//            timeZoneIndex = tempTimeZone.indexOf(_timezoneTextField.text!)!
//        }
        


        if(_eyeColorTextField.text!.isEmpty){
            
            eyeColorIndex = 0
        }
        else
        {
            if(_keyeColor.contains(_eyeColorTextField.text!)){
                eyeColorIndex = _keyeColor.index(of: _eyeColorTextField.text!)!
            }
            else{
                eyeColorIndex = 0
            }
            
        }

        if(_hairColorTextField.text!.isEmpty){
            
            hairColorIndex = 0
        }
        else
        {
            if(_khairColor.contains(_hairColorTextField.text!)){
                hairColorIndex = _khairColor.index(of: _hairColorTextField.text!)!
            }
            else{
                hairColorIndex = 0
            }
        }

        // Display gender

        if let value = responseObject["gender"]{
            
            if((value as AnyObject).length > 0){
                self.gender = (value as AnyObject).intValue
                
                if(self.gender == kGender_Male){
                    _maleButton.isSelected = true
                    _femaleButton.isSelected = false
                }
                else if(self.gender == kGender_Female){
                    _maleButton.isSelected = false
                    _femaleButton.isSelected = true
                }
                else {
                    self.gender = 2
                }
            }
            else{
                self.gender = 2
            }
            
        }
        else{
            self.gender = 2
        }

        
        var heightFeet = 0
        var  heightInches = 0
        if let _ = (responseObject["heightFeet"]){
        if (responseObject["heightFeet"] is Int) {
            heightFeet = responseObject["heightFeet"]! as! Int
            heightInches = responseObject["heightInches"]! as! Int
//        } else if (responseObject["heightFeet"] is String && (!(responseObject["heightFeet"]!.isEmpty)))  {
        } else if ((responseObject["heightFeet"] is String) && (!((responseObject["heightFeet"] as! String).isEmpty)) )  {

            heightFeet = Int(responseObject["heightFeet"]! as! String)!
            heightInches = Int(responseObject["heightInches"]! as! String)!
        }
        }
        
        
        if let value = (responseObject["weight"]){
            
            let weightString  = "\(value) lb"
            if(self.weightSelection.contains(weightString)){
                self.weightIndex = weightSelection.index(of: weightString)
                _weightTextField.text = "\(value) lb"
            }
            else{
                self.weightIndex = 0
                _weightTextField.text = ""
            }
        }
        else
        {
            _weightTextField.text = ""
        }
        
        
        //(heightFeet != nil) && (heightInches != nil) &&
        if (heightFeet != 0 ) {
            //
            _heightTextField.text =     "\(heightFeet)' \(heightInches)\""
        }
        else {
            _heightTextField.text = ""
        }
        
        
        let heightFeetString : String?
        let heightInchString : String?
        if(heightFeet != 0 && heightInches != 0){
            heightFeetString  = String(heightFeet)
            heightInchString  = String(heightInches)
            height1Index = heightSelection1.index(of: "\(heightFeetString!)\'")!
            height2Index = heightSelection2.index(of: "\(heightInchString!)\"")!
        }
        
     /*   // Display height
      //  as! NSInteger
        var heightFeet : NSInteger!  = NSInteger()
        var heightInches : NSInteger!  = NSInteger()
        
        
        
        if((responseObject["heightFeet"] as AnyObject).isKind(of: NSString)) {
             heightFeet  = responseObject["heightFeet"] as! NSInteger
             heightInches  = responseObject["heightInches"] as! NSInteger
        }
        else if((responseObject["heightFeet"] as AnyObject).isKind(of: NSString)) {
             heightFeet = Int((responseObject["heightFeet"] as! String))
             heightInches = Int((responseObject["heightInches"] as! String))
        }
        else
        {
           //defaultely values would be 0 0
        }
        
        
        if let value = (responseObject["weight"]){
            
            let weightString  = "\(value) lb"
            if(self.weightSelection.contains(weightString)){
                self.weightIndex = weightSelection.index(of: weightString)
                _weightTextField.text = "\(value) lb"
            }
            else{
                self.weightIndex = 0
                _weightTextField.text = ""
            }
        }
        else
        {
            _weightTextField.text = ""
        }
        
        
        
        //(heightFeet != nil) && (heightInches != nil) &&
        if ((heightFeet != nil) &&  (heightFeet  > 0)  ) {
            //
            _heightTextField.text =     "\(heightFeet)' \(heightInches)\""
        }
        else {
            _heightTextField.text = ""
        }
        
        let heightFeetString : String
        let heightInchString : String
        if(heightFeet != nil && heightInches != nil){
            heightFeetString  = String(format: "%d\'", arguments: [heightFeet!])
            heightInchString  = String(format: "%d\"", arguments: [heightInches!])
            index = heightSelection1.index(of: heightFeetString)!
            height1Index = index
            index = heightSelection2.index(of: heightInchString)!
            height2Index = index
        }
        
     */
        // Display avatar
        if ((_isAvatarPresented) != nil) {
            return;
        }
        _isAvatarPresented = true;
        self._profilePicActivity.isHidden = false
        self._profilePicActivity.startAnimating()
        if let avatarPath = responseObject["photoUrl"] as? String
        {
            
            let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL(string:avatarPath)!, completionHandler: { (data, response, error) in
                DispatchQueue.main.async { () -> Void in
                    guard let data = data , error == nil else { return }
                    self._avtarImage.image = UIImage(data: data)
                    self._profilePicActivity.isHidden = true
                    self._profilePicActivity.stopAnimating()
                }
            })
            dataTask.resume()
            
//            self.getDataFromUrl( URL(string:avatarPath)!) { (data, response, error)  in
//                DispatchQueue.main.async { () -> Void in
//                    guard let data = data , error == nil else { return }
//                    self._avtarImage.image = UIImage(data: data)
//                    self._profilePicActivity.isHidden = true
//                    self._profilePicActivity.stopAnimating()
//                }
//            }
 
        }
        else
        {
            _avtarImage.image = UIImage(named: "image_icon.png")
            self._profilePicActivity.isHidden = true
            self._profilePicActivity.stopAnimating()
        }
        
        
    }
    
    func _updateProfileWithPasswordAndToChangePhoneNumber(_ password : String, isChanged : Bool){
        
        isprofileInUpdate = true
        
        self.view.endEditing(true)
        
        if(_nameTextField.text?.trim().length == 0){
            self.showAlert(kText_AppName, message: kText_EmptyUserName)
            return
        }
        
        
        let fullnameArr : NSArray = (_nameTextField.text?.components(separatedBy: " "))! as NSArray
        
        var firstname : String = ""
        if (fullnameArr.count > 0) {
            firstname = fullnameArr.firstObject as! String
        }
        
        var lastname : String = ""
        if (fullnameArr.count > 1) {
//            for (var i : NSInteger = 1; i < fullnameArr.count; i++) {
        for i in 1 ..< fullnameArr.count{
                lastname = lastname + (fullnameArr.object(at: i) as! String)
                if (i < fullnameArr.count - 1) {
                    lastname =   lastname + " "
                }
            }
        }
        
        if(firstname.length == 0)
        {
            self.showAlert(kText_AppName, message: kText_RequireFirstname)
            return;

        }
        
        if (lastname.trim().length == 0) {
            self.showAlert(kText_AppName, message: kText_RequireLastname)
            return;
        }

        
        let email : String?     = _emailTextField.text!.trim()
        
        let phone : String     = _phoneTextField.text!.trim()
        let phoneAlt : String   = "";
        var address1 : String  =  _streetTextField.text!.trim()
        if(address1.length > 0){
            address1 = _streetTextField.text!
        }
        var address2 : String  =  _address2TextField.text!.trim()
        if(address2.length > 0){
            address2 = _address2TextField.text!
        }
        var city : String      = _cityTextField.text!.trim()
        if(city.length > 0){
            city = _cityTextField.text!
        }
        let zipcode : String   = _zipcodeTextField.text!.trim()
        let state : String     = _stateTextField.text!
        var disFeature : String = _distinguishTextField.text!.trim();
        if(disFeature.length > 0){
            if(_distinguishTextField.text! == "Additional Distinguishing Features"){
                disFeature = ""
            }
            else{
                disFeature = _distinguishTextField.text!
            }
        }
        
        
        let ethnicity  : String = _ethnicityTextField.text!;
        var eyeColor = ""
        
        if(_eyeColorTextField.text!.length > 0)
        {

           if(_eyeColorTextField.text! == "Other colored eyes")
           {
            eyeColor = "Other"
           }
           else{
            
            let eyeArr = _eyeColorTextField.text!.components(separatedBy: " ")
            eyeColor = eyeArr[0]
           }
        }
        
        var timezoneValue : String?  = _timezoneTextField.text!
       // let hairColor : String = _hairColorTextField.text!;
        
        var hairColor = ""
        
        if(_hairColorTextField.text!.length > 0)
        {
            if(_hairColorTextField.text! == "Other colored hair")
            {
                hairColor = "Other"
            }
            else if(_hairColorTextField.text! == "Blond(e) hair")
            {
                hairColor = "Blond"
            }
            else{
                
                let hairArr = _hairColorTextField.text!.components(separatedBy: " ")
                hairColor = hairArr[0]
            }
        }
        
        
        var weight : String    = _weightTextField.text!;
        weight = weight.replacingOccurrences(of: " lb", with: "")
        //
        // Extract feet and inches
        let tokens : NSArray = (_heightTextField.text?.trim().components(separatedBy: "'"))! as NSArray
        var heightFeet : String   = ""
        var heightInches : String   = ""
        
        if (tokens.count == 2) {
            heightFeet = (tokens[0] as AnyObject).substring(to: ((tokens[0]) as! String).length)
            heightInches = (tokens[1] as AnyObject).substring(to: ((tokens[1]) as! String).length - 1)
        }
        
        /* Condition validation:Validate email address */
        if ((email == nil) || (email!.length == 0)) {
            self.showAlert(kText_AppName, message: kText_RequireEmailAddress)
            return;
        }
        else if (!(email!.isValidEmail)) {
            self.showAlert(kText_AppName, message: kText_InvalidEmailAddress)
            return;
        }
        
        /* Condition validation:Validate alternative mobile number */
        if (phoneAlt.length > 0 && !(phoneAlt.isPhoneNumber)) {
            self.showAlert(kText_AppName, message: kText_InvalidUSPhoneAlternative)
            return;
        }
        
        if(address1.length == 0){
            self.showAlert(kText_AppName, message: kText_EmptyAddress1)
            return;
        }
        
        if ((timezoneValue != nil) && (timezoneValue!.length) > 0) {
            
            var index : NSInteger = 0
            
            for(dict) in timeZoneSelection{
                if((((dict as AnyObject).object(forKey: "Name"))! as AnyObject).isEqual(to: timezoneValue!)){
                    index = timeZoneSelection.index(of: dict)
                }
            }
            
            if(index>0){
                timezoneValue = (((timeZoneSelection[index]) as AnyObject).object(forKey: "Value")) as? String
            }
            
            if(timezoneValue == "America/Los_Angeles\" selected=\"selected")
                
            {
                timezoneValue = "America/Los_Angeles"
            }
            
            
        }
        
        
        let paramDict : NSMutableDictionary = ["firstName":firstname , "lastName" :lastname, "email":email! , "phoneAlt"  : phoneAlt ,"address1" : address1 , "address2" : address2 , "city" : city , "state" : state , "zip" : zipcode  , "distFeature" : disFeature , "ethnicity" : ethnicity , "eyeColor" : eyeColor , "timezone" : timezoneValue! , "hairColor" : hairColor , "heightFeet" : heightFeet , "heightInches" : heightInches , "weight" : weight]
        
        
        var bdayDateStr : String
        if let _ = self.bdayDate
        {
            bdayDateStr    =  String(bdayDate.timeIntervalSince1970)
            bdayDateStr    =  (bdayDateStr.components(separatedBy: "."))[0]
        }
        else{
            bdayDateStr = ""
        }
        if(bdayDateStr.length > 0){
            paramDict.setValue(Double(bdayDateStr)!, forKey: "birthDate")
        }
        
        
        if(self.gender  == 2){
            paramDict.setValue("", forKey: "gender")
        }
        else{
            if (_maleButton.isSelected || _femaleButton.isSelected) {
                paramDict.setValue(self.gender, forKey: "gender")
            }
        }
        
        if (isChanged) {
            paramDict.setValue(phone, forKey: "phone")
            paramDict.setValue(password, forKey: "phonePassword")
        }
        

        kNetworkManager.executePatchRequest(String(format: kService_User,kUserPreferences.currentProfileId()!), parameters: paramDict, requestVC: self)
        
    }
    
    override func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        
        
        if(requesteUrl == String(format: kService_User,kUserPreferences.currentProfileId()!) && (!isprofileInUpdate))
        {
            
            kUserPreferences.setProfileData(responseObject as? NSDictionary)
            kUserPreferences.setCurrentProfileId((responseObject as AnyObject).value(forKey: "id") as? String)
            kUserPreferences.setCurrentUsername((responseObject as AnyObject).value(forKey: "phone") as? String)
            self.presentProfileWith(responseObject as! [String : AnyObject])
            return
        }
        
        isprofileInUpdate = false;
        kUserPreferences.setProfileData(responseObject as? NSDictionary)
        kUserPreferences.setCurrentProfileId(responseObject.value(forKey: "id") as? String)
        kUserPreferences.setCurrentUsername(responseObject.value(forKey: "phone") as? String)
        kUserPreferences.save()

      //  self.presentProfileWith(responseObject as! NSDictionary)  // enable it if we remove navigation to home screen
        
        let alertController = UIAlertController(title: kText_AppName, message: "Profile updated successfully.", preferredStyle: .alert)
        let buttonOne = UIAlertAction(title: "Ok", style: .default, handler: { (action) -> Void in
            alertController.dismiss(animated: true, completion: nil)
            
            self.showHomeScreen()
        })
        alertController.addAction(buttonOne)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        if(requesteUrl == String(format: kService_User,kUserPreferences.currentProfileId()!) && (!isprofileInUpdate))
        {
        }
        else{
            _phoneTextField.text = kUserPreferences.currentUsername()!
            isprofileInUpdate = false;

        }

        self.showAlert(kText_Warning, message:kText_CouldNotConnectToServer)
        
    }

    //MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        self.view.endEditing(true)
        kAppController!.menuBtnTapped()
    }
    
    @IBAction func editClicked()
    {
        
//        self.navigationItem.rightBarButtonItems = nil
//        self.navigationItem.leftBarButtonItem = nil
//        if(isEditMode == false){
//            isEditMode = true
//            rightBtn = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(ProfileViewController.doneButtonClicked))
//            leftBtn = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(ProfileViewController.cancelButtonClicked))
//            self.navigationItem.leftBarButtonItem = leftBtn
//            self.navigationItem.rightBarButtonItem = rightBtn
//            self.handleEnablingField(true)
//        }
//        else{
//            isEditMode = false
//            rightBtn = kAppDelegate._call911Item
//            rightBtn2 = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action:#selector(ProfileViewController.editClicked))
//            leftBtn = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.Plain, target: self, action: #selector(AppContainerViewController.menuBtnTapped))
//            self.navigationItem.leftBarButtonItem = leftBtn
//            self.navigationItem.setRightBarButtonItems([rightBtn2,space,rightBtn], animated: true)
//            self.handleEnablingField(false)
//        }
    }
    
    @IBAction func doneButtonClicked()
    {
      //  self.editClicked()
        //  var previousPhone : NSString? =  appUserDefaults.valueForKey("current_username") as? String
        

        
        let previousPhone:String = kUserPreferences.currentUsername()!
        
        let phone : String? = _phoneTextField.text
       _ =  phone!.trim()
        
        /* Condition validation:Validate mobile number */
        if ( phone!.length == 0) {
            self.showAlert(kText_AppName, message: kText_RequirePhone)
            return;
        }
        else if(!(phone!.isPhoneNumber)) {
            self.showAlert(kText_AppName, message: kText_InvalidUSPhone)
            return;
        }
        
//        // Strip all prefix number for previous mobile number
//        if (previousPhone.length > 10) {
//            previousPhone = (previousPhone as NSString).substringFromIndex((previousPhone.length - 10))
//        }
//        // Strip all prefix number for mobile number
//        let index1 = phone!.endIndex.advancedBy(-((phone!.length - 10)))
//        
//        if ((phone != nil) && (phone!.length > 10)) {
//            phone =  phone!.substringFromIndex(index1)
//        }
        
        if ( (previousPhone.length >= 10) && (phone != nil) && phone!.length >= 10 && ((phone!) != previousPhone)) {
            
            let alertView = UIAlertView(title: "Mobile Number Changed", message: kText_UpdatePhoneNumber, delegate: self, cancelButtonTitle: kText_Cancel)
            alertView.tag = 222222222
            alertView.addButton(withTitle: kText_Continue)
            alertView.alertViewStyle = UIAlertViewStyle.secureTextInput
            alertView.show()
        }
        else {
           
            self._updateProfileWithPasswordAndToChangePhoneNumber("", isChanged: false)
            
        }
    }
    
    @IBAction func updateButtonClicked()
    {
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
//        self.performSegueWithIdentifier("UpdatePwdVc", sender: <#T##AnyObject?#>)
        
        let updatePswdVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UpdatePwdVc") as! UpdatePasswordViewController
        self.navigationController?.pushViewController(updatePswdVC, animated: true)
    }
    
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int)
    {
      if(alertView.tag == 222222222)
      {
        if(buttonIndex == 1)
        {
          let password = (alertView.textField(at: 0)?.text)!
            
            if(password.length <= 0)
            {
                self.showAlert(kText_AppName, message: kText_RequirePassword)
                _phoneTextField.text = kUserPreferences.currentUsername()!

                return
            }
            else if(!(password.isPassword))
            {
                self.showAlert(kText_AppName, message: kText_InvalidPassword)
                _phoneTextField.text = kUserPreferences.currentUsername()!

                return
            }

            self._updateProfileWithPasswordAndToChangePhoneNumber(password, isChanged: true)

        }
        
        else
        {
          _phoneTextField.text = kUserPreferences.currentUsername()!
        }
        
      }
      else if(alertView.tag == 3){
        
            if(buttonIndex == 1){
//                self.editClicked()
                self._scrollView.endEditing(true)
//                if AFNetworkReachabilityManager.sharedManager().reachable {
//                    self.presentProfileWith(kUserPreferences.getProfileData()!)
//                }
                showHomeScreen()

                
            }
      }
    }

    @IBAction func cancelButtonClicked()
    {
        kAppDelegate.isLoginScreen = true
        kAppController!.showLoginScreen()
        kAppController!.LogoutFromApp()
        kUserPreferences.reset()
    }
    
    @IBAction func dropDownClicked(_ sender:UIButton)
    {
        self._scrollView.endEditing(true)
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        
        
        if(isEditMode == true){
         
            kAppDelegate.setAppActionPickerButtonItemsTextColor()
            
            if(sender == _stateDropDwnBtn){
                
                ActionSheetStringPicker.show(withTitle: "Select State", rows:_g_stateName, initialSelection: stateIndex, doneBlock: {
                    picker, value, index in
                    
                    self._stateTextField.text =   _g_stateCode[value]
                    self.stateIndex = value
                    self.hideKeyBoardfromBtn(sender)
                    
                    kAppDelegate.setAppNavBarButtonItemsTextColor()

                    return
                    }, cancel: {
                        ActionStringCancelBlock in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()
                        return
                    }, origin: _stateDropDwnBtn)
                
            }
                
            else if(sender == _weightDropDwnBtn){
                
                ActionSheetStringPicker.show(withTitle: "Select Weight", rows:(self.weightSelection as NSArray) as [AnyObject] , initialSelection: self.weightIndex, doneBlock: {
                    picker, value, index in
                    
                    self._weightTextField.text =   self.weightSelection[value] as? String
                    self.weightIndex = value
                    self.hideKeyBoardfromBtn(sender)
                    
                    kAppDelegate.setAppNavBarButtonItemsTextColor()
                    
                    return
                    }, cancel: {
                        ActionStringCancelBlock in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()
                        return
                    }, origin: _weightDropDwnBtn)
                
            }
            else if(sender == _bdyDropDwnBtn) {
                
                var dateToShow : Date!
                if let date = self.bdayDate
                {
                    dateToShow = date
                }
                else{
                    dateToShow = Date()
                }
                
                
                ActionSheetDatePicker.show(withTitle: "Select Date", datePickerMode: UIDatePickerMode.date, selectedDate: dateToShow, minimumDate: minimumDate, maximumDate: Date(), doneBlock: { (picker, obj1, obj2) in
                    
                    let dateFormatter = DateFormatter()
                    
                    dateFormatter.dateFormat = "MM/dd/yyyy"
                    
                    self.bdayDate = (obj1 as! Date)
                    
                    self._bdayTextField.text = dateFormatter.string(from: obj1 as! Date)
                    
                    self.hideKeyBoardfromBtn(sender)
                    kAppDelegate.setAppNavBarButtonItemsTextColor()
                    
                    return
                    }, cancel: { (picker) in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()
                        return
                    }, origin: _bdyDropDwnBtn)
            }
            else if(sender == _ethinicityDropDwnBtn){
                
                ActionSheetStringPicker.show(withTitle: "Select Ethnicity", rows: _kEthnic, initialSelection: ethinicityIndex, doneBlock: {
                    picker, value, index in
                    self._ethnicityTextField.text = (index as! String)
                    self.ethinicityIndex = value
                    self.hideKeyBoardfromBtn(sender)
                    kAppDelegate.setAppNavBarButtonItemsTextColor()
   
                    return
                    }, cancel: {
                        ActionStringCancelBlock in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()

                        return
                    }, origin: _ethinicityDropDwnBtn)
            }
            else if(sender == _timeZoneDropDwnBtn){
                
                ActionSheetStringPicker.show(withTitle: "Select TimeZone", rows:timeZoneNameSelection, initialSelection: timeZoneIndex, doneBlock: {
                    picker, value, index in
                    self._timezoneTextField.text = (index as! String)
                    self.timeZoneIndex = value
                    self.hideKeyBoardfromBtn(sender)
                    kAppDelegate.setAppNavBarButtonItemsTextColor()

                    return
                    }, cancel: {
                        ActionStringCancelBlock in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()

                        return
                    }, origin: _timezoneTextField)
            }
            else if(sender == _hairColorDropDwnBtn){
                
                ActionSheetStringPicker.show(withTitle: "Select Hair Color", rows:_khairColor, initialSelection: hairColorIndex, doneBlock: {
                    picker, value, index in
                    self._hairColorTextField.text = (index as! String)
                    self.hairColorIndex = value
                    self.hideKeyBoardfromBtn(sender)
                    kAppDelegate.setAppNavBarButtonItemsTextColor()

                    return
                    }, cancel: {
                        ActionStringCancelBlock in
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()

                        return
                    }, origin: _hairColorDropDwnBtn)
            }
            else if(sender == _eyeColorDropDwnBtn){
                if(_keyeColor.count>0){
                    ActionSheetStringPicker.show(withTitle: "Select Eye Color", rows:_keyeColor, initialSelection: eyeColorIndex, doneBlock: {
                        picker, value, index in
                        self._eyeColorTextField.text = (index as! String)
                        self.eyeColorIndex = value
                        self.hideKeyBoardfromBtn(sender)
                        kAppDelegate.setAppNavBarButtonItemsTextColor()

                        return
                        }, cancel: {
                            ActionStringCancelBlock in
                            self.hideKeyBoardfromBtn(sender)
                            kAppDelegate.setAppNavBarButtonItemsTextColor()

                            return
                        }, origin: _eyeColorDropDwnBtn)
                }
            }
            else if(sender == _heightDropDwnBtn){
                if(heightSelection1.count>0 && heightSelection2.count>0){
                    ActionSheetMultipleStringPicker.show(withTitle: "Select Height", rows: [
                        heightSelection1,
                        heightSelection2
                        ], initialSelection: [height1Index, height2Index], doneBlock: {
                            picker, values, indexes in
                            
                            self._heightTextField.text = ((indexes as! NSArray)[0] as! String) + ((indexes as! NSArray)[1] as! String)
//                            self.height1Index = ((values as Array)[0] as! NSInteger)
//                            self.height2Index = ((values as Array)[0] as! NSInteger)
                            self.height1Index = (values?[0] as! NSInteger)
                            self.height2Index = (values?[0] as! NSInteger)
                            self.hideKeyBoardfromBtn(sender)
                            kAppDelegate.setAppNavBarButtonItemsTextColor()

                            return
                        }, cancel: {
                            ActionStringCancelBlock in
                            self.hideKeyBoardfromBtn(sender)
                            kAppDelegate.setAppNavBarButtonItemsTextColor()

                            return
                        }, origin: _heightDropDwnBtn)
                }
                
            }
            _scrollView.setContentOffset(CGPoint(x: _scrollView.frame.origin.x, y: sender.frame.origin.y-100), animated: true)
        }
        else{
            
        }
        
        
    }
    
    
    @IBAction func genderSelection(_ sender:UIButton)
    {
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        
        if !isEditMode{
            return
        }
        
        if (sender == _maleTopButton) {
            self.gender = kGender_Male
        
            _maleButton.isSelected = true
            _femaleButton.isSelected = false
        }
        else if (sender == _femaleTopButton) {
            self.gender = kGender_Female;
            _maleButton.isSelected = false
            _femaleButton.isSelected = true
        }
    }
    
    
    
    
    @IBAction func keyPressed(_ sender:UIButton){
        
        if(sender == _uploadPhotoBtn)
        {
            if(kAppController!.isExpanded == true)
            {
                kAppController!.menuBtnTapped()
                return
            }
            
            if !isEditMode{
                return
            }

//            imagePicker.allowsEditing  = true
            
            if(kUtilities.checkiOS8()){
                
//                if #available(iOS 8.0, *) {
                    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    let buttonOne = UIAlertAction(title: "Camera", style: .default, handler: { (action) -> Void in
                        alertController.dismiss(animated: true, completion: nil)
                        
                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                            self.imagePicker.sourceType = .camera

                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                        
                    })
                    let buttonTwo = UIAlertAction(title: "Photo Library", style: .default, handler: { (action) -> Void in
                        alertController.dismiss(animated: true, completion: nil)
                        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                            self.imagePicker.sourceType = .photoLibrary
                            self.present(self.imagePicker, animated: true, completion: nil)
                        }
                    })
                    let buttonCancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
                        alertController.dismiss(animated: true, completion: nil)
                    }
                    alertController.addAction(buttonOne)
                    alertController.addAction(buttonTwo)
                    alertController.addAction(buttonCancel)
                    
                    present(alertController, animated: true, completion: nil)
                    
//                } else {
//                    // Fallback on earlier versions
//                }
            }
            else{
                
                let imageActionSheet = UIActionSheet(title:nil, delegate:self, cancelButtonTitle:nil, destructiveButtonTitle:nil);
                imageActionSheet.addButton(withTitle: "Camera")
                imageActionSheet.addButton(withTitle: "Photo Library")
                imageActionSheet.addButton(withTitle: "Cancel")
                imageActionSheet.cancelButtonIndex = 2
                
                imageActionSheet.show(in: self.view)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        self.widthConstraint.constant = self.view.frame.size.width
        
    }
    
    
    //MARK: KeyBoard Methods======
    
    func hideKeyBoardfromBtn(_ sender:UIButton){
        _scrollView.setContentOffset(CGPoint(x: _scrollView.frame.origin.x, y: _scrollView.frame.origin.y), animated: true)
    }
    
    
    
    func keyboardWillShow(_ notification:Notification){
        var userInfo = (notification as NSNotification).userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = _scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        
        
        UIView.animate(withDuration: 0.3, animations: {
            if self.fr == self.view as? UITextView {
                contentInset.bottom = contentInset.bottom + 50
                self._scrollView.contentInset = contentInset
            }
            else{
                self._scrollView.contentInset = contentInset
            }
            self.view.layoutIfNeeded()
        }) 
        
        
    }
    
    func keyboardWillHide(_ notification:Notification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        
        UIView.animate(withDuration: 0.3, animations: {
            self._scrollView.contentInset = contentInset
            self.view.layoutIfNeeded()
        }) 

    }
    
    
    
    //MARK: Action Sheet Delegate Methods======
    
    func actionSheet(_ actionSheet: UIActionSheet, clickedButtonAt buttonIndex: Int)
    {
        NSLog("%d",buttonIndex)
        if(buttonIndex == 0){
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                self.imagePicker.sourceType = .camera
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        else if(buttonIndex == 1){
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    //MARK: UIImagePickerController Delegate Methods======
    
    
    
    func rotateImage(_ image: UIImage) -> UIImage {
        
        if (image.imageOrientation == UIImageOrientation.up ) {
            return image
        }
        
        UIGraphicsBeginImageContext(image.size)
        
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return copy!
    }
 
    
    
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]){
        var image: UIImage!
        
        // fetch the selected image
        image = info[UIImagePickerControllerOriginalImage] as! UIImage
        self._profilePicActivity.isHidden = false
        self._profilePicActivity.startAnimating()
//        _avtarImage.image = image;
        let newimage:UIImage = rotateImage(image)
        
        let imgPngData : Data = UIImageJPEGRepresentation(newimage, 0.2)!
        
        let manager = AFHTTPRequestOperationManager(baseURL: URL(string: kHostname))
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/json; charset=UTF-8", forHTTPHeaderField:"Content-Type")
        manager.responseSerializer.acceptableContentTypes = NSSet(objects: "application/json","application/hal+json") as Set<NSObject>
        manager.requestSerializer.setValue(String(format:"%@ %@",kUserPreferences.tokenType(),kUserPreferences.accessToken()!), forHTTPHeaderField:"Authorization")
        manager.post(String(format:kService_UploadPhoto,kUserPreferences.currentProfileId()!), parameters: nil, constructingBodyWith: {(formData: AFMultipartFormData!) -> Void in
            formData.appendPart(withFileData: imgPngData, name: "photo", fileName: "photo.jpeg", mimeType: "image/jpeg")
            }, success: {(operation: AFHTTPRequestOperation!, responseObject : Any) -> Void in
                //Success
                
//                self.getDataFromUrl( URL(string:(responseObject["url"] as!  String))!) { (data, response, error)  in
//                    DispatchQueue.main.async { () -> Void in
//                        guard let data = data , error == nil else {
//                            self.showAlert(kText_Warning, message: "Could not able to update the image.")
//                            return
//                        }
//                        self._avtarImage.image = UIImage(data: data)
//                        self._profilePicActivity.isHidden = true
//                        self._profilePicActivity.stopAnimating()
//                    }
//                    
//                }
                let rep = responseObject as! [String : AnyObject]
               
                let dataTask: URLSessionDataTask = URLSession.shared.dataTask(with: URL(string:rep["url"] as! String)!, completionHandler: { (data, response, error) in
                    DispatchQueue.main.async { () -> Void in
                        guard let data = data , error == nil else {
                            self.showAlert(kText_Warning, message: "Could not able to update the image.")
                            return
                        }
                        self._avtarImage.image = UIImage(data: data)
                        self._profilePicActivity.isHidden = true
                        self._profilePicActivity.stopAnimating()
                    }
                })
                dataTask.resume()
                
                
            }, failure: {(operation: AFHTTPRequestOperation?, error: Error!) -> Void in
                //Failure
                DispatchQueue.main.async(execute: {
                    
                    self.showAlert(kText_Warning, message: "Could not able to update the image.")
                })
        })
        // dissmiss the image picker controller window
        self.dismiss(animated: true, completion: nil)


        
    }
    
    
    func getDataFromUrl(_ url:URL, completion: @escaping ((_ data: Data?, _ response: URLResponse?, _ error: Error? ) -> Void)) {
        URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            completion(data, response, error)
            }) .resume()
    }
    
    //MARK:=====Network handlers======================================================
    
    
    func _handleReachabilityStateChangedNotification() {
        
        if AFNetworkReachabilityManager.shared().isReachable {
        } else {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textFieldDidBeginEditing(_ tf: UITextField) {
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            tf.resignFirstResponder()
            return
        }
        
        
        self.fr = tf
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        
        textField.resignFirstResponder()
        self.fr = nil
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool{
        
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        
        if(textField == _zipcodeTextField)
        {
            return newString.length <= 10

        }else if(textField == _nameTextField)
        {
            return newString.length <= 41
            
        }else if(textField == _cityTextField)
        {
            return newString.length <= 30
        }
        
        return true
        
    }
    
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            _scrollView.endEditing(true)
            self._scrollView.setContentOffset(CGPoint.zero, animated:true)
            return
        }
        
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        self.fr = textView
    }
    func textViewShouldEndEditing(_ textView: UITextView) {
        self.fr = nil
    }
    
    func textView(_ textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        
        
        let currentText:NSString = textView.text as NSString
        let updatedText = currentText.replacingCharacters(in: range, with:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            textView.text = "Additional Distinguishing Features"
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            if(text == "\n"){
                textView.resignFirstResponder()
            }
            
            return false
        }
            
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        if(text == "\n"){
            textView.resignFirstResponder()
        }
        
        return true
    }
    
    //    func textViewDidChangeSelection(textView: UITextView) {
    //        if self.view.window != nil {
    //            if textView.textColor == UIColor.lightGrayColor() {
    //                textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
    //            }
    //        }
    //    }
       
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Additional Distinguishing Features"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func scrollEndEditing(_ gesture:UITapGestureRecognizer){
        
        
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        else{
            _scrollView.endEditing(true)
        }
        
    }
    

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
