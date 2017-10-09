//
//  MenuTableViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit
import CoreData

class MenuTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource ,UIAlertViewDelegate,CellLeftMenuDelegate{
    
    @IBOutlet weak var lblTitleMenu: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnLock: UIButton!
    
    var isDetectingBeacon = false
    var listItemMenu:[LeftMenuInfo] = []
    var cacheViewControllerListMenu = Dictionary<String, UIViewController>()
    fileprivate var loadMailCurrentVC: LoadMailViewController?
    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initForView()
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kReloadLeftMenuNotification), object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kClearCacheViewController), object: nil)
    }
    
    func initForView() {
        //Set title
        self.lblTitleMenu.text = "menu_header".localizedString
        self.btnLock.setTitle("menu_edit".localizedString, for: UIControlState.normal)
        self.btnLock.setTitle("menu_complete".localizedString, for: UIControlState.selected)
        
        //Fix bug show underline title button
        self.btnLock.setBackgroundImage(UIImage(), for: UIControlState.normal)
        
        // add long press gesture recognize to tableView
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 1.5
        self.tableView.addGestureRecognizer(longPress)
        
        self.btnLock.isSelected = false
        self.createListMenu()
        self.revealViewController().frontViewController.view.endEditing(true)
        NotificationCenter.default.addObserver(self, selector: #selector(beaconDetectChange(_:)), name: NSNotification.Name(rawValue: kReloadLeftMenuNotification), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(clearCacheController(_:)), name: NSNotification.Name(rawValue: kClearCacheViewController), object: nil)
    }
    
    // MARK: - IBAction
    @IBAction func onTouchBtnEdit(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.tableView.reloadData()
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listItemMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CellLeftMenu = self.tableView.dequeueReusableCell(withIdentifier: "CellLeftMenu")! as! CellLeftMenu
        let leftMenu  = self.listItemMenu[indexPath.row]
        // setup view and data
        cell.setupCell(leftMenu,indexPath:indexPath,isLock: self.btnLock.isSelected, isDetectingBeacon: self.isDetectingBeacon)
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell:CellLeftMenu = tableView.cellForRow(at: indexPath) as! CellLeftMenu
        print("View on Cell Name =",cell.labelName.text)

        
        if self.btnLock.isSelected == true {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let leftMenu  = self.listItemMenu[indexPath.row]
        print("LEFT MENU: \(leftMenu.name)")
        
        self.selectMenuAction(item: leftMenu)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    //MARK: Private
    fileprivate func createListMenu(){
        self.listItemMenu.removeAll()
        // Default Beacon
        let defaultBeacon = Common.getDefaultBeacon()
        // Favorite
        let leftMenuFavorite = LeftMenuInfo()
        leftMenuFavorite.name = "menu_favorite".localizedString
        leftMenuFavorite.imageIcon = "btn_favorite.png"
        leftMenuFavorite.naviName = NaviName.favorite
        leftMenuFavorite.type = LeftMenuType.menu
        leftMenuFavorite.unreadCnt = 0
        leftMenuFavorite.beaconInfo = BeaconInfo()
        self.listItemMenu.append(leftMenuFavorite)
        
        // Creat a temporary array contain beacon and geofence account
        var listAccounts: [LeftMenuInfo] = []
        
        // get list beacons in db
        var listBeacons = Beacon.getAll()
        var beaconDetectedCount = 0
        
        // Handle defaultBeacon
        for beaconInfo in listBeacons {
            if defaultBeacon.isEqualBeacon(beaconInfo) {
                let menuItem = LeftMenuInfo(iBeacon: beaconInfo)
                menuItem.type = LeftMenuType.beacon_DEFAULT
                self.listItemMenu.insert(menuItem, at: 0)

                // Remove defaultBeacon from listBeacons
                let index = listBeacons.index(of: beaconInfo)
                listBeacons.remove(at: index!)
                break
            }
        }
        
        // Handle rest beacons
        for beaconInfo in listBeacons {
            let menuItem = LeftMenuInfo(iBeacon: beaconInfo)
            menuItem.type = LeftMenuType.beacon

            // Detect app state: Detecting Beacon or Geofence or not
            if BeaconDetectManager.shared.isDetectingBeacon(beaconInfo) {
                self.listItemMenu.insert(menuItem, at: 2)
                beaconDetectedCount = beaconDetectedCount + 1
            } else {
                if menuItem.name.isEmpty == false {
                    listAccounts.append(menuItem)
                }
            }
        }
        
        self.isDetectingBeacon = beaconDetectedCount == 1
        
        //get geofence in db
        let listGeo = Geofence.getGeoEnterRegion()
        for geo in listGeo {
            if geo.xml_file?.file == nil {
                continue
            }
            
            let menuItem = LeftMenuInfo(geofence: geo.toGeoInfo())
            menuItem.type = LeftMenuType.geofence
            
            let geoFence = geo.toGeoInfo()
            
            if !self.isDetectingBeacon && LocationManager.shared.isDetectingGeofence(geoFence) {
                self.listItemMenu.insert(menuItem, at: 2)
                
                //Add geo for monitor debug mode
                GeoFenceMonitorViewController.shared?.addGeoFence(geoFence)
                
            } else {
                listAccounts.append(menuItem)
            }
        }
        
        // Sort listAccounts by updateDate
        listAccounts = listAccounts.sorted(by: { (x, y) -> Bool in
            x.updateDate! > y.updateDate!
        })
        
        // Add listAccounts into main array (listItemMenu)
        self.listItemMenu = self.listItemMenu + listAccounts
        
        // About App
        let leftMenuAboutApp = LeftMenuInfo()
        leftMenuAboutApp.name = "menu_about".localizedString
        leftMenuAboutApp.imageIcon = "btn_info.png"
        leftMenuAboutApp.naviName = NaviName.info
        leftMenuAboutApp.type = LeftMenuType.menu_ABOUT
        leftMenuAboutApp.unreadCnt = 0
        leftMenuAboutApp.beaconInfo = BeaconInfo()
        self.listItemMenu.append(leftMenuAboutApp)
        
        
        // get value to enable or disable debug mode
        let isEnableDebugMode:Bool = UDGet(KEY_DEBUG_MODE_ENABLE)
        if isEnableDebugMode {
            // Debug mode
            let leftMenuModeDebug = LeftMenuInfo()
            leftMenuModeDebug.name = "menu_debug_mode".localizedString
            leftMenuModeDebug.imageIcon = "btn_debug_mode.png"
            leftMenuModeDebug.naviName = .debug_MODE
            leftMenuModeDebug.type = LeftMenuType.menu
            leftMenuModeDebug.unreadCnt = 0
            leftMenuModeDebug.beaconInfo = BeaconInfo()
            self.listItemMenu.append(leftMenuModeDebug)
            
            let leftMenuStatusMode = LeftMenuInfo()
            leftMenuStatusMode.name = "menu_status".localizedString
            leftMenuStatusMode.imageIcon = "img_status_disable.png"
            leftMenuStatusMode.type = LeftMenuType.menu
            leftMenuStatusMode.naviName = .debug_STATUS_SCREEN
            leftMenuStatusMode.unreadCnt = 0
            self.listItemMenu.append(leftMenuStatusMode)
        }
        self.tableView.reloadData()
    }
    
    fileprivate func selectMenuAction(item leftMenu: LeftMenuInfo) {
        
        print("selectMenuAction LeftMenuInfo:",leftMenu.beaconInfo)
        print("selectMenuAction LeftMenuInfo:",leftMenu.geofenceInfor)
        
        var menuItem:UIViewController?
        if let identifierVC = leftMenu.naviName?.description(){
            menuItem = self.storyboard?.instantiateViewController(withIdentifier: identifierVC)
        }
        
        if let navi = menuItem as? UINavigationController {
            for viewcontroller in navi.viewControllers {
                if let vc = viewcontroller as? LoadMailViewController {
                    vc.beaconInfo = leftMenu.beaconInfo ?? BeaconInfo()
                    vc.geofence = leftMenu.geofenceInfor
        
                    if BeaconDetectManager.shared.isDetectingBeacon(leftMenu.beaconInfo) == false {
                        vc.isLoadMail = true
                    }else {
                        navi.popToRootViewController(animated: false)
                        vc.isLoadMail = false
                    }
//                    DispatchQueue.main.async(execute: {
//                        vc.initForView()
//                    })
                    loadMailCurrentVC = vc
                    break
                }
            }
            
            self.revealViewController().setFront(navi, animated: false)
            self.revealViewController().setFrontViewPosition(FrontViewPosition.left, animated: true)
        }
    }
    
    func handleLongPress(_ gestureRecognizer:UILongPressGestureRecognizer){
        // get value to enable or disable debug mode
        let defaults = UserDefaults.standard
        let isEnableDebugMode = defaults.bool(forKey: KEY_DEBUG_MODE_ENABLE)
        if isEnableDebugMode {
            return
        }
        // get indexPath which long press
        let point = gestureRecognizer.location(in: self.tableView)
        if let indexPath:IndexPath = self.tableView.indexPathForRow(at: point) {
            if gestureRecognizer.state == UIGestureRecognizerState.began
            {
                let leftMenu  = self.listItemMenu[indexPath.row]
                if leftMenu.type == LeftMenuType.menu_ABOUT
                {
                    if #available(iOS 8.0, *) {
                        // create alert
                        let alertView = UIAlertController(title: "", message: "alert_debug_mode".localizedString,
                                                          preferredStyle: .alert)
                        
                        // cancel
                        alertView.addAction(UIAlertAction(title: "button_cancel".localizedString, style: .default, handler: { (alertAction) -> Void in
                            print("handleLongPress : いいえ")
                        }))
                        
                        // OK
                        alertView.addAction(UIAlertAction(title: "button_ok".localizedString, style: .default, handler: { (alertAction) -> Void in
                            print("handleLongPress : はい")
                            self.openDebugMode()
                        }))
                        
                        // show alert
                        present(alertView, animated: true, completion: nil)
                    } else {
                        let alertView = UIAlertView()
                        alertView.title = ""
                        alertView.message = "alert_debug_mode".localizedString
                        alertView.delegate = self
                        alertView.addButton(withTitle: "button_cancel".localizedString)
                        alertView.addButton(withTitle: "button_ok".localizedString)
                        alertView.show()
                    }
                    
                }
            }
            
        }
    }
    
    func beaconDetectChange(_ notification: Foundation.Notification) {
        DLog(infor:"beaconDetectChange")
       // DispatchQueue.main.async(execute: {
            self.createListMenu()
       // })
    }
    
    func clearCacheController(_ notification: Foundation.Notification) {
        self.cacheViewControllerListMenu.removeAll()
    }
    
    /*
     guard let mailInfos = mailInfos else {
     print("Haven't new mails")
     if let isPush = isPushNotification, isPush == true {
     Common.sendNotification(nil, geo: geoFence)
     }
     
     return
     }
     
     if let firstMail = mailInfos.first {
     Common.sendNotifyByHasNewMail(firstMail, beaconInfo: nil, geoFence: geoFence)
     } else if isPushNotification == true {
     print("Haven't new mails  & is push = true")
     Common.sendNotification(nil, geo: geoFence)
     
     }
     
     } else {
     // fail
     // send notification default
     if let isPush = isPushNotification, isPush == true {
     print("checkHasNewMail success = fail")
     Common.sendNotification(nil, geo: geoFence)
     }
     
     
     */
    
    // MARK: UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        if buttonIndex == 0 {
            
        }else if buttonIndex == 1 {
            self.openDebugMode()
        }
    }
    
    func openDebugMode() {
        
        let defaults = UserDefaults.standard
        defaults.set(true, forKey:KEY_DEBUG_MODE_ENABLE)
        
        // create list menu
        self.createListMenu()
    }
    
    //MARK: - CellLeftMenuDelegate
    func cellLeftMenuTouchBtnLock(_ menuInfo: LeftMenuInfo?) {
        if let iBeacon = menuInfo?.beaconInfo {
            iBeacon.protected =  !iBeacon.protected
            BeaconInfo.updateBeaconProtectToDb(iBeacon)
        }
        self.tableView .reloadData()
    }
    
    func cellLeftMenuTouchBtnTrash(_ menuInfo: LeftMenuInfo?) {
        let alertView = UIAlertController(title: "", message: "dialog_message_you_want_to_delete_account".localizedString,
                                          preferredStyle: UIAlertControllerStyle.alert)
       
        alertView.addAction(UIAlertAction(title: "button_cancel".localizedString,
                                          style: .default, handler: { (alertAction) -> Void in
        }))
        alertView.addAction(UIAlertAction(title: "button_ok".localizedString,
                                          style: .default, handler: { (alertAction) -> Void in
            if let beacon = menuInfo?.beaconInfo {
                Beacon.delete(beacon: beacon)
            }
            if let geo = menuInfo?.geofenceInfor {
                UserDefaults.standard.removeObject(forKey: geo.identifier)
                Geofence.enterRegion(geo, isEnter: false)
            }
//            let favoriteMenu  = self.listItemMenu[1]
//            self.selectMenuAction(item: favoriteMenu)
            self.createListMenu()
        }))
        
        // show alert
        present(alertView, animated: true, completion: nil)
    }
}
