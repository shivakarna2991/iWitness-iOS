
//
//  SubscriptionViewController.swift
//  iWitness
//
//  Created by Sravani on 04/01/16.
//  Copyright © 2016 PTG. All rights reserved.
//

import UIKit
import StoreKit
import AFNetworking

class SubscriptionViewController: BaseViewController {
    
    var products = [SKProduct]()
    var selectedIndex  = Int()
    var requests  = NSMutableDictionary()
    var subscriptionInfoUrl  = String()
    var isDataAvailable  = Bool()
    var currentuserId:String!
    var receiptDict = NSMutableDictionary()
    var productIdentifier = String()
    
    // priceFormatter is used to show proper, localized currency
    lazy var priceFormatter: NumberFormatter = {
        let pf = NumberFormatter()
        pf.formatterBehavior = .behavior10_4
        pf.numberStyle = .currency
        return pf
    }()
    
    @IBOutlet var _subscriptionTableView :UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _subscriptionTableView.rowHeight = UITableViewAutomaticDimension
        _subscriptionTableView.estimatedRowHeight = 40
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(SubscriptionViewController._handleReachabilityStateChangedNotification), name: NSNotification.Name.AFNetworkingReachabilityDidChange, object: nil)
        self.automaticallyAdjustsScrollViewInsets = false
        self.reload()
        // Subscribe to a notification that fires when a product is purchased.
        NotificationCenter.default.addObserver(self, selector: #selector(SubscriptionViewController.productPurchased(_:)), name: NSNotification.Name(rawValue: IAPHelperProductPurchasedNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SubscriptionViewController.productFailed(_:)), name: NSNotification.Name(rawValue: IAPHelperProductFailedNotification), object: nil)
        self.showloader()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        
        if kAppDelegate.isSubscriptionRenew == true{
            
            self.title = "Renew Subscription"
        }
        else{
            self.title = "Subscription"
            kAppDelegate.isLoginScreen =  true
            
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
        kAppDelegate.isLoginScreen =  false
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelperProductPurchasedNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: IAPHelperProductFailedNotification), object: nil)
        
    }
    
    
    
    
    // Fetch the products from iTunes connect, redisplay the table on successful completion
    func reload() {
        products = []
        _subscriptionTableView.reloadData()
        RageProducts.store.requestProductsWithCompletionHandler { success, products in
            if success {
                self.products = products
                self._subscriptionTableView.reloadData()
            }
            
            self.removeloader()
            //    self.refreshControl?.endRefreshing()
        }
    }
    
    // Restore purchases to this device.
    func restoreTapped(_ sender: AnyObject) {
        RageProducts.store.restoreCompletedTransactions()
    }
    
    // When a product is purchased, this notification fires, redraw the correct row
    func productPurchased(_ notification: Notification) {
        
        let purchasedProductDict = notification.object as! NSDictionary
        
        for (index, product) in products.enumerated() {
            
            if product.productIdentifier == (purchasedProductDict.object(forKey: "ProductIdentifier") as! String) {
                
                if(purchasedProductDict.object(forKey: "Status") as! String == "Complete"){
                    
                    self.pushSubscriptionToServer(purchasedProductDict)
                    
                }
                else if(purchasedProductDict.object(forKey: "Status") as! String == "Restore"){
                    
                }
                
                self._subscriptionTableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                break
            }
        }
        
    }
    
    
    func productFailed(_ notification: Notification) {
        self.removeloader()
        let transaction = notification.object as! SKPaymentTransaction

        if(_subscriptionTableView.numberOfRows(inSection: 0) > 0){
            let innerCell = _subscriptionTableView.cellForRow(at: IndexPath(row: selectedIndex, section: 0)) as! SubscriptionCell
            innerCell._selectImage.isSelected = false
            innerCell._isSelected = false
        }
        
        if (((transaction.error! as NSError).code == 2) || ((transaction.error! as NSError).code == 0) ){ return}
        
        self.showAlert(kText_Warning, message:kText_CouldNotConnectToiTunes)
    }
    
    
    func pushSubscriptionToServer (_ subscription : NSDictionary){
        
        
        let data : Data = try! Data(contentsOf: (Bundle.main.appStoreReceiptURL!))
        
        let receiptDate : Double = ((subscription.object(forKey: "TransactionDate") as AnyObject).timeIntervalSince1970)!
        
        
        
        
//       let dict:NSMutableDictionary =   ["packageName":String(format: subscription.object(forKey: "ProductIdentifier")! as! String) ,"productId":String(format: subscription.object(forKey: "ProductIdentifier")! as! String),"receiptId":String(format: subscription.object(forKey: "TransactionIdentifier")! as! String),"receiptData":kUtilities.convertToBase64(data),"receiptDate":receiptDate,"originalreceiptid":String(format: subscription.object(forKey: "OrginalTransactionIdentifier")! as! String), "sandboxtest":"yes"]
        
    
    let dict:NSMutableDictionary =   ["packageName":String(format: subscription.object(forKey: "ProductIdentifier")! as! String) ,"productId":String(format: subscription.object(forKey: "ProductIdentifier")! as! String),"receiptId":String(format: subscription.object(forKey: "TransactionIdentifier")! as! String),"receiptData":kUtilities.convertToBase64(data),"receiptDate":receiptDate,"originalreceiptid":String(format: subscription.object(forKey: "OrginalTransactionIdentifier")! as! String)]

        
        
        if kAppDelegate.isSubscriptionRenew == true {
            
            dict.setValue(true, forKey:"isRenew")
            dict.setValue(kUserPreferences.currentUsername()!, forKey:"userId")

        }
        else{
            //   dict.setValue(false, forKey:"isRenew")
        }
        
        receiptDict = dict
        productIdentifier = subscription.object(forKey: "ProductIdentifier")! as! String
        
        
        //              self.requests.setObject(["request" : kService_Subscription , "data" : dict], forKey:subscription.objectForKey("ProductIdentifier")! as! String)
        
        kNetworkManager.executePostRequest(String(format:kService_Subscription), parameters: dict, requestVC: self)
        
        return
        
        
        
        
    }
    
    
    func pushSubscriptionInfoToServer (_ subscription : NSDictionary){
        //(subscription.objectForKey("receiptData") != nil)
        if((subscription.object(forKey: "data") as AnyObject).object(forKey: "receiptData") != nil){
            
           // receiptDict = (subscription.object(forKey: "data") as AnyObject).object(forKey: "receiptData") as! NSMutableDictionary
            receiptDict = subscription.object(forKey: "data") as! NSMutableDictionary

            subscriptionInfoUrl = String(format:kHostname+kService_SubscriptionInfo,((subscription.object(forKey: "data") as AnyObject).object(forKey: "receiptId")! as! String))
            kNetworkManager.executeGetRequest(subscriptionInfoUrl, parameters:nil, requestVC: self)
            
        }
        else{
            
            if kAppDelegate.isSubscriptionRenew == true {
                subscription.setValue(true, forKey:"isRenew")
            }
            else{
                subscription.setValue(false, forKey:"isRenew")
            }
            
            receiptDict = subscription.object(forKey: "data") as! NSMutableDictionary
            productIdentifier = subscription.object(forKey: "ProductIdentifier")! as! String
            
            kNetworkManager.executePostRequest(kService_Subscription, parameters:subscription, requestVC: self)
            
            //            self.requests.setObject(["request" : kService_Subscription , "data" : subscription.objectForKey("data") as! NSDictionary], forKey:subscription.objectForKey("ProductIdentifier")! as! String )
            //           self.pushSubscriptionToServer(subscription)
        }
    }
    
    override  func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
    {
        if(requesteUrl == kService_Subscription){
            
           // self.requests.setObject(["request" : kService_Subscription , "data" : self.receiptDict], forKey:self.productIdentifier as NSCopying)
            
            self.receiptDict = NSMutableDictionary()
            self.productIdentifier = ""
            
            
            if kAppDelegate.isSubscriptionRenew == true {
                kAppDelegate.isSubscriptionRenew = false
                
                //Presented Authenticated Flow
                kUserPreferences.setProfileData(nil)   // To update profile with latest expire date
                kAppController!.showHomePage()
            }
            else{
                
                currentuserId = responseObject.object(forKey: "id") as! String
                self.performSegue(withIdentifier: "showSignupSegue", sender: self)
                
            }
        }
        else if(requesteUrl == subscriptionInfoUrl){
            
            if(((responseObject.object(forKey: "page_count")) as AnyObject).intValue == 0){
                
                if kAppDelegate.isSubscriptionRenew == true {
                    receiptDict.setValue(true, forKey:"isRenew")
                }
                else{
                    receiptDict.setValue(false, forKey:"isRenew")
                }
                
                //                receiptDict = subscription.objectForKey("data") as! NSMutableDictionary
                productIdentifier = receiptDict.object(forKey: "packageName")! as! String
                
                kNetworkManager.executePostRequest(kService_Subscription, parameters:receiptDict, requestVC: self)
                
            }
            else{
                
                if kAppDelegate.isSubscriptionRenew == true {
                    kAppDelegate.isSubscriptionRenew = false
                    //Presented Authenticated Flow
                    kUserPreferences.setProfileData(nil)     // To update profile with latest expire date
                    
                    kAppController!.showHomePage()
                }
                else{
                    
                    //modified for swift 3.0
                    let res1 = responseObject["_embedded"] as! [String:AnyObject]
                    let res2 = res1["subscription"] as! [AnyObject]
                    currentuserId = (res2[0] as! [String:AnyObject])["id"] as! String
                    
                    //  currentuserId = ((((responseObject["_embedded"] as [String:AnyObject])["subscription"]) as AnyObject)[0] as AnyObject)["id"] as! String
                    self.performSegue(withIdentifier: "showSignupSegue", sender: self)
                    
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if(segue.identifier == "showSignupSegue"){
            let detailVCObj = segue.destination as! SignUpViewController
            detailVCObj.UserId = currentuserId
        }
    }
    
    
    override func requestFailed(_ error:NSError!,requesteUrl:String){
        
        self.showAlert(kText_Warning, message:kText_CouldNotConnectToServer)
        
    }
    
    
    
    
    //MARK:=====Network handlers======================================================
    
    
    func _handleReachabilityStateChangedNotification() {
        
        if AFNetworkReachabilityManager.shared().isReachable {
            // print("connected")//check this method in old app
        } else {
            // print("disconnected")
        }
    }
    
    //MARK:=====IBAction Methods======================================================
    
    @IBAction func keyPressed(_ sender:UIButton){
    }
    
    //MARK: UITableView Delegate and DataSource methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAtIndexPath indexPath: IndexPath) -> UITableViewCell {
        
        let aCell =
            _subscriptionTableView.dequeueReusableCell(withIdentifier: "SubscriptionCell",
                                                       for: indexPath) as! SubscriptionCell
        
        let product = products[(indexPath as NSIndexPath).row]
        aCell.subscription = products[(indexPath as NSIndexPath).row]
        priceFormatter.locale = product.priceLocale
        
        if UIScreen.main.bounds.size.width == 320 {
            aCell._titleLabel.text =  String(format: "%@:\n%@", arguments: [product.localizedTitle,priceFormatter.string(from: product.price)!])
        }
        else {
            aCell._titleLabel.text =  String(format: "%@: %@", arguments: [product.localizedTitle,priceFormatter.string(from: product.price)!])
        }
        aCell._selectImage.addTarget(self, action:#selector(SubscriptionViewController.selectBtnTapped(_:withEvent:)), for: UIControlEvents.touchUpInside)
        return aCell
    }
    
    
    
    func selectBtnTapped(_ sender:UIControl,withEvent event:UIEvent ) {
        
        let point = _subscriptionTableView.convert(CGPoint.zero, from: sender)
        if let indexPath = _subscriptionTableView.indexPathForRow(at: point) {
            self.setCellSelectedStatus(indexPath)
        }
        else {
            return
        }
    }
    
    func  setCellSelectedStatus(_ indexPath : IndexPath) {
        
        let cell = _subscriptionTableView.cellForRow(at: indexPath) as! SubscriptionCell
        if   cell._isSelected == false{
            cell._isSelected = true
        }
        else{
            cell._isSelected = false
        }
        
        for (index , _) in products.enumerated() {
            if (index == (indexPath as NSIndexPath).row){
                cell._selectImage.isSelected = true
                selectedIndex = ((indexPath as NSIndexPath).row)
            }
            else{
                let innerCell = _subscriptionTableView.cellForRow(at: IndexPath(row: index, section: 0)) as! SubscriptionCell
                innerCell._selectImage.isSelected = false
            }
        }
        
        
        self.showloader()
        
        
        if((self.requests[cell.subscription.productIdentifier]) != nil){
            self.pushSubscriptionInfoToServer(self.requests[cell.subscription.productIdentifier] as! NSDictionary)
        }
        else {
            isDataAvailable = false
            let product = cell.subscription
            RageProducts.store.purchaseProduct(product!)
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        
        self.setCellSelectedStatus(indexPath)
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}








