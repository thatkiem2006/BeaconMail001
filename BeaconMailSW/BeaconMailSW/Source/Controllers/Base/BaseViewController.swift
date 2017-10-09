//
//  BaseViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import Toast
class BaseViewController: UIViewController {
    var beaconInfo:BeaconInfo = BeaconInfo()
    var geofence: GeoFenceBean?
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showMenuButton(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    // MARK: Create View
    func showMenuButton(_ isShow:Bool) {
        if self.revealViewController() != nil {
            if isShow{
                // create left menu button
                let menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
                menuButton.setImage(UIImage.bmImage( "btn_leftmenu.png"), for: UIControlState())
                menuButton.setImage(UIImage.bmImage( "btn_leftmenu_highlighted.png"), for: UIControlState.highlighted)
                menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: UIControlEvents.touchUpInside)
                //menuButton.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
                let barButton = UIBarButtonItem(customView: menuButton)
                self.navigationItem.leftBarButtonItem = barButton
                
                // config left menu table and pan gesture to open menu
                self.revealViewController().rearViewRevealWidth = 270
                self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
                
            }else {
                self.navigationItem.leftBarButtonItem = nil
                self.view.removeGestureRecognizer(self.revealViewController().panGestureRecognizer())
            }
            
        }
    }
    
    
    func setNavWithImageAndTitle(_ imageName:String,title:String) {
        delay(0.4, closure: {
            // view bar
            let viewBar = UIView()
            viewBar.backgroundColor = UIColor.clear
            /*
             let urlString = NSURL.init(string: imageName, relativeToURL: nil)
             let imageView = UIImageView(frame: CGRectMake(0, 0, 32, 32))
             imageView.sd_setImageWithURL(urlString)
             print(urlString)
             viewBar.addSubview(imageView)
             */
            
            // image View
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            
            imageView.image = UIImage.bmImage( imageName)
            viewBar.addSubview(imageView)
            
            // title label
            let titleView = UILabel(frame: CGRect(x: 35, y: 0, width: 32, height: 32))
            titleView.backgroundColor = UIColor.clear
            titleView.text = title
            titleView.sizeToFit()
            viewBar.addSubview(titleView)
            
            // set frame title label
            var frame = titleView.frame
            frame.size.height = 32
            titleView.frame = frame
            
            // setframe viewBar
            viewBar.frame = CGRect(x: 0, y: 0, width: titleView.frame.origin.x + titleView.frame.width, height: 32)
            viewBar.clipsToBounds = true
            
            // add viewbar to navigationItem
            self.navigationItem.titleView = viewBar
        })
    }
    
    func setNavWithImageURLAndTitle(_ imageURL:String, title:String)
    {
        delay(0.4, closure: {
            // view bar
            let viewBar = UIView()
            viewBar.backgroundColor = UIColor.clear
            
            // image View
            let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
            if let urlImage = URL(string: imageURL) {
                imageView.loadImageWithURL(urlImage)
                viewBar.addSubview(imageView)
            }
            
            // title label
            let titleView = UILabel(frame: CGRect(x: 35, y: 0, width: 32, height: 32))
            titleView.backgroundColor = UIColor.clear
            titleView.text = title
            titleView.sizeToFit()
            viewBar.addSubview(titleView)
            
            // set frame title label
            var frame = titleView.frame
            frame.size.height = 32
            titleView.frame = frame
            
            // setframe viewBar
            viewBar.frame = CGRect(x: 0, y: 0, width: titleView.frame.origin.x + titleView.frame.width, height: 32)
            viewBar.clipsToBounds = true
            // add viewbar to navigationItem
            self.navigationItem.titleView = viewBar
        })
    }
    
    func setNavTitle(_ title:String)
    {
        // view bar
        let viewBar = UIView()
        viewBar.backgroundColor = UIColor.clear
        
        // title label
        let titleView = UILabel(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        titleView.backgroundColor = UIColor.clear
        titleView.text = title
        titleView.sizeToFit()
        viewBar.addSubview(titleView)
        
        // set frame title label
        var frame = titleView.frame
        frame.size.height = 32
        titleView.frame = frame
        viewBar.frame = CGRect(x: 0, y: 0, width: titleView.frame.origin.x + titleView.frame.width, height: 32)
        viewBar.clipsToBounds = true
        // add viewbar to navigationItem
        self.navigationItem.titleView = viewBar
        
    }
    
    func setRightBarButton(_ title:String,target: AnyObject?,action:Selector) {
        
        let rightBarButton = UIBarButtonItem()
        rightBarButton.title = title
        rightBarButton.target = target
        rightBarButton.action = action
        
        // add rightBarButton to navigationItem
        self.navigationItem.rightBarButtonItem = rightBarButton
    }
    
    // MARK: Functions
    func gotoWebView(_ beaconInfo:BeaconInfo? = nil, geoFence: GeoFenceBean? = nil) {
        print("gotoWebView")
        if let navi = self.storyboard!.instantiateViewController(withIdentifier: NaviName.webview.description()) as? UINavigationController {
            if let viewController = navi.topViewController as? WebViewController {
                if let ibeacon = beaconInfo {
                    viewController.beaconInfo = ibeacon
                }
                viewController.geofence = geoFence
                let rootViewController = self.revealViewController()
                rootViewController?.setFront(navi, animated: true)
                rootViewController?.setFrontViewPosition(FrontViewPosition.left, animated: false)
            }
        }
    }
    
    func backToWebView(_ beaconInfo:BeaconInfo, geo :GeoFenceBean?) {
        // get root viewController
        if let viewController = self.navigationController?.viewControllers[0] as? WebViewController {
            self.navigationController?.popToViewController(viewController, animated: true)
        }else {
            self.gotoWebView(beaconInfo, geoFence: geo)
        }
        
    }
    
    func addMailToFavorite(_ listMail:[MailInfo]) {
        MailBox.updateFavorite(listMail, isFavorite: true)
    }
    
    func deleteMail(_ listMail:[MailInfo], fromFavorite:Bool) {
        MailBox.delete(array:listMail, applyForFavorite: fromFavorite)
    }
    
    func showToast(_ message:String) {
        let position = CGPoint(x: self.view.bounds.size.width/2, y: (self.view.bounds.size.height - 50))
        self.view.makeToast(message, duration: 1, position:NSValue(cgPoint: position))
    }
    
}
