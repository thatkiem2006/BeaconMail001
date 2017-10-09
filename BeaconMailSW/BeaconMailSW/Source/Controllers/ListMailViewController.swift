//
//  ListMailViewController.swift
//  LBBeaconMail
//
//  Created by longdq on X/XX/17.
//  Copyright © 2017 longdq. All rights reserved.
//

import UIKit

class ListMailViewController: BaseListViewController,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate{
    
    @IBOutlet weak var buttonAddFavorite: UIButton!
    @IBOutlet weak var buttonWeb: UIButton!
    @IBOutlet weak var buttonDelete: UIButton!
    var refreshControl:UIRefreshControl!
    var isDisplayWebButton:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.buttonWeb.setTitle("menu_information".localizedString, for: UIControlState.normal)
        self.buttonWeb.setTitle("menu_information".localizedString, for: UIControlState.selected)
        
        //Fix bug show underline title button
        self.buttonWeb.setBackgroundImage(UIImage(), for: UIControlState.normal)
 
        showTitleNavigationBar()
        
        // refresh
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(ListMailViewController.loadMailMore(_:)), for: UIControlEvents.valueChanged)
        self.tableView.addSubview(refreshControl)
        
        self.tableView.register(UINib(nibName: "CellMessage", bundle: Bundle(for: CellMessage.self)), forCellReuseIdentifier: "CellMessage")        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadMail), name: NSNotification.Name(rawValue: kCheckMailsExist), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async(execute: {
            self.reloadData()
            self.showMenuButton(true)
        })
    }
    
    deinit{
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kCheckMailsExist), object: nil)
    }
    
    func reloadMail() {
        self.reloadData()
    }
    
    
    func showTitleNavigationBar() {
        // default beacon
        if self.beaconInfo.isEqualBeacon(Common.getDefaultBeacon()) {
            self.setNavWithImageAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
        }else if let geo = self.geofence{
            self.setNavWithImageURLAndTitle(geo.profile?.iconURl ?? "", title: geo.mail?.name ?? "")
        }else {
            self.setNavWithImageURLAndTitle(self.beaconInfo.profile?.iconURl ?? "", title: self.beaconInfo.mail?.name ?? "")
        }
    }
    
    func reloadData() {
        
        self.loadMailFromDb()
        
        var url = ""
        if let geo = self.geofence {
            url = geo.web?.url ?? ""
        }else {
            let webAccess = beaconInfo.getWebAccess()
            url = webAccess.webAccess_url
        }
        
        if  url.isEmpty == false && RegionManager.inRegion(self.beaconInfo, geo: self.geofence) != .unknown {
            self.isDisplayWebButton = true
        }else {
            self.isDisplayWebButton = false
        }
        if self.isDisplayWebButton == true {
            self.hideBottomBar(false)
            self.buttonDelete.isHidden = true
            self.buttonAddFavorite.isHidden = true
        }
        self.buttonWeb?.isHidden = !self.isDisplayWebButton
    }
    
    // MARK: - Function
    override func onTouchEditButton() {
        super.onTouchEditButton()
        self.buttonDelete.isHidden = false
        self.buttonAddFavorite.isHidden = false
        self.buttonWeb.isHidden  = true
    }
    
    override func onTouchCancelButton(){
        super.onTouchCancelButton()
        
        if self.isDisplayWebButton == true
        {
            self.hideBottomBar(false)
            self.buttonDelete.isHidden = true
            self.buttonAddFavorite.isHidden = true
        }
        
        // hidden or not
        self.buttonWeb.isHidden = !self.isDisplayWebButton
    }
    
    func deleteCellSelection() {
        // Delete what the user selected.
        if let selectedRows:[IndexPath] = self.tableView.indexPathsForSelectedRows {
            let deleteSpecificRows = selectedRows.count > 0;
            if (deleteSpecificRows) {
                // create empty list deleting mail
                var listDeleteMail = [MailInfo]()
                for selectionIndex in selectedRows {
                    listDeleteMail.append(self.listMail[selectionIndex.row])
                }
                self.deleteMail(listDeleteMail,fromFavorite:false)
                self.listMail = MailBox.getMailBy(self.beaconInfo, geofence: self.geofence)
                if (self.listMail.count + selectedRows.count) != self.tableView.numberOfRows(inSection: 0) {
                    self.tableView.reloadData()
                }else {
                    self.tableView.deleteRows(at: selectedRows, with: UITableViewRowAnimation.automatic)
                }
                let message = String.init(format: "mail_box_delete_toast".localizedString, selectedRows.count)
                self.showToast(message)
            }
        }
    }
    
    func addFavoriteCellSelection() {
        if let selectedRows:[IndexPath] = self.tableView.indexPathsForSelectedRows {
            let deleteSpecificRows = selectedRows.count > 0
            if (deleteSpecificRows) {
                var listAddFavoriteMail = [MailInfo]()
                for selectionIndex in selectedRows {
                    listAddFavoriteMail.append(self.listMail[selectionIndex.row])
                }
                self.addMailToFavorite(listAddFavoriteMail)
                MailBox.optimizeMemory(self.beaconInfo, geo: nil, applyForFavorite: true)
                
                let message = String.init(format: "mail_box_add_favorite_toast".localizedString, selectedRows.count)
                self.showToast(message)
                self.onTouchCancelButton()
            }
        }
    }

    fileprivate func loadMailFromDb() {
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
        hub.bezelView.style = .solidColor
        hub.bezelView.color = UIColor.clear
        
        self.loadMail { (success) in
            self.tableView.reloadData()
            if let appDelegete = UIApplication.shared.delegate as? BeaconMailDelegate {
               appDelegete.setBadge()
            }//fix error
            self.setStateView()
            hub.hide(true, afterDelay: 0.3)
            
            //Sync mail from server
            self.synMailServerAndLocal()
        }
    }
    
    fileprivate func loadMail(_ complete: @escaping (_ success: Bool)->()){
        DispatchQueue.main.async(execute: {
            self.listMail = MailBox.getMailBy(self.beaconInfo, geofence: self.geofence)
            complete(true)
        })
        
    }
    
    func synMailServerAndLocal() {
        
        print("synMailServerAndLocal title:%@ beacon:%@  ; geofence:%@",self.title, self.beaconInfo,self.geofence)
        
        PostalMachine.loadAllMailForSynServer(self.beaconInfo, geofence: self.geofence, number: NUMBER_MAIL) { (result, success) in
            if let listServerMail = result{
                self.synMailServerAndLocal(listLocalMail: self.listMail, listServerMail: listServerMail)
            }
        }
    }
    
    func synMailServerAndLocal(listLocalMail: [MailInfo], listServerMail: [MailInfo] ) {
        
//        if listLocalMail.count == 0 || listServerMail.count == 0 || listLocalMail.count == listServerMail.count {
//            return
//        }
        
        // create empty list deleting mail
        var listDeleteMail = [MailInfo]()
        
        //Check item deleted by server -> need remove this item in local
        for itemLocal in listLocalMail {
            let mailId = itemLocal.mail_id
            
            //Check mailId in list server , if not found -> remove this item
            if listServerMail.contains(where: { $0.mail_id == itemLocal.mail_id }) {
                // found
            } else {
                // not
                 listDeleteMail.append(itemLocal)
            }
        }
        
        //delete mails that have been deleted from server
        if listDeleteMail.count > 0 {
            self.deleteMail(listDeleteMail,fromFavorite:false)
            
            //reload data
            self.listMail = MailBox.getMailBy(self.beaconInfo, geofence: self.geofence)
            
            self.tableView.reloadData()
        }
        
        self.setStateView()
    }
    
    func loadMailMore(_ sender:AnyObject) {
        PostalMachine.loadLastMail(self.beaconInfo, geofence: self.geofence, number: NUMBER_MAIL) { (result, success) in
            if let result = result {
                var account = MailAccount.getMailAccoutBy(self.beaconInfo, geo: self.geofence)
                if account == nil {
                    account = MailAccount.getMailAccoutBy(self.beaconInfo, geo: self.geofence, isDefault: true)
                }
                
                if result.count > 0 {
                    account?.update(mailBox: result)
                    account?.update(hasNewMail: true)
                    
                    MailBox.optimizeMemory(self.beaconInfo, geo: self.geofence)
                    
                    print("loadMailMore > kReloadLeftMenuNotification")
                    NotificationCenter.default.post(name: Foundation.Notification.Name(rawValue: kReloadLeftMenuNotification), object: nil, userInfo: nil)
                    self.loadMailFromDb()
                    
                } else {
                    account?.update(hasNewMail: false)
                    //Sync mail from server
                    self.synMailServerAndLocal()
                }
            }
            
            self.refreshControl.endRefreshing()
        }
    }
    // MARK: - IBAction
    @IBAction func onTouchButtonFavorite(_ sender: AnyObject) {
        // create alert
        let alertView = UIAlertController(title: "", message: MESSAGE_MAIL_ADD_FAVORITE, preferredStyle: .alert)
        
        // cancel
        alertView.addAction(UIAlertAction(title: "button_cancel".localizedString, style: .default, handler: { (alertAction) -> Void in
            print("onTouchButtonFavorite : いいえ")
        }))
        
        // OK
        alertView.addAction(UIAlertAction(title: "button_ok".localizedString, style: .default, handler: { (alertAction) -> Void in
            print("onTouchButtonFavorite : はい")
            // Add favorite
            self.addFavorite()
        }))
        
        // show alert
        present(alertView, animated: true, completion: nil)
    }
    
    
    @IBAction func onTouchButtonDelete(_ sender: AnyObject) {
        let alertView = UIAlertController(title: "", message: MESSAGE_MAIL_DELETE, preferredStyle: .alert)
        alertView.addAction(UIAlertAction(title: "button_cancel".localizedString, style: .default, handler: { (alertAction) -> Void in
            print("onTouchButtonDelete : いいえ")
        }))
        alertView.addAction(UIAlertAction(title: "button_ok".localizedString, style: .default, handler: { (alertAction) -> Void in
            print("onTouchButtonDelete : はい")
            self.deleteMail()
        }))
        present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func onTouchButtonWeb(_ sender: AnyObject) {
        
        self.backToWebView(self.beaconInfo, geo: self.geofence)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.listMail.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // get cell
        let cell =  tableView.dequeueReusableCell(withIdentifier: "CellMessage", for: indexPath) as! CellMessage
        
        //         setup view
        let mailInfo = self.listMail[indexPath.row]
        cell.setupView(mailInfo)
        
        // return
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView.isEditing == false) {
            if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "messageDetail") as? MessageDetailViewController {
                viewController.isDisplayWebButton = self.isDisplayWebButton
                viewController.mailInfo = self.listMail[indexPath.row]
                viewController.beaconInfo = self.beaconInfo
                viewController.geofence = self.geofence
                self.navigationController?.pushViewController(viewController, animated: true)
            }
            
            // deselect
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    // MARK : UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        
        if buttonIndex == 0
        {
            
        }else if buttonIndex == 1
        {
            // DELETE
            if alertView.tag == 20
            {
                
                // Delete
                self.deleteMail()
            }else // Add favorite
            {
                
                // Add favorite
                self.addFavorite()
                
            }
            
        }
    }
    
    func addFavorite(){
        self.addFavoriteCellSelection()
        if self.listMail.count == 0 {
            self.onTouchCancelButton()
        }
        self.setStateView()
    }
    
    func deleteMail()
    {
        // delete cell
        self.deleteCellSelection()
        
        //
        if self.listMail.count == 0
        {
            self.onTouchCancelButton()
        }
        
        self.setStateView()
    }
}
