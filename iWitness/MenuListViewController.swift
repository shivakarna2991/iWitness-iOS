//
//  MenuListViewController.swift
//  iWitness
//
//  Created by Sravani on 01/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class MenuListViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

     @IBOutlet var menuListTableView:UITableView!
    
    // 0, 5, 3, 4, 2, ..., 6, 1
    let itemsArray = ["Camera","Preferences","Emergency Contacts","Videos","Tips/Titorial","Demo","Share the App","Profile"]
//    let itemsArray = ["Home","Profile","Notifications","Emergency Contacts","Videos","Preferences","Share","Logout"]
    let imageNamesArray = [
        "icon_menu_camera", "icon_menu_preferences", "icon_menu_contacts", "icon_menu_videos", "icon_menu_tips", "icon_menu_demo", "icon_menu_share", "icon_menu_profile"
    ]
    //    let imageNamesArray = ["home.png","profile.png","notification.png","emergency_contact.png","video_icon.png","preference.png","share.png","logout.png"]
    let imageNamesRedArray = [
        "icon_menu_camera", "icon_menu_preferences", "icon_menu_contacts", "icon_menu_videos", "icon_menu_tips", "icon_menu_demo", "icon_menu_share", "icon_menu_profile"
    ]

    //    let imageNamesRedArray = ["home_red.png","profile_red.png","notification_red.png","emergency_contact_red.png","video_icon_red.png","prefernce_red.png","share_red.png","logout_red.png"]

    var selectedRowIndex:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section:
        Int) -> Int
    {
        return itemsArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        // Allocates a Table View Cell
        let aCell =
        menuListTableView.dequeueReusableCell(withIdentifier: "cell",
            for: indexPath) as! MenuTableViewCell
        aCell.menutitleLabel.text = itemsArray[(indexPath as NSIndexPath).row]
        //aCell.menutitleLabel.highlightedTextColor = UIColor.red
        aCell.menuiconImgView.highlightedImage = UIImage(named:imageNamesRedArray[(indexPath as NSIndexPath).row])
        
        if(self.view.frame.size.height == 480 || self.view.frame.size.height == 568){
          aCell.menutitleLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 15.0)
        }

        if((indexPath as NSIndexPath).row == selectedRowIndex)
        {
            //aCell.menutitleLabel.textColor = UIColor.red
            aCell.menuiconImgView.image = UIImage(named:imageNamesRedArray[(indexPath as NSIndexPath).row])
        }
        else
        {
            //aCell.menutitleLabel.textColor = UIColor.black
            aCell.menuiconImgView.image = UIImage(named:imageNamesArray[(indexPath as NSIndexPath).row])
  
        }
        
        return aCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        kAppController!.menuDidSelectedRow((indexPath as NSIndexPath).row)
    }



}
