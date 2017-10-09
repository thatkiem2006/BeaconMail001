//
//  LoadMailViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import SDWebImage

class LoadMailViewController: BaseViewController {
    // IBOutlet
    @IBOutlet weak var imageViewBanner: UIImageView!
    @IBOutlet weak var labelLoadingMessage: UILabel!
    
    // variable
    let mailManager = MailManager()
    var isLoadMail = false
    var isFromIconOrNotification = false

    override func viewDidLoad() {
        super.viewDidLoad()

        self.initForView();
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func initForView() {
        // check if no message -> beaconNewMessage = nil
        if self.isRegionHasNewMail() == false {
            self.doWhenReciveMessageInForeground()
        }else if let geo = self.geofence { // if new notification had.  ->  open
            self.reloadDataWith(geoFence: self.geofence!)
        }else {
            print("LoadMailViewController > initForView > gotoLastestMailBox")
            self.gotoLastestMailBox(self.beaconInfo)
        }
        
    }
    //MARK: - Private
    fileprivate func doWhenReciveMessageInForeground() {
        let numberUnRead = MailBox.countNumberMail(isRead: false)
        if numberUnRead == 0 {
            self.handleWhenAllMailWasRead()
        }else {
            self.handleWhenHaveMailUnRead()
        }
    }
    
    fileprivate func handleWhenHaveMailUnRead() {
        let account = MailAccount.getLatestUpdate()
        if self.beaconInfo.isEmpty() == true && self.geofence == nil{
            if let beaconLatest = account?.beacon{
                self.gotoLastestMailBox(beaconLatest.toBeaconInfo())
            }else if let geoLatest = account?.geofence{
                self.geofence = geoLatest.toGeoInfo()
                self.reloadDataWith(geoFence: self.geofence!)
            }
            return
        }
        if beaconInfo.isEqualBeacon(Common.getDefaultBeacon()) {
            self.gotoDefaultMailbox()
            return
        }
        if self.beaconInfo.isEmpty() == false {
            
            if let bannerUrl = self.beaconInfo.profile?.bannerUrl, let url = URL(string: bannerUrl) {
                if self.imageViewBanner != nil {
                    self.imageViewBanner.loadImageWithURL(url)
                }
            }
           
            self.setNavWithImageURLAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
            self.getXmlInfoOfBeacon(self.beaconInfo)
            return
        }
        if let geo = self.geofence {
            self.reloadDataWith(geoFence: geo)
        }
    }
    
    fileprivate func handleWhenAllMailWasRead() {
        if self.beaconInfo.isEmpty() == true && self.geofence == nil{
            self.gotoDefaultMailbox()
            AppConfig.moveToMenu()
            return
        }
        if self.beaconInfo.isEqualBeacon(Common.getDefaultBeacon()){
            self.gotoDefaultMailbox()
            return
        }
        if self.beaconInfo.isEmpty() == false {
            DispatchQueue.main.async(execute: {
                let url = URL(string: self.beaconInfo.profile?.bannerUrl ?? "")
                if self.imageViewBanner != nil {
                    self.imageViewBanner.loadImageWithURL(url)
                }
                self.setNavWithImageURLAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
            })
            self.getXmlInfoOfBeacon(self.beaconInfo)
        }
        if let geo = self.geofence {
            self.reloadDataWith(geoFence: geo)
        }
    }
    
    fileprivate func reloadDataWith(geoFence geo:GeoFenceBean) {
        let url = URL(string: geo.profile?.bannerUrl ?? "")
        if self.imageViewBanner != nil {
            self.imageViewBanner.loadImageWithURL(url)
        }
        self.setNavWithImageURLAndTitle(geo.profile?.iconURl ?? "", title: geo.mail?.name ?? "")
        if LocationManager.shared.isDetectingGeofence(geo) && self.isLoadMail == false{
            self.gotoWebView(nil, geoFence: geo)
        }else {
            self.loadMail(nil, geofence: geo)
        }
    }
    
    fileprivate func isRegionHasNewMail()-> Bool {
        if let mailAccount = MailAccount.getLatestUpdate(true) {
            if let beacon = mailAccount.beacon {
                self.beaconInfo = beacon.toBeaconInfo()
                return true
            }
            if let geo = mailAccount.geofence {
                self.geofence = geo.toGeoInfo()
                return true
            }
        }
        return false
    }
    
    func getXmlInfoOfBeacon(_ beaconInfo:BeaconInfo) {
        
        APIClient.shared.requestGetiBeaconXMLFile(beaconInfo) { (xmlParseError, iBeacon) in
            if let beaconConfig = iBeacon {
                let beacon = BeaconInfo()
                beacon.clone(beaconInfo)
                
                if self.labelLoadingMessage != nil {
                    self.labelLoadingMessage.text = beacon.notification?.message ?? ""
                }
                
                let webCount = beacon.webGroup?.count ?? 0
               
                if  webCount > 0 && self.isLoadMail == false && BeaconDetectManager.shared.isDetectingBeacon(beacon) == true {
                   
                    self.gotoWebView(beacon)
               
                }else if self.isFromIconOrNotification == true {
                    delay(3, closure: {
                        self.gotoWebView(self.beaconInfo)
                    })
                }else {
                    
                    self.gotoListMailOrDefaultMailbox(beacon)
                    
                }
            }else {
                self.gotoListMailOrDefaultMailbox(beaconInfo)
            }
        }
    }
    
    func gotoListMailOrDefaultMailbox(_ beaconInfo:BeaconInfo){
        // if run by Icon or Notificationget
        if self.isFromIconOrNotification{
            self.gotoDefaultMailbox()
            self.isFromIconOrNotification = false
        }else {
            self.loadMail(beaconInfo)
        }
    }
    
    func gotoListMail() {
        var listMailVC: ListMailViewController!
//        if let viewcontrollers = self.navigationController?.viewControllers {
//            for vc in viewcontrollers {
//                if vc is ListMailViewController {
//                    listMailVC = vc as! ListMailViewController
//                    listMailVC.beaconInfo = self.beaconInfo
//                    listMailVC.geofence = self.geofence
//                    listMailVC.reloadData()
//                    return
//                }
//            }
//        }
//        
        if listMailVC == nil {
            listMailVC = self.storyboard?.instantiateViewController(withIdentifier: "ListMailViewController") as! ListMailViewController
            listMailVC.beaconInfo = self.beaconInfo
            listMailVC.geofence = self.geofence
            self.navigationController?.pushViewController(listMailVC, animated: true)
        }
        
        
        
    }
    
    func gotoDefaultMailbox() {
        print("gotoDefaultMailbox")
        let defaultBeacon = Common.getDefaultBeacon()
        self.beaconInfo = Beacon.fetch(defaultBeacon.uuid, major: defaultBeacon.major, minor: defaultBeacon.minor).first!
        if self.imageViewBanner != nil {
            self.imageViewBanner.image = UIImage.bmImage(self.beaconInfo.profile?.bannerUrl ?? "")
        }
        self.setNavWithImageAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "インフオメーション")
        self.labelLoadingMessage.text = self.beaconInfo.notification?.message
        self.loadMail(self.beaconInfo)
    }
    
    func gotoLastestMailBox(_ beaconInfo:BeaconInfo) {
        print("gotoLastestMailBox > beaconInfo")
        self.beaconInfo = beaconInfo
        let urlString = URL.init(string: self.beaconInfo.profile?.bannerUrl ?? "", relativeTo: nil)
        if self.imageViewBanner != nil {
            self.imageViewBanner.sd_setImage(with: urlString)
        }
        self.setNavWithImageAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
        
        if let labelLoadingMessage = self.labelLoadingMessage {
            labelLoadingMessage.text = self.beaconInfo.mail?.name
        }
        
        self.loadMail(self.beaconInfo)
    }
    
    func loadMail(_ beaconInfo:BeaconInfo? = nil, geofence: GeoFenceBean? = nil) {
//        self.loadMail(beaconInfo, geofence: geofence) { listMail in
//            PostalMachine.checkMailExisting(beaconInfo, geofence: geofence, mailInfos: listMail, completion: {
//                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kCheckMailsExist), object: nil, userInfo: nil)
//            })
//        }
        
        PostalMachine.loadLastMail(beaconInfo, geofence: geofence,number: NUMBER_MAIL) {[weak self] (result, success) in
            if let result = result {
                var account = MailAccount.getMailAccoutBy(self?.beaconInfo, geo: self?.geofence)
                if account == nil {
                    account = MailAccount.getMailAccoutBy(self?.beaconInfo, geo: self?.geofence, isDefault: true)
                }
                account?.update(mailBox: result)
                if result.count > 0 {
                    MailBox.optimizeMemory(self?.beaconInfo, geo: geofence)
                }
                account?.update(hasNewMail: false)
            }
            DispatchQueue.main.async(execute: {
                self?.gotoListMail()
                
                print("LoadMailViewController > loadMail > kReloadLeftMenuNotification")
                NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
            })
        }
    }
    
    
    fileprivate func loadMail(_ beaconInfo:BeaconInfo? = nil, geofence: GeoFenceBean? = nil, complete: @escaping ([MailInfo])->()){
        /*
        DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.default).async {
        let listMail: [MailInfo] = MailBox.getMailBy(beaconInfo, geofence: geofence)
            DispatchQueue.main.async(execute: {
                complete(listMail)
            })
        }
        */
                
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            let listMail: [MailInfo] = MailBox.getMailBy(beaconInfo, geofence: geofence)
            DispatchQueue.main.async{
                complete(listMail)
            }
        }
    }
}
