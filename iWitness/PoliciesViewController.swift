//
//  PoliciesViewController.swift
//  iWitness
//
//  Created by Sravani on 16/02/17.
//  Copyright © 2017 PTG. All rights reserved.
//

import UIKit

class PoliciesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        kAppDelegate.isLoginScreen =  true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        kAppDelegate.isLoginScreen =  false
        
    }

    @IBAction func privacypolicyTapped(_ sender: Any) {
        openTermsUrl("https://www.iwitness.com/content-terms-of-service/")
    }
    @IBAction func termsofServiceTapped(_ sender: Any) {
        openTermsUrl("https://www.iwitness.com/content-terms-of-use/")
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func openTermsUrl(_ url: String) {
        let url = URL(string: url)!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
