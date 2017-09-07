//
//  NotificationDetailViewController.swift
//  iWitness
//
//  Created by Sravani on 07/12/15.
//  Copyright © 2015 PTG. All rights reserved.
//

import UIKit

class NotificationDetailViewController: BaseViewController {

    var selectedIndex:Int!
    var selectedTipObject:AnyObject!
    var isScreenFromRegistration:Bool!
    
    @IBOutlet var tip1View:UIView!
    @IBOutlet var tip2View:UIView!
    @IBOutlet var tip3View:UIView!
    @IBOutlet var IUnderStandBtn:UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        _visualize()
       
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func _visualize()
    {
        self.title = "Notifications"
        let leftBtn : UIBarButtonItem = UIBarButtonItem(image: UIImage(named:"back.png"), style:UIBarButtonItemStyle.plain, target: self, action: #selector(NotificationDetailViewController.backBtnTapped))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        if isScreenFromRegistration == true{
            IUnderStandBtn.isHidden = false
            tip3View.isHidden = false
            tip2View.isHidden  = true
            tip1View.isHidden = true
        }
            
        else
        {
            
          //  let rightBtn : UIBarButtonItem = UIBarButtonItem(title: "Call 911", style: UIBarButtonItemStyle.Plain, target: self, action:"call911BtnTapped")
            self.navigationItem.rightBarButtonItem = kAppDelegate._call911Item

            IUnderStandBtn.isHidden = true
            showTipView()
        }

    }
    
    @IBAction func termsAccepted()
    {
        kAppController!.showHomePage()
    }
    
    func updateSeelctedIndexWithTipArray()
    {
       let object = selectedTipObject
       
        if(object?["tipno"] as! String == "tipone"){
            selectedIndex = 0
        }
        else if(object?["tipno"] as! String == "tiptwo"){
            selectedIndex = 1
        }
        else {
            selectedIndex = 2
        }
    }
    
    func showTipView()
    {
        updateSeelctedIndexWithTipArray()

        switch(selectedIndex)
        {
        case 0: tip1View.isHidden = false
                tip2View.isHidden = true
                tip3View.isHidden = true
                 break
        case 1: tip2View.isHidden = false
                tip1View.isHidden  = true
                tip3View.isHidden = true
               break
        case 2: tip3View.isHidden = false
                tip2View.isHidden  = true
                tip1View.isHidden = true
                break
 
        default:break
        }
    }
    
    func backBtnTapped()
    {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
//    func call911BtnTapped()
//    {
//        
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
