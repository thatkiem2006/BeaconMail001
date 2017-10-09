//
//  WebViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController,UIWebViewDelegate {
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var btnWebPrev: UIButton!
    @IBOutlet weak var btnWebNext: UIButton!
    @IBOutlet weak var btnLoadMail: UIButton!
    
    
    var webViewAccess = UIWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup button
        self.btnWebNext.isHidden = true
        self.btnWebPrev.isHidden = true
        
        self.btnLoadMail.setTitle("toolbar_favorite".localizedString, for: .normal)
        self.btnLoadMail.setTitle("toolbar_favorite".localizedString, for: .selected)
        
        //Fix bug show underline title button
        self.btnLoadMail.setBackgroundImage(UIImage(), for: UIControlState.normal)
        
        // load info
        self.loadWebViewInfo()        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - IBAction
    @IBAction func onTouchBtnLoadMail(_ sender: AnyObject) {
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "loadMailView") as? LoadMailViewController {
            viewController.beaconInfo = self.beaconInfo
            viewController.geofence = self.geofence
            viewController.isLoadMail = true
            self.navigationController?.pushViewController(viewController, animated: true)
        }
        
    }
    
    @IBAction func onTouchBtnPrev(_ sender: AnyObject) {
        
        if self.webViewAccess.canGoBack
        {
            self.webViewAccess.goBack()
        }
        
        // reset state 2 btnPrev & btnNext
        self.setStateButtonPrevNext()
        
    }
    
    @IBAction func onTouchBtnNext(_ sender: AnyObject) {
        
        if self.webViewAccess.canGoForward
        {
            self.webViewAccess.goForward()
        }
        
        // reset state 2 btnPrev & btnNext
        self.setStateButtonPrevNext()
        
    }
    
    // MARK: - IBAction
    @IBAction func onTouchButtonRefresh(_ sender: AnyObject) {
        
        // reload webView
        self.webViewAccess.reload()
    }
    
    
    // MARK: Beacon Detect Delegate
    func beaconDetectFinish(_ iBeacon: BeaconInfo?, geoFence: GeoFenceBean?) {
        if let beaconInfo = iBeacon {
            let webAccessCurrent = self.beaconInfo.getWebAccess()
            let webAccessNew = beaconInfo.getWebAccess()
            if webAccessCurrent.webAccess_url == webAccessNew.webAccess_url {
                return
            }
            self.beaconInfo = beaconInfo
            self.geofence = geoFence
            DispatchQueue.main.async {
                self.loadWebViewInfo()
            }
        }else if let geo = geoFence, RegionManager.inRegion(self.beaconInfo, geo: geoFence) == .geofence{
            self.beaconInfo = BeaconInfo()
            self.geofence = geoFence
            DispatchQueue.main.async {
                self.loadWebViewInfo()
            }
        }
    }
    
    // MARK: - Actions
    func loadWebViewInfo() {
        var title = ""
        var iconURL = ""
        var webURL = ""
        if self.beaconInfo.uuid.isEmpty == false {
            title = self.beaconInfo.mail?.name ?? ""
            iconURL = self.beaconInfo.profile?.iconURl ?? ""
            let webAccess = self.beaconInfo.getWebAccess()
            webURL = webAccess.webAccess_url
        }else if let geo = self.geofence {
            title = geo.mail?.name ?? ""
            iconURL = geo.profile?.iconURl ?? ""
            webURL = geo.web?.url ?? ""
        }
        self.setNavWithImageURLAndTitle(iconURL, title: title)
        if webURL.isEmpty == false {
            guard let url = URL (string: webURL) else {
                return
            }
            
            print("webURL : \(url)")
            
            let requestObj = URLRequest(url: url,
                                        cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                        timeoutInterval: 60 * 60)
            for subView in self.view.subviews {
                if subView.tag == 101011 {
                    subView.removeFromSuperview()
                }
            }
            self.webViewAccess = UIWebView()
            self.webViewAccess.tag = 101011
            self.webViewAccess.translatesAutoresizingMaskIntoConstraints = false
            self.webViewAccess.scalesPageToFit = true
            self.webViewAccess.delegate = self
            self.view.addSubview(self.webViewAccess)
            self.webViewAccess.loadRequest(requestObj)
            
            // Top
            let topConstraint = NSLayoutConstraint(item: self.webViewAccess, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.topLayoutGuide, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
            self.view.addConstraint(topConstraint)
            
            // Bottom
            let bottomConstraint = NSLayoutConstraint(item: self.webViewAccess, attribute: NSLayoutAttribute.bottom, relatedBy: NSLayoutRelation.equal, toItem: self.viewBottom, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 0)
            self.view.addConstraint(bottomConstraint)
            
            // Trailing
            let tConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.trailing, relatedBy: NSLayoutRelation.equal, toItem: self.webViewAccess, attribute: NSLayoutAttribute.trailing, multiplier: 1, constant: 0)
            self.view.addConstraint(tConstraint)
            
            // Leading
            let lConstraint = NSLayoutConstraint(item: self.view, attribute: NSLayoutAttribute.leading, relatedBy: NSLayoutRelation.equal, toItem: self.webViewAccess, attribute: NSLayoutAttribute.leading, multiplier: 1, constant: 0)
            self.view.addConstraint(lConstraint)
            
        }else{
            self.onTouchBtnLoadMail(UIButton())
        }
        
    }
    
    func setStateButtonPrevNext(){
        self.btnWebNext.isHidden = !self.webViewAccess.canGoForward
        self.btnWebPrev.isHidden = !self.webViewAccess.canGoBack
    }
    
    // MARK: - UIWebViewDelegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        
        print("webViewDidFinishLoad")
        
        // if weburl is not empty, goto webView
        let webAccess = self.beaconInfo.getWebAccess()
        if webAccess.webAccess_elementIdOfUserId.isEmpty == false {
            print("webViewDidFinishLoad")
            let jsEmail = "document.getElementById('\(webAccess.webAccess_elementIdOfUserId)').value = '\(webAccess.webAccess_userId)'"
            let jsPasswd = "document.getElementById('\(webAccess.webAccess_elementIdOfPasswd)').value = '\(webAccess.webAccess_passwd)'"
            
            self.webViewAccess.stringByEvaluatingJavaScript(from: "\(jsEmail) ; \(jsPasswd)")
            
        }
        
        // reset state of button next, prev
        self.setStateButtonPrevNext()
    }
}
