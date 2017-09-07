//
//  NotificationsListViewController.swift
//  iWitness
//
//  Created by Sravani on 04/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit
////import AFNetworking

class NotificationsListViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet var listView :UITableView!
    @IBOutlet var bg_imgView :UIImageView!
    var selectedIndex:Int!
    var selectedObject:AnyObject!
    var isScreenFromHomeScreen = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
        bg_imgView.alpha = 0.8
        
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Class's private methods
    
    func _visualize()
    {
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.title = "Notifications"
       // let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.Plain, target: self, action:"call911BtnTapped")
        self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NotificationsListViewController.closeMenuScreen(_:)))
        listView.addGestureRecognizer(tapGesture)

        
        if(isScreenFromHomeScreen)
        {
            let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationsListViewController.backBtnTapped))
            self.navigationItem.leftBarButtonItem = leftBtn
  
        }
        else
        {
            let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"menu.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationsListViewController.menuBtnTapped))
            self.navigationItem.leftBarButtonItem = leftBtn
   
        }
        
        //print(kUserPreferences.currentProfileId()!)

    }
    
    
//MARK: Action Methods======
    
    @IBAction func menuBtnTapped(){
        
        kAppController!.menuBtnTapped()
    }
    
//    @IBAction func call911BtnTapped()
//    {
//        
//    }
    
    
    func backBtnTapped()
    {
       _ =  self.navigationController?.popViewController(animated: true)
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

//MARK: Tableview Delegates =========================================
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return kAppDelegate.NotificationsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        listView.dequeueReusableCell(withIdentifier: "NotificationCell",
            for: indexPath) as! NotificationListTableViewCell
        let obj = kAppDelegate.NotificationsArray[(indexPath as NSIndexPath).row]
        aCell.notificationLbl.text = obj["NotificationText"] as? String
        aCell.backgroundColor = UIColor.clear

        if(obj["isRead"] as! Bool)
        {
            aCell.notificationLbl.font = UIFont(name:"HelveticaNeue-Medium", size: 19.0)
            aCell.notificationImgView.image = UIImage(named:"circle_button.png")
        }
        else
        {
            aCell.notificationLbl.font = UIFont(name: "HelveticaNeue-Bold", size: 18.0)
            aCell.notificationImgView.image = UIImage(named:"circle_button_red.png")
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
       
        if(kAppController!.isExpanded == true)
        {
            kAppController!.menuBtnTapped()
            return
        }
        
        
        selectedIndex = (indexPath as NSIndexPath).row
       selectedObject = kAppDelegate.NotificationsArray[selectedIndex]
        
        if(kAppDelegate.notificationUnreadCount > 0)
        {
          kAppDelegate.notificationUnreadCount -= 1
        }

       if(selectedIndex == 2){     //Disclaimer is always in readable state
           self.performSegue(withIdentifier: "NotificationDetailSegue", sender: self)
           return
        }

        updateListViewStatus()
        
    }
    
    
//    func logoutAPI(){
//        
//        print(kUserPreferences.currentProfileId()!)
//        kNetworkManager.executeGetRequest(String(format: kServiceLogout,kUserPreferences.currentProfileId()!), parameters: nil, requestVC: self)
//        
//    }
//
//    override func requestSuccess(_ responseObject:AnyObject!,requesteUrl:String)
//    {
//       print("sucess")
//    }
//    override func requestFailed(_ error:NSError!,requesteUrl:String){
//        
//        print("failed")
//    }

    
    
    func updateListViewStatus()
    {
      
        let tipobj0 = NSMutableDictionary(dictionary: kAppDelegate.NotificationsArray[0])
        let tipobj1 = NSMutableDictionary(dictionary: kAppDelegate.NotificationsArray[1])
        

        if(selectedIndex == 0 && !(tipobj0["isRead"] as! Bool)){
            
            tipobj0["isRead"] = true
            
              if(!(tipobj1["isRead"] as! Bool)) // It is when tipobj0 is unread and tipobj1 is unread
              {
                kAppDelegate.NotificationsArray.remove(at: 1) //after action, array is [tipobj0,tipobj2]
                kAppDelegate.NotificationsArray.remove(at: 0) // after action, array is [tipobj2]
                kAppDelegate.NotificationsArray.insert(tipobj0, at: 0) //after action, array is [tipobj0,tipobj2] with modified tipobj0 as true
                kAppDelegate.NotificationsArray.insert(tipobj1, at: 0) //after action , array is [tipobj1-unread, tipobj0-read,tipobj2-read
                

              }
              else // It is when tipobj0 is unread and tipobj1 is read
              {
                kAppDelegate.NotificationsArray.remove(at: 0) //after action, array is [tipobj0--unread,tipobj1tipobj3]
                kAppDelegate.NotificationsArray.insert(tipobj0, at: 0)//after action, array is [tipobj0--read,tipobj1,tipobj2]
  
              }
             listView.reloadData()

        }
        
        else if(selectedIndex == 1 && !(tipobj1["isRead"] as! Bool)){
           
            tipobj1["isRead"] = true
            kAppDelegate.NotificationsArray.remove(at: 1) //after action, array is [tipobj0,tipobj3]
            kAppDelegate.NotificationsArray.insert(tipobj1, at: 1)//after action, array is [tipobj0,tipobj1,tipobj2]
            listView.reloadData()

        }
       
        kAppDelegate.updatePlistContents()
        self.performSegue(withIdentifier: "NotificationDetailSegue", sender: self)

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        let detailVCObj = segue.destination as! NotificationDetailViewController
        detailVCObj.selectedTipObject  = selectedObject
        detailVCObj.isScreenFromRegistration = false
        //selected index object will change from selectedTipObject as we are updating notification array, so sending object
    }



}
