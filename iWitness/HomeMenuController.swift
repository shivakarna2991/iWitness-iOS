//
//  HomeMenuController.swift
//  iWitness
//
//  Created by Dmitry Guglya on 2017-07-24.
//  Copyright © 2017 PTG. All rights reserved.
//

import UIKit

class HomeMenuController: UIViewController {

    
    @IBOutlet weak var isTapEnabledImageView: UIImageView!
    @IBOutlet weak var isTapEnabledSwitch: UISwitch!
    @IBOutlet weak var isTapEnabledButton: UIButton!
    @IBAction func tapValueChanged(_ sender: UISwitch!) {
        isTapEnabled = sender.isOn
        isTapEnabledImageView.image = UIImage(named: isTapEnabled ? "icon_police_red" : "icon_police_white")
        isTapEnabledButton.alpha = sender.isOn ? 1.0 : 0.5
        homeVC?.isTapEnabled = sender.isOn
    }
    var isTapEnabled: Bool = false
    
    @IBOutlet weak var isContactEnabledImageView: UIImageView!
    @IBOutlet weak var isContactEnabledSwitch: UISwitch!
    @IBOutlet weak var isContactEnabledButton: UIButton!
    @IBAction func contactValueChanged(_ sender: UISwitch!) {
        isContactEnabled = sender.isOn
        isContactEnabledImageView.image = UIImage(named: isContactEnabled ? "icon_emergency_contact_red" : "icon_emergency_contact_white")
        isContactEnabledButton.alpha = sender.isOn ? 1.0 : 0.5
        homeVC?.isContactEnabled = sender.isOn
    }
    var isContactEnabled: Bool = false
    
    @IBOutlet weak var isAlarmEnabledImageView: UIImageView!
    @IBOutlet weak var isAlarmEnabledSwitch: UISwitch!
    @IBOutlet weak var isAlarmEnabledButton: UIButton!
    @IBAction func alarmValueChanged(_ sender: UISwitch!) {
        isAlarmEnabled = sender.isOn
        isAlarmEnabledImageView.image = UIImage(named: isAlarmEnabled ? "icon_alarm_red" : "icon_alarm_white")
        isAlarmEnabledButton.alpha = sender.isOn ? 1.0 : 0.5
        homeVC?.isAlarmEnabled = sender.isOn
    }
    var isAlarmEnabled: Bool = false
    
    var homeVC: HomeViewController?
    var completion: ((HomeMenuController) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        isTapEnabledSwitch.isOn = isTapEnabled
        isTapEnabledImageView.image = UIImage(named: isTapEnabled ? "icon_police_red" : "icon_police_white")

        isContactEnabledSwitch.isOn = isContactEnabled
        isContactEnabledImageView.image = UIImage(named: isContactEnabled ? "icon_emergency_contact_red" : "icon_emergency_contact_white")

        isAlarmEnabledSwitch.isOn = isAlarmEnabled
        isAlarmEnabledImageView.image = UIImage(named: isAlarmEnabled ? "icon_alarm_red" : "icon_alarm_white")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        
        if (completion != nil) {
            completion!(self)
        }
        dismiss(animated: true, completion: nil)
    }


}
