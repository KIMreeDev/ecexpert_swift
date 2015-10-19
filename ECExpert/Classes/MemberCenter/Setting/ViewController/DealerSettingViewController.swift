//
//  DealerSettingViewController.swift
//  ECExpert
//
//  Created by Fran on 15/6/29.
//  Copyright (c) 2015年 Fran. All rights reserved.
//

import UIKit

class DealerSettingViewController: BasicViewController, UITableViewDelegate, UITableViewDataSource {
    
    static let CellIdentifier = "CellIdentifier"
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.needLogin = true
        self.title = i18n("Setting")
        
        setUpView()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: i18n("Logout"), style: UIBarButtonItemStyle.Plain, target: self.tabBarController, action: "logout")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView(){
        let tableFrame = getVisibleFrame()
        
        tableView = UITableView(frame: tableFrame, style: UITableViewStyle.Grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = RGBA(red: 0, green: 0, blue: 0, alpha: 0.3)
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.view.addSubview(tableView)
    }
    
    // MARK: - UITableViewDelegate
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.min
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        if section == 0{
            let heartTestVC =  HeartRateTestViewController()
            self.navigationController?.pushViewController(heartTestVC, animated: true)
        }else if section == 1{
            if row == 0{
                showAbout()
            }else if row == 1{
                let feedBack = FeedbackViewController()
                self.navigationController?.pushViewController(feedBack, animated: true)
            }else{
                clearCacche()
            }
        }else{
            if row == 1{
                UIApplication.sharedApplication().openURL(NSURL(string: APP_URL_ITUNES_COMMENT)!)
            }
        }
        
    }
    
    func showAbout(){
//        let statusH: CGFloat = 20
        let bottomH: CGFloat = 60
        
        let aboutVC = UIViewController()
        aboutVC.view.backgroundColor = UIColor.whiteColor()
        
        let statusBar = UIView(frame: CGRectMake(0, 0, KM_FRAME_SCREEN_WIDTH, KM_FRAME_VIEW_STATUSBAR_HEIGHT))
        statusBar.backgroundColor = KM_COLOR_MAIN
        aboutVC.view.addSubview(statusBar)
        
        let label = UIFactory.labelWithFrame(CGRectMake(10, 80, KM_FRAME_SCREEN_WIDTH - 10 * 2, 30), text: "电子烟专家", textColor: UIColor.blackColor(), fontSize: 26, numberOfLines: 0, textAlignment: NSTextAlignment.Center)
        
        let detailLabel = UIFactory.labelWithFrame(CGRectMake(10, 110, KM_FRAME_SCREEN_WIDTH - 10 * 2, 150), text: "       专注电子烟行业，是全球最大最全的电子烟门户APP。\n       为您提供电子烟行业最权威的新闻、品牌、政策、展会等最新资讯。", textColor: UIColor.blackColor(), fontSize: 15, numberOfLines: 0, fontName: "Arial-BoldItalicMT")
        
        let emptyView = UIView(frame: CGRectMake(0, aboutVC.view.frame.size.height - bottomH, aboutVC.view.frame.size.width, bottomH))
        emptyView.backgroundColor = UIColor.whiteColor()
        
        let backButton = UIButton(type: UIButtonType.Custom)
        backButton.frame = CGRectMake(10, 10, emptyView.frame.size.width - 10 * 2, bottomH - 10 * 2)
        backButton.setTitle(i18n("Back"), forState: UIControlState.Normal)
        backButton.backgroundColor = KM_COLOR_BUTTON_MAIN
        backButton.layer.masksToBounds = true
        backButton.layer.cornerRadius = 5
        backButton.layer.borderWidth = 2
        backButton.layer.borderColor = UIColor.whiteColor().CGColor
        backButton.addTarget(self, action: "aboutViewBack:", forControlEvents: UIControlEvents.TouchUpInside)
        
        emptyView.addSubview(backButton)
        
        aboutVC.view.addSubview(label)
        aboutVC.view.addSubview(detailLabel)
        aboutVC.view.addSubview(emptyView)
        
        self.navigationController?.presentViewController(aboutVC, animated: true, completion: { () -> Void in
            
        })
    }
    
    func aboutViewBack(sender: AnyObject!){
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func clearCacche(){
        let alertView = UIAlertView(title: "", message: i18n("Confirm to clear the cache?"), delegate: nil, cancelButtonTitle: i18n("Cancel"), otherButtonTitles: i18n("Sure"))
        alertView.showAlertViewWithCompleteBlock {(buttonIndex) -> Void in
            if buttonIndex == 1{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), { () -> Void in
                    let cachePath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.CachesDirectory, NSSearchPathDomainMask.UserDomainMask, true).first!
                    let files = NSFileManager.defaultManager().subpathsAtPath(cachePath)
                    if files != nil{
                        for item in files!{
//                            let path = cachePath.stringByAppendingPathComponent(item as String )
                            let path = cachePath.stringByAppendingString("/").stringByAppendingString(item)
                            if NSFileManager.defaultManager().fileExistsAtPath(path){
                                do {
                                    try NSFileManager.defaultManager().removeItemAtPath(path)
                                } catch _ {
                                }
                            }
                        }
                    }
                    LocalStroge.sharedInstance().deleteFile(APP_PATH_DEALER_INFO, searchPathDirectory: NSSearchPathDirectory.CachesDirectory)
                    
                    dispatch_sync(dispatch_get_main_queue(), {() -> Void in
                        self.progressHUD?.mode = MBProgressHUDMode.Text
                        self.progressHUD?.labelText = ""
                        self.progressHUD?.detailsLabelText = i18n("Clean up success!")
                        self.progressHUD?.show(true)
                        self.progressHUD?.hide(true, afterDelay: 2)
                    })
                })
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else if section == 1{
            return 3
        }else{
            return 2
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UIFactory.tableViewCellForTableView(tableView, cellIdentifier: DealerSettingViewController.CellIdentifier, cellType: UITableViewCellStyle.Subtitle) { (tableViewCell: UITableViewCell!) -> Void in
            tableViewCell!.backgroundColor = UIColor.clearColor()
            tableViewCell!.textLabel?.textColor = UIColor.whiteColor()
            tableViewCell!.detailTextLabel?.textColor = UIColor.whiteColor()
            tableViewCell!.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            
            tableViewCell!.selectionStyle = UITableViewCellSelectionStyle.None
        }
        
        let section = indexPath.section
        let row = indexPath.row
        
        if section == 0{
            cell?.textLabel?.text = i18n("Heart rate test")
            cell?.imageView?.image = UIImage(named: "heartRateTest")
        }else if section == 1{
            if row == 0 {
                cell?.textLabel?.text = i18n("About")
                cell?.imageView?.image = UIImage(named: "aboutUs")
            }else if row == 1{
                cell!.textLabel?.text = i18n("Your suggestion")
                cell?.imageView?.image = UIImage(named: "feedBack")
            }else {
                cell?.textLabel?.text = i18n("Clear the cache")
                cell?.imageView?.image = UIImage(named: "clearCache")
            }
        }else{
            if row == 0 {
                
                cell?.accessoryType = UITableViewCellAccessoryType.None
                cell?.selectionStyle = UITableViewCellSelectionStyle.None
                
                cell?.textLabel?.text = i18n("Current version")
                cell?.imageView?.image = UIImage(named: "versionNumber")
                
                let versionNum = bundleInfoDictionary()?["CFBundleShortVersionString"] as? String ?? ""
                cell?.detailTextLabel?.text = versionNum
            }else {
                cell?.textLabel?.text = i18n("Comment")
                cell?.imageView?.image = UIImage(named: "Comment")
            }
        }
        
        return cell!
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
