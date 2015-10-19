//
//  KMNavigationController.swift
//  ECExpert
//
//  Created by Fran on 15/6/12.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

import UIKit

class KMNavigationController: UINavigationController {
        
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button item 背景色
//        self.navigationBar.tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        // 背景色
//        self.navigationBar.barTintColor = KM_COLOR_MAIN
        UINavigationBar.appearance().barTintColor = KM_COLOR_MAIN
        
        let titleTextDic: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.whiteColor()]
//        self.navigationBar.titleTextAttributes = titleTextDic
        UINavigationBar.appearance().titleTextAttributes = titleTextDic
        
        // Do any additional setup after loading the view.
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: "swipeGesture:")
        swipeGesture.direction = UISwipeGestureRecognizerDirection.Right
        self.navigationBar.addGestureRecognizer(swipeGesture)
    }
    
    func swipeGesture(swipeGesture: UIGestureRecognizer){
        KMLog("swipeGesture")
        let firstVC = self.viewControllers.first
        let lastVC = self.viewControllers.last
        if lastVC != firstVC{
            if lastVC is BasicViewController{
                (lastVC as! BasicViewController).goback()
            }else{
                self.popViewControllerAnimated(true)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - 立方体翻转动画效果
    /**
    - parameter viewController: <#viewController description#>
    - parameter animated:       <#animated description#>
    */
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "cube"
        animation.subtype = kCATransitionFromRight
        self.view.layer.addAnimation(animation, forKey: nil)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "cube"
        animation.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(animation, forKey: nil)
        return super.popViewControllerAnimated(animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        let animation = CATransition()
        animation.delegate = self
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.type = "cube"
        animation.subtype = kCATransitionFromLeft
        self.view.layer.addAnimation(animation, forKey: nil)
        return super.popToRootViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK : - 屏幕旋转， tabView不允许旋转
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
}
