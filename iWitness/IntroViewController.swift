//
//  IntroViewController.swift
//  iWitness
//
//  Created by Dmitry Guglya on 2017-08-29.
//  Copyright © 2017 PTG. All rights reserved.
//

import UIKit

class IntroViewController: UIViewController {
    
    var pageVC: IntroPageViewController?
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginBtnBottomConstraint:NSLayoutConstraint!
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeLoginButton()
        customizeNextButton()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func customizeLoginButton() {
        loginBtnBottomConstraint.constant = setLoginBottomConstraint()
    }
    
    private func customizeNextButton() {
        nextButton.layer.borderWidth = 2.0
        nextButton.layer.borderColor = UIColor(red: 0.82, green: 0.01, blue: 0.11, alpha: 1.0).cgColor
        nextButton.layer.cornerRadius = nextButton.frame.height / 2
    }
    
    // MARK: - Selectors
    
    @IBAction func nextButtonAction(_ sender: UIButton) {
        if pageVC != nil {
            if (pageVC!.pages.count > pageVC!.currentPage+1) {
                pageVC!.setCurrentPage(page: pageVC!.currentPage+1)
                pageVC?.currentPage += 1
            }
            else {
                loginButtonAction()
            }
        }
        
    }
    
    @IBAction func loginButtonAction() {
        
        UserPreferences.sharedInstance.setDisplayIntro(false)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let application = UIApplication.shared
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainViewController = storyboard.instantiateInitialViewController()
        
        appDelegate.window?.rootViewController = mainViewController
        appDelegate.launchMain(application)
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is IntroPageViewController {
            pageVC = (segue.destination as! IntroPageViewController)
        }
    }
    
    // MARK: - Utility Functions
    
    private func setLoginBottomConstraint() -> CGFloat {
        // 667.0 = iPhone 7/6/6S
        // 736.0 = iPhone 7+/6+
        // 568.0 = iPhone 5/5S
        let screenHeight = UIScreen.main.bounds.height
        
        if screenHeight == 736.0 {
            return 70.0
        } else if screenHeight == 667.0 {
            return 62.0
        } else if screenHeight >= 568.0 {
            return 50.0
        }
        return 70.0
    }
}

class IntroPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    var pages = [UIViewController]()
    var currentPage: Int = 0
    
    func setCurrentPage(page: Int) {
        if page < 0 || page >= pages.count {
            return
        }

        setViewControllers([pages[page]], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.dataSource = self
        
        let p1: IntroContentViewController! = storyboard?.instantiateViewController(withIdentifier: "intro1") as? IntroContentViewController
        p1.pageIndex = 0
        let p2: IntroContentViewController! = storyboard?.instantiateViewController(withIdentifier: "intro2") as? IntroContentViewController
        p2.pageIndex = 1
        let p3: IntroContentViewController! = storyboard?.instantiateViewController(withIdentifier: "intro3") as? IntroContentViewController
        p3.pageIndex = 2
        let p4: IntroContentViewController! = storyboard?.instantiateViewController(withIdentifier: "intro4") as? IntroContentViewController
        p4.pageIndex = 3
        
        pages.append(p1)
        pages.append(p2)
        pages.append(p3)
        pages.append(p4)
        
        setViewControllers([p1], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
        currentPage = 0
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        if cur == 0 { return nil }
        
        let prev = abs((cur - 1) % pages.count)

        return pages[prev]
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController)-> UIViewController? {
        
        let cur = pages.index(of: viewController)!
        
        if cur == (pages.count - 1) { return nil }
        
        let nxt = abs((cur + 1) % pages.count)

        return pages[nxt]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        let contentVC = pageViewController.viewControllers?[0] as! IntroContentViewController
        currentPage = contentVC.pageIndex
    }
    
    func presentationIndex(for pageViewController: UIPageViewController)-> Int {
        return pages.count
    }
}

class IntroContentViewController: UIViewController {
    
    var pageIndex:Int = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
